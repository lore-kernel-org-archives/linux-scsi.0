From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 01/11] libiscsi: Convert to host_lock less w/
	interrupts disabled internally
Date: Thu, 18 Nov 2010 15:30:55 -0800
Message-ID: <1290123055.31890.152.camel@haakon2.linux-iscsi.org>
References: <1290032304-4859-1-git-send-email-nab@linux-iscsi.org>
	 <4CE47C12.80804@cs.wisc.edu> <4CE4F906.3080506@panasas.com>
	 <4CE56FF3.300@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:51786 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760326Ab0KRXgS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Nov 2010 18:36:18 -0500
In-Reply-To: <4CE56FF3.300@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Boaz Harrosh <bharrosh@panasas.com>, linux-scsi <linux-scsi@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@suse.de>, Christoph Hellwig <hch@lst.de>

<Trimming CC list>

On Thu, 2010-11-18 at 12:26 -0600, Mike Christie wrote:
> On 11/18/2010 03:59 AM, Boaz Harrosh wrote:
> > On 11/18/2010 03:06 AM, Mike Christie wrote:
> >> On 11/17/2010 04:18 PM, Nicholas A. Bellinger wrote:
> >>>    prepd_fault:
> >>>    	sc->scsi_done = NULL;
> >>
> >>> -	done(sc);
> >>> -	spin_lock(host->host_lock);
> >>> +	sc->scsi_done(sc);
> >>>    	return 0;
> >>
> >> This will NULL pointer. See a couple lines above where we NULL it.
> >> iscsi_free_task checks if the scsi_done pointer is set and if it is it
> >> will call scsi_done.
> >>
> >> It is a hack to prevent the normal completion path from calling
> >> scsi_done. For the case where we return SCSI_MLQUEUE_TARGET_BUSY (the
> >> prepd_reject case) we need something to prevent scsi_done from getting
> >> called.
> >>
> >> For the return 0/prepd_fault case we can just call sc->scsi_done, but we
> >> have to move some code around.
> >>
> >> I do not like how the code does the NULLing and testing. Let me work on
> >> this and send a tested patch.
> >
> > Mike if you are on this. Do you think we need the _irqsave locking.
> > I always thought that the network receive is not on the HW interrupt
> > but on a completion thread. Could you verify?
> >
> 
> Yeah, we do not need the irqsave locking, because for software iscsi the 
> session lock is just locked in softirqs/timers and the iscsi xmit 
> thread. For offload and iser (be2iscsi, bnx2i, iser and cxgb*) we have 
> similar combinations (some drivers have a tasklet thrown in there too) 
> and no real interrupts.
> 

Indeed, I have been meaning to ping you about this..  I had originally
assumed that the software case would be OK to drop this, but was unsure
about the HW offload case.  Thanks for the clarification here that we
can gain the extra benefit here..

I am commiting the following incremental patch to
lock_less-LLDs-for-38-v2, and will apply your forthcoming NULL
sc->scsi_done() cleanup patch on top of this for v3.

Thanks Mike!

--nab


>From 51f6d901d9b175c6a83c31eb1ffe3ac0fc0a7b5b Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Thu, 18 Nov 2010 23:31:01 +0000
Subject: [PATCH] libiscsi: Do not disable interrupts around queuecommand session->lock

This patch follows Mike Christie's recommendation that there is no hard
requirement for either Open-iSCSI software mode or existing HW offload
to disable interrupts around session->lock in iscsi_queuecommand().

Reported-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/libiscsi.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 499f837..5535782 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1608,7 +1608,6 @@ int iscsi_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
        struct iscsi_session *session;
        struct iscsi_conn *conn;
        struct iscsi_task *task = NULL;
-       unsigned long irq_flags;

        sc->result = 0;
        sc->SCp.ptr = NULL;
@@ -1618,7 +1617,7 @@ int iscsi_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)

        cls_session = starget_to_session(scsi_target(sc->device));
        session = cls_session->dd_data;
-       spin_lock_irqsave(&session->lock, irq_flags);
+       spin_lock(&session->lock);

        reason = iscsi_session_chkready(cls_session);
        if (reason) {
@@ -1704,14 +1703,14 @@ int iscsi_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
        }

        session->queued_cmdsn++;
-       spin_unlock_irqrestore(&session->lock, irq_flags);
+       spin_unlock(&session->lock);
        return 0;

 prepd_reject:
        sc->scsi_done = NULL;
        iscsi_complete_task(task, ISCSI_TASK_COMPLETED);
 reject:
-       spin_unlock_irqrestore(&session->lock, irq_flags);
+       spin_unlock(&session->lock);
        ISCSI_DBG_SESSION(session, "cmd 0x%x rejected (%d)\n",
                          sc->cmnd[0], reason);
        return SCSI_MLQUEUE_TARGET_BUSY;
@@ -1720,7 +1719,7 @@ prepd_fault:
        sc->scsi_done = NULL;
        iscsi_complete_task(task, ISCSI_TASK_COMPLETED);
 fault:
-       spin_unlock_irqrestore(&session->lock, irq_flags);
+       spin_unlock(&session->lock);
        ISCSI_DBG_SESSION(session, "iscsi: cmd 0x%x is not queued (%d)\n",
                          sc->cmnd[0], reason);
        if (!scsi_bidi_cmnd(sc))
-- 
1.7.2.3



