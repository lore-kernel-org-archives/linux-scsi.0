Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13E72C4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 19:52:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238063AbiBRTw3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Feb 2022 14:52:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238158AbiBRTwH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Feb 2022 14:52:07 -0500
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8208629E
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:51:50 -0800 (PST)
Received: by mail-pf1-f179.google.com with SMTP id c4so3126696pfl.7
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:51:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Woqxw/zqQxyqs/Ud74tzjcz1WT0YRS65oBUeDleTKn8=;
        b=S/kKvM2nWFQ7cwv6q+sawEtBX6BEqXFdaaNZbExFHcw5qUx2HlbDj1i4YCzVNfxijc
         dOHLsSGzNDtm32Qm7IHRiclxdAExWamxz83LytX6dMBJm8koEqufoVubAolS5GJlrBZn
         R1hH1VzRVsAmV2TiKI4kyb98GDHlwGc9fENPrXM6rt81KfrWN4E+qxLY0OGEyhdUogsi
         wrIlzizvLDa0GwKvvESUT0UK+OEWum5vOO5hWcXEeOVqbLVZeILAo4ssgwpWGhY4x8GQ
         RN3fEHlrndskuMMK49+uHQq+UN9t+1o3WaJIM1jNNXhZDlL7jb9ftNYG5SB/ZYH93NX0
         1vQA==
X-Gm-Message-State: AOAM5323GawoFq2sOI+eAZ8WdzaS+rKzB12jDdN8LQ5F7f6O26PrHBct
        LirzogIaGEVfBBkLKdwzOLU=
X-Google-Smtp-Source: ABdhPJyfYlTSL/JkBAP05iFLFjUonuPSiPZp0AEc0NY5HdNPlC26nqbxVI73NvBC+fUqjBSLMUUZZQ==
X-Received: by 2002:a63:1651:0:b0:342:b566:57c4 with SMTP id 17-20020a631651000000b00342b56657c4mr7339584pgw.258.1645213909842;
        Fri, 18 Feb 2022 11:51:49 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id e15sm3930523pfv.104.2022.02.18.11.51.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 11:51:49 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v5 11/49] scsi: 53c700: Stop clearing SCSI pointer fields
Date:   Fri, 18 Feb 2022 11:50:39 -0800
Message-Id: <20220218195117.25689-12-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220218195117.25689-1-bvanassche@acm.org>
References: <20220218195117.25689-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

None of the 53c700 drivers uses the SCSI pointer. Hence remove the code
from 53c700.c that clears two SCSI pointer fields. The 53c700 drivers are:

$ git grep -l 'include.*53c700'
drivers/scsi/53c700.c
drivers/scsi/a4000t.c
drivers/scsi/bvme6000_scsi.c
drivers/scsi/lasi700.c
drivers/scsi/mvme16x_scsi.c
drivers/scsi/sim710.c
drivers/scsi/sni_53c710.c
drivers/scsi/zorro7xx.c

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/53c700.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index 3ad3ebaca8e9..df469a411fdb 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -1792,8 +1792,6 @@ static int NCR_700_queuecommand_lck(struct scsi_cmnd *SCp)
 	slot->cmnd = SCp;
 
 	SCp->host_scribble = (unsigned char *)slot;
-	SCp->SCp.ptr = NULL;
-	SCp->SCp.buffer = NULL;
 
 #ifdef NCR_700_DEBUG
 	printk("53c700: scsi%d, command ", SCp->device->host->host_no);
