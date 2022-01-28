Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1FB9C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Jan 2022 22:21:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344189AbiA1WVO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Jan 2022 17:21:14 -0500
Received: from mail-pj1-f52.google.com ([209.85.216.52]:44866 "EHLO
        mail-pj1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344913AbiA1WVI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Jan 2022 17:21:08 -0500
Received: by mail-pj1-f52.google.com with SMTP id nn16-20020a17090b38d000b001b56b2bce31so7726350pjb.3
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jan 2022 14:21:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iVNVnDJm17dSLbvQzZA2HQPnTJ6B/ASG4mKP1wIpkTk=;
        b=Ijk32t1AUUTvRq8agu6Nk+5yckzCfGpUviJRamku4S0fcqrpejh0+DKQzhCPPGj+wk
         w/t3x5Yj45prDI2pfs6gNsmCrPQWm6AK1qz4NhBlmRCILBLbOf8EskEEKcH2cyLi/nz3
         yei1HIpBvEPDI5zz8FBSsNqnAR2NVc2C/Sk0HNcGbu0aTx2LBqAlB8Q/uwrsMY3jNPPy
         Ul0GXtZE+fKiXwKvwEw0XA63BtOg0TPlOuwJbPKnZFAUNoWiBAInC8RYswXRRod14spZ
         wh5pmFjaz82Krh8ymdyxKWWuSbaSllkxdSJIDWz0DjvFs70SoZ2MHD7AKMi7AD41iuJi
         II9g==
X-Gm-Message-State: AOAM530CSo17Oh8SzbzlkMFt8knfx8qXfYZ/67CnOZXNgU6b++m9TzSK
        cCRh/Hu2wEPOpF19NiKo+i0=
X-Google-Smtp-Source: ABdhPJwKYYYYbebqrxYqGw06TEgHTQItxlQYndre+Mb5dlRUhfoSgk1z2gco9TiV/oLYTsR4T298Dw==
X-Received: by 2002:a17:90b:17c1:: with SMTP id me1mr19835012pjb.182.1643408467614;
        Fri, 28 Jan 2022 14:21:07 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id t2sm7787931pfg.207.2022.01.28.14.21.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 14:21:06 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Oliver Neukum <oneukum@suse.com>,
        Oliver Neukum <oliver@neukum.org>,
        Ali Akcaagac <aliakc@web.de>,
        Jamie Lenehan <lenehan@twibble.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 15/44] dc395x: Stop using the SCSI pointer
Date:   Fri, 28 Jan 2022 14:18:40 -0800
Message-Id: <20220128221909.8141-16-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220128221909.8141-1-bvanassche@acm.org>
References: <20220128221909.8141-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove the code that sets SCSI pointer members since there is no code in
this driver that reads these members.

Cc: Oliver Neukum <oneukum@suse.com>
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
