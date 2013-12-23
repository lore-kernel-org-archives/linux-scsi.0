From: Vijaya Mohan Guvva <vmohan@brocade.com>
Subject: [PATCH] bfa: Fix smatch warnings
Date: Mon, 23 Dec 2013 00:18:21 -0800
Message-ID: <1387786701-7876-1-git-send-email-vmohan@Brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:24510 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757191Ab3LWIS0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Dec 2013 03:18:26 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Dan Carpenter <dan.carpenter@oracle.com>

From: Vijaya Mohan Guvva <vguvva@redhat.com>

Fixed following smatch warnings in bfa.
drivers/scsi/bfa/bfa_ioc.c:3882 bfa_sfp_show_comp() error: memcpy()
'des' too small (64 vs 248)
drivers/scsi/bfa/bfa_ioc.c:6859 bfa_flash_status_read() warn: unsigned
'status' is never less than zero.
drivers/scsi/bfa/bfa_ioc.c:6881 bfa_flash_status_read() warn: unsigned
'status' is never less than zero.
drivers/scsi/bfa/bfa_ioc.c:6917 bfa_flash_read_start() warn: unsigned
'status' is never less than zero.
drivers/scsi/bfa/bfa_ioc.c:7043 bfa_flash_raw_read() warn: unsigned
'status' is never less than zero.

Signed-off-by: Vijaya Mohan Guvva <vmohan@brocade.com>
---
 drivers/scsi/bfa/bfa_ioc.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index 65180e1..7e256ef 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -3878,7 +3878,7 @@ bfa_sfp_show_comp(struct bfa_sfp_s *sfp, struct bfi_mbmsg_s *msg)
 		bfa_trc(sfp, sfp->data_valid);
 		if (sfp->data_valid) {
 			u32	size = sizeof(struct sfp_mem_s);
-			u8 *des = (u8 *) &(sfp->sfpmem->srlid_base);
+			u8 *des = (u8 *) &(sfp->sfpmem);
 			memcpy(des, sfp->dbuf_kva, size);
 		}
 		/*
@@ -6851,7 +6851,7 @@ static u32
 bfa_flash_status_read(void __iomem *pci_bar)
 {
 	union bfa_flash_dev_status_reg_u	dev_status;
-	u32				status;
+	int				status;
 	u32			ret_status;
 	int				i;
 
@@ -6899,7 +6899,7 @@ static u32
 bfa_flash_read_start(void __iomem *pci_bar, u32 offset, u32 len,
 			 char *buf)
 {
-	u32 status;
+	int status;
 
 	/*
 	 * len must be mutiple of 4 and not exceeding fifo size
@@ -7021,7 +7021,8 @@ bfa_status_t
 bfa_flash_raw_read(void __iomem *pci_bar, u32 offset, char *buf,
 		       u32 len)
 {
-	u32 n, status;
+	u32 n;
+	int status;
 	u32 off, l, s, residue, fifo_sz;
 
 	residue = len;
-- 
1.8.2.1

