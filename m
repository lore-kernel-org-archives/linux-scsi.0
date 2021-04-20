Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6654AC433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:14:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C7EF61107
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:14:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233604AbhDTCOx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 22:14:53 -0400
Received: from mail-pf1-f176.google.com ([209.85.210.176]:36607 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233575AbhDTCOs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 22:14:48 -0400
Received: by mail-pf1-f176.google.com with SMTP id c3so5687069pfo.3
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 19:14:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bAOfnUgFGeqOcibPS4OY4GEZfpPUYeZlVfGVZTEZGis=;
        b=ACEELkEraGqDaj8C7Dj9CqQxqMFL66VUHnHL/j/QWSncHvE3ss3U36PVNPYt/oPkKi
         4WoJIMFyKMw/7DOpZAnmgbbgibAnD086/6v/WSpDrFltkf4hXHE+EIQlP/xz73lNDnjO
         CtzARo2yHh0EnJQicaL/++xjXvUn/dRlNM93kbwVNU/e3pJpLwqfjBFQLGceLSgQB5zp
         WIEAvRopxHMeAYp4LEhQDpHE+EJOx69CQjfiTo0rV8op6d7ZG63XIOBmj0ao4mJXsEJf
         06sluWSrUW/r/x0K9iwQxhU7EW6OjSDx2fgNPWRg1MKJNf4j9ZYjZszsikE5e2ylKVLS
         rGQQ==
X-Gm-Message-State: AOAM531/CZmHei/N7Zw8j5/w1ElfTbZj9X4N9NjNT94IyOkoojuobDmV
        a7n4IHWD54rUcMiun8LtVBo=
X-Google-Smtp-Source: ABdhPJyqncB8mVLNN8oRlydGl7A38ixnERFhOcvp/KLzaPw9v6XzaqF4z3F//WyTJHLW6y2vpRSRRA==
X-Received: by 2002:aa7:9f02:0:b029:25d:26b2:ecac with SMTP id g2-20020aa79f020000b029025d26b2ecacmr11889509pfr.61.1618884857801;
        Mon, 19 Apr 2021 19:14:17 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id mq2sm630984pjb.24.2021.04.19.19.14.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 19:14:17 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH 098/117] ufs: Remove an unused structure member
Date:   Mon, 19 Apr 2021 19:13:43 -0700
Message-Id: <20210420021402.27678-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210420000845.25873-1-bvanassche@acm.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The 'scsi_status' member is present since the introduction of the UFS
driver but has never been used. Hence remove it.

Cc: Can Guo <cang@codeaurora.org>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Bean Huo <beanhuo@micron.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Asutosh Das <asutoshd@codeaurora.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 5eb66a8debc7..20ad78083246 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -211,7 +211,6 @@ struct ufshcd_lrb {
 	struct scsi_cmnd *cmd;
 	u8 *sense_buffer;
 	unsigned int sense_bufflen;
-	int scsi_status;
 
 	int command_type;
 	int task_tag;
