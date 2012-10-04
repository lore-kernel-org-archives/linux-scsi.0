From: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [qla2xxx] INFO: possible irq lock inversion dependency
 detected
Date: Thu, 4 Oct 2012 15:02:00 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1210041500010.9942@pobox.suse.cz>
References: <506D80C2.5040405@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35465 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754119Ab2JDNCK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Oct 2012 09:02:10 -0400
In-Reply-To: <506D80C2.5040405@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>

On Thu, 4 Oct 2012, Srivatsa S. Bhat wrote:

> With the mainline kernel (in the merge window) I am seeing the following lockdep
> splat every time during boot.
> 
> Regards,
> Srivatsa S. Bhat
> 
> ------------------------------------>
> 
> [    3.940316] SCSI subsystem initialized
> [    3.949021] Fusion MPT base driver 3.04.20
> [    3.953141] Copyright (c) 1999-2008 LSI Corporation
> [    3.955471] Fusion MPT SAS Host driver 3.04.20
> [    3.955850] mptbase: ioc0: Initiating bringup
> [    4.656179] ioc0: LSISAS1064E B3: Capabilities={Initiator}
> [   16.216323] scsi0 : ioc0: LSISAS1064E B3, FwRev=011e0000h, Ports=1, MaxQ=277, IRQ=28
> [   16.248414] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 1, phy 0, sas_addr 0x5000c5001d7e18c9
> [   16.259708] scsi 0:0:0:0: Direct-Access     IBM-ESXS ST9146803SS      B536 PQ: 0 ANSI: 5
> [   16.271986] mptsas: ioc0: attaching sata device: fw_channel 0, fw_id 3, phy 1, sas_addr 0x677c605e9f919a95
> [   16.284288] scsi 0:0:1:0: Direct-Access     ATA      GBRLB031XVECCM   4.26 PQ: 0 ANSI: 5
> [   16.348106] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driver: 8.04.00.03-k.
> [   16.356369] qla2xxx [0000:24:00.0]-001d: : Found an ISP2532 irq 32 iobase 0xffffc9001e0ba000.
> [   16.365364] qla2xxx 0000:24:00.0: irq 66 for MSI/MSI-X
> [   16.370527] qla2xxx 0000:24:00.0: irq 67 for MSI/MSI-X
> [   16.436226] scsi1 : qla2xxx
> [   17.280685] qla2xxx [0000:24:00.0]-505f:1: Link is operational (2 Gbps).
> [   17.780955] 
> [   17.782450] =========================================================
> [   17.784924] [ INFO: possible irq lock inversion dependency detected ]
> [   17.784924] 3.6.0-0.0.0.28.36b5ec9-default #1 Not tainted
> [   17.784924] ---------------------------------------------------------
> [   17.784924] qla2xxx_1_dpc/368 just changed the state of lock:
> [   17.784924]  (&(&ha->vport_slock)->rlock){+.....}, at: [<ffffffffa009b377>] qla2x00_configure_hba+0x197/0x3c0 [qla2xxx]
> [   17.784924] but this lock was taken by another, HARDIRQ-safe lock in the past:
> [   17.784924]  (&(&ha->hardware_lock)->rlock){-.....}

This seems to be real. You should be seeing that since 3.5-rc1 already 
though ... ?

Does the patch below fix that?




From: Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] [SCSI] qla2xxx: fix potential deadlock on ha->hardware_lock

Lockdep reports:

=== [ cut here ] ===
 =========================================================
 [ INFO: possible irq lock inversion dependency detected ]
 3.6.0-0.0.0.28.36b5ec9-default #1 Not tainted
 ---------------------------------------------------------
 qla2xxx_1_dpc/368 just changed the state of lock:
  (&(&ha->vport_slock)->rlock){+.....}, at: [<ffffffffa009b377>] qla2x00_configure_hba+0x197/0x3c0 [qla2xxx]
 but this lock was taken by another, HARDIRQ-safe lock in the past:
  (&(&ha->hardware_lock)->rlock){-.....}

and interrupts could create inverse lock ordering between them.

other info that might help us debug this:
 Possible interrupt unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&(&ha->vport_slock)->rlock);
                               local_irq_disable();
                               lock(&(&ha->hardware_lock)->rlock);
                               lock(&(&ha->vport_slock)->rlock);
  <Interrupt>
    lock(&(&ha->hardware_lock)->rlock);
=== [ cut here ] ===

Fix the potential deadlock by disabling IRQs while holding ha->vport_slock.

Reported-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 drivers/scsi/qla2xxx/qla_init.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 799a58b..48fca47 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2080,6 +2080,7 @@ qla2x00_configure_hba(scsi_qla_host_t *vha)
 	uint8_t       domain;
 	char		connect_type[22];
 	struct qla_hw_data *ha = vha->hw;
+	unsigned long flags;
 
 	/* Get host addresses. */
 	rval = qla2x00_get_adapter_id(vha,
@@ -2154,9 +2155,9 @@ qla2x00_configure_hba(scsi_qla_host_t *vha)
 	vha->d_id.b.area = area;
 	vha->d_id.b.al_pa = al_pa;
 
-	spin_lock(&ha->vport_slock);
+	spin_lock_irqsave(&ha->vport_slock, flags);
 	qlt_update_vp_map(vha, SET_AL_PA);
-	spin_unlock(&ha->vport_slock);
+	spin_unlock_irqrestore(&ha->vport_slock, flags);
 
 	if (!vha->flags.init_done)
 		ql_log(ql_log_info, vha, 0x2010,

-- 
Jiri Kosina
SUSE Labs
