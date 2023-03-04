Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A43DEC61DA4
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:36:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbjCDAgU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:36:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbjCDAfl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:35:41 -0500
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6952F6A403
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:35:07 -0800 (PST)
Received: by mail-pl1-f171.google.com with SMTP id ky4so4561527plb.3
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:35:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677890107;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uXZqACJMWT7UtutWd7duHq9TCEcykw7N6hhRpB04vPs=;
        b=67nNzCPYVycE/fo0UpFmFNrNaIVE4+iiAlwPodil9uu1KRjRmbTKGm3X3yIUkkuh3O
         SoWntVyrBvm13I0rNDaGFSQL3LPkE8C38J6pyafOQpcl0kQskBTUQrVXfsmlv0pzZcFH
         JSD5K5I+p63koc9QGUfZ3/C49LWy4jHZ3Ml30xgVbmHS7p8QKS/HcpsG/f6d4nRQJeGG
         KECHSnOSP3CeGWiPvSjfVpsqvEnmtB3avdEYEyPGFOUm6Bl24T/LhSU0Hsa0BcqgYqXE
         GMLu4CA4Rd08dJXHbsOsrulbyu2qqPPTZwH0QS50Y2EU9uIzl/HSNI5h3dZyjNeRv1Qj
         5ASg==
X-Gm-Message-State: AO0yUKUGFnUEI6jtaX1+uBlG8w41MpUIr9iVpEy110zXOYVVuetw4YRN
        CXHdOEh3z4jbsT/M1Qde4SA=
X-Google-Smtp-Source: AK7set+bNBrjd5GrG4CzAbYDuam/7jOqlN6VFAkCrWlRPYxthPZo6s2yxTdJNz2UPHFSxpsShbW1DQ==
X-Received: by 2002:a17:902:e5c2:b0:19a:a650:ac55 with SMTP id u2-20020a170902e5c200b0019aa650ac55mr8251221plf.23.1677890106896;
        Fri, 03 Mar 2023 16:35:06 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.35.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:35:06 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>
Subject: [PATCH 79/81] scsi: ufs: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:31:01 -0800
Message-Id: <20230304003103.2572793-80-bvanassche@acm.org>
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
