From: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH 13/15] scsi: make device_type const
Date: Sat, 19 Aug 2017 13:52:24 +0530
Message-ID: <1503130946-2854-14-git-send-email-bhumirks__49956.6360413612$1503131237$gmane$org@gmail.com>
References: <1503130946-2854-1-git-send-email-bhumirks@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:34159 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752013AbdHSI1J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Aug 2017 04:27:09 -0400
In-Reply-To: <1503130946-2854-1-git-send-email-bhumirks@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: julia.lawall@lip6.fr, bp@alien8.de, mchehab@kernel.org, daniel.vetter@intel.com, jani.nikula@linux.intel.com, seanpaul@chromium.org, airlied@linux.ie, g.liakhovetski@gmx.de, tomas.winkler@intel.com, dwmw2@infradead.org, computersforpeace@gmail.com, boris.brezillon@free-electrons.com, marek.vasut@gmail.com, richard@nod.at, cyrille.pitchen@wedev4u.fr, peda@axentia.se, kishon@ti.com, bhelgaas@google.com, thierry.reding@gmail.com, jonathanh@nvidia.com, dvhart@infradead.org, andy@infradead.org, ohad@wizery.com, bjorn.andersson@linaro.org, freude@de.ibm.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, jth@kernel.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, lduncan@suse.com, cleech@redhat.com, johan@kernel.org, elder@kernel.org, gregkh@linuxfoundation.orgheik
Cc: Bhumika Goyal <bhumirks@gmail.com>

Make these const as they are only stored in the type field of a device
structure, which is const.
Done using Coccinelle.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/scsi/fcoe/fcoe_sysfs.c      | 4 ++--
 drivers/scsi/scsi_transport_iscsi.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_sysfs.c b/drivers/scsi/fcoe/fcoe_sysfs.c
index 9cf3d56..5c8310b 100644
--- a/drivers/scsi/fcoe/fcoe_sysfs.c
+++ b/drivers/scsi/fcoe/fcoe_sysfs.c
@@ -659,13 +659,13 @@ static void fcoe_fcf_device_release(struct device *dev)
 	kfree(fcf);
 }
 
-static struct device_type fcoe_ctlr_device_type = {
+static const struct device_type fcoe_ctlr_device_type = {
 	.name = "fcoe_ctlr",
 	.groups = fcoe_ctlr_attr_groups,
 	.release = fcoe_ctlr_device_release,
 };
 
-static struct device_type fcoe_fcf_device_type = {
+static const struct device_type fcoe_fcf_device_type = {
 	.name = "fcoe_fcf",
 	.groups = fcoe_fcf_attr_groups,
 	.release = fcoe_fcf_device_release,
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index a424eae..b9513f8 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1009,7 +1009,7 @@ static void iscsi_flashnode_sess_release(struct device *dev)
 	kfree(fnode_sess);
 }
 
-static struct device_type iscsi_flashnode_sess_dev_type = {
+static const struct device_type iscsi_flashnode_sess_dev_type = {
 	.name = "iscsi_flashnode_sess_dev_type",
 	.groups = iscsi_flashnode_sess_attr_groups,
 	.release = iscsi_flashnode_sess_release,
@@ -1195,7 +1195,7 @@ static void iscsi_flashnode_conn_release(struct device *dev)
 	kfree(fnode_conn);
 }
 
-static struct device_type iscsi_flashnode_conn_dev_type = {
+static const struct device_type iscsi_flashnode_conn_dev_type = {
 	.name = "iscsi_flashnode_conn_dev_type",
 	.groups = iscsi_flashnode_conn_attr_groups,
 	.release = iscsi_flashnode_conn_release,
-- 
1.9.1
