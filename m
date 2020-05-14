Return-Path: <SRS0=2tzU=64=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5BE6C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 21:36:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E5BD206F1
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 21:36:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727876AbgENVgG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 May 2020 17:36:06 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44998 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726073AbgENVgG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 May 2020 17:36:06 -0400
Received: by mail-pg1-f196.google.com with SMTP id b8so1817962pgi.11
        for <linux-scsi@vger.kernel.org>; Thu, 14 May 2020 14:36:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2+q7v+6keOzmizZYeApNkTggym3xkyLiGcu4Q45EkTg=;
        b=KNPL+SBothL4FRDnhUzik1c26aAfOzTXI+J8KyfavKMEovV3c0XigNbAu8lJOO863U
         a+FD2UFjZBQQrJ2BFsnxG8k8N/mXF8BcZlQ5AMRlzc+v+hjvj1dKisa9UGgUiW6wIvDk
         FilP27fw4j7TWxYa0U4HOJ0SGmXSjEjicuSsYEhrR3C6HViRaY/a5xEOyIAFrp8+JeUq
         qP9agraG1G32xs9VN+yI67bQ0w+yQ29du174alXTf4DnQ5nlt56WR4uVVj3LlPLJjKek
         JFgsigP2eZjZZNggCYUkkPXNuO67n0zBHoW8iqxqqyfgzzJIusl+S1810rCFBFXgATb5
         L61Q==
X-Gm-Message-State: AOAM533GMKtDZpQZbq270wbR7w5h4NvFVa66QJw67f5VHY7cjpt1m80z
        wzXGOSovxqdtB0ZV7fXi0io=
X-Google-Smtp-Source: ABdhPJwWxGBtq+k5GQMguU6oKghSzZnGKVEJGttYhKS5qD4fhkUMRg9I8SSDNI0Ed743d2xZ1OLVPw==
X-Received: by 2002:a63:1a11:: with SMTP id a17mr93501pga.227.1589492163785;
        Thu, 14 May 2020 14:36:03 -0700 (PDT)
Received: from localhost.localdomain ([2601:647:4000:d7:6c16:7f27:8c37:e02d])
        by smtp.gmail.com with ESMTPSA id a142sm145754pfa.6.2020.05.14.14.36.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2020 14:36:03 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Arun Easi <aeasi@marvell.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Daniel Wagner <dwagner@suse.de>,
        Nilesh Javali <njavali@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH v6 06/15] qla2xxx: Make a gap in struct qla2xxx_offld_chain explicit
Date:   Thu, 14 May 2020 14:35:07 -0700
Message-Id: <20200514213516.25461-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200514213516.25461-1-bvanassche@acm.org>
References: <20200514213516.25461-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch makes struct qla2xxx_offld_chain compatible with ARCH=i386.

Reviewed-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Arun Easi <aeasi@marvell.com>
Cc: Nilesh Javali <njavali@marvell.com>
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_dbg.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_dbg.h
index 433e95502808..b106b6808d34 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.h
+++ b/drivers/scsi/qla2xxx/qla_dbg.h
@@ -238,6 +238,7 @@ struct qla2xxx_offld_chain {
 	uint32_t chain_size;
 
 	uint32_t size;
+	uint32_t reserved;
 	u64	 addr;
 };
 
