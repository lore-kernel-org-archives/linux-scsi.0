Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD7DDC433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:46:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90E61611CE
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:46:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351319AbhERRrT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 13:47:19 -0400
Received: from mail-pj1-f49.google.com ([209.85.216.49]:52776 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351323AbhERRrM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 13:47:12 -0400
Received: by mail-pj1-f49.google.com with SMTP id q6so5922072pjj.2
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2021 10:45:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TcMzUO0H6Lt/O7fINkfa5lg23UduAJg6prHwSx9j0ok=;
        b=puWPxRmsnH7Bj0tO98oCdnkhEJkIBFCMD4L12X8NJbLKxxA/3RgN0k0F+9LksiuWPN
         yeEsIWUOeepOQz07/mnrOSKgj7aD89eXsY943HyVgWhHw0WivstAazskb1HPyPw6+q7o
         FlVENgxhrD6gPofJ9RxLpfiAUq5xIZHUqhXlBeNDBW5FKmL1nhC1zRxSxAVaODi6HkNO
         J80ehmajC7zDeZCbK0nljgqm2VUUjDrBVjtk9Hk/s+N1i4ORSEg1+4M775XKa21YDqLH
         QCv2pAytpFdSRzDG6qCavbiUiqSby+os0cpLeV58hlJhT/yeSZ25JWdn9H9Ly1EgW2/v
         phIw==
X-Gm-Message-State: AOAM531GsbTKk8oId1pfLWcUGau5Hiv/S7OsTzsGmdhB6LBgSkyIAs1+
        81yl6/qde72uspxNg7h1Bkk=
X-Google-Smtp-Source: ABdhPJw0L/z3lz78aGwUoQKD8ZIhHIsbrG5A9qUHWet+neYv+g+9J/4A84kLGBm6F4nXBIyAQMIqXg==
X-Received: by 2002:a17:90a:6285:: with SMTP id d5mr6697592pjj.3.1621359954474;
        Tue, 18 May 2021 10:45:54 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:4ae4:fc49:eafe:4150])
        by smtp.gmail.com with ESMTPSA id z27sm12656920pfr.46.2021.05.18.10.45.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 10:45:54 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 47/50] xen-scsifront: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Tue, 18 May 2021 10:44:47 -0700
Message-Id: <20210518174450.20664-48-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210518174450.20664-1-bvanassche@acm.org>
References: <20210518174450.20664-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/xen-scsifront.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/xen-scsifront.c b/drivers/scsi/xen-scsifront.c
index 259fc248d06c..efb95e222e70 100644
--- a/drivers/scsi/xen-scsifront.c
+++ b/drivers/scsi/xen-scsifront.c
@@ -212,7 +212,7 @@ static int scsifront_do_request(struct vscsifrnt_info *info,
 	memcpy(ring_req->cmnd, sc->cmnd, sc->cmd_len);
 
 	ring_req->sc_data_direction   = (uint8_t)sc->sc_data_direction;
-	ring_req->timeout_per_command = sc->request->timeout / HZ;
+	ring_req->timeout_per_command = scsi_cmd_to_rq(sc)->timeout / HZ;
 
 	for (i = 0; i < (shadow->nr_segments & ~VSCSIIF_SG_GRANT); i++)
 		ring_req->seg[i] = shadow->seg[i];
