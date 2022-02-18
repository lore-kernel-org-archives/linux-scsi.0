Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96F33C4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 19:52:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238406AbiBRTwf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Feb 2022 14:52:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238513AbiBRTw0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Feb 2022 14:52:26 -0500
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFAEA29412A
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:52:07 -0800 (PST)
Received: by mail-pf1-f182.google.com with SMTP id d187so3129805pfa.10
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:52:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uD1tH8wDMn3Wm4Fc6dGeyWCxFL02tMZz49ogOKnrwOU=;
        b=DvR1BVuAICj5gcHlb3d//MHgVPfmzJYfMJX8Fts0huoACEXVV+YJuV1MU7dXb4pnCr
         /dEXSOAGZeQtIoSRKVUSlSQAUpkwT90SiG5heMecAPGR0I5aaPMIYJ91itUdcrkxDDik
         eVlr3OLgt/EdWkTFsXselfz/yCoqukCa25uRO+YpRC/fv0P+wGbPMkVW1OE9wB8wnCBJ
         nsjDrT/6Jjgyjy9rlauun0xZkI2XZw38zTVXtv20ZL+h8/MkRp67q1ipv6f0EXsE0BQZ
         cywSxpKSH4XA9MPKGj+diSg0JrLkVMabOHFeRRrBmA2s66hiZWomSYBcG4WJSfOhUXhM
         FXoA==
X-Gm-Message-State: AOAM532wNV0m0SLta4M6clkTR7t7rCMX8JH40jdMbuMysBeKGOyfkbDF
        r7bKHIofzvG7tfCfnj72bLc=
X-Google-Smtp-Source: ABdhPJwxz6LFgRwBTk/BHoY+s+P7RnKH0IXRse3aTCbVUGGKrzoQs6nzc9/6uRdCulNVqItfzTdBpQ==
X-Received: by 2002:a65:4108:0:b0:36b:ffa6:9c86 with SMTP id w8-20020a654108000000b0036bffa69c86mr7609766pgp.203.1645213927148;
        Fri, 18 Feb 2022 11:52:07 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id e15sm3930523pfv.104.2022.02.18.11.52.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 11:52:06 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Oliver Neukum <oneukum@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Oliver Neukum <oliver@neukum.org>,
        Ali Akcaagac <aliakc@web.de>,
        Jamie Lenehan <lenehan@twibble.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 18/49] scsi: dc395x: Stop using the SCSI pointer
Date:   Fri, 18 Feb 2022 11:50:46 -0800
Message-Id: <20220218195117.25689-19-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220218195117.25689-1-bvanassche@acm.org>
References: <20220218195117.25689-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove the code that sets SCSI pointer members since there is no code in
this driver that reads these members.

Cc: Oliver Neukum <oneukum@suse.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
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
