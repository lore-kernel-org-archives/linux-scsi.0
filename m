From: Josef Bacik <jbacik@redhat.com>
Subject: Re: some hard numbers on ext3 & batching performance issue
Date: Wed, 5 Mar 2008 15:20:08 -0500
Message-ID: <200803051520.09931.jbacik@redhat.com>
References: <47C6A46D.8020700@emc.com> <20080228175422.GU155259@sgi.com> <47CEF254.2090208@emc.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <47CEF254.2090208@emc.com>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
To: ric@emc.com
Cc: David Chinner <dgc@sgi.com>, Theodore Ts'o <tytso@mit.edu>, adilger@sun.com, jack@ucw.cz, "Feld, Andy" <Feld_Andy@emc.com>, linux-fsdevel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wednesday 05 March 2008 2:19:48 pm Ric Wheeler wrote:
> After the IO/FS workshop last week, I posted some details on the slow
> down we see with ext3 when we have a low latency back end instead of a
> normal local disk (SCSI/S-ATA/etc).
>
> As a follow up to that thread, I wanted to post some real numbers that
> Andy from our performance team pulled together. Andy tested various
> patches using three classes of storage (S-ATA, RAM disk and Clariion
> array).
>
> Note that this testing was done on a SLES10/SP1 kernel, but the code in
> question has not changed in mainline but we should probably retest on
> something newer just to clear up any doubts.
>
> The work load is generated using fs_mark
> (http://sourceforge.net/projects/fsmark/) which is basically a write
> workload with small files, each file gets fsync'ed before close. The
> metric is "files/sec".
>
> The clearest result used a ramdisk to store 4k files.
>
> We modified ext3 and jbd to accept a new mount option: bdelay Use it like:
>
> mount -o bdelay=n dev mountpoint
>
> n is passed to schedule_timeout_interruptible() in the jbd code. if n ==
> 0, it skips the whole loop. if n is "yield", then substitute the
> schedule...(n) with yield().
>
> Note that the first row is the value of the delay with a 250HZ build
> followed by the number of concurrent threads writing 4KB files.
>
> Ramdisk test:
>
> bdelay  1       2       4       8       10      20
> 0       4640    4498    3226    1721    1436     664
> yield   4640    4078    2977    1611    1136     551
> 1       4647     250     482     588     629     483
> 2       4522     149     233     422     450     389
> 3       4504      86     165     271     308     334
> 4       4425      84     128     222     253     293
>
> Midrange clariion:
>
> bdelay   1       2       4       8       10      20
> 0        778     923    1567    1424    1276     785
> yield    791     931    1551    1473    1328     806
> 1        793     304     499     714     751     760
> 2        789     132     201     382     441     589
> 3        792     124     168     298     342     471
> 4        786      71     116     237     277     393
>
> Local disk:
>
> bdelay    1       2       4       8       10      20
> 0         47      51      81     135     160     234
> yield     36      45      74     117     138     214
> 1         44      52      86     148     183     258
> 2         40      60     109     163     184     265
> 3         40      52      97     148     171     264
> 4         35      42      83     149     169     246
>
> Apologies for mangling the nicely formatted tables.
>
> Note that the justification for the batching as we have it today is
> basically this last local drive test case.
>
> It would be really interesting to rerun some of these tests on xfs which
> Dave explained in the thread last week has a more self tuning way to
> batch up transactions....
>
> Note that all of those poor users who have a synchronous write workload
> today are in the "1" row for each of the above tables.

Mind giving this a whirl?  The fastest thing I've got here is an Apple X RAID 
and its being used for something else atm, so I've only tested this on local 
disk to make sure it didn't make local performance suck (which it doesn't btw).  
This should be equivalent with what David says XFS does.  Thanks much,

Josef

diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
index c6cbb6c..4596e1c 100644
--- a/fs/jbd/transaction.c
+++ b/fs/jbd/transaction.c
@@ -1333,8 +1333,7 @@ int journal_stop(handle_t *handle)
 {
 	transaction_t *transaction = handle->h_transaction;
 	journal_t *journal = transaction->t_journal;
-	int old_handle_count, err;
-	pid_t pid;
+	int err;
 
 	J_ASSERT(journal_current_handle() == handle);
 
@@ -1353,32 +1352,22 @@ int journal_stop(handle_t *handle)
 
 	jbd_debug(4, "Handle %p going down\n", handle);
 
-	/*
-	 * Implement synchronous transaction batching.  If the handle
-	 * was synchronous, don't force a commit immediately.  Let's
-	 * yield and let another thread piggyback onto this transaction.
-	 * Keep doing that while new threads continue to arrive.
-	 * It doesn't cost much - we're about to run a commit and sleep
-	 * on IO anyway.  Speeds up many-threaded, many-dir operations
-	 * by 30x or more...
-	 *
-	 * But don't do this if this process was the most recent one to
-	 * perform a synchronous write.  We do this to detect the case where a
-	 * single process is doing a stream of sync writes.  No point in waiting
-	 * for joiners in that case.
-	 */
-	pid = current->pid;
-	if (handle->h_sync && journal->j_last_sync_writer != pid) {
-		journal->j_last_sync_writer = pid;
-		do {
-			old_handle_count = transaction->t_handle_count;
-			schedule_timeout_uninterruptible(1);
-		} while (old_handle_count != transaction->t_handle_count);
-	}
-
 	current->journal_info = NULL;
 	spin_lock(&journal->j_state_lock);
 	spin_lock(&transaction->t_handle_lock);
+
+	if (journal->j_committing_transaction && handle->h_sync) {
+		tid_t tid = journal->j_committing_transaction->t_tid;
+
+		spin_unlock(&transaction->t_handle_lock);
+		spin_unlock(&journal->j_state_lock);
+
+		err = log_wait_commit(journal, tid);
+
+		spin_lock(&journal->j_state_lock);
+		spin_lock(&transaction->t_handle_lock);
+	}
+
 	transaction->t_outstanding_credits -= handle->h_buffer_credits;
 	transaction->t_updates--;
 	if (!transaction->t_updates) {


