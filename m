Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD694C77B62
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Apr 2023 18:32:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235825AbjDDScx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Apr 2023 14:32:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236403AbjDDSch (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Apr 2023 14:32:37 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C07E7299;
        Tue,  4 Apr 2023 11:29:57 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id g19so30395002lfr.9;
        Tue, 04 Apr 2023 11:29:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680632996;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iyOtHBCn/uWNrq/R7ZU6Qv+JF796mVDB+Rf4s24M8k8=;
        b=ib9mbykm3+8hKIYWnHITKJCz17TUtGdUTKk3v2uwnImQG0J82GrUq7qgQzTPkd6HrE
         NhUZnvOEsVdDd5WEBFutKoE1kma+7g+QUz70yaiTiO3qcT191MzskWZQp2v9FFFetYZS
         RAimbJ+Zcyg6HtPr620V/qQXvzId/t9IOiCP70bP8Eq4KR/dczuw3doaQGADSRLmr7Jb
         wlSvh8/DIk+QRn0Kx6P9fUli/q00rSqWwsFxTd8C4sT1ZV+7Lf5FcxUM+vEFvU+6+wpV
         1VOv3423fRJRwEetZEFoKm6sfj6XxVmnhfwORe+C1Gv4hOBfnUfABVd/+wR9JZ+GXNaZ
         W+NQ==
X-Gm-Message-State: AAQBX9db/+JF0xRPwwwaooBom1RyOfVkXH5WFlk6XKWSZkz19+5QNyMY
        kSOa8ec461BPIVyhG85bPxsI0tEnHEY2jw==
X-Google-Smtp-Source: AKy350Zuu6oRwoWxK7jFyzhkUcbAGbkBFA6XrYXRGF/ep7kWeA/x99mPQ7eqCAXA4HSUMpmEEdphTg==
X-Received: by 2002:ac2:495c:0:b0:4eb:f6d:64f with SMTP id o28-20020ac2495c000000b004eb0f6d064fmr875381lfi.42.1680632995622;
        Tue, 04 Apr 2023 11:29:55 -0700 (PDT)
Received: from flawful.org (c-a3f5e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.245.163])
        by smtp.gmail.com with ESMTPSA id q17-20020a19a411000000b004d3d43c7569sm2434994lfc.3.2023.04.04.11.29.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 11:29:55 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id 58508895; Tue,  4 Apr 2023 20:29:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1680632993; bh=rbfvsr3tquiM93ijFijrjR0bS0TPBVeknlwL0sNNs3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a3DxNnZoYVoyfOR9GBn/fKDA+kCpFRiV4COlGHiFOmiGGYiHRvsH7YO3hhH7tmRY9
         UbcueSw/PFYgvmiPrJAy4lNHlfj7ZoIt/+YVeISDOfL0qIrl/AvpdzlHIWgZIvY/v7
         +BIuO6uKJfXuIGGHZ5P+en4vLcnwgB8pZ8VFyStA=
Received: from x1-carbon.lan (OpenWrt.lan [192.168.1.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id 47F2CA55;
        Tue,  4 Apr 2023 20:25:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1680632737; bh=rbfvsr3tquiM93ijFijrjR0bS0TPBVeknlwL0sNNs3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JWi/ewFA6jmNPVTTeqjpc+8T/swngda6y6f4QJuGJxv7ruzgZDA0vqDUbWGIfLCVK
         bUicPZep8s+7Ys3YYoA66fwda9r7qzoDHHIR3H4aah70tAVh0o5lfquU1b5NEqVl63
         KMJXYpIayHlUHNqO2boKhvQXS7AfxtnemS5FKxGQ=
From:   Niklas Cassel <nks@flawful.org>
To:     Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>,
        Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v5 05/19] scsi: rename and move get_scsi_ml_byte()
Date:   Tue,  4 Apr 2023 20:24:10 +0200
Message-Id: <20230404182428.715140-6-nks@flawful.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230404182428.715140-1-nks@flawful.org>
References: <20230404182428.715140-1-nks@flawful.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

SCSI has two different getters:
- get_XXX_byte() (in scsi_cmnd.h) which takes a struct scsi_cmnd *, and
- XXX_byte() (in scsi.h) which takes a scmd->result.
The proper name for get_scsi_ml_byte() should thus be without the get_
prefix, as it takes a scmd->result. Rename the function to rectify this.
(This change was suggested by Mike Christie.)

Additionally, move get_scsi_ml_byte() to scsi_priv.h since both scsi_lib.c
and scsi_error.c will need to use this helper in a follow-up patch.

Cc: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c  | 7 +------
 drivers/scsi/scsi_priv.h | 5 +++++
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b7c569a42aa4..fac9c31161d2 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -578,11 +578,6 @@ static bool scsi_end_request(struct request *req, blk_status_t error,
 	return false;
 }
 
-static inline u8 get_scsi_ml_byte(int result)
-{
-	return (result >> 8) & 0xff;
-}
-
 /**
  * scsi_result_to_blk_status - translate a SCSI result code into blk_status_t
  * @result:	scsi error code
@@ -595,7 +590,7 @@ static blk_status_t scsi_result_to_blk_status(int result)
 	 * Check the scsi-ml byte first in case we converted a host or status
 	 * byte.
 	 */
-	switch (get_scsi_ml_byte(result)) {
+	switch (scsi_ml_byte(result)) {
 	case SCSIML_STAT_OK:
 		break;
 	case SCSIML_STAT_RESV_CONFLICT:
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 96284a0e13fe..74324fba4281 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -29,6 +29,11 @@ enum scsi_ml_status {
 	SCSIML_STAT_TGT_FAILURE		= 0x04,	/* Permanent target failure */
 };
 
+static inline u8 scsi_ml_byte(int result)
+{
+	return (result >> 8) & 0xff;
+}
+
 /*
  * Scsi Error Handler Flags
  */
-- 
2.39.2

