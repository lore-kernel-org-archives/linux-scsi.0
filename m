Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE0E1C61DA3
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:34:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbjCDAeR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:34:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbjCDAdu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:33:50 -0500
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5D0E65110
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:33:21 -0800 (PST)
Received: by mail-pl1-f181.google.com with SMTP id u5so4524626plq.7
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:33:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677889996;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rAnNmf/vUnMbW3pIRgaKZexCYtM4BMG6dAuOPLNKlXg=;
        b=XtMzavEPoIT+lrvhWUWYPSew8k7i6O7OjUjRVgVwpjfiatjeYEPTzbROZ8QjARYQ9Q
         TWQkkaa0OTc0AOUulLHnby7uqlPVJHJsmtoz1RlaVlas7kgMNp/N7l6SgMAu/po2iRO6
         TO043Hpiya9wMmcFc9ViEHWME+pF4jhxv8EdS3Fq7FZHIDiRnkFgkyqLruyIreCxuiV6
         r258UpCM8xizKa8C5OmLrTKQus7LHFbFZuyZiuI5znEj+iPZRCmjYvzbQtU5axDYSbyQ
         XUmFQUP2Q8e9qDYKRPm49BppVZXeLg0hOXlUEF9mZOzz0UosYVuXDPuoHP1jg2bZlBvi
         j1uw==
X-Gm-Message-State: AO0yUKWzzDEvMYDwYCa3UpSOV4BZgDn/87tp291RzlmhwHtG3XoOgc+m
        ZEZFASxxe9V68g32WhlyIUabax7Eftp6Aw==
X-Google-Smtp-Source: AK7set8EyVLqm3bN91kppuIzGophImvr2FsvH8787Byan/wLp/yc3UkdhE8g+YS1Nt3SgjUHYiBCEg==
X-Received: by 2002:a17:903:492:b0:19e:773b:2215 with SMTP id jj18-20020a170903049200b0019e773b2215mr3364777plb.36.1677889996112;
        Fri, 03 Mar 2023 16:33:16 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.33.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:33:15 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 44/81] scsi: ibmvfc: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:30:26 -0800
Message-Id: <20230304003103.2572793-45-bvanassche@acm.org>
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
 drivers/scsi/ibmvscsi/ibmvfc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 1a0c0b7289d2..ce9eb00e2ca0 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -3611,7 +3611,7 @@ static struct attribute *ibmvfc_host_attrs[] = {
 
 ATTRIBUTE_GROUPS(ibmvfc_host);
 
-static struct scsi_host_template driver_template = {
+static const struct scsi_host_template driver_template = {
 	.module = THIS_MODULE,
 	.name = "IBM POWER Virtual FC Adapter",
 	.proc_name = IBMVFC_NAME,
