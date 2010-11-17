From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 04/11] libsas: Convert to host_lock less w/ interrupts
	disabled externally
Date: Wed, 17 Nov 2010 14:36:11 -0800
Message-ID: <1290033371.31890.66.camel@haakon2.linux-iscsi.org>
References: <1290032331-4919-1-git-send-email-nab@linux-iscsi.org>
	 <20101117223053.GB26760@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:34629 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935070Ab0KQWlh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Nov 2010 17:41:37 -0500
In-Reply-To: <20101117223053.GB26760@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@suse.de>, Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Ravi Anand <ravi.anand@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Joe Eykholt <jeykholt@cisco.com>, James Smart <james.smart@emulex.com>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Tejun Heo <tj@kernel.org>, Mike Anderson <andmike@linux.vnet.ibm.com>, MPTFusionLinux <DL-MPTFusionLinux@lsi.com>

On Wed, 2010-11-17 at 17:30 -0500, Christoph Hellwig wrote:
> > @@ -189,7 +189,7 @@ int sas_queue_up(struct sas_task *task)
> >   * Note: XXX: Remove the host unlock/lock pair when SCSI Core can
> >   * call us without holding an IRQ spinlock...
> 
> That comment can be removed now.
> 
> >   */
> > -static int sas_queuecommand_lck(struct scsi_cmnd *cmd,
> 
> That's now how the code looks like upstream.
> 
> > +static int sas_queuecommand_irq_disable(struct scsi_cmnd *cmd,
> >  		     void (*scsi_done)(struct scsi_cmnd *))
> >  	__releases(host->host_lock)
> >  	__acquires(dev->sata_dev.ap->lock)
> 
> The host_lock annotations are not incorrect, and the sata_dev ones
> never made sense.
> 
> > @@ -254,7 +254,7 @@ out:
> >  	return res;
> >  }
> >  
> > -DEF_SCSI_QCMD(sas_queuecommand)
> > +IRQ_DISABLE_SCSI_QCMD(sas_queuecommand)
> 
> And in addition this doesn't even seem correct to me.  First thing
> sas_queuecommand upstream does is spin_unlock_irq on the host_lock
> which it expects to be held, then it does a spin_lock_irqsave for the
> sata case, or operations that do not appear to need a lock for the
> sas case.

Ugh, this was the one patch that I carried forwad and had to apply by
hand, and evidently I missed the some bits.  Pushing this commit now..

Thanks,

>From 444d87126389286c869d10c947707c1d33855995 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Wed, 17 Nov 2010 22:38:23 +0000
Subject: [PATCH] libsas: Added dropped bits for host_lock-less operation

This patch fixes drop-lock_less usage, lockdep annotation, and comment
changes that where dropped while moving the libsas forward.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
Reported-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/libsas/sas_scsi_host.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/libsas/sas_scsi_host.c
b/drivers/scsi/libsas/sas_scsi_host.c
index 595ed21..011580f 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -185,24 +185,17 @@ int sas_queue_up(struct sas_task *task)
 /**
  * sas_queuecommand -- Enqueue a command for processing
  * @parameters: See SCSI Core documentation
- *
- * Note: XXX: Remove the host unlock/lock pair when SCSI Core can
- * call us without holding an IRQ spinlock...
  */
 static int sas_queuecommand_irq_disable(struct scsi_cmnd *cmd,
                     void (*scsi_done)(struct scsi_cmnd *))
-       __releases(host->host_lock)
        __acquires(dev->sata_dev.ap->lock)
        __releases(dev->sata_dev.ap->lock)
-       __acquires(host->host_lock)
 {
        int res = 0;
        struct domain_device *dev = cmd_to_domain_dev(cmd);
        struct Scsi_Host *host = cmd->device->host;
        struct sas_internal *i = to_sas_internal(host->transportt);

-       spin_unlock_irq(host->host_lock);
-
        {
                struct sas_ha_struct *sas_ha = dev->port->ha;
                struct sas_task *task;
@@ -250,7 +243,6 @@ static int sas_queuecommand_irq_disable(struct
scsi_cmnd *cmd,
                }
        }
 out:
-       spin_lock_irq(host->host_lock);
        return res;
 }

-- 
1.7.2.3


> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

