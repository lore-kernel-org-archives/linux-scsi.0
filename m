Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A507C4320A
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:05:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F23E60F38
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:05:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237044AbhHIXFq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 19:05:46 -0400
Received: from mail-pj1-f54.google.com ([209.85.216.54]:46047 "EHLO
        mail-pj1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235520AbhHIXFq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 19:05:46 -0400
Received: by mail-pj1-f54.google.com with SMTP id m24-20020a17090a7f98b0290178b1a81700so2390124pjl.4
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2021 16:05:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TMLCx7WeEQe4ZBsSl0axnckf7a0fh04bRQwe8iGs0W4=;
        b=ac2XdxhMZkeFI6iBoz1EM6s+eBj6HMkKE4/iKZdnBrMiS2FrffO2IDM5suh1ip2EJN
         2BOHXxfuT0PFYlkOnSffpdr69lJW4K8s40hkbMGxPZse+61N2mH7SD18jekEeJsU0ru/
         bp4qIOSdOKGjNsSOnt+hGqK6RkVQU1zrXTHFKwgX/JsJW1YUWejoPm3DS8ZEilhXCnMQ
         tsX6nt54+R1s7G+9eWSJsw7vojZd8R/oM++v3qMTyUkigIL2zMMK97VSZU4cuaL9ifwp
         6kkkYIG44WSL+BfWywXQTb2B3Aa+BT6EMEsmeA+keXQ2irQQmMkn15dx+P7MA2qvyHpd
         L1LA==
X-Gm-Message-State: AOAM530hTWTPTl2CCJre14az1oRo7ZweMucI4CI6zCMfWu7fqNXwgSy5
        1sNw2pO9/rA28nY2l0ws/NM=
X-Google-Smtp-Source: ABdhPJxAxnEsKKVNmjU3nT1NIXuK4d3YX2AbsP5TFTn8I2/6qjS0Au9GiOxJ1KMzXdxyRCCSz+PIjw==
X-Received: by 2002:a17:90b:1004:: with SMTP id gm4mr6915239pjb.181.1628550324772;
        Mon, 09 Aug 2021 16:05:24 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7dd4:e46e:368b:7454])
        by smtp.gmail.com with ESMTPSA id j6sm24102260pgq.0.2021.08.09.16.05.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 16:05:24 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 49/52] xen-scsifront: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Mon,  9 Aug 2021 16:03:52 -0700
Message-Id: <20210809230355.8186-50-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210809230355.8186-1-bvanassche@acm.org>
References: <20210809230355.8186-1-bvanassche@acm.org>
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
index ec9d399fbbd8..0204e314b482 100644
--- a/drivers/scsi/xen-scsifront.c
+++ b/drivers/scsi/xen-scsifront.c
@@ -212,7 +212,7 @@ static int scsifront_do_request(struct vscsifrnt_info *info,
 	memcpy(ring_req->cmnd, sc->cmnd, sc->cmd_len);
 
 	ring_req->sc_data_direction   = (uint8_t)sc->sc_data_direction;
-	ring_req->timeout_per_command = sc->request->timeout / HZ;
+	ring_req->timeout_per_command = scsi_cmd_to_rq(sc)->timeout / HZ;
 
 	for (i = 0; i < (shadow->nr_segments & ~VSCSIIF_SG_GRANT); i++)
 		ring_req->seg[i] = shadow->seg[i];
