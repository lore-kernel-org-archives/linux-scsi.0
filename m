From: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] scsi: scsi_transport_fc: make a field of fc_internal structure const
Date: Fri, 13 Oct 2017 16:29:57 +0200
Message-ID: <1507904997-26606-1-git-send-email-bhumirks@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: julia.lawall@lip6.fr, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
List-Id: linux-scsi@vger.kernel.org

The 'f' field of the fc_internal structure do not modify the fields
of the fc_function_template structure it points to. And there are no
other pointers initialized with this field 'f'. So, the field 'f' is
never modified and therefore make it const.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/scsi/scsi_transport_fc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index cbd4495..f38975f 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -323,7 +323,7 @@ struct device_attribute device_attr_##_prefix##_##_name = 	\
 
 struct fc_internal {
 	struct scsi_transport_template t;
-	struct fc_function_template *f;
+	const struct fc_function_template *f;
 
 	/*
 	 * For attributes : each object has :
-- 
1.9.1
