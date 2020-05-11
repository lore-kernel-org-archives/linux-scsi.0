Return-Path: <SRS0=B1Ch=6Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86220C47255
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 20:10:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72B4B206F5
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 20:10:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731592AbgEKUKQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 May 2020 16:10:16 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:47039 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731240AbgEKUKQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 May 2020 16:10:16 -0400
Received: by mail-pf1-f196.google.com with SMTP id 145so5219449pfw.13
        for <linux-scsi@vger.kernel.org>; Mon, 11 May 2020 13:10:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vNqcWeXPZJ3AMKyAWKxWXBU66xmPlLfLnmMbsKeXPuc=;
        b=A1AS3nS79KcTWWNsncnTaMffuuBzkGGa0zAICZDijgfyF1n83+IoX+aS1prJw20dpl
         csCLYyP5Oz6vS3EEyRd71IC20FvarOJ/8d/ipBmvPGxkIzn3VmBQacjyef2o6XWqbCKj
         j+vzuFUlrbPKEUD7/eoScZIFfHQM0uYZ4+zuIsjiIOM6y9w1A7mmN5V/Yhw+Wi7MCNtJ
         1bDyh7cI6DBgYr+Lqc5FcxASnp9nedJ9a6IZiZUSVqPvETixyC3bME5oRsHRSIAJPqqO
         P8/qruIL4YiDVeSzzfHvWykcOIWM0jp8PsfXhGZl7PbsEvMWs9Wl0nbVkDAggh3/KylD
         tS9w==
X-Gm-Message-State: AGi0PuYjEcSPou/DPUWqDq6PmF+5lw14nxNySYpheGZb9tCHsHkYk1/i
        6b9scS/Z71/zen5+NqL8SVU=
X-Google-Smtp-Source: APiQypJCekLNLAyAueHAPETIThKaJTdpvHzuyCGNsaxOHh2hwdtwlxbDqAO9ON1MF+lAD8++MF7ZKg==
X-Received: by 2002:a62:146:: with SMTP id 67mr17949662pfb.169.1589227815038;
        Mon, 11 May 2020 13:10:15 -0700 (PDT)
Received: from localhost.localdomain ([2601:647:4000:d7:c4e5:b27b:830d:5d6e])
        by smtp.gmail.com with ESMTPSA id 30sm8610265pgp.38.2020.05.11.13.10.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 13:10:14 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Arun Easi <aeasi@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Hannes Reinecke <hare@suse.de>, Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH v5 13/15] qla2xxx: Use make_handle() instead of open-coding it
Date:   Mon, 11 May 2020 13:09:44 -0700
Message-Id: <20200511200946.7675-14-bvanassche@acm.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200511200946.7675-1-bvanassche@acm.org>
References: <20200511200946.7675-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Cc: Arun Easi <aeasi@marvell.com>
Cc: Nilesh Javali <njavali@marvell.com>
Cc: Daniel Wagner <dwagner@suse.de>
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_isr.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 87d0f5e4d81a..0a9a838c7f20 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -819,7 +819,7 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 		goto skip_rio;
 	switch (mb[0]) {
 	case MBA_SCSI_COMPLETION:
-		handles[0] = le32_to_cpu((uint32_t)((mb[2] << 16) | mb[1]));
+		handles[0] = le32_to_cpu(make_handle(mb[2], mb[1]));
 		handle_cnt = 1;
 		break;
 	case MBA_CMPLT_1_16BIT:
@@ -858,10 +858,10 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 		mb[0] = MBA_SCSI_COMPLETION;
 		break;
 	case MBA_CMPLT_2_32BIT:
-		handles[0] = le32_to_cpu((uint32_t)((mb[2] << 16) | mb[1]));
-		handles[1] = le32_to_cpu(
-		    ((uint32_t)(RD_MAILBOX_REG(ha, reg, 7) << 16)) |
-		    RD_MAILBOX_REG(ha, reg, 6));
+		handles[0] = le32_to_cpu(make_handle(mb[2], mb[1]));
+		handles[1] =
+			le32_to_cpu(make_handle(RD_MAILBOX_REG(ha, reg, 7),
+						RD_MAILBOX_REG(ha, reg, 6)));
 		handle_cnt = 2;
 		mb[0] = MBA_SCSI_COMPLETION;
 		break;
