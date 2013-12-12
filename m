From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] iscsi_target: race condition on shutdown
Date: Wed, 11 Dec 2013 23:54:12 -0800
Message-ID: <1386834852.20247.121.camel@haakon3.risingtidesystems.com>
References: <1386251665-39173-1-git-send-email-hare@suse.de>
	 <1386805475.20247.109.camel@haakon3.risingtidesystems.com>
	 <52A96352.3050107@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:48433 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385Ab3LLIED (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Dec 2013 03:04:03 -0500
In-Reply-To: <52A96352.3050107@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Nic Bellinger <nab@daterainc.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, 2013-12-12 at 08:18 +0100, Hannes Reinecke wrote:
> On 12/12/2013 12:44 AM, Nicholas A. Bellinger wrote:

<SNIP>

> > I'm not sure this extra logic is necessary.  How about just clearing
> > np->np_thread in iscsit_del_np instead..?
> > 
> > Care to verify on your side with the following patch..?
> > 
> > --nab
> > 
> > diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> > index 02182ab..0086719 100644
> > --- a/drivers/target/iscsi/iscsi_target.c
> > +++ b/drivers/target/iscsi/iscsi_target.c
> > @@ -465,6 +465,7 @@ int iscsit_del_np(struct iscsi_np *np)
> >                  */
> >                 send_sig(SIGINT, np->np_thread, 1);
> >                 kthread_stop(np->np_thread);
> > +               np->np_thread = NULL;
> >         }
> >  
> >         np->np_transport->iscsit_free_np(np);
> > diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
> > index 4eb93b2..6ab43b6 100644
> > --- a/drivers/target/iscsi/iscsi_target_login.c
> > +++ b/drivers/target/iscsi/iscsi_target_login.c
> > @@ -1415,7 +1415,6 @@ exit:
> >         iscsi_stop_login_thread_timer(np);
> >         spin_lock_bh(&np->np_thread_lock);
> >         np->np_thread_state = ISCSI_NP_THREAD_EXIT;
> > -       np->np_thread = NULL;
> >         spin_unlock_bh(&np->np_thread_lock);
> >  
> >         return 0;
> > 
> > 
> The problem here is that 'kthread_stop()' is supposed to be called
> with a _valid_ task structure.
> 
> There is this race window:
> 
> 	np->np_thread_state = ISCSI_NP_THREAD_SHUTDOWN;
> 	spin_unlock_bh(&np->np_thread_lock);
> here ->
> 	if (np->np_thread) {
> 		/*
> 
> If the login thread exits before we evaluate 'np->np_thread'
> the pointer is stale and kthread_stop will be called with
> an invalid task structure.
> 
> So at the very least we need to check the thread_state before
> evaluating 'np->np_thread' (which will evaluate to 'true' anyway if
> we were to follow up with your patch).
> But in doing so we would need to protect is by the thread_lock
> to synchronize the state.
> And we'll end up with quite the same patch as I've send originally.
>
> In fact, it was an invalid call to kthread_stop() which triggered
> the whole patch in the first place :-)
> 

Mmmm, point taken..

> I would love to be proven wrong, as I'm not keen on the 'schedule()'
> in there. But I fail to see another way out here, short of
> converting the entire kthread into a workqueue item ...

Thinking about this a bit more, I think the pre-kthread API
np_thead_state check to exit at the out: label in
__iscsi_target_login_thread() is the culprit..

How about following to only exit when iscsit_del_np() -> kthread_stop()
has been called, and kthread_should_stop() is true..?

--nab

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 02182ab..0086719 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -465,6 +465,7 @@ int iscsit_del_np(struct iscsi_np *np)
                 */
                send_sig(SIGINT, np->np_thread, 1);
                kthread_stop(np->np_thread);
+               np->np_thread = NULL;
        }
 
        np->np_transport->iscsit_free_np(np);
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 4eb93b2..e29279e 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -1403,11 +1403,6 @@ old_sess_out:
 
 out:
        stop = kthread_should_stop();
-       if (!stop && signal_pending(current)) {
-               spin_lock_bh(&np->np_thread_lock);
-               stop = (np->np_thread_state == ISCSI_NP_THREAD_SHUTDOWN);
-               spin_unlock_bh(&np->np_thread_lock);
-       }
        /* Wait for another socket.. */
        if (!stop)
                return 1;
@@ -1415,7 +1410,6 @@ exit:
        iscsi_stop_login_thread_timer(np);
        spin_lock_bh(&np->np_thread_lock);
        np->np_thread_state = ISCSI_NP_THREAD_EXIT;
-       np->np_thread = NULL;
        spin_unlock_bh(&np->np_thread_lock);
 
        return 0;


