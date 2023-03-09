Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7699CC6FD19
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:29:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbjCIT3Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:29:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbjCIT2o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:28:44 -0500
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEDBF5D771
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:28:43 -0800 (PST)
Received: by mail-pf1-f172.google.com with SMTP id ce7so2184502pfb.9
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:28:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390123;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+nPdfaCBfymi9FswOaEhynsUU0AC84LnhTLDzofEm7g=;
        b=EVZL3jP6z+m8XGYC0jKDns6ZmcTdysVtoyFd+C53pzC1s7Jv+xPxavTP6/CHk/33fk
         +U+DpB4T1F0Ctgvq8Y1DYYlsdhQq+l5qTTr6lNndvyNoSnwDNPYo5r9TlWf8Jsis3PR2
         uJAsppWxGW1VUHpuovPGBLap6WBFfFokKwWSqe1LfBbkCEXdnWcoESzOLhRwCWDntInq
         rLcxL+Vu8FdXKpU/a4dY0KKYOwbd5c7FYt6bhJc+kp6ifivfPryWGGXgx4O9MBrYKhtV
         jz7WJvj+nh6fvcXQmdPVihlrvnxLIbpGa75Sr+bvEOdgi9OA75jglytH1Dr4wGGfbJ96
         kgJA==
X-Gm-Message-State: AO0yUKUa9KxRdcrVN8b2Z/+nLzGEN1yLze2aZ8Emlxl2RpvfDUFNKgJy
        AiSQrsFyglGFhdPaADcqods=
X-Google-Smtp-Source: AK7set/LUf+djJMZkSl7ChcFcfdzP4UFTyDzLlCd4Hs1cDKYLlarhkuFlgnggFHf65L1I4zdf8pbbg==
X-Received: by 2002:a62:3182:0:b0:617:bce6:f033 with SMTP id x124-20020a623182000000b00617bce6f033mr14090674pfx.14.1678390123353;
        Thu, 09 Mar 2023 11:28:43 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.28.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:28:42 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 44/82] scsi: ibmvfc: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:25:36 -0800
Message-Id: <20230309192614.2240602-45-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230309192614.2240602-1-bvanassche@acm.org>
References: <20230309192614.2240602-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Acked-by: Tyrel Datwyler <tyreld@linux.ibm.com>
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
