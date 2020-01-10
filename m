Return-Path: <SRS0=9eMh=27=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC54BC33CA4
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jan 2020 18:36:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B39272072E
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jan 2020 18:36:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R78av0Pm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728735AbgAJSgt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Jan 2020 13:36:49 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44561 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728400AbgAJSgn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jan 2020 13:36:43 -0500
Received: by mail-wr1-f66.google.com with SMTP id q10so2737286wrm.11;
        Fri, 10 Jan 2020 10:36:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RXhuYHUQf7uxSiQZxx/MA7iyUWDN3SLdWOsQTulC9S4=;
        b=R78av0PmtrxwhPQn2freZodrqi4x65lDTTlih37Z0jcQ8hPvAioH1eZ/r99mnr6wLV
         4r9njGiWAZwDJA7zcALfNLY+BsHrmDSnYnzbo08/yyD+v04hIUCSPzMfH0Ow9Jlz65/8
         yrv74QVM8b0n1ilQH/VtWc7j9ct2SKfqd61KIerozpse/2WwBFbeuVHv7LI7DE0B4tQj
         ImDwcx2GQ+CAGsfR6fimdhwLSe9Yc8P/+oc5pPO9S8Nw1Xwjy9v/YK0TyAeu1MZgL8Bu
         OgxHEpYr9gFkcouKjJWuiUTAedWrpVEsb3rvpCOLxrk9ANF4KGpiT52rAMuJqB0vcE7v
         CR/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=RXhuYHUQf7uxSiQZxx/MA7iyUWDN3SLdWOsQTulC9S4=;
        b=fxsnCvezMYBtVRfoCyXEOFnIC+uWWbs5Rk/lxnII1mCdYINEuoGmvvqI0pMuFvKudo
         7/2S/Mm4Qn2a0TFtW9NcqW5v52onlAVwyTzEjEaZCl4beoxEr332Vp6iqDn5gkJVTB/7
         66STTd5AVNJHdjNgjt6Fe/uPyhPM+uWxQOjmlfjyV3aDRfo9UDDs0S0GeDxnFkAb+pRz
         Gcs1XaJhw/U9negHKqB4UoEKlk/7JyHrvZHbb/avbza7G9gVVTWWwA1YcW2oyqLVT6Ac
         dP3DRF1m9HQftlI3gv/dudQwRwBlWqxjLNMPDxsLV1lKZs8mz3I/etJc2OE0hd6tYvSR
         ihxA==
X-Gm-Message-State: APjAAAX1SHbmnjL82f55Uk9bIx13uq0Ug1X9pkaqJDRLrPM4C+nTktt/
        J2AHTCB8j2GB8m2SdZGi6u8=
X-Google-Smtp-Source: APXvYqwnRdakZ3Ds7QRSOw6vSGqYAEtvFqIl3B0Cw8nSvJz2+DGYXlM6Yy8VuKMxPEGJEdS2Gncakw==
X-Received: by 2002:adf:fd43:: with SMTP id h3mr4747926wrs.169.1578681401414;
        Fri, 10 Jan 2020 10:36:41 -0800 (PST)
Received: from localhost.localdomain (ip5f5bee3c.dynamic.kabel-deutschland.de. [95.91.238.60])
        by smtp.gmail.com with ESMTPSA id x11sm3182825wre.68.2020.01.10.10.36.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 10:36:40 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        pedrom.sousa@synopsys.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] scsi: ufs: initialize max_lu_supported while booting
Date:   Fri, 10 Jan 2020 19:36:05 +0100
Message-Id: <20200110183606.10102-3-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200110183606.10102-1-huobean@gmail.com>
References: <20200110183606.10102-1-huobean@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

This patch is to add a new function ufshcd_init_device_param() for
initialization of  UFS device related parameters which are used by
driver. In this version patch, there is only dev_info.max_lu_supported
being initialized.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 47 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 46 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 1b97f2dc0b63..a297fe55e36a 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3158,6 +3158,11 @@ static int ufshcd_read_device_desc(struct ufs_hba *hba, u8 *buf, u32 size)
 	return ufshcd_read_desc(hba, QUERY_DESC_IDN_DEVICE, 0, buf, size);
 }
 
+static int ufshcd_read_geometry_desc(struct ufs_hba *hba, u8 *buf, u32 size)
+{
+	return ufshcd_read_desc(hba, QUERY_DESC_IDN_GEOMETRY, 0, buf, size);
+}
+
 /**
  * struct uc_string_id - unicode string
  *
@@ -6827,6 +6832,37 @@ static void ufshcd_clear_dbg_ufs_stats(struct ufs_hba *hba)
 	hba->req_abort_count = 0;
 }
 
+static int ufshcd_init_device_param(struct ufs_hba *hba)
+{
+	int err;
+	size_t buff_len;
+	u8 *desc_buf;
+
+	buff_len = QUERY_DESC_MAX_SIZE;
+	desc_buf = kmalloc(buff_len, GFP_KERNEL);
+	if (!desc_buf) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	err = ufshcd_read_geometry_desc(hba, desc_buf,
+			hba->desc_size.geom_desc);
+	if (err) {
+		dev_err(hba->dev, "%s: Failed reading Geometry Desc. err = %d\n",
+			__func__, err);
+		goto out;
+	}
+
+	if (desc_buf[GEOMETRY_DESC_PARAM_MAX_NUM_LUN] == 1)
+		hba->dev_info.max_lu_supported = 32;
+	else if (desc_buf[GEOMETRY_DESC_PARAM_MAX_NUM_LUN] == 0)
+		hba->dev_info.max_lu_supported = 8;
+
+out:
+	kfree(desc_buf);
+	return err;
+}
+
 static void ufshcd_init_desc_sizes(struct ufs_hba *hba)
 {
 	int err;
@@ -7016,13 +7052,22 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
 
 	/*
 	 * If we are in error handling context or in power management callbacks
-	 * context, no need to scan the host
+	 * context, no need to scan the host and to reinitialize the parameters
 	 */
 	if (!ufshcd_eh_in_progress(hba) && !hba->pm_op_in_progress) {
 		bool flag;
 
 		/* clear any previous UFS device information */
 		memset(&hba->dev_info, 0, sizeof(hba->dev_info));
+		/* Init parameters according to UFS relevant descriptors */
+		ret = ufshcd_init_device_param(hba);
+		if (ret) {
+			dev_err(hba->dev,
+				"%s: Init of device param failed. err = %d\n",
+				__func__, ret);
+			goto out;
+		}
+
 		if (!ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_READ_FLAG,
 				QUERY_FLAG_IDN_PWR_ON_WPE, &flag))
 			hba->dev_info.f_power_on_wp_en = flag;
-- 
2.17.1

