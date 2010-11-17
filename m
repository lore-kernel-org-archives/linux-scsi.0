From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH/RFCv2 00/11] First wave of LLD host_lock less conversion
Date: Wed, 17 Nov 2010 14:18:15 -0800
Message-ID: <1290032295-4838-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm23.bullet.mail.sp2.yahoo.com ([98.139.91.93]:35008 "HELO
	nm23.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S934523Ab0KQWSU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Nov 2010 17:18:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@suse.de>, Christoph Hellwig <hch@lst.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Ravi Anand <ravi.anand@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Joe Eykholt <jeykholt@cisco.com>, James Smart <james.smart@emulex.com>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Tejun Heo <tj@kernel.org>, Mike Anderson <andmike@linux.vnet.ibm.com>, MPTFusionLinux <DL-MPTFusionLinux@lsi.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings all,

This series contains the v2 respin for the first series of lock_less LLD
conversion patches now available from lio-core-2.6.git/lock_less-LLDs-for-38-v2
This series is built on top of the recently committed to mainline full host_lock
push down patch by jgarzik @ commit f281233d3, and the recent:

[PATCH] Eliminate error handler overload of the SCSI serial number

The first patch to libiscsi does a conversion to host_lock less whilst using existing
internal spin_lock_irqsave(); do_lld_work(); spin_unlock_irqrestore() LLD locks.
The second patch from jgarzik included in the series does an simlar -> improved
host_lock less conversion w/ interrupts disabled internally from the libata I/O
queuecommand dispatcher.

The third patch adds a IRQ_DISABLE_SCSI_QCMD wrapper similar to DEF_SCSI_QCMD()
that will disable interrupts using local_irq_save() before calling
lld_queuecommand_irq_disable().

The forth -> eleventh patches convert libsas, message/fusion, mpt2sas, fnic, lpfc,
qla2xxx and qla4xxx to run in host_lock less w/ IRQ_DISABLE_SCSI_QCMD().  The final
patch drops the usage of DEF_SCSI_QCMD() around scsi_debug, which is fully capable
of processing I/O w/o hard interrupts disabled.

This code has been generated against this afternoon's .37-rc2, and compile tested only.

To the CC'ed LLD maintainers, please have a look and add your comments / feedback
as necessary.

Thanks!

--nab


Jeff Garzik (1):
  libata: remove SCSI host lock and serial number usage from
    ata_scsi_queuecmd

Nicholas Bellinger (10):
  libiscsi: Convert to host_lock less w/ interrupts disabled internally
  scsi: Add IRQ_DISABLE_SCSI_QCMD wrapper
  libsas: Convert to host_lock less w/ interrupts disabled externally
  message: Convert to host_lock less w/ interrupts disabled externally
  mpt2sas: Convert to host_lock less w/ interrupts disabled externally
  fnic: Convert to host_lock less w/ interrupts disabled externally
  lpfc: Convert to host_lock less w/ interrupts disabled externally
  qla2xxx: Convert to host_lock less w/ interrupts disabled externally
  qla4xxx: Convert to host_lock less w/ interrupts disabled externally
  scsi_debug: Convert to host_lock less

 drivers/ata/libata-scsi.c            |   21 +++++++++------------
 drivers/message/fusion/mptfc.c       |    2 +-
 drivers/message/fusion/mptsas.c      |    6 +++---
 drivers/message/fusion/mptscsih.c    |    8 +++++---
 drivers/message/fusion/mptscsih.h    |    2 +-
 drivers/message/fusion/mptspi.c      |    6 +++---
 drivers/scsi/fnic/fnic_scsi.c        |   14 +++-----------
 drivers/scsi/libiscsi.c              |   19 +++++++------------
 drivers/scsi/libsas/sas_scsi_host.c  |    4 ++--
 drivers/scsi/lpfc/lpfc_scsi.c        |    9 ++++-----
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |    6 +++---
 drivers/scsi/qla2xxx/qla_os.c        |   11 +++--------
 drivers/scsi/qla4xxx/ql4_os.c        |   10 +++-------
 drivers/scsi/scsi_debug.c            |   16 +++++++---------
 include/scsi/scsi_host.h             |   14 ++++++++++++++
 15 files changed, 68 insertions(+), 80 deletions(-)

-- 
1.7.2.3

