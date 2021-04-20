Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CB11C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DE3861363
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232825AbhDTAJf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:09:35 -0400
Received: from mail-pl1-f178.google.com ([209.85.214.178]:38511 "EHLO
        mail-pl1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232748AbhDTAJd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:09:33 -0400
Received: by mail-pl1-f178.google.com with SMTP id o16so5066601plg.5
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:09:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B4gF/dQpwBofV/33gfLeEn2T3KYG3wALfgy0HxrX7rc=;
        b=WmvRkTK5niJ9K56XBBleEnleBdFXMQ42X7mp5e+XbTNXOmMMCWcSzOeU8jnFKtdq0h
         ++bTlm7yjc4/4D6tsfyJc6hbIWjqu4HJqq8cJ+t662mQrciBO4n7M+da5Nbit14ty7zP
         pRB0g0a84BsYOGvn2zlUiZy1D3fTz+dhmB/a9nLAtCGzlsSAgjHL0jV6UoIbVIHmiH4t
         6rRUxkcKhhT/ZSqAm/UWiqjUujzgQC+Jd8OwMw7kFfvfgzRXa+t5Qg/ZwAeI/bKiiPrH
         dFtu0+w4mn8SybwkYM8xlpydXLYPCU6WUmrSB4M4zA/U62O0lA+w/3S+63ANzIFW8xFC
         DmtA==
X-Gm-Message-State: AOAM533w+k/tkn/d+tFXWqW/vXap0TuG6rbY9ZNR3OHWmYWNbOPkxko3
        h0cVXQHOarCo4/5YZ2sEDG4=
X-Google-Smtp-Source: ABdhPJwPRbIvDixt1fAcOPUtu0WTNL1YINzgSTgsmWSAHV8lHiAVV2wjvhfVZ3bnMUREy+Jiz7Cxlg==
X-Received: by 2002:a17:90a:540b:: with SMTP id z11mr1807906pjh.133.1618877342319;
        Mon, 19 Apr 2021 17:09:02 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.09.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:09:01 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Lee Duncan <lduncan@suse.com>
Subject: [PATCH 009/117] iscsi: Add a compile-time structure size check
Date:   Mon, 19 Apr 2021 17:06:57 -0700
Message-Id: <20210420000845.25873-10-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210420000845.25873-1-bvanassche@acm.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Before modifying the struct iscsi_bsg_reply definition, add a compile-time
structure size check.

Cc: Lee Duncan <lduncan@suse.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_transport_iscsi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index bebfb355abdf..4f821118ea23 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -4729,6 +4729,9 @@ static __init int iscsi_transport_init(void)
 		.groups	= 1,
 		.input	= iscsi_if_rx,
 	};
+
+	BUILD_BUG_ON(offsetof(struct iscsi_bsg_reply, reply_data) != 8);
+
 	printk(KERN_INFO "Loading iSCSI transport class v%s.\n",
 		ISCSI_TRANSPORT_VERSION);
 
