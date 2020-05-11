Return-Path: <SRS0=B1Ch=6Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 524F6C47255
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 20:10:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E427206F5
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 20:10:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731577AbgEKUKJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 May 2020 16:10:09 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35807 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731240AbgEKUKI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 May 2020 16:10:08 -0400
Received: by mail-pg1-f194.google.com with SMTP id t11so5060373pgg.2
        for <linux-scsi@vger.kernel.org>; Mon, 11 May 2020 13:10:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TyKGcwsvoo+Au6r+BpjAYhENqaW33j3kR6F7Xm6VfXU=;
        b=nHh+MnppMNQjpxWNCRWX3eDAJs6A1fYTPbrIaoFzgc6wD37rYyussDTTojArSLxQQQ
         7LM3eUQQIweaWNkCKcba00LDnvAGwzlRTOUaka4yBM6PE1VQQ23cqvQtk7paNFAz5W6E
         pvWL39RLyLyZefSJ9eILxWsF5A/bkWlSpMBbSx6/BITWSNKQAZh1RSE0QiD6rlt7pT6m
         OOvJ1ZjgTJC9ymAo/fXSh4DATTKA0m6iOWes0LCL0MYC1xH3UKe+F9hq6hvl/xwgxRHS
         1zLQ4gOi7UlIalhGmsxF47AxDpNDwDWCx05ilgFN2hivNlbxftajBoft1/qAHxLYEoig
         Mm4A==
X-Gm-Message-State: AGi0PuaJUud/aDO/Dw11ZDK3ImQLmTPIfBDADCw0MzJZ2ggb5e2BXvB/
        B8gcai0TMa+zqlyO78mnARH+KqJtQvA=
X-Google-Smtp-Source: APiQypLL+wbae2aNPsqL0/l5l3FImpCRYrMyhzZpznVuM3Uu2tEGbt9hRj00cq13nJYgZyH9uhN+HQ==
X-Received: by 2002:a63:d201:: with SMTP id a1mr15640043pgg.137.1589227807324;
        Mon, 11 May 2020 13:10:07 -0700 (PDT)
Received: from localhost.localdomain ([2601:647:4000:d7:c4e5:b27b:830d:5d6e])
        by smtp.gmail.com with ESMTPSA id 30sm8610265pgp.38.2020.05.11.13.10.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 13:10:06 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Arun Easi <aeasi@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Hannes Reinecke <hare@suse.de>, Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH v5 09/15] qla2xxx: Use register names instead of register offsets
Date:   Mon, 11 May 2020 13:09:40 -0700
Message-Id: <20200511200946.7675-10-bvanassche@acm.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200511200946.7675-1-bvanassche@acm.org>
References: <20200511200946.7675-1-bvanassche@acm.org>
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

Cc: Arun Easi <aeasi@marvell.com>
Cc: Nilesh Javali <njavali@marvell.com>
Cc: Daniel Wagner <dwagner@suse.de>
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>
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
