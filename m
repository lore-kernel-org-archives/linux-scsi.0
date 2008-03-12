From: Martin Peschke <mp3@de.ibm.com>
Subject: Re: [patch 1/2] zfcp: Fix race during ERP thread shutdown
Date: Wed, 12 Mar 2008 15:13:47 +0100
Message-ID: <1205331227.4852.102.camel@kitka.ibm.com>
References: <20080310151852.808020000@de.ibm.com>
	 <20080310152328.463410000@de.ibm.com>
	 <20080311164341.GA6380@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:49209 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbYCLONt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Mar 2008 10:13:49 -0400
In-Reply-To: <20080311164341.GA6380@osiris.boeblingen.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Christof Schmitt <christof.schmitt@de.ibm.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org

On Tue, 2008-03-11 at 17:43 +0100, Heiko Carstens wrote:
> > --- a/drivers/s390/scsi/zfcp_erp.c	2008-03-10 12:34:48.000000000 +0100
> > +++ b/drivers/s390/scsi/zfcp_erp.c	2008-03-10 16:05:26.000000000 +0100
> > @@ -1002,7 +1002,7 @@ zfcp_erp_thread_setup(struct zfcp_adapte
> >  					    &adapter->status));
> >  		debug_text_event(adapter->erp_dbf, 5, "a_thset_ok");
> >  	}
> > -
> > +	atomic_set_mask(ZFCP_STATUS_ADAPTER_ERP_ACCEPT, &adapter->status);
> >  	return (retval < 0);
> 
> This way the flag will be set even if the creation of the erp thread failed.

You are right.

This used to be correct with all the cleanups pending in our queue
applied. Looks like this flaw creeped in when the bug fix patch was
moved to the head of queue.

> It should be done somewhere within zfcp_erp_thread() instead.

Setting the flag in the setup function is fine, as long as we make sure
the thread is really up and running. I'd prefer to have it here because
of its symmetry with zfcp_erp_thread_kill().

> Besides that setting the flag must be done while holding the erp_lock.
> Otherwise zfcp_erp_action_enqueue might check the flag, other cpu clears
> the flag right after that, and then enqueueing continues while the flag is
> not set.

Correct.

zfcp_erp_wait() might fail to wait for that new action to finish,
because the PENDING flag is set later in the action enqueuing process.
But we want zfcp_erp_wait() to make sure that recovery is settled, so
that we can go on killing the thread.

> >  }
> > 
> > @@ -1025,6 +1025,8 @@ zfcp_erp_thread_kill(struct zfcp_adapter
> >  {
> >  	int retval = 0;
> > 
> > +	atomic_clear_mask(ZFCP_STATUS_ADAPTER_ERP_ACCEPT, &adapter->status);
> > +	zfcp_erp_wait(adapter);
> >  	atomic_set_mask(ZFCP_STATUS_ADAPTER_ERP_THREAD_KILL, &adapter->status);
> >  	up(&adapter->erp_ready_sem);
> > 
> > @@ -2940,8 +2942,7 @@ zfcp_erp_action_enqueue(int action,
> >  	 * efficient.
> >  	 */
> > 
> > -	if (!atomic_test_mask(ZFCP_STATUS_ADAPTER_ERP_THREAD_UP,
> > -			      &adapter->status))
> > +	if (!atomic_test_mask(ZFCP_STATUS_ADAPTER_ERP_ACCEPT, &adapter->status))
> >  		return -EIO;
> > 
> >  	debug_event(adapter->erp_dbf, 4, &action, sizeof (int));
> > --- a/drivers/s390/scsi/zfcp_ccw.c	2008-03-10 12:34:48.000000000 +0100
> > +++ b/drivers/s390/scsi/zfcp_ccw.c	2008-03-10 16:05:26.000000000 +0100
> > @@ -198,7 +198,6 @@ zfcp_ccw_set_offline(struct ccw_device *
> >  	down(&zfcp_data.config_sema);
> >  	adapter = dev_get_drvdata(&ccw_device->dev);
> >  	zfcp_erp_adapter_shutdown(adapter, 0);
> > -	zfcp_erp_wait(adapter);
> >  	zfcp_erp_thread_kill(adapter);
> 
> And as a sidenote, if the scenario this patch is supposed to fix can really
> happen, how can you make sure the adapter is still down before the erp thread
> gets killed? Some action could have been enqueued and finished which reopened
> the adapter after zfcp_erp_adapter_shutdown and before zfcp_erp_thread_kill.
> Just wondering... :)

You acting the innocent... :)

As to question one - Is there a way for recovery being triggered when we
are about to kill the recovery thread during the adapter offlining
procedure:
I am not sure. There are many potential triggers for error recovery.
Some code path might be blocked when an adapter has been shut down
(zfcp_fsf.c). I could review each one of them, and maybe add a comment
about the assumption in the zfcp_ccw.c. But I don't like the idea of
some one adding another recovery trigger somewhere in the driver in the
future, not taking heed of this assumption.

That is why, I'd rather have the error recovery shutdown procedure be
airtight and self-dependent in the first place and have it not rely on
shaky assumptions about the code which uses it.

As to question two - Do we know for sure the adapter won't be brought
back up again?
With or without my patch, the issue would be there.
Actually my patch is useless as long as it only concernes itself with
bringing recovery to a termination, while disregarding the fact that
recovery needs to be brought to a termination in a way that guarantees
that adapter operation has been stopped.

Thank you,
Martin


