Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F82FC7EE26
	for <linux-scsi@archiver.kernel.org>; Thu, 11 May 2023 01:18:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236736AbjEKBS6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 May 2023 21:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236884AbjEKBSy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 May 2023 21:18:54 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F4FA2D59;
        Wed, 10 May 2023 18:18:53 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id 2adb3069b0e04-4f1fe1208a4so6041508e87.2;
        Wed, 10 May 2023 18:18:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683767931; x=1686359931;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wn5Uem/TN7lNp1dim2+ah0hl+8LcJ21rMxA8K+qIwd8=;
        b=gIkLD6NG7x0gpd8t7Nu27yzmlzyFR3uYtT5OjMNoVTxqVrbZvjZ/rYkeOafY3+1wmI
         oqwHK1I7xO+jKemU/StvNclIbt1VQgI/vVnf8Zg0ta7IwnfXb7T0xhiouooQS28zOcVS
         vm14PufQQT+12D3CYX7GZwiIOxVcfSi1f+LVtEHZTGpOR30Rc2lmSiefggUbuM3VZJst
         dglIEY/afqAXMpxwy9+HNnbzuYJxUchDSU3JPJa/mtXA364ehcto1mV6zqfNdYkPqFXO
         yDWmpT58aygQyOw9CX5Yy12CpkOWREVOrw4za3PUaBHnUS3utm0ROaF/DHQuspX4UKst
         Lr/Q==
X-Gm-Message-State: AC+VfDzaCixtSMYTG2QeDmzd0/89/FIyok80+4KFWEWpmmkCSblS2EdL
        3bT0r1I1YdD7OTH+xyg3ImYxSpVuoYuuS06Z
X-Google-Smtp-Source: ACHHUZ4ZQaq9Xg4v5pEKFgtodPrhgKU39OMgWQiBlJhgxxCjWVY8nmwg65RJoPPN3tX/T+rDNO0gSA==
X-Received: by 2002:ac2:48b8:0:b0:4ef:f509:1184 with SMTP id u24-20020ac248b8000000b004eff5091184mr2286286lfg.3.1683767931337;
        Wed, 10 May 2023 18:18:51 -0700 (PDT)
Received: from flawful.org (c-fcf6e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.246.252])
        by smtp.gmail.com with ESMTPSA id g5-20020ac25385000000b004f00189e1dasm916968lfh.143.2023.05.10.18.18.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 18:18:51 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id BC558587; Thu, 11 May 2023 03:18:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1683767929; bh=lRcNr0GcCLZ5HnXWqUl+ttS0G3sDgEj2kHt+NCv3i5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G7GwQ1nwDNd6/oNxfp7M0Y/bTPOfQRJl1doWS9T31Y8raeUaR+8WTD/qDSdIgx3jx
         wgt7/ukNKFiLfkE6zXhRe/niCAhaI6JVJOfZ8PmsV5gjQZfpZKdFnMDPH664QwD8Zf
         zCsKeVhXBsHIqKwrU17k1fInOCN6dsfwsg+yfaDw=
Received: from x1-carbon.. (unknown [64.141.80.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id CAA26593;
        Thu, 11 May 2023 03:14:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1683767703; bh=lRcNr0GcCLZ5HnXWqUl+ttS0G3sDgEj2kHt+NCv3i5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H0neEyRoI2aVrZfiaow/06ityNYELOhUbQnPVG3tuzCFp2kZMqSn/sc/n05ZGCu32
         vJ70c02VGB3EKPVjVtGjFBDtnXe3xxLCcLDnlvAAUAeoQYfgdCxjQOE2Le16t06ItA
         lVgoaq2u7CvMD2wosrWe1RT0RXrVvS8qTX8oomBs=
From:   Niklas Cassel <nks@flawful.org>
To:     Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <dlemoal@kernel.org>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>,
        Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v7 05/19] scsi: rename and move get_scsi_ml_byte()
Date:   Thu, 11 May 2023 03:13:38 +0200
Message-Id: <20230511011356.227789-6-nks@flawful.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230511011356.227789-1-nks@flawful.org>
References: <20230511011356.227789-1-nks@flawful.org>
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
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
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
2.40.1

