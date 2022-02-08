Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D07BEC4332F
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Feb 2022 17:26:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384318AbiBHR0E (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 12:26:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384257AbiBHRZ6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2022 12:25:58 -0500
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26FE4C061579
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 09:25:58 -0800 (PST)
Received: by mail-pl1-f169.google.com with SMTP id x3so14420262pll.3
        for <linux-scsi@vger.kernel.org>; Tue, 08 Feb 2022 09:25:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hE0aMFgLHDathpw0gsv8hcoRtBJtmF2RKsB9j1TXbNo=;
        b=i8qNdyPMfLJG8jyXILF3laT5iquxpaTLKk2BojlAW9/ZxfGfx1NdRR6G/CQbgE1iVw
         1tEgDcjrnWjdIpmMeHyYQeFTglvCgUKpG8uS5oP9zFnLxH1Vslm9ii30q4EJM3i09TN6
         l2ocapOn97OSEgNbtWQUyQHQ4UH2E6/TgrRY2D6D9Jc1LMz/+PgOaZjGsyjJRnfeTjX1
         fvS8bgHUlRkLvr5Z+wuGrKnP9LtfHntI/z+kHmr6NfmL64bXKIvIZZsykOgNpVSVNr3A
         9tNidT+Tp9jgYD895iirh5gZ8PWAcVrjcFtKHjgeLmzbHJcqCDvWPH1PuyoQuxmrXlpD
         36hA==
X-Gm-Message-State: AOAM531MWwlT3h5clElADEQlYwaz5okFVwLQ4r3bNGhVRTScj5Frqz13
        Ctss+8IlazV9J2TZjTGn/Cw=
X-Google-Smtp-Source: ABdhPJwq0NR+fWOSRPQkRrOzZV1M2tOC1BWQD31z2gd422mVUfGIc21HRs3NRf3PFUfCeH2iwBgqJQ==
X-Received: by 2002:a17:90a:548:: with SMTP id h8mr2498230pjf.109.1644341157489;
        Tue, 08 Feb 2022 09:25:57 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id q1sm335116pfs.112.2022.02.08.09.25.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 09:25:56 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 11/44] aha1542: Remove a set-but-not-used array
Date:   Tue,  8 Feb 2022 09:24:41 -0800
Message-Id: <20220208172514.3481-12-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220208172514.3481-1-bvanassche@acm.org>
References: <20220208172514.3481-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch fixes the following W=1 warning:

drivers/scsi/aha1542.c:209:12: warning: variable ‘inquiry_result’ set but not used [-Wunused-but-set-variable]
  209 |         u8 inquiry_result[4];

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/aha1542.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index f0e8ae9f5e40..cf7bba2ca68d 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -206,7 +206,6 @@ static int makecode(unsigned hosterr, unsigned scsierr)
 
 static int aha1542_test_port(struct Scsi_Host *sh)
 {
-	u8 inquiry_result[4];
 	int i;
 
 	/* Quick and dirty test for presence of the card. */
@@ -240,7 +239,7 @@ static int aha1542_test_port(struct Scsi_Host *sh)
 	for (i = 0; i < 4; i++) {
 		if (!wait_mask(STATUS(sh->io_port), DF, DF, 0, 0))
 			return 0;
-		inquiry_result[i] = inb(DATA(sh->io_port));
+		(void)inb(DATA(sh->io_port));
 	}
 
 	/* Reading port should reset DF */
