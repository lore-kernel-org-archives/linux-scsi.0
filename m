From: Alan <gnomes@lxorguk.ukuu.org.uk>
Subject: [PATCH] ibmraid: fix writeable attribute with no store method
Date: Wed, 27 Aug 2014 16:27:20 +0100
Message-ID: <20140827152700.7694.65005.stgit@alan.etchedpixels.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cpc5-cwma8-2-0-cust185.7-3.cable.virginm.net ([82.17.37.186]:37081
	"EHLO alan.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934491AbaH0Pfq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Aug 2014 11:35:46 -0400
Received: from alan.etchedpixels.co.uk (localhost [127.0.0.1])
	by alan.etchedpixels.co.uk (8.14.4/8.14.4/Debian-4.1ubuntu1) with ESMTP id s7RFRKO5007719
	for <linux-scsi@vger.kernel.org>; Wed, 27 Aug 2014 16:27:21 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=81311

 [ 0.603157] WARNING: at drivers/base/core.c:601
device_create_file+0x8d/0xa0()
 [ 0.603158] Attribute adapter_id: write permission without 'store'
 [ 0.603159] Modules linked in: i915(+) i2c_algo_bit drm_kms_helper drm
mpt2sas(+) pmcraid(+) raid_class scsi_transport_sas i2c_core video

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 drivers/scsi/pmcraid.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 6f3275d..e2232c3 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -4292,7 +4292,7 @@ static ssize_t pmcraid_show_adapter_id(
 static struct device_attribute pmcraid_adapter_id_attr = {
 	.attr = {
 		 .name = "adapter_id",
-		 .mode = S_IRUGO | S_IWUSR,
+		 .mode = S_IRUGO,
 		 },
 	.show = pmcraid_show_adapter_id,
 };

