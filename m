From: ravi.anand@qlogic.com
Subject: [PATCH 02/11] Drop IPAddr*() functions.
Date: Tue, 7 Mar 2006 16:35:22 -0800
Message-ID: <1141778117884-git-send-email-ravi.anand@qlogic.com>
References: <11417781172980-git-send-email-ravi.anand@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:34543 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S964849AbWCHAf0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Mar 2006 19:35:26 -0500
In-Reply-To: <11417781172980-git-send-email-ravi.anand@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, arjan@infradead.org
Cc: ravi.anand@qlogic.com

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>


---

 drivers/scsi/qla4xxx/ql4_def.h  |   14 --------------
 drivers/scsi/qla4xxx/ql4_init.c |    3 ++-
 2 files changed, 2 insertions(+), 15 deletions(-)

a94b5548a92d8f6feae73f15f631a74aeed8ba2c
diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index 8c75929..c2e5f56 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -84,20 +84,6 @@
 #define BIT_30	0x40000000
 #define BIT_31	0x80000000
 
-#define IPAddrIsZero( _X1_ )   ((_X1_)[0] == 0 && \
-                                (_X1_)[1] == 0 && \
-                                (_X1_)[2] == 0 && \
-                                (_X1_)[3] == 0)
-#define IPAddrIsEqual(_X1_, _X2_) ((_X1_)[0] == (_X2_)[0] && \
-                                   (_X1_)[1] == (_X2_)[1] && \
-                                   (_X1_)[2] == (_X2_)[2] && \
-                                   (_X1_)[3] == (_X2_)[3])
-#define IPAddr2Uint32(_X1_,_X2_) { \
-                                  *_X2_ = 0; \
-				  *_X2_ |= _X1_[3] << 24; \
-				  *_X2_ |= _X1_[2] << 16; \
-				  *_X2_ |= _X1_[1] << 8;  \
-				  *_X2_ |= _X1_[0];}
 /*
  * Host adapter default definitions
  ***********************************/
diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index 5ad55ec..16dfb26 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -1250,7 +1250,8 @@ qla4xxx_initialize_adapter(scsi_qla_host
 		return status;
 
 	/* Skip device discovery if ip and subnet is zero */
-	if (IPAddrIsZero(ha->ip_address) || IPAddrIsZero(ha->subnet_mask))
+	if (memcmp(ha->ip_address, 0, IP_ADDR_LEN) ||
+	    memcmp(ha->subnet_mask, 0, IP_ADDR_LEN))
 		return status;
 
 	if (renew_ddb_list == PRESERVE_DDB_LIST) {
-- 
1.2.4.g9201-dirty


