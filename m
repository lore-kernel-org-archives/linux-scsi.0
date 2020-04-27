Return-Path: <SRS0=af2F=6L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5023BC55194
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 03:03:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AB3C206DD
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 03:03:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726374AbgD0DDT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 26 Apr 2020 23:03:19 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43930 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbgD0DDT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 26 Apr 2020 23:03:19 -0400
Received: by mail-pf1-f196.google.com with SMTP id v63so8264289pfb.10
        for <linux-scsi@vger.kernel.org>; Sun, 26 Apr 2020 20:03:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oUR/+fzPcZEaCR7aM6FTqus/G3zElRKO8lKcija1eTo=;
        b=klgKhGYBmc8oN8oQXC6kXjyIWljlv8o9jsqJjzhWpz58EaipD8nG7xtWxs7cMjLXus
         4iwQ4q/3Srkr/Cu0YuCdUw6hNtuqdABidol9/RL7nqNLPu5+96+4va0JrFRoluT7apkq
         UVgOSNAw7/o4bHbRQd1xp+l2jNk4mAbVnuCJbUb4yWeUFo78HiaBjvlklNMuDTQ7Kf4K
         U0PK1ZvNojbARyXisVn6d/+FcaVNCWruMlz532rF7UQatkBjP9c/E9cjZSRRvxUOHHr7
         QZYqo5uOvNPZ5EmAGRbnG/QzEMB9od1rdjwpjMKgLiB0BaLQK27eH+sZAYCtqIP0yyZW
         tVuw==
X-Gm-Message-State: AGi0Puaaf/WC94HzZpj4t/7DsCUVZ/7Dp/A/MeYXslATpzt8WDlr1glc
        rufXdgijDKw/Q2aYere3MLA=
X-Google-Smtp-Source: APiQypJ30oujk3Q6O6OJMQ0asYzcbsKEI+yWjk5Fi40II7Nk4c6MrgFSUFXwPziMqvRF9HaPepoEsQ==
X-Received: by 2002:a63:e002:: with SMTP id e2mr18533272pgh.405.1587956598275;
        Sun, 26 Apr 2020 20:03:18 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:612a:373a:aa97:7fa7])
        by smtp.gmail.com with ESMTPSA id v94sm9982617pjb.39.2020.04.26.20.03.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2020 20:03:17 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH v4 01/11] qla2xxx: Fix spelling of a variable name
Date:   Sun, 26 Apr 2020 20:03:00 -0700
Message-Id: <20200427030310.19687-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200427030310.19687-1-bvanassche@acm.org>
References: <20200427030310.19687-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Cc: Nilesh Javali <njavali@marvell.com>
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Daniel Wagner <dwagner@suse.de>
Cc: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_fw.h   | 2 +-
 drivers/scsi/qla2xxx/qla_init.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index f9bad5bd7198..b364a497e33d 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -1292,7 +1292,7 @@ struct device_reg_24xx {
 };
 /* RISC-RISC semaphore register PCI offet */
 #define RISC_REGISTER_BASE_OFFSET	0x7010
-#define RISC_REGISTER_WINDOW_OFFET	0x6
+#define RISC_REGISTER_WINDOW_OFFSET	0x6
 
 /* RISC-RISC semaphore/flag register (risc address 0x7016) */
 
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 80390d3f3236..b94429504d30 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2861,7 +2861,7 @@ qla25xx_read_risc_sema_reg(scsi_qla_host_t *vha, uint32_t *data)
 	struct device_reg_24xx __iomem *reg = &vha->hw->iobase->isp24;
 
 	WRT_REG_DWORD(&reg->iobase_addr, RISC_REGISTER_BASE_OFFSET);
-	*data = RD_REG_DWORD(&reg->iobase_window + RISC_REGISTER_WINDOW_OFFET);
+	*data = RD_REG_DWORD(&reg->iobase_window + RISC_REGISTER_WINDOW_OFFSET);
 
 }
 
@@ -2871,7 +2871,7 @@ qla25xx_write_risc_sema_reg(scsi_qla_host_t *vha, uint32_t data)
 	struct device_reg_24xx __iomem *reg = &vha->hw->iobase->isp24;
 
 	WRT_REG_DWORD(&reg->iobase_addr, RISC_REGISTER_BASE_OFFSET);
-	WRT_REG_DWORD(&reg->iobase_window + RISC_REGISTER_WINDOW_OFFET, data);
+	WRT_REG_DWORD(&reg->iobase_window + RISC_REGISTER_WINDOW_OFFSET, data);
 }
 
 static void
