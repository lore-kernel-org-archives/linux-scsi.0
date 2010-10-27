From: "Jack Wang" <jack_wang@usish.com>
Subject: RE: [PATCH] scsi: Add SHT->unlocked_qcmd for host_lock less SHT->queuecommand() dispatch
Date: Wed, 27 Oct 2010 09:52:07 +0800
Message-ID: <EA06876956CB4AC4A0678AD1E6E72840@usish.com.cn>
References: <1288139559-12019-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:51487 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab0J0BtM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Oct 2010 21:49:12 -0400
In-Reply-To: <1288139559-12019-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'Nicholas A. Bellinger'" <nab@linux-iscsi.org>, 'linux-scsi' <linux-scsi@vger.kernel.org>, 'linux-kernel' <linux-kernel@vger.kernel.org>, 'Vasu Dev' <vasu.dev@linux.intel.com>
Cc: 'James Smart' <james.smart@emulex.com>, 'Andrew Vasquez' <andrew.vasquez@qlogic.com>, 'FUJITA Tomonori' <fujita.tomonori@lab.ntt.co.jp>, 'Hannes Reinecke' <hare@suse.de>, 'Joe Eykholt' <jeykholt@cisco.com>, 'Christoph Hellwig' <hch@lst.de>, 'Jon Hawley' <warthog9@kernel.org>, 'MPTFusionLinux' <DL-MPTFusionLinux@lsi.com>, "'eata.c maintainer'" <dario.ballabio@inwind.it>, 'Luben Tuikov' <ltuikov@yahoo.com>, 'mvsas maintainer' <kewei@marvell.com>


From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings all,

This patch adds scsi_dispatch_cmd_unlocked() and scsi_dispatch_cmd_locked()
which are now called directly from scsi_dispatch_cmd() depending upon what
is reported by SHT->unlocked_qcmd on a per driver basis.  Note that by
default
unlocked_qcmd is disabled, and all LLDs not defining a SHT->unlocked_qcmd
will
be using the legacy scsi_dispatch_cmd_locked().

This patch also drops the usage of scsi_cmd_get_serial() in
scsi_dispatch_cmd()
and assumes the legacy SCSI LLDs that depend upon struct
scsi_cmnd->serial_number
will call the now EXPORT_SYMBOL()'ed scsi_cmd_get_serial() call.

This patch also adds a cmd->eh_eflags |= SCSI_EH_SOFTIRQ_DONE assignment in
scsi_softirq_done() in order to signal scsi_try_to_abort_cmd() that the
command
has been completed.  This patch uses blk_test_rq_complete() together with a
new SCSI_EH_SOFTIRQ_DONE in scsi_error.c:scsi_try_to_abort_cmd() in order to
handle the struct scsi_cmnd timeout case intsead w/o scmd->serial_number
usage:

-	if (scmd->serial_number == 0)
+	if ((blk_test_rq_complete(scmd->request)) &&
+	    (scmd->eh_eflags & SCSI_EH_SOFTIRQ_DONE))
		return SUCCESS;

Finally, this patch also converts the remaining struct
Scsi_Host->cmd_serial_number
to atomic_t following a recommedation by Joe Eykholt to start struct
Scsi_Host->
cmd_serial_number at 1, and increment each serial_number by 2 so that the
serial is odd, and wraps to 1 instead of 0.  struct
Scsi_Host->cmd_serial_number
is initialized to '1' in drivers/scsi/hosts.c:scsi_host_alloc().

Along with the changes to SCSI ML, this series includes the following LLD
commits to enable lock-less operation for certain LLDs, and adds the explict
scsi_cmd_get_serial() to the legacy LLDs still requring cmd->serial_number
for anything beyond informational purposes:

libiscsi: Remove host_lock unlock() + lock() from iscsi_queuecommand()
libsas: Remove host_lock unlock() + lock() from sas_queuecommand()
aic94xx: Set SHT->unlocked_qcmd=1 for libsas queuecommand()
mvsas: Set SHT->unlocked_qcmd=1 for libsas queuecommand()
pm8001: Set SHT->unlocked_qcmd=1 for libsas queuecommand()
libata: Remove host_lock unlock() + lock() from ata_scsi_queuecmd()
lpfc: Remove host_lock unlock() + lock() from lpfc_queuecommand()
qla4xxx: Remove host_lock unlock() + lock() from qla4xxx_queuecommand()
qla2xxx: Remove host_lock unlock() + lock() from qla2xxx_queuecommand()
fnic: Remove host_lock unlock() + lock() from fnic_queuecommand()
mpt2sas: Add scsi_cmd_get_serial() call and set SHT->unlocked_qcmd=1
mpt/fusion: Add scsi_cmd_get_serial() call and set SHT->unlocked_qcmd=1
dpt_i2o: Add scsi_cmd_get_serial() call
eata: Add scsi_cmd_get_serial() call
u14-34f: Add scsi_cmd_get_serial() call


Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
Acked-by: Ravi Anand <ravi.anand@qlogic.com> (for qla2xx)
Acked-by: Luben Tuikov <ltuikov@yahoo.com> (for aic94xx)

Hi, Nab

Please consider to add my ack. Thanks!
Acked-by: Jack Wang <jack_wang@usish.com> (for pm8001)

Jack

