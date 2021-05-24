Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3620DC47080
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:09:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 192DC61159
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:09:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232282AbhEXDLK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 23:11:10 -0400
Received: from mail-pg1-f174.google.com ([209.85.215.174]:38784 "EHLO
        mail-pg1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232276AbhEXDLJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 23:11:09 -0400
Received: by mail-pg1-f174.google.com with SMTP id 6so19042762pgk.5
        for <linux-scsi@vger.kernel.org>; Sun, 23 May 2021 20:09:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E1UO5vrCstw9gxZuwcmCZCPBjeDEolIQTXzW+jrfs58=;
        b=Pj/3qFu1ykg7u+ZwwhlgTiAaOPxsnQJIkPKBa0pSenRk7bU1poA6igWFzcZQmKp785
         VDlM6HZrXrRfZgxOq5xN6pSvlXcEsgb3Mo8njon0yUuod3uS2DNApXJj/xd9aQLCL2Ha
         mfnqzdhtLnWq/wystO9sR2QbohLotmnCATuSkitanU1vWRjaF1iLmKPHT5hT9Edz4Omq
         GoGhRqzYkKRbH/lkhaTiGY5RMEvb6CsS4Yu4Mh19Sk3i8eR9T9NlC84dA77dABqYascF
         TRZaKyqaHsGoyqedqceaPS/C/AYxtc7fbSZ7KRJFLZnu81ODQI6Q1V8pZ3BHj9do3Dfk
         7USw==
X-Gm-Message-State: AOAM533Q9HH50tjuwLcyzTnw9V/mI9C41E5AcOGXsttLmieEfgND4qdZ
        c/lzYAnWJaLbuA7hFGgBDkuDS/HXh1cFpA==
X-Google-Smtp-Source: ABdhPJyk6aaq9sWkzd3WNcIponA9db1BMZjdoNexbb3anGgCZVvT+FtqVzhE6X0IVKNOpxQiZH85tQ==
X-Received: by 2002:a62:1d52:0:b029:2dd:ee:1439 with SMTP id d79-20020a621d520000b02902dd00ee1439mr21961122pfd.57.1621825781593;
        Sun, 23 May 2021 20:09:41 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id v9sm11131863pjd.26.2021.05.23.20.09.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 20:09:40 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 23/51] ibmvfc: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Sun, 23 May 2021 20:08:28 -0700
Message-Id: <20210524030856.2824-24-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524030856.2824-1-bvanassche@acm.org>
References: <20210524030856.2824-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index a251dbf630cc..9067ce1611d3 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -1910,7 +1910,7 @@ static int ibmvfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 	struct ibmvfc_cmd *vfc_cmd;
 	struct ibmvfc_fcp_cmd_iu *iu;
 	struct ibmvfc_event *evt;
-	u32 tag_and_hwq = blk_mq_unique_tag(cmnd->request);
+	u32 tag_and_hwq = blk_mq_unique_tag(scsi_cmd_to_rq(cmnd));
 	u16 hwq = blk_mq_unique_tag_to_hwq(tag_and_hwq);
 	u16 scsi_channel;
 	int rc;
