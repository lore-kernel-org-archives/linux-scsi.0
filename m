Return-Path: <SRS0=AKtJ=6V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B491C38A2A
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 19:17:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28C70218AC
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 19:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588879046;
	bh=jCoTy5MqBatp+N4A2hyv+CcwMbeePmBG8iZQJXgFJyk=;
	h=Date:From:To:Cc:Subject:List-ID:From;
	b=MVOCI7ttGHeI8O/1bStzxHLt+gii5tgYSqfNAXkkU1f4M95A1pGj7qv9fOr2zw8j3
	 9W80pgU+ZKCznAMffT2RL2d4A1/If0jpTWSF6asp5M4q1H0+xN0f/M3DO9bo7he0n5
	 3dinoswvPfRsDGAmdOyN74XZyXL9gS4iGVEgf+2E=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727904AbgEGTRW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 May 2020 15:17:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:40362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726367AbgEGTRV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 7 May 2020 15:17:21 -0400
Received: from embeddedor (unknown [189.207.59.248])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCCBD208E4;
        Thu,  7 May 2020 19:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588879041;
        bh=jCoTy5MqBatp+N4A2hyv+CcwMbeePmBG8iZQJXgFJyk=;
        h=Date:From:To:Cc:Subject:From;
        b=Si6p6NGivshUDV6cBs2VzvsOg7asKsaSfn/Wf4UUkPHAoSp9Ku+0Rs0uUbBBoFFYt
         cyBxz+gNCsMd6ZDc8ALgWrupc7wZweRCZTHD3k7Uu4aYBDsjLaba/FV0nzglcnl63j
         7EuWj4JiyJn6xmqXk/YCO4JKUxuIj1trtIjiHo6s=
Date:   Thu, 7 May 2020 14:21:47 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: libsas: Replace zero-length array with flexible-array
Message-ID: <20200507192147.GA16206@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The current codebase makes use of the zero-length array language
extension to the C90 standard, but the preferred mechanism to declare
variable-length types such as these ones is a flexible array member[1][2],
introduced in C99:

struct foo {
        int stuff;
        struct boo array[];
};

By making use of the mechanism above, we will get a compiler warning
in case the flexible array does not occur last in the structure, which
will help us prevent some kind of undefined behavior bugs from being
inadvertently introduced[3] to the codebase from now on.

Also, notice that, dynamic memory allocations won't be affected by
this change:

"Flexible array members have incomplete type, and so the sizeof operator
may not be applied. As a quirk of the original implementation of
zero-length arrays, sizeof evaluates to zero."[1]

sizeof(flexible-array-member) triggers a warning because flexible array
members have incomplete type[1]. There are some instances of code in
which the sizeof operator is being incorrectly/erroneously applied to
zero-length arrays and the result is zero. Such instances may be hiding
some bugs. So, this work (flexible-array member conversions) will also
help to get completely rid of those sorts of issues.

This issue was found with the help of Coccinelle.

[1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
[2] https://github.com/KSPP/linux/issues/21
[3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/scsi/aic94xx/aic94xx_sds.c |   14 +++++++-------
 include/scsi/sas.h                 |    8 ++++----
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_sds.c b/drivers/scsi/aic94xx/aic94xx_sds.c
index 3ddc8852bc32..105adba559a1 100644
--- a/drivers/scsi/aic94xx/aic94xx_sds.c
+++ b/drivers/scsi/aic94xx/aic94xx_sds.c
@@ -406,7 +406,7 @@ struct asd_manuf_sec {
 	u8    sas_addr[SAS_ADDR_SIZE];
 	u8    pcba_sn[ASD_PCBA_SN_SIZE];
 	/* Here start the other segments */
-	u8    linked_list[0];
+	u8    linked_list[];
 } __attribute__ ((packed));
 
 struct asd_manuf_phy_desc {
@@ -449,7 +449,7 @@ struct asd_ms_sb_desc {
 	u8    type;
 	u8    node_desc_index;
 	u8    conn_desc_index;
-	u8    _recvd[0];
+	u8    _recvd[];
 } __attribute__ ((packed));
 
 #if 0
@@ -478,12 +478,12 @@ struct asd_ms_conn_desc {
 	u8    size_sideband_desc;
 	u32   _resvd;
 	u8    name[16];
-	struct asd_ms_sb_desc sb_desc[0];
+	struct asd_ms_sb_desc sb_desc[];
 } __attribute__ ((packed));
 
 struct asd_nd_phy_desc {
 	u8    vp_attch_type;
-	u8    attch_specific[0];
+	u8    attch_specific[];
 } __attribute__ ((packed));
 
 #if 0
@@ -503,7 +503,7 @@ struct asd_ms_node_desc {
 	u8    size_phy_desc;
 	u8    _resvd;
 	u8    name[16];
-	struct asd_nd_phy_desc phy_desc[0];
+	struct asd_nd_phy_desc phy_desc[];
 } __attribute__ ((packed));
 
 struct asd_ms_conn_map {
@@ -518,7 +518,7 @@ struct asd_ms_conn_map {
 	u8    usage_model_id;
 	u32   _resvd;
 	struct asd_ms_conn_desc conn_desc[0];
-	struct asd_ms_node_desc node_desc[0];
+	struct asd_ms_node_desc node_desc[];
 } __attribute__ ((packed));
 
 struct asd_ctrla_phy_entry {
@@ -542,7 +542,7 @@ struct asd_ll_el {
 	u8   id0;
 	u8   id1;
 	__le16  next;
-	u8   something_here[0];
+	u8   something_here[];
 } __attribute__ ((packed));
 
 static int asd_poll_flash(struct asd_ha_struct *asd_ha)
diff --git a/include/scsi/sas.h b/include/scsi/sas.h
index a5d8ae49198c..4726c1bbec65 100644
--- a/include/scsi/sas.h
+++ b/include/scsi/sas.h
@@ -324,7 +324,7 @@ struct ssp_response_iu {
 	__be32 response_data_len;
 
 	u8     resp_data[0];
-	u8     sense_data[0];
+	u8     sense_data[];
 } __attribute__ ((packed));
 
 struct ssp_command_iu {
@@ -346,7 +346,7 @@ struct ssp_command_iu {
 	u8    add_cdb_len:6;
 
 	u8    cdb[16];
-	u8    add_cdb[0];
+	u8    add_cdb[];
 } __attribute__ ((packed));
 
 struct xfer_rdy_iu {
@@ -555,7 +555,7 @@ struct ssp_response_iu {
 	__be32 response_data_len;
 
 	u8     resp_data[0];
-	u8     sense_data[0];
+	u8     sense_data[];
 } __attribute__ ((packed));
 
 struct ssp_command_iu {
@@ -577,7 +577,7 @@ struct ssp_command_iu {
 	u8    _r_c:2;
 
 	u8    cdb[16];
-	u8    add_cdb[0];
+	u8    add_cdb[];
 } __attribute__ ((packed));
 
 struct xfer_rdy_iu {

