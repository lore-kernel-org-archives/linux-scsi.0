Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FC3DC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Jan 2022 22:20:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344913AbiA1WUy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Jan 2022 17:20:54 -0500
Received: from mail-pj1-f47.google.com ([209.85.216.47]:46852 "EHLO
        mail-pj1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344739AbiA1WUx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Jan 2022 17:20:53 -0500
Received: by mail-pj1-f47.google.com with SMTP id oa14-20020a17090b1bce00b001b61aed4a03so6406017pjb.5
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jan 2022 14:20:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lpeALnhc9qvDFzBhYhbAAzuR6HxfoJMtk2PvpIqrd1s=;
        b=bChWcfhQtEcERq2ZM8pERVlbD3/O+6fjgJFcVm3XyT9OXjLkYqODGgSSCkpt0s7Lcx
         J7j3k32GkOidttqHqLpjzAbEuEOtmMPGMK+QxBVubebhU+WAoeGmY6UiiN05L0kUm0KH
         t0ht6kRGrxsFHaioF/x11S3/Q0/MnfdCqUCzhv+MKqAM5GprEXCboAqpuqeiBSUA/rex
         3u+jjPltZmz9a/tsGebA6zshPvgbg/9+gNZ5ia/hwcCcPKu892pC2VT+7dYFOjs713cF
         IFykt0K2SoaO5whrwXBZ7+liEJnQDLoFXYeLIj5AHpUcJV1iFNoAytskWjV+fVPhbFrP
         FSSw==
X-Gm-Message-State: AOAM533AXW3UMa1ARUSY6jIf0iwSwu4HlB5ig5Uvj0cWYPB1w8ZfcnjJ
        VP2foqa4hzQ/XHVyixwh6T8=
X-Google-Smtp-Source: ABdhPJwUSLSNqEVexLY06oevutQAnqEoumbOvUqnqhQ1Vxuxr3AGNsFaP2BbC/JtbyFyZbomK0kpUw==
X-Received: by 2002:a17:902:8e84:: with SMTP id bg4mr10759505plb.141.1643408452449;
        Fri, 28 Jan 2022 14:20:52 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id t2sm7787931pfg.207.2022.01.28.14.20.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 14:20:51 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 08/44] 53c700: Stop clearing SCSI pointer fields
Date:   Fri, 28 Jan 2022 14:18:33 -0800
Message-Id: <20220128221909.8141-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220128221909.8141-1-bvanassche@acm.org>
References: <20220128221909.8141-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

None of the 53c700 drivers uses the SCSI pointer. Hence remove the code
from 53c700.c that clears two SCSI pointer fields. The 53c700 drivers are:

$ git grep -nHE 'include.*53c700'
drivers/scsi/53c700.c:132:#include "53c700.h"
drivers/scsi/53c700.c:153:#include "53c700_d.h"
drivers/scsi/a4000t.c:22:#include "53c700.h"
drivers/scsi/bvme6000_scsi.c:23:#include "53c700.h"
drivers/scsi/lasi700.c:43:#include "53c700.h"
drivers/scsi/mvme16x_scsi.c:23:#include "53c700.h"
drivers/scsi/sim710.c:29:#include "53c700.h"
drivers/scsi/sni_53c710.c:38:#include "53c700.h"
drivers/scsi/zorro7xx.c:25:#include "53c700.h"

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
