Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3103C43462
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8882A61363
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232838AbhDTAJf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:09:35 -0400
Received: from mail-pj1-f44.google.com ([209.85.216.44]:44743 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231175AbhDTAJe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:09:34 -0400
Received: by mail-pj1-f44.google.com with SMTP id m6-20020a17090a8586b02901507e1acf0fso3976123pjn.3
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:09:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=un+9zpjDZL4UdMPAScb+oLv9NoebEKwBopaM4XRVTFk=;
        b=EEPdrH1+hQW4qvsBqMiginkj1YllDqVTqy/W7wMEDblJpGoy6vnSirqqwGxcms3O4q
         5e89tZbFScmRtUWyVuB3Eu1oHfwGPGWYIY7voFMb7wvBU5AHxEKKui6ICjYU9urEfR31
         FQyF9w5MSRJLhDrHhAOJx22NPIsXYltkJ7060bf7nEzxBiraVGPVffeQc0CQq4HNfkd2
         Tci6oRPDMhhODLfFKijQNr7Zjf+EH4FIoe+SQf1CrXQ5ACVeZ48yjt71iB1r01fU3pyu
         jWsOklisOcYcMUJtrVAqneTJmkb489+xsSp7JO4KNTi8vrjSHwNGQ14cx8ryLeBQqTjM
         bl7A==
X-Gm-Message-State: AOAM533HhwzhgT/Jm4kppKDEX8un9iftoXkARExaXpz/G5v6xI/gDCpY
        traNH8nMeJOkMFjuLcE5mLU=
X-Google-Smtp-Source: ABdhPJxmJcztXPjmjahy/nOqsVTyn+VivjLnHa5k2ej2OV01mSwyfKcL4toPffDk5IU970AM3yHeQQ==
X-Received: by 2002:a17:90a:df10:: with SMTP id gp16mr1735217pjb.209.1618877343575;
        Mon, 19 Apr 2021 17:09:03 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.09.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:09:02 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Can Guo <cang@codeaurora.org>
Subject: [PATCH 010/117] ufs: Add a compile-time structure size check
Date:   Mon, 19 Apr 2021 17:06:58 -0700
Message-Id: <20210420000845.25873-11-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210420000845.25873-1-bvanassche@acm.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Before modifying the definition of struct ufs_bsg_reply, add a compile-time
structure size check.

Cc: Can Guo <cang@codeaurora.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 0625da7a42ee..fa596cf66c23 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -9455,6 +9455,8 @@ EXPORT_SYMBOL_GPL(ufshcd_init);
 
 static int __init ufshcd_core_init(void)
 {
+	BUILD_BUG_ON(offsetof(struct ufs_bsg_reply, upiu_rsp) != 8);
+
 	ufs_debugfs_init();
 	return 0;
 }
