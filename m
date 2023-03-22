Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 680B7C76196
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 20:04:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231666AbjCVUEf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 16:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231578AbjCVUEK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 16:04:10 -0400
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 789CE6E68A
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:59:46 -0700 (PDT)
Received: by mail-pl1-f179.google.com with SMTP id o2so12890753plg.4
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:59:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679515167;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F0awJl7VuZCak7ZqmVpOunicPTwgCzwngttr212mf40=;
        b=3BHsICGsv+1sHnVPXVeR1yvL5JMPY2ZZ9cn+vgZYgyn/ouaaT3GOGCNa9wO8HjUogC
         UXwNKue7R1+bjsOExJQOdn/u+DNzOHF9pJnr7BqoYOJYFrRwCXh41uBPZc5OnmT99qbA
         plKidoJZDOIjos1xbpcFtL8g/1xu5JwO/Na0m6+nIv2l8ZWeAjyNLVnFuGkjIXJA/5Ue
         Z/l35dCzohY6/suRcJZyXVBdblnqUyU/d2atAPGpXy3eo23FptyCHfp6+OX55zYk2tJf
         RYV11rpP9UUnOPrjdnWnUK490SNT3kU5JD+aQg4OM7F3LPuPeFyflOZqaJ1Coi1TBnFK
         LEMQ==
X-Gm-Message-State: AO0yUKW3r0WQUGtQ9PcLTwwAxVk6FZ/8PBggefc0Sg4VfHmD/LThsENv
        xwYLVqmMpZWuj3ud6HK6OmU=
X-Google-Smtp-Source: AK7set89Wnmzgx+EBVnhH1sDHzLUUiBT+vNFHJ/TvsJCRQKcMaxRCnJAKV5FAN6Cp2l2moYQ1NnUfg==
X-Received: by 2002:a17:90a:190d:b0:23f:5c65:8c72 with SMTP id 13-20020a17090a190d00b0023f5c658c72mr4477294pjg.49.1679515167613;
        Wed, 22 Mar 2023 12:59:27 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.59.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:59:27 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>
Subject: [PATCH v3 79/80] scsi: ufs: Declare SCSI host template const
Date:   Wed, 22 Mar 2023 12:55:14 -0700
Message-Id: <20230322195515.1267197-80-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230322195515.1267197-1-bvanassche@acm.org>
References: <20230322195515.1267197-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 8e7dfaadc691..35a3bd95c5e4 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8751,7 +8751,7 @@ static struct ufs_hba_variant_params ufs_hba_vps = {
 	.ondemand_data.downdifferential	= 5,
 };
 
-static struct scsi_host_template ufshcd_driver_template = {
+static const struct scsi_host_template ufshcd_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= UFSHCD,
 	.proc_name		= UFSHCD,
