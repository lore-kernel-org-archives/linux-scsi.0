Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFCB3C61DA3
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:33:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbjCDAdS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:33:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbjCDAc6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:32:58 -0500
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D93FCDFF
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:32:57 -0800 (PST)
Received: by mail-pj1-f50.google.com with SMTP id h17-20020a17090aea9100b0023739b10792so3938431pjz.1
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:32:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677889977;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4uxxN7Q5Bd2Nk0RDe6hDV+Z1h0pZWa/g2GzvVwJGpA4=;
        b=pskKd2JMkoDuBqPRdWf1u0rvXR78ZYjmWGLIqxKEL628/d2S2eorCavptfF3bsN8kV
         wNbCgta/Lhwp6dUR2cO3VE6Bt0zMb1Q8HJHg2y/RP5tMQDcJnWeZIT3iN7wd17XXU4re
         9p3ob1st4pQwzwXVC++Iq7v4pQuwlZxJASwGcGTe2yzNHpkxxx3PSUyYWi40zYUnUQOg
         Gkec5b3cAxL/6JiVIfXdsli+WHUBHT7dW93NVDp1LWIuI9R4IVqL0qxIIY5Veq5RBK6r
         bLl7WZI1d/Y7GO8O/NilazmxC7z+7AY2fx5Y/4G22dZsFLRqXimLzK5gfuAL65jvksmX
         kioA==
X-Gm-Message-State: AO0yUKWCa/8KS3rc/+xtQut6kTGK1IUUh1IEsqRvAaqQ1F1/Kjvre+Cg
        63bOz6983zYRC1xBPWEixFY=
X-Google-Smtp-Source: AK7set9wmyBqiTlakM5ByMW/oLnNb5/jHRAM2s7/uJUrecB7fo/Sucw604ls7XuEQo/lcwoMFn8InQ==
X-Received: by 2002:a17:903:24d:b0:19e:76b7:c7d2 with SMTP id j13-20020a170903024d00b0019e76b7c7d2mr4373487plh.26.1677889976821;
        Fri, 03 Mar 2023 16:32:56 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.32.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:32:56 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Bradley Grove <linuxdrivers@attotech.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 33/81] scsi: esas2r: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:30:15 -0800
Message-Id: <20230304003103.2572793-34-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
In-Reply-To: <20230304003103.2572793-1-bvanassche@acm.org>
References: <20230304003103.2572793-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/esas2r/esas2r_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
index d7a2c49ff5ee..f700a16cd885 100644
--- a/drivers/scsi/esas2r/esas2r_main.c
+++ b/drivers/scsi/esas2r/esas2r_main.c
@@ -231,7 +231,7 @@ struct bin_attribute bin_attr_default_nvram = {
 	.write	= NULL
 };
 
-static struct scsi_host_template driver_template = {
+static const struct scsi_host_template driver_template = {
 	.module				= THIS_MODULE,
 	.show_info			= esas2r_show_info,
 	.name				= ESAS2R_LONGNAME,
