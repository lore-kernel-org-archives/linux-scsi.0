From: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 20/33] scsi generic: sg chaining support
Date: Mon, 16 Jul 2007 11:47:34 +0200
Message-ID: <11845792684131-git-send-email-jens.axboe@oracle.com>
References: <11845792671245-git-send-email-jens.axboe@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:9289 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759509AbXGPJsg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jul 2007 05:48:36 -0400
In-Reply-To: <11845792671245-git-send-email-jens.axboe@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>, dgilbert@interlog.com

Cc: dgilbert@interlog.com
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 drivers/scsi/sg.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 85d3894..2fc24e7 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1168,7 +1168,7 @@ sg_vma_nopage(struct vm_area_struct *vma, unsigned long addr, int *type)
 	sg = rsv_schp->buffer;
 	sa = vma->vm_start;
 	for (k = 0; (k < rsv_schp->k_use_sg) && (sa < vma->vm_end);
-	     ++k, ++sg) {
+	     ++k, sg = sg_next(sg)) {
 		len = vma->vm_end - sa;
 		len = (len < sg->length) ? len : sg->length;
 		if (offset < len) {
@@ -1212,7 +1212,7 @@ sg_mmap(struct file *filp, struct vm_area_struct *vma)
 	sa = vma->vm_start;
 	sg = rsv_schp->buffer;
 	for (k = 0; (k < rsv_schp->k_use_sg) && (sa < vma->vm_end);
-	     ++k, ++sg) {
+	     ++k, sg = sg_next(sg)) {
 		len = vma->vm_end - sa;
 		len = (len < sg->length) ? len : sg->length;
 		sa += len;
@@ -1866,7 +1866,7 @@ sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * sfp, int buff_size)
 	}
 	for (k = 0, sg = schp->buffer, rem_sz = blk_size;
 	     (rem_sz > 0) && (k < mx_sc_elems);
-	     ++k, rem_sz -= ret_sz, ++sg) {
+	     ++k, rem_sz -= ret_sz, sg = sg_next(sg)) {
 		
 		num = (rem_sz > scatter_elem_sz_prev) ?
 		      scatter_elem_sz_prev : rem_sz;
@@ -1939,7 +1939,7 @@ sg_write_xfer(Sg_request * srp)
 		if (res)
 			return res;
 
-		for (; p; ++sg, ksglen = sg->length,
+		for (; p; sg = sg_next(sg), ksglen = sg->length,
 		     p = page_address(sg->page)) {
 			if (usglen <= 0)
 				break;
@@ -2018,7 +2018,7 @@ sg_remove_scat(Sg_scatter_hold * schp)
 			int k;
 
 			for (k = 0; (k < schp->k_use_sg) && sg->page;
-			     ++k, ++sg) {
+			     ++k, sg = sg_next(sg)) {
 				SCSI_LOG_TIMEOUT(5, printk(
 				    "sg_remove_scat: k=%d, pg=0x%p, len=%d\n",
 				    k, sg->page, sg->length));
@@ -2071,7 +2071,7 @@ sg_read_xfer(Sg_request * srp)
 		if (res)
 			return res;
 
-		for (; p; ++sg, ksglen = sg->length,
+		for (; p; sg = sg_next(sg), ksglen = sg->length,
 		     p = page_address(sg->page)) {
 			if (usglen <= 0)
 				break;
@@ -2118,7 +2118,7 @@ sg_read_oxfer(Sg_request * srp, char __user *outp, int num_read_xfer)
 	if ((!outp) || (num_read_xfer <= 0))
 		return 0;
 
-	for (k = 0; (k < schp->k_use_sg) && sg->page; ++k, ++sg) {
+	for (k = 0; (k < schp->k_use_sg) && sg->page; ++k, sg = sg_next(sg)) {
 		num = sg->length;
 		if (num > num_read_xfer) {
 			if (__copy_to_user(outp, page_address(sg->page),
@@ -2168,7 +2168,7 @@ sg_link_reserve(Sg_fd * sfp, Sg_request * srp, int size)
 	SCSI_LOG_TIMEOUT(4, printk("sg_link_reserve: size=%d\n", size));
 	rem = size;
 
-	for (k = 0; k < rsv_schp->k_use_sg; ++k, ++sg) {
+	for (k = 0; k < rsv_schp->k_use_sg; ++k, sg = sg_next(sg)) {
 		num = sg->length;
 		if (rem <= num) {
 			sfp->save_scat_len = num;
-- 
1.5.3.rc0.90.gbaa79

