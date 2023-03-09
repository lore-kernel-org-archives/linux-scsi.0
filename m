Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97CEDC61DA4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:32:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbjCITci (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:32:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231185AbjCITbn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:31:43 -0500
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21FC7F222A
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:30:42 -0800 (PST)
Received: by mail-pf1-f173.google.com with SMTP id ay18so2215622pfb.2
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:30:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390241;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uXZqACJMWT7UtutWd7duHq9TCEcykw7N6hhRpB04vPs=;
        b=7lh/x29HBFp8b5oc7nfSGU0WTKDGWDOLDzA7Yoc19QFhRQffO+ncB8oZz69Er4T+3V
         nYXMAXJGi9kx2mkC7FaFclCXLtFRDkdU8+1Vs4xbZJnr//a+uwbjlv1PV62DHOt6Rtd3
         o/AfhHlj4TGVhyyyrm7vO/HQRwI9ENgAu3ijuMtwbstTuWnr1fUX5MKWGarwBMoHLNyp
         /uNE4OwGQCRM5lKYtHRDS6JjNuWyjL4k4lAk42l4gWKe6j+GsSPdBeJb3j4w5GE5DZ6N
         p6EjPHfbgovT1d1TwzW3wa60wklwXAJMny1Eax3DrOfdEPdQyLvc5H28/zEufMBqPkw0
         s+cQ==
X-Gm-Message-State: AO0yUKXVBBz3sZfCKp4AUFAto+7AzmFrrY0IpTUP9p35lYSpXeIdEcWp
        5lY5pIDp8zdQEV3jP2wpSsM=
X-Google-Smtp-Source: AK7set9hu1rtkh/aDykTgezPpjbB/Ei9H+iRADkQnAYCUqFyHLfFVRbeGqXNuVjtaBKTVHffpWfqxg==
X-Received: by 2002:a62:3808:0:b0:5e1:f4e3:57d4 with SMTP id f8-20020a623808000000b005e1f4e357d4mr4616860pfa.17.1678390241569;
        Thu, 09 Mar 2023 11:30:41 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.30.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:30:40 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>
Subject: [PATCH v2 80/82] scsi: ufs: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:26:12 -0800
Message-Id: <20230309192614.2240602-81-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230309192614.2240602-1-bvanassche@acm.org>
References: <20230309192614.2240602-1-bvanassche@acm.org>
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
index 172d25fef740..42f01af1e1b7 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8721,7 +8721,7 @@ static struct ufs_hba_variant_params ufs_hba_vps = {
 	.ondemand_data.downdifferential	= 5,
 };
 
-static struct scsi_host_template ufshcd_driver_template = {
+static const struct scsi_host_template ufshcd_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= UFSHCD,
 	.proc_name		= UFSHCD,
