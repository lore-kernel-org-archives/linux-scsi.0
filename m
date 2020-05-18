Return-Path: <SRS0=k4K9=7A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 692FBC433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 18 May 2020 21:17:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A14A207F9
	for <linux-scsi@archiver.kernel.org>; Mon, 18 May 2020 21:17:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728117AbgERVRg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 May 2020 17:17:36 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:33607 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727944AbgERVRf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 May 2020 17:17:35 -0400
Received: by mail-pg1-f193.google.com with SMTP id s10so3162961pgm.0
        for <linux-scsi@vger.kernel.org>; Mon, 18 May 2020 14:17:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UU6vHDNyGT5Frv5qBrDKIX/CaByKMx7lkz1m5f6JEow=;
        b=W1ybdqHhH/CFnkexJ/r5WzdCPV3+GHjw44i7JNBDW19FcjZ9neDU6lseKeWaLRuk5e
         LOHk6ct2X7TE5xI4jGQCJdFVwcOCeXyG9ScP6Kp4e81IEkzaVEyjl0D9urewT87rD9ew
         7/dHB+ty4ZSvQpSXvozOcL78twfHfyjPE/vByaZVKaur98kuTTnueOYkyUsrMd7WdMrE
         J+X77lNdq/bACn6vdznrtEuD/XHImbNbM8b6Xx9NvkgeJNDLvMFX2Fy/TdjnYwFvN/lv
         s7fwdFAFS410CLtzXDWZket8m0crYLh6vJ0G56NzVEco/emmnXmmtcplG1JXS978dpmx
         ngpw==
X-Gm-Message-State: AOAM530SX0V5QvAa+uKb9D1cI7JiVCGB2eMvLe2d+kWH+M49CVgOvuFO
        GP0pJZzNP7/wvLsYMRJw44A=
X-Google-Smtp-Source: ABdhPJzhjL4aOwaKdZfuD/l+Cv+LDdMcVc+BNkHZfCrx40nyvqtadmL3GW37cm93HDrbTuzPafxNvw==
X-Received: by 2002:a62:2ac3:: with SMTP id q186mr19152178pfq.101.1589836653813;
        Mon, 18 May 2020 14:17:33 -0700 (PDT)
Received: from localhost.localdomain ([2601:647:4000:d7:dc5d:b628:d57b:164])
        by smtp.gmail.com with ESMTPSA id i184sm8813123pgc.36.2020.05.18.14.17.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2020 14:17:32 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Arun Easi <aeasi@marvell.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH v7 09/15] qla2xxx: Use register names instead of register offsets
Date:   Mon, 18 May 2020 14:17:06 -0700
Message-Id: <20200518211712.11395-10-bvanassche@acm.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518211712.11395-1-bvanassche@acm.org>
References: <20200518211712.11395-1-bvanassche@acm.org>
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
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: Arun Easi <aeasi@marvell.com>
Cc: Nilesh Javali <njavali@marvell.com>
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
