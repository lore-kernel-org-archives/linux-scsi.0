Return-Path: <SRS0=wJ7M=YV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55506CA9EC0
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 20:07:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3AED1208C0
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 20:07:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732465AbfJ1UHX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Oct 2019 16:07:23 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34321 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732418AbfJ1UHV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Oct 2019 16:07:21 -0400
Received: by mail-pg1-f193.google.com with SMTP id e4so3368978pgs.1;
        Mon, 28 Oct 2019 13:07:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cYBcEr7JXamXlGE0nw4evwvTfMUMSlNBodCHAYkMNhs=;
        b=kfnRiBA6xelLmMHBltelKUlY5h4r/oQNbW0pHmoWzO86stxbVVLQLKBOIBC+v3jRd3
         41xEkxMvfumQYoQxqYR9bvOJ8nBjnx92LvKmvtLYYx9kCA1bkbxJyKQNNPKvc7JXs2NJ
         XE2Cnu+ALuRG4vgmSd7QjEPJzIjU2bC+VeLhbLUNXRiPqG7f9L52q4ARUBLVIlCp0PWV
         U3FyJyZMRXGNmleY47goVbYVCkvzGqdGjyHNsG84P05+XU2Y0zhKids7kOH7tCYWERJZ
         9OIAYjPBiQZwxe+iT5ZOXiL4Ge6n2YdwO29AiBTuY9C4BCcrkxKwTpdX2up7/ADxxjj5
         +4Qg==
X-Gm-Message-State: APjAAAVG8zbgsbH2EiYPa+pjIG6bd8BzKUUj2y3b3mJ3HTl2F/Yhqm2P
        flXJUdKs8gL+awPjs9LqG0c=
X-Google-Smtp-Source: APXvYqzIJzeohKKZJQE3qciehJBrrZzTGGzGTPCHPjLItPBhDiW6bafqXJG4K1XVEIGlmTtCwtLfAg==
X-Received: by 2002:a17:90a:77c6:: with SMTP id e6mr1343495pjs.93.1572293240291;
        Mon, 28 Oct 2019 13:07:20 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id p3sm11084218pgp.41.2019.10.28.13.07.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2019 13:07:19 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Doug Ledford <dledford@redhat.com>
Subject: [PATCH 8/9] IB/qib: Sign extend without triggering implementation-defined behavior
Date:   Mon, 28 Oct 2019 13:06:59 -0700
Message-Id: <20191028200700.213753-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
In-Reply-To: <20191028200700.213753-1-bvanassche@acm.org>
References: <20191028200700.213753-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From the C standard: "The result of E1 >> E2 is E1 right-shifted E2 bit
positions. If E1 has an unsigned type or if E1 has a signed type and a
nonnegative value, the value of the result is the integral part of the
quotient of E1 / 2E2 . If E1 has a signed type and a negative value, the
resulting value is implementation-defined."

Hence use sign_extend_24_to_32() instead of "<< 8 >> 8".

Cc: Dennis Dalessandro <dennis.dalessandro@intel.com>
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Doug Ledford <dledford@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/infiniband/hw/qib/qib_rc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/qib/qib_rc.c b/drivers/infiniband/hw/qib/qib_rc.c
index aaf7438258fa..2f1beaab6935 100644
--- a/drivers/infiniband/hw/qib/qib_rc.c
+++ b/drivers/infiniband/hw/qib/qib_rc.c
@@ -566,7 +566,7 @@ int qib_make_rc_req(struct rvt_qp *qp, unsigned long *flags)
 		break;
 	}
 	qp->s_sending_hpsn = bth2;
-	delta = (((int) bth2 - (int) wqe->psn) << 8) >> 8;
+	delta = sign_extend_24_to_32(bth2 - wqe->psn);
 	if (delta && delta % QIB_PSN_CREDIT == 0)
 		bth2 |= IB_BTH_REQ_ACK;
 	if (qp->s_flags & RVT_S_SEND_ONE) {
-- 
2.24.0.rc0.303.g954a862665-goog

