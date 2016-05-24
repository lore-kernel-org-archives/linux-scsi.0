From: Thomas Huth <thuth@redhat.com>
Subject: [PATCH] scsi/qla2xxx: Remove erroneous macro qla82xx_get_temp_val1()
Date: Tue, 24 May 2016 12:27:34 +0200
Message-ID: <1464085654-7485-1-git-send-email-thuth@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575AbcEXK1i (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 May 2016 06:27:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: trivial@kernel.org, qla2xxx-upstream@qlogic.com, linux-scsi@vger.kernel.org
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com

That macros uses logical "&&" instead of bit-wise "&" which is
apparently wrong. Since the macro is completely unused, simply
remove it, so that nobody can accidentially use it anymore.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 drivers/scsi/qla2xxx/qla_nx.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.h b/drivers/scsi/qla2xxx/qla_nx.h
index 59c4778..6201dce 100644
--- a/drivers/scsi/qla2xxx/qla_nx.h
+++ b/drivers/scsi/qla2xxx/qla_nx.h
@@ -1183,7 +1183,6 @@ static const int MD_MIU_TEST_AGT_RDDATA[] = { 0x410000A8, 0x410000AC,
 #define CRB_NIU_XG_PAUSE_CTL_P1        0x8
 
 #define qla82xx_get_temp_val(x)          ((x) >> 16)
-#define qla82xx_get_temp_val1(x)          ((x) && 0x0000FFFF)
 #define qla82xx_get_temp_state(x)        ((x) & 0xffff)
 #define qla82xx_encode_temp(val, state)  (((val) << 16) | (state))
 
-- 
1.8.3.1

