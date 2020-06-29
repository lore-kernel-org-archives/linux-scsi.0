Return-Path: <SRS0=wv9C=AK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAC90C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 22:55:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4FDD20786
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 22:55:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728409AbgF2WzI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 18:55:08 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:36212 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726078AbgF2WzH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2020 18:55:07 -0400
Received: by mail-pj1-f66.google.com with SMTP id h22so8649094pjf.1
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2020 15:55:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2sO4M/I6KZtr0qUW3pRrWNvAvtKK9SHCZ3zIc16BBCk=;
        b=YbXLyPsc1qCylt+wx6SbHCqdD6YgoO3IgkuXzk4/KcrTT39eDtnr5Bae73vfhfmQse
         7rO4qffY/8muH46is3vf4RlfWNyGi/RyYKKbTfOISL1HWz/WfindWDtCDXeXEaRYMrpD
         sippoY/M/1L2egIUM8U/F/ZC+QLpzAdNmORcNNer5ze0UEtymHT6le803m2nfj7HoB2w
         LfjQCy+hI7X6nScBxAGTL2Z4Fomxfptlta9iR0yJ9BC3mD+YobZNtCNVF9uBV9YHGVRd
         rLo16TzoLo4pr8mSWxnruF3oXq31oayTMkH9BUv/JUVXY7Tkf4qwo+iv5PdkW9+Wk6+h
         r00w==
X-Gm-Message-State: AOAM531hqFdXkNn1oRPXDooWPU1iFBE5TqMcbajzv11gpywaL7FUNF56
        naN8xnxvuNV64gU6kWlPRL90Tgh/pzw=
X-Google-Smtp-Source: ABdhPJyt8LUwn9tEoJpwq4vKzZc4Y+bppMSq4DCh95VP8pukq8Ekd91gILIHFZpBAGeFPhRB8/i7tQ==
X-Received: by 2002:a17:90b:fd3:: with SMTP id gd19mr20596322pjb.83.1593471306431;
        Mon, 29 Jun 2020 15:55:06 -0700 (PDT)
Received: from localhost.localdomain (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id mr8sm478379pjb.5.2020.06.29.15.55.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 15:55:05 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Daniel Wagner <dwagner@suse.de>,
        Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH v2 1/9] qla2xxx: Check the size of struct fcp_hdr at compile time
Date:   Mon, 29 Jun 2020 15:54:46 -0700
Message-Id: <20200629225454.22863-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200629225454.22863-1-bvanassche@acm.org>
References: <20200629225454.22863-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since struct fcp_hdr is used to exchange data with the firmware, check its
size at compile time.

Reviewed-by: Daniel Wagner <dwagner@suse.de>
Cc: Nilesh Javali <njavali@marvell.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 188aa5f02c01..f7e9b5bc0b26 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -1971,6 +1971,7 @@ static int __init tcm_qla2xxx_init(void)
 	BUILD_BUG_ON(sizeof(struct ctio_crc2_to_fw) != 64);
 	BUILD_BUG_ON(sizeof(struct ctio_crc_from_fw) != 64);
 	BUILD_BUG_ON(sizeof(struct ctio_to_2xxx) != 64);
+	BUILD_BUG_ON(sizeof(struct fcp_hdr) != 24);
 	BUILD_BUG_ON(sizeof(struct fcp_hdr_le) != 24);
 	BUILD_BUG_ON(sizeof(struct nack_to_isp) != 64);
 
