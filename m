Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A526C61DA4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:29:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbjCIT3h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:29:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbjCIT2s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:28:48 -0500
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36D632B9DA
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:28:47 -0800 (PST)
Received: by mail-pl1-f174.google.com with SMTP id x11so3084737pln.12
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:28:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390127;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MFd7OEytCze0u5XL5op+H8sbsT2Mg/pBWrkNJAZR/H8=;
        b=vTYcpepoXlKcAFD8m9hrSDetySlr2g+CGFEM9vjqMu/m2eZw6ipA7sSsbH8yIJFIg/
         EDtqlS/10X2b56dPBui79DYrDQaCiXWi25EuvyJm+gEhHcJF9xmc/r7Cwi27oWXIDPrI
         LWl5dbPq0opp/crj/ejbHfe0oRUW8/BUe4PLVltJh9a8jON/lt0HJPoKOcfys8haaKFl
         qyDL214HmRlv7EmYW9ZjsSMGAeJPFQ+U8y0ou4l4KLdjJNF27qDIjZwDAF5w3UCUhj3e
         3KNT9rxekEHwk+188lZdyad7plb4EXXs/rBxYqprxGUQI2G6B0EqSf10MNxAd8HI/Ge5
         dsMg==
X-Gm-Message-State: AO0yUKUC8jNojw5/WEMQkdtW5mwmwcVsxWzXtH/WzerSAjhsAsO1DmX5
        cv1Y62Vz7HhLfoEQIbdzQGY=
X-Google-Smtp-Source: AK7set+LcvaFlovOcbGXbfDeF3X6SrFlKEGD4AHh6ZlQV+vaqGJEHpeXtwF66JeVefXR+XZvMOM2Kw==
X-Received: by 2002:a05:6a20:3d13:b0:c7:2a63:8792 with SMTP id y19-20020a056a203d1300b000c72a638792mr25697337pzi.29.1678390126673;
        Thu, 09 Mar 2023 11:28:46 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.28.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:28:46 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 46/82] scsi: initio: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:25:38 -0800
Message-Id: <20230309192614.2240602-47-bvanassche@acm.org>
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
 drivers/scsi/initio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index 375261d67619..2a50fda3a628 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -2788,7 +2788,7 @@ static void i91uSCBPost(u8 * host_mem, u8 * cblk_mem)
 	initio_release_scb(host, cblk);	/* Release SCB for current channel */
 }
 
-static struct scsi_host_template initio_template = {
+static const struct scsi_host_template initio_template = {
 	.proc_name		= "INI9100U",
 	.name			= "Initio INI-9X00U/UW SCSI device driver",
 	.queuecommand		= i91u_queuecommand,
