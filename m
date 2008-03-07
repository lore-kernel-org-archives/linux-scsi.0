From: Josef Bacik <jbacik@redhat.com>
Subject: Re: some hard numbers on ext3 & batching performance issue
Date: Fri, 7 Mar 2008 15:40:13 -0500
Message-ID: <200803071540.13958.jbacik@redhat.com>
References: <47C6A46D.8020700@emc.com> <200803051520.09931.jbacik@redhat.com> <47D1A0C0.8010908@emc.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <47D1A0C0.8010908@emc.com>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
To: ric@emc.com
Cc: David Chinner <dgc@sgi.com>, Theodore Ts'o <tytso@mit.edu>, adilger@sun.com, jack@ucw.cz, "Feld, Andy" <Feld_Andy@emc.com>, linux-fsdevel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Friday 07 March 2008 3:08:32 pm Ric Wheeler wrote:
> Josef Bacik wrote:
> > On Wednesday 05 March 2008 2:19:48 pm Ric Wheeler wrote:
> >> After the IO/FS workshop last week, I posted some details on the slow
> >> down we see with ext3 when we have a low latency back end instead of a
> >> normal local disk (SCSI/S-ATA/etc).
>
> ...
> ...
> ...
>
> >> It would be really interesting to rerun some of these tests on xfs which
> >> Dave explained in the thread last week has a more self tuning way to
> >> batch up transactions....
> >>
> >> Note that all of those poor users who have a synchronous write workload
> >> today are in the "1" row for each of the above tables.
> >
> > Mind giving this a whirl?  The fastest thing I've got here is an Apple X
> > RAID and its being used for something else atm, so I've only tested this
> > on local disk to make sure it didn't make local performance suck (which
> > it doesn't btw). This should be equivalent with what David says XFS does.
> >  Thanks much,
> >
> > Josef
> >
> > diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
> > index c6cbb6c..4596e1c 100644
> > --- a/fs/jbd/transaction.c
> > +++ b/fs/jbd/transaction.c
> > @@ -1333,8 +1333,7 @@ int journal_stop(handle_t *handle)
> >  {
> >  	transaction_t *transaction = handle->h_transaction;
> >  	journal_t *journal = transaction->t_journal;
> > -	int old_handle_count, err;
> > -	pid_t pid;
> > +	int err;
> >
> >  	J_ASSERT(journal_current_handle() == handle);
> >
> > @@ -1353,32 +1352,22 @@ int journal_stop(handle_t *handle)
> >
> >  	jbd_debug(4, "Handle %p going down\n", handle);
> >
> > -	/*
> > -	 * Implement synchronous transaction batching.  If the handle
> > -	 * was synchronous, don't force a commit immediately.  Let's
> > -	 * yield and let another thread piggyback onto this transaction.
> > -	 * Keep doing that while new threads continue to arrive.
> > -	 * It doesn't cost much - we're about to run a commit and sleep
> > -	 * on IO anyway.  Speeds up many-threaded, many-dir operations
> > -	 * by 30x or more...
> > -	 *
> > -	 * But don't do this if this process was the most recent one to
> > -	 * perform a synchronous write.  We do this to detect the case where a
> > -	 * single process is doing a stream of sync writes.  No point in
> > waiting -	 * for joiners in that case.
> > -	 */
> > -	pid = current->pid;
> > -	if (handle->h_sync && journal->j_last_sync_writer != pid) {
> > -		journal->j_last_sync_writer = pid;
> > -		do {
> > -			old_handle_count = transaction->t_handle_count;
> > -			schedule_timeout_uninterruptible(1);
> > -		} while (old_handle_count != transaction->t_handle_count);
> > -	}
> > -
> >  	current->journal_info = NULL;
> >  	spin_lock(&journal->j_state_lock);
> >  	spin_lock(&transaction->t_handle_lock);
> > +
> > +	if (journal->j_committing_transaction && handle->h_sync) {
> > +		tid_t tid = journal->j_committing_transaction->t_tid;
> > +
> > +		spin_unlock(&transaction->t_handle_lock);
> > +		spin_unlock(&journal->j_state_lock);
> > +
> > +		err = log_wait_commit(journal, tid);
> > +
> > +		spin_lock(&journal->j_state_lock);
> > +		spin_lock(&transaction->t_handle_lock);
> > +	}
> > +
> >  	transaction->t_outstanding_credits -= handle->h_buffer_credits;
> >  	transaction->t_updates--;
> >  	if (!transaction->t_updates) {
>
> Running with Josef's patch, I was able to see a clear improvement for
> batching these synchronous operations on ext3 with the RAM disk and
> array. It is not too often that you get to do a simple change and see a
> 27 times improvement ;-)
>
> On the bad side, the local disk case took as much as a 30% drop in
> performance.  The specific disk is not one that I have a lot of
> experience with, I would like to retry on a disk that has been qualified
>   by our group (i.e., we have reasonable confidence that there are no
> firmware issues, etc).
>
> Now for the actual results.
>
> The results are the average value of 5 runs for each number of threads.
>
> Type     Threads   Baseline    Josef    Speedup (Josef/Baseline)
> array	    1	     320.5      325.4      1.01
> array	    2	     174.9      351.9      2.01
> array	    4	     382.7      593.5      1.55
> array	    8	     644.1      963.0      1.49
> array	    10	     842.9     1038.7      1.23
> array	    20	    1319.6     1432.3      1.08
>
> RAM disk    1       5621.4     5595.1      0.99
> RAM disk    2        281.5     7613.3     27.04
> RAM disk    4        579.9     9111.5     15.71
> RAM disk    8        891.1     9357.3     10.50
> RAM disk    10      1116.3     9873.6      8.84
> RAM disk    20      1952.0    10703.6      5.48
>
> S-ATA disk  1         19.0       15.1      0.79
> S-ATA disk  2         19.9       14.4      0.72
> S-ATA disk  4         41.0       27.9      0.68
> S-ATA disk  8         60.4       43.2      0.71
> S-ATA disk  10        67.1       48.7      0.72
> S-ATA disk  20       102.7       74.0      0.72
>
> Background on the tests:
>
> All of this is measured on three devices - a relatively old & slow
> array, the local (slow!) 2.5" S-ATA disk in the box and a RAM disk.
>
> These numbers are used fs_mark to write 4096 byte files with the
> following commands:
>
> fs_mark  -d  /home/test/t  -s  4096  -n  40000  -N  50  -D  64  -t  1
> ...
> fs_mark  -d  /home/test/t  -s  4096  -n  20000  -N  50  -D  64  -t  2
> ...
> fs_mark  -d  /home/test/t  -s  4096  -n  10000  -N  50  -D  64  -t  4
> ...
> fs_mark  -d  /home/test/t  -s  4096  -n  5000  -N  50  -D  64  -t  8
> ...
> fs_mark  -d  /home/test/t  -s  4096  -n  4000  -N  50  -D  64  -t  10
> ...
> fs_mark  -d  /home/test/t  -s  4096  -n  2000  -N  50  -D  64  -t  20
> ...
>
> Note that this spreads the files across 64 subdirectories, each thread
> writes 50 files and then moves on to the next in a round robin.
>

I'm starting to wonder about the disks I have, because my files/second is 
spanking yours, and its just a local samsung 3gb/s sata drive.  With those 
commands I'm consistently getting over 700 files/sec.  I'm seeing about a 1-5% 
increase in speed locally with my patch.  I guess I'll start looking around for 
some other hardware and check on there in case this box is more badass than I 
think it is.  Thanks much,

Josef

