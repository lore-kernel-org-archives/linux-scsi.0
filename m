Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CCAFC4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Feb 2022 21:03:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233606AbiBPVDp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Feb 2022 16:03:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233634AbiBPVDj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Feb 2022 16:03:39 -0500
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BE2121FEEA
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 13:03:26 -0800 (PST)
Received: by mail-pl1-f182.google.com with SMTP id x4so2966192plb.4
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 13:03:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uD1tH8wDMn3Wm4Fc6dGeyWCxFL02tMZz49ogOKnrwOU=;
        b=MzZ2YshO+N8/q2EV7Y3LYDbbjRX9xoOd6CRyfQNNBPEds0liudgaTzfb0DwVH6m3tx
         Ymv6mrEviT7ZhoT8vThO0wTZdN7pIUt01BxBIcSYGpRD/6cnOu/xJ5e3G+b0vtTlrf+x
         hKAESKntWaLj2LI23RgWIAQgdAhPSf3hSihNrqB+5WWcU0MBzjGeF8GQAh01gDyH18Sc
         Cfu+VReokdFTIH8fvOATVry5Dv5+S+ZIK8mTsNYQzsVrO92T/tfmgB2yabSaPWCAstku
         zy02XC/6RdicbMQpTSDmYjdQWH0HQCbURcQaFY6Mce5DAaqWSKk1T22UppDaPtRF2m1h
         N+eg==
X-Gm-Message-State: AOAM531eQ2DYHNFlJvyp0CUEwMmqLg0jvWt64EPpFb1vwHBGh2n3tYET
        XY8x+gf0EWMDnCbBULhkeIE=
X-Google-Smtp-Source: ABdhPJycK/D48qfWldknXt0mNh5iw+qXxqoMJhA5j0jYNlgcdVUeJ86/DXcgWViNB70nj9bWqHlWwg==
X-Received: by 2002:a17:90b:4a92:b0:1b8:a3c5:1afe with SMTP id lp18-20020a17090b4a9200b001b8a3c51afemr3875276pjb.69.1645045405421;
        Wed, 16 Feb 2022 13:03:25 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id c8sm46591222pfv.57.2022.02.16.13.03.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 13:03:24 -0800 (PST)
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
Subject: [PATCH v4 19/50] scsi: dc395x: Stop using the SCSI pointer
Date:   Wed, 16 Feb 2022 13:02:02 -0800
Message-Id: <20220216210233.28774-20-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220216210233.28774-1-bvanassche@acm.org>
References: <20220216210233.28774-1-bvanassche@acm.org>
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
