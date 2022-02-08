Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 731B0C4332F
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Feb 2022 17:26:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384293AbiBHR0A (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 12:26:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384255AbiBHRZ5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2022 12:25:57 -0500
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DECAEC0612C0
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 09:25:52 -0800 (PST)
Received: by mail-pf1-f174.google.com with SMTP id c10so1175836pfi.9
        for <linux-scsi@vger.kernel.org>; Tue, 08 Feb 2022 09:25:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AOUDFTqYlauVmBrnXtY7XMp9uwI44rlkQySMMQjDVxQ=;
        b=NH7eMEpzo+iIlby6uwf6z24IXIVmYAmbHcba8Z05VJo6T59UyxME++SQxeMkxoMvGa
         dLcU00fPthn3OCYWyaxTj8pw/Red45IzXPgPLorcW5s+dqx5D6AmMRCPmT9U+FhxXlGB
         RFiv2+c7v9QJiLu20u8yvKz+qRdzBOtq4ThdHhK6KapFOhNv7XOOWlilcdimBmGng3ln
         JjgfKlo+FWpm6gerWXBeJM2ocZMm88/5PfmwS6uhlw6RyQClZ8PO0Bl3diuNdDOyJ3Ng
         UOuA7RXwNPWNZWjIEYaG32cfzyVyzQA/1dq2P5Rj9BwecP66i2heI/nmMCBrvs36++jT
         q/XA==
X-Gm-Message-State: AOAM533gJOIy7qR3Yv7Xw5bscGfEf1mfaGb6CluhhdCZb7sE3bUWvVy/
        RqfUWCa2/sdNauBPenDGhPM=
X-Google-Smtp-Source: ABdhPJx09XYxn6jNoZb4UlKAq51APyuhwS7JAqyBbojcfoSp9zpwerDNrmaT3W6Vo6cvlp+88l1fQw==
X-Received: by 2002:a63:87c3:: with SMTP id i186mr4343606pge.311.1644341152258;
        Tue, 08 Feb 2022 09:25:52 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id q1sm335116pfs.112.2022.02.08.09.25.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 09:25:51 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 08/44] 53c700: Stop clearing SCSI pointer fields
Date:   Tue,  8 Feb 2022 09:24:38 -0800
Message-Id: <20220208172514.3481-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220208172514.3481-1-bvanassche@acm.org>
References: <20220208172514.3481-1-bvanassche@acm.org>
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

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/53c700.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index ad4972c0fc53..e1e4f9d10887 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -1791,8 +1791,6 @@ static int NCR_700_queuecommand_lck(struct scsi_cmnd *SCp)
 	slot->cmnd = SCp;
 
 	SCp->host_scribble = (unsigned char *)slot;
-	SCp->SCp.ptr = NULL;
-	SCp->SCp.buffer = NULL;
 
 #ifdef NCR_700_DEBUG
 	printk("53c700: scsi%d, command ", SCp->device->host->host_no);
