From: Dan Williams <dan.j.williams@intel.com>
Subject: [3.2-rc PATCH 6/8] isci: link speeds default to gen 2
Date: Fri, 16 Dec 2011 16:53:41 -0800
Message-ID: <20111217005341.14133.99327.stgit@localhost6.localdomain6>
References: <20111217004820.14133.19249.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:23180 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752708Ab1LQAxm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Dec 2011 19:53:42 -0500
In-Reply-To: <20111217004820.14133.19249.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

From: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

Gen-3 operation is marginal, default to gen-2 for now.

Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/host.c |    5 +++--
 drivers/scsi/isci/init.c |    2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/isci/host.c b/drivers/scsi/isci/host.c
index ecaa7bb..b09c36b 100644
--- a/drivers/scsi/isci/host.c
+++ b/drivers/scsi/isci/host.c
@@ -1676,8 +1676,9 @@ static void sci_controller_set_default_config_parameters(struct isci_host *ihost
 
 	/* Initialize all of the phy parameter information. */
 	for (index = 0; index < SCI_MAX_PHYS; index++) {
-		/* Default to 6G (i.e. Gen 3) for now. */
-		ihost->user_parameters.phys[index].max_speed_generation = 3;
+		/* Default to 3G (i.e. Gen 2). */
+		ihost->user_parameters.phys[index].max_speed_generation =
+			SCIC_SDS_PARM_GEN2_SPEED;
 
 		/* the frequencies cannot be 0 */
 		ihost->user_parameters.phys[index].align_insertion_frequency = 0x7f;
diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index 3c4ddad..2bcfb40 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -114,7 +114,7 @@ u16 stp_inactive_to = 5;
 module_param(stp_inactive_to, ushort, 0);
 MODULE_PARM_DESC(stp_inactive_to, "STP inactivity timeout (100us incr)");
 
-unsigned char phy_gen = 3;
+unsigned char phy_gen = SCIC_SDS_PARM_GEN2_SPEED;
 module_param(phy_gen, byte, 0);
 MODULE_PARM_DESC(phy_gen, "PHY generation (1: 1.5Gbps 2: 3.0Gbps 3: 6.0Gbps)");
 

