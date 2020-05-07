Return-Path: <SRS0=AKtJ=6V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B13EC38A24
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 19:21:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66DE221835
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 19:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588879285;
	bh=LzS3WkLEkY5cS9HhYedg7dL8hIWbzOpus+g7yFKnoSg=;
	h=Date:From:To:Cc:Subject:List-ID:From;
	b=m6m99EKMc61A4lDof6JzUEPCMlY6DUCrdR1x/kGVc4dIpsNNec6jKqXbY9EFzcf8r
	 k7s9o/kQbpqyxRxxO01SZbBvU8vL8k8Fje93CRBRXmaZkOJAxNFOaQwSPEmCNyyOGt
	 iPr3kY/Dd/lX09Gs4LRahCCwrbkzeCvYzG2XKPp4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728743AbgEGTVZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 May 2020 15:21:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:42994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728309AbgEGTVY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 7 May 2020 15:21:24 -0400
Received: from embeddedor (unknown [189.207.59.248])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB1AA208D6;
        Thu,  7 May 2020 19:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588879284;
        bh=LzS3WkLEkY5cS9HhYedg7dL8hIWbzOpus+g7yFKnoSg=;
        h=Date:From:To:Cc:Subject:From;
        b=Kg8Ub230vZM5el8GxJinpdLe5+WYA+dyaY2jtwqzGtR5MG1v6hlsnhV4rsqkXE/Qi
         EXp7+48CRJneGlH0ejE09Dful5Jy8MKRyZQju0qEsyrdbUVlP+gQtQ92VYZ13Ba43q
         e01X+EEvPW+MnMfy44PfdsrXfxvlEod7W1fb1fcw=
Date:   Thu, 7 May 2020 14:25:50 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     linux-kernel@vger.kernel.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>, linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: ufs: Replace zero-length array with flexible-array
Message-ID: <20200507192550.GA16683@embeddedor>
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
 drivers/scsi/ufs/ufshcd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 698e8d20b4ba..cd34a7873623 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3223,7 +3223,7 @@ static inline int ufshcd_read_desc(struct ufs_hba *hba,
 struct uc_string_id {
 	u8 len;
 	u8 type;
-	wchar_t uc[0];
+	wchar_t uc[];
 } __packed;
 
 /* replace non-printable or non-ASCII characters with spaces */

