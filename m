Return-Path: <SRS0=2tzU=64=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B6C8C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 21:36:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 810702065F
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 21:36:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727977AbgENVgJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 May 2020 17:36:09 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:46975 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727929AbgENVgJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 May 2020 17:36:09 -0400
Received: by mail-pl1-f195.google.com with SMTP id b12so45263plz.13
        for <linux-scsi@vger.kernel.org>; Thu, 14 May 2020 14:36:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KcWZadH9IbNdha95Q6DM/0rkVd/uxe4CL5bKOdrS66U=;
        b=pQ40czcYHE2JZ0x+4w9wiNk+1dSM45M5tMxaep0HPeUPYy7UKA/yMrT3xaxpeShXPl
         hj6X1tNTWydhy9FmzAX1eYcwfWJThELEfPDMlfVvFk7bYZE+g+vCSrha84bPGWYW6lK0
         dAv/UV8bDtESHiKAtG0N9YO5FrgX43SVRz9zzuHRTUkFWh2HQRy4PkbG2KMXxNIU7euB
         qbj/PnU44blHpr3+F727f09iP60jnGw67jSX+TTBIUbAY5o0MnAwXJwLMzqk6DK0+7pf
         4OgGrnEKJolPjtmpioiEqdRVhNWpLZpVcgkfsKcS4Gp4bMaci9iqfJup3LPBKhmCKoIl
         4BFA==
X-Gm-Message-State: AGi0Puae6Csun+nhca95f6RAW98h5HPGz+LVG38zQg2joDoM3FrhqqPm
        zsSIyq5ZxIjVmm1ftEr34AI=
X-Google-Smtp-Source: APiQypI5vD1Gn3FnUYdkWHMngymfS0+r7Dx31cl3AZkPcOElg2Mxd6SjjkPpnfkS8EpmoQhSibC4EQ==
X-Received: by 2002:a17:90b:2388:: with SMTP id mr8mr40263699pjb.97.1589492168671;
        Thu, 14 May 2020 14:36:08 -0700 (PDT)
Received: from localhost.localdomain ([2601:647:4000:d7:6c16:7f27:8c37:e02d])
        by smtp.gmail.com with ESMTPSA id a142sm145754pfa.6.2020.05.14.14.36.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2020 14:36:07 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Arun Easi <aeasi@marvell.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH v6 09/15] qla2xxx: Use register names instead of register offsets
Date:   Thu, 14 May 2020 14:35:10 -0700
Message-Id: <20200514213516.25461-10-bvanassche@acm.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200514213516.25461-1-bvanassche@acm.org>
References: <20200514213516.25461-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make qla27xx_write_remote_reg() easier to read by using register names
instead of register offsets. The 'pahole' tool has been used to convert
register offsets into register names. See also commit cbb01c2f2f63
("scsi: qla2xxx: Fix MPI failure AEN (8200) handling").

Reviewed-by: Hannes Reinecke <hare@suse.de>
Cc: Arun Easi <aeasi@marvell.com>
Cc: Nilesh Javali <njavali@marvell.com>
Cc: Daniel Wagner <dwagner@suse.de>
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_tmpl.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c b/drivers/scsi/qla2xxx/qla_tmpl.c
index 4a4d92046cbf..645496091186 100644
--- a/drivers/scsi/qla2xxx/qla_tmpl.c
+++ b/drivers/scsi/qla2xxx/qla_tmpl.c
@@ -17,14 +17,14 @@ static void
 qla27xx_write_remote_reg(struct scsi_qla_host *vha,
 			 u32 addr, u32 data)
 {
-	char *reg = (char *)ISPREG(vha);
+	struct device_reg_24xx __iomem *reg = &vha->hw->iobase->isp24;
 
 	ql_dbg(ql_dbg_misc, vha, 0xd300,
 	       "%s: addr/data = %xh/%xh\n", __func__, addr, data);
 
-	WRT_REG_DWORD(reg + IOBASE(vha), 0x40);
-	WRT_REG_DWORD(reg + 0xc4, data);
-	WRT_REG_DWORD(reg + 0xc0, addr);
+	WRT_REG_DWORD(&reg->iobase_addr, 0x40);
+	WRT_REG_DWORD(&reg->iobase_c4, data);
+	WRT_REG_DWORD(&reg->iobase_window, addr);
 }
 
 void
