From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC v4 06/19] pm8001: Set SHT->unlocked_qcmd=1 for libsas queuecommand()
Date: Mon, 27 Sep 2010 19:06:00 -0700
Message-ID: <1285639560-7325-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux>
Cc: James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>, Christoph Hellwig <hch@lst.de>, Jon Hawley <warthog9@kernel.org>, MPTFusionLinux <DL-MPTFusionLinux@lsi.com>, "eata.c maintainer" <dario.ballabio@inwind.it>, Luben Tuikov <ltuikov@yahoo.com>, mvsas maintainer <kewei@marvell.com>, pm8001 maintainer Jack Wang <jack_wang@usish.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch updates pm8001 to set struct scsi_host_template->unlocked_qcmd=1
because it is using generic libsas sas_queuecommand() code which now can be
run without struct Scsi_Host->host_lock held following the original
host_lock unlock -> do_work() -> lock optimization in sas_queuecommand().

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/pm8001/pm8001_init.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index f8c86b2..96e1dd6 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -69,6 +69,7 @@ static struct scsi_host_template pm8001_sht = {
 	.can_queue		= 1,
 	.cmd_per_lun		= 1,
 	.this_id		= -1,
+	.unlocked_qcmd		= 1,
 	.sg_tablesize		= SG_ALL,
 	.max_sectors		= SCSI_DEFAULT_MAX_SECTORS,
 	.use_clustering		= ENABLE_CLUSTERING,
-- 
1.7.3
