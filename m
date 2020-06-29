Return-Path: <SRS0=wv9C=AK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6C2AC433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 22:55:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FE0320780
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 22:55:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728468AbgF2WzJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 18:55:09 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:39736 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728467AbgF2WzJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2020 18:55:09 -0400
Received: by mail-pj1-f67.google.com with SMTP id b92so8643681pjc.4
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2020 15:55:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4ilOEN7XUE2540HfcY3bba214XMb8Srj8q70FUW95sE=;
        b=tVn7HZnYDC2Zrfm4JZLdcyPYT8XIW5r5RbLm/502ls6KuDZIx1BbHk+adGPCg57oEb
         PuNuZINg/TUm4eOvi+foWtVKuZ5CnSAnqdORCD8OkUt33XdrtpKpVY6a3FwvAuADBXtS
         wD4R6IZsUmSLjckOgFva5eGae4wBEbhEdQ37jygO5jrd7ae9MmM9suflZ6geFKaHwEWm
         CVmGZiWVGEkdEMX72rl++ZqI+/76PQcC8MoomUfBCnNgxp4Fuzangi7UfdT+RWgvzhOv
         x702BSyai1obpLby2fn8krDGtVBO9CQ5wYXh5pAflzu/TcVcSIsoSzlJMUkzn2d7ehJA
         Vkpw==
X-Gm-Message-State: AOAM532Zr0F8vZTreLyXw0UqJ6ZuHC7jDS7oNpsmG+bULr7mS7XDIrLh
        637AdfVkQv7Ujf9ITkQSYoc=
X-Google-Smtp-Source: ABdhPJwD4vMLjbyOSSwrKmcr+6PK/VQc+GtOcMX7qE/gkw+4jy0sSJFigszSPL4aHoEFSihdkYnYlg==
X-Received: by 2002:a17:902:7896:: with SMTP id q22mr14799453pll.338.1593471308014;
        Mon, 29 Jun 2020 15:55:08 -0700 (PDT)
Received: from localhost.localdomain (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id mr8sm478379pjb.5.2020.06.29.15.55.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 15:55:07 -0700 (PDT)
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
Subject: [PATCH v2 2/9] qla2xxx: Remove the __packed annotation from struct fcp_hdr and fcp_hdr_le
Date:   Mon, 29 Jun 2020 15:54:47 -0700
Message-Id: <20200629225454.22863-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200629225454.22863-1-bvanassche@acm.org>
References: <20200629225454.22863-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove the __packed annotation from struct fcp_hdr* because that annotation
is not necessary for these data structures.

Reviewed-by: Daniel Wagner <dwagner@suse.de>
Cc: Nilesh Javali <njavali@marvell.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_target.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index 010f12523b2a..1cff7c69d448 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -258,7 +258,7 @@ struct fcp_hdr {
 	__be16   ox_id;
 	uint16_t rx_id;
 	__le32	parameter;
-} __packed;
+};
 
 struct fcp_hdr_le {
 	le_id_t  d_id;
@@ -273,7 +273,7 @@ struct fcp_hdr_le {
 	__le16	rx_id;
 	__le16	ox_id;
 	__le32	parameter;
-} __packed;
+};
 
 #define F_CTL_EXCH_CONTEXT_RESP	BIT_23
 #define F_CTL_SEQ_CONTEXT_RESIP	BIT_22
