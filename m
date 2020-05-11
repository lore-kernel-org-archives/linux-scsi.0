Return-Path: <SRS0=B1Ch=6Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 958BDC54E90
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 20:10:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78D74206F5
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 20:10:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731568AbgEKUKD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 May 2020 16:10:03 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:42257 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731405AbgEKUKD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 May 2020 16:10:03 -0400
Received: by mail-pl1-f196.google.com with SMTP id k19so4379578pll.9
        for <linux-scsi@vger.kernel.org>; Mon, 11 May 2020 13:10:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C0cot1my3DSTorq5qYnwXxrVta8UfIO9bwrwrWtZ1vU=;
        b=HSDUiZbzcD/ZZTN2jMF7sxoihQOVCi9LdDQHpvt5/XVphFhg10hnqzKyaqXdnmje6e
         Z4umoelu+1BpyGcfZiGgpw4911ICwjFB1nlXWOtfLH7WGzCtM2y8uzI+YlEzveq3Iqox
         Bpe8N/codQf42J6/hW6QvhKL47pOqKCIWUzZ+9LZE1YLkyDG9q7dE01TxzFx2Nprplog
         JaFQYLNMWSXNYsh0Z5snvc5e6M5CiarBl4lqEDQTWUxwe8dKhzfPir1TeGhakS6FeswV
         jY2BsUeuV2rW6YSwqIz4NruzazwC9pTS2xnUUoiSjNWI65Vawd5TR6kK4W1tUWAJf2RY
         m56w==
X-Gm-Message-State: AGi0PubszkNV1bbcbsk1vv2cxYNyQ6X9i07QgckBD/sh6n4Ss9nhu9ay
        q2jfLCoOsV2zdPEoW9Do2Pk=
X-Google-Smtp-Source: APiQypIZrvU2klSTmacYVVakA25ii6pjJtbXU+BXOnFIzRkH8XWakIA00GwTl8WxjRDm4ruF0vgb+g==
X-Received: by 2002:a17:90b:23c7:: with SMTP id md7mr23625129pjb.165.1589227802484;
        Mon, 11 May 2020 13:10:02 -0700 (PDT)
Received: from localhost.localdomain ([2601:647:4000:d7:c4e5:b27b:830d:5d6e])
        by smtp.gmail.com with ESMTPSA id 30sm8610265pgp.38.2020.05.11.13.10.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 13:10:01 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Daniel Wagner <dwagner@suse.de>,
        Hannes Reinecke <hare@suse.de>,
        Nilesh Javali <njavali@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH v5 06/15] qla2xxx: Make a gap in struct qla2xxx_offld_chain explicit
Date:   Mon, 11 May 2020 13:09:37 -0700
Message-Id: <20200511200946.7675-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200511200946.7675-1-bvanassche@acm.org>
References: <20200511200946.7675-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch makes struct qla2xxx_offld_chain compatible with ARCH=i386.

Reviewed-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
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
 
