Return-Path: <SRS0=TSrQ=WF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B7DDC433FF
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1233216C8
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405268AbfHIDDd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Aug 2019 23:03:33 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43307 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405025AbfHIDDd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2019 23:03:33 -0400
Received: by mail-pf1-f193.google.com with SMTP id i189so45226043pfg.10
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2019 20:03:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=opJnL6VrQ+4ofCM+NlietFBrWGvMj3Wf5L94rn3IFv4=;
        b=RAyOhgbqSzbol4paOH+qUyi5OECIjQZ6IQnkEL2r48Gr1fRrDWsNQkg4U3rsz9Ey1F
         wKfvZumzRnwI0XM8yJNUHnjlM7xTVH1YVRidYsWqfJrZPNfkzdqR1ZBmD3gGbV47Ufqe
         a10ur7KAdwMx+hONjAVuHQJAY7Zkyyz9/AgAdouR7FF4kvgtW8ui36hIxsyL7of4D+Jv
         94cttmPO2K62HPxygXKhfzH7/W6xGOyYdsaQcl5U1QXRW8fKlN1uyLKvNvg9gGX/UBNy
         i3xviVvppRpGrHXjhVmkIk58ryEwa7tUgzonV1caqIa/CGDWDILuOKTrkYs9l+pYw0+H
         Fekg==
X-Gm-Message-State: APjAAAXLBTp93m0t+im6BHKUV0YZkeRqnkFmXf3Jfk7+GLop/iC582FZ
        +9G+iHlIuY7NXiY4atEa9qo=
X-Google-Smtp-Source: APXvYqz2UCTCrqYh9ZNWo4Oje9wd0wZ91pgYbNFFhbdTG4kvGJ85VZnwJFFyZ7CMimbVxlyNtlWhvg==
X-Received: by 2002:a17:90a:ad93:: with SMTP id s19mr7178834pjq.36.1565319812202;
        Thu, 08 Aug 2019 20:03:32 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4001:6530:8f02:649d:771a:4703])
        by smtp.gmail.com with ESMTPSA id g2sm111787580pfi.26.2019.08.08.20.03.30
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 20:03:31 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH v2 42/58] qla2xxx: Rework key encoding in qlt_find_host_by_d_id()
Date:   Thu,  8 Aug 2019 20:02:03 -0700
Message-Id: <20190809030219.11296-43-bvanassche@acm.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809030219.11296-1-bvanassche@acm.org>
References: <20190809030219.11296-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use the same approach for encoding the destination ID as the approach
used by qlt_update_vp_map().

Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_target.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 3dd897d3e400..f7b72d1d4862 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -191,16 +191,14 @@ struct scsi_qla_host *qlt_find_host_by_d_id(struct scsi_qla_host *vha,
 					    be_id_t d_id)
 {
 	struct scsi_qla_host *host;
-	uint32_t key = 0;
+	uint32_t key;
 
 	if (vha->d_id.b.area == d_id.area &&
 	    vha->d_id.b.domain == d_id.domain &&
 	    vha->d_id.b.al_pa == d_id.al_pa)
 		return vha;
 
-	key  = d_id.domain << 16;
-	key |= d_id.area << 8;
-	key |= d_id.al_pa;
+	key = be_to_port_id(d_id).b24;
 
 	host = btree_lookup32(&vha->hw->tgt.host_map, key);
 	if (!host)
-- 
2.22.0

