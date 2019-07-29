From: Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] scsi: mpt3sas: Fix a possible null-pointer dereference in mpt3sas_transport_update_links()
Date: Mon, 29 Jul 2019 11:08:51 +0800
Message-ID: <20190729030851.22059-1-baijiaju1990@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc: MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
List-Id: linux-scsi@vger.kernel.org

In mpt3sas_transport_update_links(), there is an if statement 
on line 994 to check whether mpt3sas_phy->phy is NULL:
    if (mpt3sas_phy->phy)

When mpt3sas_phy->phy is NULL, it is used on line 999:
    dev_printk(KERN_INFO, &mpt3sas_phy->phy->dev, ...)

Thus, a possible null-pointer dereference may occur.

To fix this bug, mpt3sas_phy->phy is checked before being used.

This bug is found by a static analysis tool STCheck written by us.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/scsi/mpt3sas/mpt3sas_transport.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index 5324662751bf..df790a9877a0 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -995,7 +995,8 @@ mpt3sas_transport_update_links(struct MPT3SAS_ADAPTER *ioc,
 		mpt3sas_phy->phy->negotiated_linkrate =
 		    _transport_convert_phy_link_rate(link_rate);
 
-	if ((ioc->logging_level & MPT_DEBUG_TRANSPORT))
+	if ((ioc->logging_level & MPT_DEBUG_TRANSPORT) && 
+			mpt3sas_phy->phy)
 		dev_printk(KERN_INFO, &mpt3sas_phy->phy->dev,
 		    "refresh: parent sas_addr(0x%016llx),\n"
 		    "\tlink_rate(0x%02x), phy(%d)\n"
-- 
2.17.0
