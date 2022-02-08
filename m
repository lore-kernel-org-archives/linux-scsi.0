Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 711F3C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Feb 2022 17:26:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384272AbiBHR0Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 12:26:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384265AbiBHR0W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2022 12:26:22 -0500
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D12FBC03FEDB
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 09:26:08 -0800 (PST)
Received: by mail-pl1-f181.google.com with SMTP id w20so5147585plq.12
        for <linux-scsi@vger.kernel.org>; Tue, 08 Feb 2022 09:26:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zUdLEcJefSdQ7f+LzamDsYNgtawbBHYD8BAyp0PVxeE=;
        b=N0RABKF+NALc4nNbzwPrCo0dRkyjyG/mnDs3Cnl2HhhUw195pnFDVM8Etwab8oLviK
         Gg2hwgl70lAszzgOR8PATv+eFA6sZRNo5UpAKKqdhyMgiYbxwbCyEwjp2ps4MlDjCiMz
         DcnESBetD0NVykTKMbb/PDoPufIcEju7s0NZGxX90TgIeoevgRlrphWgGGjElT+boHkt
         bqfmbiS6YpAL83NUUtk2BjSUkIl2RJvVeDSSNv3p0eByGV3RwHFQR2caqM9AX5KLxrh9
         kkwRA0BCTMaQquTEPtNdE0dsSvsRx3kmSk8+s8aL4Xq0bEaQNPIEUq/UqTF6pY8HkdHR
         0K5Q==
X-Gm-Message-State: AOAM5328w1MunDr8EXBCPDyTMxqAMuZoySj0thI6M/gKtWeTZ0JlESJD
        uiAMHY7ozMQisuZLL5lBXk8=
X-Google-Smtp-Source: ABdhPJyIsxQ1JLKJBLCQWetYYXZoD/XGZ58LKFHGmYkO0XbAXy/gSfaXL4NfXi0YbV09GAAlQgySTQ==
X-Received: by 2002:a17:90a:6585:: with SMTP id k5mr2498749pjj.94.1644341168124;
        Tue, 08 Feb 2022 09:26:08 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id q1sm335116pfs.112.2022.02.08.09.26.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 09:26:07 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Oliver Neukum <oneukum@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Oliver Neukum <oliver@neukum.org>,
        Ali Akcaagac <aliakc@web.de>,
        Jamie Lenehan <lenehan@twibble.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 15/44] dc395x: Stop using the SCSI pointer
Date:   Tue,  8 Feb 2022 09:24:45 -0800
Message-Id: <20220208172514.3481-16-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220208172514.3481-1-bvanassche@acm.org>
References: <20220208172514.3481-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove the code that sets SCSI pointer members since there is no code in
this driver that reads these members.

Cc: Oliver Neukum <oneukum@suse.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/dc395x.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index c11916b8ae00..67a89715c863 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -3314,9 +3314,6 @@ static void srb_done(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 
 	/* Here is the info for Doug Gilbert's sg3 ... */
 	scsi_set_resid(cmd, srb->total_xfer_length);
-	/* This may be interpreted by sb. or not ... */
-	cmd->SCp.this_residual = srb->total_xfer_length;
-	cmd->SCp.buffers_residual = 0;
 	if (debug_enabled(DBG_KG)) {
 		if (srb->total_xfer_length)
 			dprintkdbg(DBG_KG, "srb_done: (0x%p) <%02i-%i> "
