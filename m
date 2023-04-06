Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1684C7618D
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Apr 2023 11:42:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238706AbjDFLmC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Apr 2023 07:42:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238696AbjDFLlo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Apr 2023 07:41:44 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77C4DE1B1;
        Thu,  6 Apr 2023 04:37:38 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id g29so538930lfj.4;
        Thu, 06 Apr 2023 04:37:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680781058;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iyOtHBCn/uWNrq/R7ZU6Qv+JF796mVDB+Rf4s24M8k8=;
        b=rW6WZAucl0pWLA4v05m6K2h22WbaqCYIxiYu3ny1aRZYd7C8mrYeT3FUmZxJ/Pwidn
         /8UZatgvnTJFrwnLCzRxuuMtvVvNOzu1ORBQeTbDiXfWXS+DOx0Dc8G3+YxsBReUj1Or
         DK2t7oVtU2bd+5fde4G1LuAZrslUvBpg7M+UxoTyZ2cUKzn5nvR/KPB+cpKjGEe10i/l
         gHExAB7L6RHoEN1CY4QoE09dalLvg4WIgUkwfR/MfITIGytkmyF3le7qhs6hQXkWyIjN
         GD5WGyTFrp0SFVMmW8t9hywRVnO2PowTJMsgNAZp4gRz3e3+je5MbrWY+hBV0ibvCrNW
         FGjg==
X-Gm-Message-State: AAQBX9eIs5Mi1elqZGT3A0PgUe1AfvJj3Ny4XpV5FUsjKT5KNLnYNpgi
        8DE1NB/FOdl2Xm4jK6/05kFdVlz3veq4aw==
X-Google-Smtp-Source: AKy350ZrtcWegIux5GQ/St8Arf5Lv1nLioZ5LyYovAgoh8QRNRv5G8clmm2xG0DVeprez0037ORfXA==
X-Received: by 2002:ac2:495c:0:b0:4ea:f526:5bea with SMTP id o28-20020ac2495c000000b004eaf5265beamr1455747lfi.27.1680781057618;
        Thu, 06 Apr 2023 04:37:37 -0700 (PDT)
Received: from flawful.org (c-fcf6e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.246.252])
        by smtp.gmail.com with ESMTPSA id v30-20020a056512049e00b004e8508899basm227823lfq.86.2023.04.06.04.37.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 04:37:37 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id 8089967E; Thu,  6 Apr 2023 13:37:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1680781056; bh=rbfvsr3tquiM93ijFijrjR0bS0TPBVeknlwL0sNNs3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M4BuHpR6Ea2a2olU54A59dsIX2/zleRNOa++nIXNJCK4X8ieuaNh6a7fPcMTvtvWm
         ti7JW5Z6xHWLIFonJW/yJeOB6wtneLVNJd5obazMGoFLmjiDBSM0FogUMjvCejJ6uR
         9JSF82/psIQaKyA7V0v/hfvin5PGG7rzKAVEwSeo=
Received: from x1-carbon.lan (OpenWrt.lan [192.168.1.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id 3C8097A7;
        Thu,  6 Apr 2023 13:33:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1680780789; bh=rbfvsr3tquiM93ijFijrjR0bS0TPBVeknlwL0sNNs3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tJhDAabzGV4ktJEmmQWeTXtDjgby0QszLrQ5jy4CQxmXlybziOPINZgrPj8tHqIwD
         ROeknw29XF1cPbJeFy1hQp6Et1IFfO/gIRHI7X2uDVcHM3fqJBT8GjgE/GHA6DI672
         hakw7MZnpNjTQ9vuQ/oAikkoH3Eo7a54ZgSb9EWU=
From:   Niklas Cassel <nks@flawful.org>
To:     Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Damien Le Moal <dlemoal@fastmail.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>,
        Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v6 05/19] scsi: rename and move get_scsi_ml_byte()
Date:   Thu,  6 Apr 2023 13:32:34 +0200
Message-Id: <20230406113252.41211-6-nks@flawful.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230406113252.41211-1-nks@flawful.org>
References: <20230406113252.41211-1-nks@flawful.org>
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

