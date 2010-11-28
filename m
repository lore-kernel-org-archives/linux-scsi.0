From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/3] megaraid_sas: Convert to host_lock less w/ interrupts disabled internally
Date: Sat, 27 Nov 2010 23:17:33 -0800
Message-ID: <1290928656-31116-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm21.bullet.mail.sp2.yahoo.com ([98.139.91.91]:32770 "HELO
	nm21.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751538Ab0K1HR5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 28 Nov 2010 02:17:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Bo Yang <Bo.Yang@lsi.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@suse.de>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings Hannes, Bo and Co,

This series converts megaraid_sas to run in modern host_lock-less mode
for >= .37-rc3+ with interrupts disabled internally around megasas_instance->hba_lock.
This series is currently living in lio-core-2.6.git/lock_less-LLDs-for-38-v2,
and is intended for .38 mainline code.

The first patch adds a handful of missing barriers around instance->fw_outstanding
usage w/ atomic_add() and atomic_dec().

The second converts instance->issuepend_done to an atomic_t, along with
the necessary assignments in order to run w/ Scsi_Host->host_lock, and
without instance->hba_lock.

The third patch does the actual conversion, and adds a __megasas_get_cmd()
usased by megasas_queue_command() w/ instance->hba_lock, along with
being held for megasas_build_ldio() and megasas_build_dcdb() in order
to locate the proper frame for struct megasas_cmd.  This is really the
one major change in order to get host_lock-less to function with interrupts
disabled around hba_lock.

So far this has been tested with Hannes's QEMU 8708EM2 HBA emulation with
TCM_Loop backends using SG_IO from KVM host in a paired Host/Guest .37-rc3
environment.  This has not been tested on real silicon yet, but I believe
this series should be working there as well.

Comments are welcome, thanks!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Nicholas Bellinger (3):
  megaraid_sas: Add smp_mb__after_atomic_*() for
    instance->fw_outstanding
  megaraid_sas: Convert instance->issuepend_done to atomic_t
  megaraid_sas: Convert SHT->queuecommand() to run host_lock-less

 drivers/scsi/megaraid/megaraid_sas.c |   84 ++++++++++++++++++++++-----------
 drivers/scsi/megaraid/megaraid_sas.h |    2 +-
 2 files changed, 57 insertions(+), 29 deletions(-)

-- 
1.7.2.3

