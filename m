Return-Path: <SRS0=af2F=6L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDA56C55194
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 03:03:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8B382084D
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 03:03:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbgD0DD0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 26 Apr 2020 23:03:26 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41621 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbgD0DD0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 26 Apr 2020 23:03:26 -0400
Received: by mail-pg1-f196.google.com with SMTP id h69so8021863pgc.8
        for <linux-scsi@vger.kernel.org>; Sun, 26 Apr 2020 20:03:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hbdSxHFtK80XWPqZEbc0CtHaoUCU6Krhiga53vuCQcc=;
        b=XrGkk1QuSVpHEvPS3pxVNn/X9Srr5JDw/d+OF8bFhJPmVp+dhkFgjSxzwJViE4Uk9q
         PAJHBJCcLlMQMuEJSGMPjRaSRZJUKdOa0Wzbnaep6CBnVGIJ9LtsNNh6Qv9qqf3PN8io
         X5ibvIEj+ikmFO14GbtmfvalDRXN5sWGotVMlFKvkg48oGmpOcL/2HbMZpQV1MyCRa/i
         8RxhICyPfrjlMGI4qTdNcQTg5Z51YOhcz/NoP/qWiBrfdS70a0IETPWQ/2LrT3evTtbl
         Q3oVHPoyQfNBbCN7wUqmlKBANJiRcg9u0Yh1ImFb3bOMdyOBSHXt7fBOoA9g6krLJdDB
         2tsA==
X-Gm-Message-State: AGi0Pub0IYh0L/FVqjNS9oFQZX3nBDixUiv6tQEimj0jcUcne9s/P2r1
        fO0T9GFqnW7A05NkFtFLPEE=
X-Google-Smtp-Source: APiQypJ1+U5q9kVuuzNfm5/8AIjTM+9NjPZDrerNs/22f5lz8562BLo95P5g/dBB3eijhr9/+UWepA==
X-Received: by 2002:a62:81c6:: with SMTP id t189mr21608892pfd.174.1587956604048;
        Sun, 26 Apr 2020 20:03:24 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:612a:373a:aa97:7fa7])
        by smtp.gmail.com with ESMTPSA id v94sm9982617pjb.39.2020.04.26.20.03.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2020 20:03:23 -0700 (PDT)
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
Subject: [PATCH v4 05/11] qla2xxx: Make a gap in struct qla2xxx_offld_chain explicit
Date:   Sun, 26 Apr 2020 20:03:04 -0700
Message-Id: <20200427030310.19687-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200427030310.19687-1-bvanassche@acm.org>
References: <20200427030310.19687-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch makes struct qla2xxx_offld_chain compatible with ARCH=i386.

Cc: Nilesh Javali <njavali@marvell.com>
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Daniel Wagner <dwagner@suse.de>
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
 
