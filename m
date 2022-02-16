Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB4E9C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Feb 2022 21:03:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233535AbiBPVD2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Feb 2022 16:03:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233418AbiBPVDX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Feb 2022 16:03:23 -0500
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E97FE213409
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 13:03:10 -0800 (PST)
Received: by mail-pf1-f182.google.com with SMTP id i6so3167321pfc.9
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 13:03:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Woqxw/zqQxyqs/Ud74tzjcz1WT0YRS65oBUeDleTKn8=;
        b=ElBcNZ0KORm0xd+z/Lu5IPoBnbpeWMq3ea4yO+hzkgowrpazDdSnwosJXSGgFEO7aF
         G4I82Wr4zJ2EHqKw1jwCmmbbgpAwTknBfZbyhEScdKSV2dzK/rF/w17l9tGlepNdOYqV
         gsETdRDEt8FvRJERLU4n9XFhA2aDcUCZ4QhtjmwG6jP5g05izRmUEY8pVCAnh1r0aV3h
         RIc3idBYHlVjLgF6BANy8p++9yNd33JgnCjEALg2/3jLC/WDBxC955ZO25iwf2hgx1PK
         NhPLHlkSCfTDoPKWuBjhk2LGS4GIbvy0PEp/N5YgS5Sq7IcGInw1M5Hr0N5vxd+Zio0z
         YjFQ==
X-Gm-Message-State: AOAM5320HAxUBNJYE8tYdtQ01r22r5jIlg/KtRzlykUdfWV3V+2VUmRZ
        D3xzPAC5ld6zPHk8FKox6Ig=
X-Google-Smtp-Source: ABdhPJxMkxHw1byr6i8CYzI/6vvR1jMcQYAKrFJI2jHYiYpfsggANtptPlnr5DpZYgkBd9NomQxOAg==
X-Received: by 2002:a63:f912:0:b0:372:bac6:b92d with SMTP id h18-20020a63f912000000b00372bac6b92dmr3709954pgi.265.1645045390356;
        Wed, 16 Feb 2022 13:03:10 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id c8sm46591222pfv.57.2022.02.16.13.03.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 13:03:09 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v4 12/50] scsi: 53c700: Stop clearing SCSI pointer fields
Date:   Wed, 16 Feb 2022 13:01:55 -0800
Message-Id: <20220216210233.28774-13-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220216210233.28774-1-bvanassche@acm.org>
References: <20220216210233.28774-1-bvanassche@acm.org>
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
