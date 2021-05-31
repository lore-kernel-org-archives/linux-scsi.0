Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F238C47080
	for <linux-scsi@archiver.kernel.org>; Mon, 31 May 2021 10:43:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41D7A60FF3
	for <linux-scsi@archiver.kernel.org>; Mon, 31 May 2021 10:43:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbhEaKpR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 May 2021 06:45:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231382AbhEaKpG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 May 2021 06:45:06 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56CA9C061760;
        Mon, 31 May 2021 03:43:25 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id lz27so15964043ejb.11;
        Mon, 31 May 2021 03:43:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QJR89/55KXiudMnlzBPyQOfHeATecr68iMPdF7Lg45k=;
        b=K1CXkY67aICkk8XQVHakyjkkVxcPKI0OgTVvMhRn0798culLJyaL453W0qgY4Uhk6N
         vTR7zkfwIqMcFLegI0Yf3/meTKtrU/yDDQFU5qTytk9RaRgqM1Mfa2fQX3glxfM2EOID
         Y5Gs3ZIcqC/NO72M0Olou7LZ0FQJwekMhY+90afE9JRtLgAPPCpfQZAEVcqZ8tDBtIsN
         jTXMX9H524WiujyAW4oOXDo0g/c5JOYcsSAZEuPRVIeDGcPqXN2sclbF60Ya4KmDF9m1
         Q5bgMdFWTGDSlBFZWNybZB3Iy96ksD9XKpa+auj4FXGP186ORO8gtrqaqXIM5e9pYqZd
         +Z1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QJR89/55KXiudMnlzBPyQOfHeATecr68iMPdF7Lg45k=;
        b=SVY/3lNHV6UGLn3DPi0dKIs6RV4OPwINjl19efFUESDSNKLn1L/q4DuR5FuOfJRrIV
         VvUjqi/CBtRV+HUcfb228Lt7U1jcC38ObDn126Z1Mzqjpb61/I9An/lnut4MvcHz49zE
         RM/WwvgGLgjA+UUWvsgmWRHtk4tmhhe+XRoJ3BwIRJMQTWTSQ1hcxL2RN7vnRVTaTZw7
         TMl5BJPZQDxpnZvSwSUsqBdRsblriI0cYtjZfyH6JZTwqIQamPmx5vGqBrWbLSVeYd6i
         oAw3TkZdzDyhcA/JQuEQEkgNgblPU38o+svGgI4WV/EoX3/CGMIo/QyTcKlbXpXu5oKp
         7zZA==
X-Gm-Message-State: AOAM5317d1Irl0CO+Cd1ZZpuc3XyysJBt9gZZlMQH9/yAMmlJ5MD05IX
        lAAYNuk/CEeuISWpSCM9l20=
X-Google-Smtp-Source: ABdhPJxDJvrgYdIK8f0tjjYwr6p6Uz/eVz7Ds1pKwC2HivAzFIfzlLx594swmbjxCRutv/Gr/5IFmw==
X-Received: by 2002:a17:906:c0c6:: with SMTP id bn6mr21272637ejb.436.1622457803973;
        Mon, 31 May 2021 03:43:23 -0700 (PDT)
Received: from localhost.localdomain (ip5f5bec5d.dynamic.kabel-deutschland.de. [95.91.236.93])
        by smtp.gmail.com with ESMTPSA id dk9sm5741035ejb.91.2021.05.31.03.43.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 03:43:23 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/4] scsi: ufs: Use UPIU query trace in devman_upiu_cmd
Date:   Mon, 31 May 2021 12:43:08 +0200
Message-Id: <20210531104308.391842-5-huobean@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210531104308.391842-1-huobean@gmail.com>
References: <20210531104308.391842-1-huobean@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Since devman_upiu_cmd is not COMMAND UPIU, and doesn't have
CDB, it is better to use UPIU query trace, which provides more
helpful information for issue shooting.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c84bd8e045f6..deb9e232b349 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6701,6 +6701,7 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 
 	hba->dev_cmd.complete = &wait;
 
+	ufshcd_add_query_upiu_trace(hba, UFS_QUERY_SEND, lrbp->ucd_req_ptr);
 	/* Make sure descriptors are ready before ringing the doorbell */
 	wmb();
 	spin_lock_irqsave(hba->host->host_lock, flags);
@@ -6732,6 +6733,8 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 			err = -EINVAL;
 		}
 	}
+	ufshcd_add_query_upiu_trace(hba, err ? UFS_QUERY_ERR : UFS_QUERY_COMP,
+				    (struct utp_upiu_req *)lrbp->ucd_rsp_ptr);
 
 out:
 	blk_put_request(req);
-- 
2.25.1

