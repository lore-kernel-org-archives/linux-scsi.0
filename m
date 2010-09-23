From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC v3 14/15] eata: Add scsi_cmd_get_serial() call
Date: Thu, 23 Sep 2010 16:39:31 -0700
Message-ID: <1285285171-16626-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp104.sbc.mail.ac4.yahoo.com ([76.13.13.243]:27209 "HELO
	smtp104.sbc.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756413Ab0IWXjh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Sep 2010 19:39:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux>
Cc: James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>, Christoph Hellwig <hch@lst.de>, MPTFusionLinux <DL-MPTFusionLinux@lsi.com>, "eata.c maintainer" <dario.ballabio@inwind.it>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds a scsi_cmd_get_serial() call in eata2x_queuecommand()
to setup a valid struct scsi_cmnd->serial_number because ihdlr() still
depends upon this being set.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/eata.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
index d1c3137..e56a0d7 100644
--- a/drivers/scsi/eata.c
+++ b/drivers/scsi/eata.c
@@ -1765,6 +1765,11 @@ static int eata2x_queuecommand(struct scsi_cmnd *SCpnt,
 	struct hostdata *ha = (struct hostdata *)shost->hostdata;
 	unsigned int i, k;
 	struct mscp *cpp;
+        /*
+	 * Call scsi_cmd_get_serial() because we need a valid serial number
+	 * for the main eata interrupt handler in ihdlr()
+	 */
+        scsi_cmd_get_serial(SCpnt);
 
 	if (SCpnt->host_scribble)
 		panic("%s: qcomm, pid %ld, SCpnt %p already active.\n",
-- 
1.7.3

