From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Subject: Re: [BUG] Oops when SCSI device under multipath is removed
Date: Wed, 31 Aug 2011 16:50:22 -0300
Message-ID: <20110831195022.GE4004@oc1711230544.ibm.com>
References: <Pine.LNX.4.44L0.1108111112280.1958-100000@iolanthe.rowland.org>
 <4E4A53F0.9040104@ce.jp.nec.com>
 <4E4CD737.4020402@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e24smtp02.br.ibm.com ([32.104.18.86]:46033 "EHLO
	e24smtp02.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484Ab1HaTud (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Aug 2011 15:50:33 -0400
Content-Disposition: inline
In-Reply-To: <4E4CD737.4020402@ce.jp.nec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Tejun Heo <tj@kernel.org>, Alan Stern <stern@rowland.harvard.edu>, jaxboe@fusionio.com, roland@purestorage.com, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, Kiyoshi Ueda <k-ueda@ct.jp.ne>

On Thu, Aug 18, 2011 at 06:11:19PM +0900, Jun'ichi Nomura wrote:
> Hi James,
> 
> On 08/16/11 20:26, Jun'ichi Nomura wrote:
> > The commit log of 86cbfb5607d4b81b1a993ff689bbd2addd5d3a9b
> > ("[SCSI] put stricter guards on queue dead checks") does not
> > explain about the move of scsi_free_queue().
> > 
> > But according to the discussion below, it seems
> > the move was motivated to solve the following self-deadlock:
> > https://lkml.org/lkml/2011/4/12/9
> > 
> >   [in the context of kblockd_workqueue]
> >   blk_delay_work
> >     __blk_run_queue
> >       scsi_request_fn
> >         put_device
> >           (puts final sdev refcount)
> >              scsi_device_dev_release
> >                execute_in_process_context(scsi_device_dev_release_usercontext)
> >                  [execute immediately because it's in process context]
> >                     scsi_device_dev_release_usercontext
> >                       scsi_free_queue
> >                         blk_cleanup_queue
> >                           blk_sync_queue
> >                             (wait for blk_delay_work to complete...)
> > 
> > James, is my understanding correct?
> > 
> > If so, isn't it possible to move the scsi_free_queue back to
> > the original place and solve the deadlock instead by
> > avoiding the wait in the same context?
> 
> Actually, Tejun has posted a patch to replace
> execute_in_process_context() with queue_work()
> and asking your review:
> 
>   [PATCH RESEND] scsi: don't use execute_in_process_context()
>   https://lkml.org/lkml/2011/4/30/87
> 
> Do you think you can take the patch and revert the move
> of scsi_free_queue()?
> 
> Thanks,
> -- 
> Jun'ichi Nomura, NEC Corporation
> --

I've tested with your suggestion (reverting the move of scsi_free_queue)
and it works like a charm. I did not get any oops after that. I tested
with a multipath setup on top of two iscsi targets. Using dd after
logging out of some of one of the iscsi targets would trigger the oops.
With this patch, it could not be triggered anymore.

Best regards,
Cascardo.

--

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index e0bd3f7..a6eb6f1 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -322,7 +322,11 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 		kfree(evt);
 	}
 
+	/* Freeing the queue signals to block that we're done */
+	scsi_free_queue(sdev->request_queue);
+
 	blk_put_queue(sdev->request_queue);
+
 	/* NULL queue means the device can't be used */
 	sdev->request_queue = NULL;
 
@@ -936,8 +940,6 @@ void __scsi_remove_device(struct scsi_device *sdev)
 	/* cause the request function to reject all I/O requests */
 	sdev->request_queue->queuedata = NULL;
 
-	/* Freeing the queue signals to block that we're done */
-	scsi_free_queue(sdev->request_queue);
 	put_device(dev);
 }
 
---

