From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] scsi: osst: silence underflow warning in osst_verify_frame()
Date: Fri, 4 Aug 2017 11:17:33 +0300
Message-ID: <20170804081733.ujuulvyh4nwgdl6n@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42006 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751303AbdHDIRz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Aug 2017 04:17:55 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Willem Riede <osst@riede.org>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, osst-users@lists.sourceforge.net, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

The code looks like this:

	i = ntohl(aux->filemark_cnt);
	if (STp->header_cache != NULL && i < OS_FM_TAB_MAX && (i > STp->filemark_cnt ||
	    STp->first_frame_position - 1 != ntohl(STp->header_cache->dat_fm_tab.fm_tab_ent[i]))) {

If i is negative then it's less than OS_FM_TAB_MAX so we read before
the start of the STp->header_cache->dat_fm_tab.fm_tab_ent[] array.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
There is a second static checker warning that I didn't know how to
address:

    drivers/scsi/osst.c:723 osst_verify_frame()
    warn: potential integer overflow from user 'blk_cnt * blk_sz'

diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index 97ab5f160bc6..2db87ec04f48 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -619,7 +619,7 @@ static int osst_verify_frame(struct osst_tape * STp, int frame_seq_number, int q
 	os_aux_t           * aux  = STp->buffer->aux;
 	os_partition_t     * par  = &(aux->partition);
 	struct st_partstat * STps = &(STp->ps[STp->partition]);
-	int		     blk_cnt, blk_sz, i;
+	unsigned int	     blk_cnt, blk_sz, i;
 
 	if (STp->raw) {
 		if (STp->buffer->syscall_result) {
