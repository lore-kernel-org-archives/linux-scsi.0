Return-Path: <SRS0=XB8t=73=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F826C433DF
	for <linux-scsi@archiver.kernel.org>; Sun, 14 Jun 2020 22:39:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A45620747
	for <linux-scsi@archiver.kernel.org>; Sun, 14 Jun 2020 22:39:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727990AbgFNWjc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 14 Jun 2020 18:39:32 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:36175 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727966AbgFNWjb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 14 Jun 2020 18:39:31 -0400
Received: by mail-pj1-f67.google.com with SMTP id h22so2847857pjf.1
        for <linux-scsi@vger.kernel.org>; Sun, 14 Jun 2020 15:39:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vNPYzc92ABKfSDvY3HbOjX8UYfRJmddGR1E2UL3x6qA=;
        b=XspQ5kA4pEOjSOKrbeWnXDMQelPPQTrpHiqG7poUm1tFCb993Jk5k+c0TxTH3R1JNu
         ZpSizLN5PENRlxNqu8vzc0J/IEISPXCri7K9HxtpIhSo56a1sZofn72BI3LSnmPH/gVA
         fEAj6s9f2XPu2/EXKlsPI83awE+0fk0yyPNjsUn2IOgncfTVPzNV3SFQlLxBXfVG8xJW
         947gfRNSl4x8I+Q07+nymKlxh7/Kh/XGg0dEaHVOW/FZhxwaEK0GDk0y+uBjI3I9dBC7
         XLOrnGjhSa3d06knzbidPY3kfemghJboLfDY1sPXeIDolvX3W23p02ztNW1lqXTJRsTU
         tDcQ==
X-Gm-Message-State: AOAM533rAJuBcqa0PDWLG61h4G+8t/ruY5uRzBhUiydEdxJJzpm4N1Y1
        AdoLMaO8JViL1x/Pb/IqhQ0=
X-Google-Smtp-Source: ABdhPJxwLPyf9rp+WzUJuzL93IBG6xlfZf7ATngX999Me0ncYbTqJFNMExXRsjVSEw7MYtONjqwySw==
X-Received: by 2002:a17:90a:6047:: with SMTP id h7mr8930259pjm.145.1592174371010;
        Sun, 14 Jun 2020 15:39:31 -0700 (PDT)
Received: from localhost.localdomain (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id u25sm11768711pfm.115.2020.06.14.15.39.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Jun 2020 15:39:30 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Daniel Wagner <dwagner@suse.de>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH 2/9] qla2xxx: Remove the __packed annotation from struct fcp_hdr and fcp_hdr_le
Date:   Sun, 14 Jun 2020 15:39:14 -0700
Message-Id: <20200614223921.5851-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200614223921.5851-1-bvanassche@acm.org>
References: <20200614223921.5851-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove the __packed annotation from struct fcp_hdr* because that annotation
is not necessary for these data structures.

Cc: Nilesh Javali <njavali@marvell.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: Daniel Wagner <dwagner@suse.de>
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
