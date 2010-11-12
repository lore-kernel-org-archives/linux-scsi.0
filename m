From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 00/11] [PATCH,RFC] First wave of LLD host_lock less conversion
Date: Thu, 11 Nov 2010 16:13:19 -0800
Message-ID: <1289520799-16418-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp107.sbc.mail.gq1.yahoo.com ([67.195.14.110]:32855 "HELO
	smtp107.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754128Ab0KLANY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Nov 2010 19:13:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@suse.de>, Christoph Hellwig <hch@lst.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Ravi Anand <ravi.anand@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Joe Eykholt <jeykholt@cisco.com>, James Smart <james.smart@emulex.com>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Tejun Heo <tj@kernel.org>, Mike Anderson <andmike@linux.vnet.ibm.com>, MPTFusionLinux <DL-MPTFusionLinux@lsi.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings folks,

Following the input of a number of folks over the past 8+ weeks, this series
does the conversion of the first wave of libs and LLDs to use host_lock less
mode.  This patch is based upon jgarzik's full host_lock push down commit 3039f3ffcc5
and the atomic_t Scsi_Host->cmd_serial_number patch from commit bb5df6d08404
in lio-core-2.6.git.

The first and second patches for libiscsi and libata do a conversion to host_lock less
whilst using existing internal spin_lock_irqsave(); do_lld_work(); spin_unlock_irqrestore()
LLD locks.

The third patch adds a IRQ_DISABLE_SCSI_QCMD wrapper similar to DEF_SCSI_QCMD()
that will disable interrupts using local_irq_save() before calling
lld_queuecommand_irq_disable().

The forth -> tenth patches convert libsas, message/fusion, mpt2sas, fnic, lpfc,
qla2xxx and qla4xxx to run in host_lock less w/ IRQ_DISABLE_SCSI_QCMD().  The final
patch drops the usage of DEF_SCSI_QCMD() around scsi_debug, which is fully capable
of processing I/O w/o hard interrupts disabled.

This code will be pushed into lio-core-2.6.git/lock_less-LLDs-for-38 shortly,
and will be respun as necessary based on LLD maintainer feedback and ACKs.

Thank you!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Nicholas Bellinger (11):
  libiscsi: Convert to host_lock less w/ interrupts disabled internally
  libata: Convert to host_lock less w/ interrupts disabled internally
  scsi: Add IRQ_DISABLE_SCSI_QCMD wrapper
  libsas: Convert to host_lock less w/ interrupts disabled externally
  message: Convert to host_lock less w/ interrupts disabled externally
  mpt2sas: Convert to host_lock less w/ interrupts disabled externally
  fnic: Convert to host_lock less w/ interrupts disabled externally
  lpfc: Convert to host_lock less w/ interrupts disabled externally
  qla2xxx: Convert to host_lock less w/ interrupts disabled externally
  qla4xxx: Convert to host_lock less w/ interrupts disabled externally
  scsi_debug: Convert to host_lock less

 drivers/ata/libata-scsi.c            |   14 ++++----------
 drivers/message/fusion/mptsas.c      |    4 ++--
 drivers/message/fusion/mptscsih.c    |    8 +++++---
 drivers/message/fusion/mptspi.c      |    4 ++--
 drivers/scsi/fnic/fnic_scsi.c        |   14 +++-----------
 drivers/scsi/libiscsi.c              |   17 ++++++-----------
 drivers/scsi/libsas/sas_scsi_host.c  |   11 +++--------
 drivers/scsi/lpfc/lpfc_scsi.c        |    9 ++++-----
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |    6 +++---
 drivers/scsi/qla2xxx/qla_os.c        |   11 +++--------
 drivers/scsi/qla4xxx/ql4_os.c        |   10 +++-------
 drivers/scsi/scsi_debug.c            |    4 +---
 include/scsi/scsi_host.h             |   15 +++++++++++++++
 13 files changed, 54 insertions(+), 73 deletions(-)

-- 
1.7.2.3

