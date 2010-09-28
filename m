From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC v4 17/19] dpt_i2o: Add scsi_cmd_get_serial() call
Date: Mon, 27 Sep 2010 19:08:00 -0700
Message-ID: <1285639680-7545-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux>
Cc: James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>, Christoph Hellwig <hch@lst.de>, Jon Hawley <warthog9@kernel.org>, MPTFusionLinux <DL-MPTFusionLinux@lsi.com>, "eata.c maintainer" <dario.ballabio@inwind.it>, Luben Tuikov <ltuikov@yahoo.com>, mvsas maintainer <kewei@marvell.com>, pm8001 maintainer Jack Wang <jack_wang@usish.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds a scsi_cmd_get_serial() call in adpt_queue() to setup a
valid struct scsi_cmnd->serial_number because adpt_cmd_to_context() still
depends upon this being set.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/dpt_i2o.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index ffc1edf..b4dfaf7 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -429,6 +429,11 @@ static int adpt_queue(struct scsi_cmnd * cmd, void (*done) (struct scsi_cmnd *))
 
 	cmd->scsi_done = done;
 	/*
+	 * Call scsi_cmd_get_serial() because we need a valid serial number
+	 * for adpt_cmd_to_context()
+	 */
+	scsi_cmd_get_serial(cmd);
+	/*
 	 * SCSI REQUEST_SENSE commands will be executed automatically by the 
 	 * Host Adapter for any errors, so they should not be executed 
 	 * explicitly unless the Sense Data is zero indicating that no error 
-- 
1.7.3
