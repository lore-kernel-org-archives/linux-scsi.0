Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 232CEC47083
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:09:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03D3061168
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:09:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232128AbhEXDKm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 23:10:42 -0400
Received: from mail-pj1-f50.google.com ([209.85.216.50]:50869 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232132AbhEXDKl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 23:10:41 -0400
Received: by mail-pj1-f50.google.com with SMTP id t11so14030608pjm.0
        for <linux-scsi@vger.kernel.org>; Sun, 23 May 2021 20:09:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RYHArbRbYelYrYQU2DTlW90aaLQP5FB1bfOWxs+KAd8=;
        b=qI0+HOz+qZxSO4NZxp+GswijdZbezaGuapKPAbV3My3lGMUf/PhMb4DCMtcusetzHk
         AjMyru0PiJaIyT1dN5tzIUZ9ogeXsywQdy0ZS4wLSbS+XGbXyOIUa/yHWGbmE3ExCDWl
         zk1SFBON7rSyx3zLS3TVzWeD8F3jojeDJ6+xvc0yVz6+TRjCguz01JmTk2rgg9O79xK7
         oHbgx7QIRUYaUCQNuair4flhw2FofxMhzRlS0A45Q/+JWJX5tdgPzT82aPrvrCYietyY
         1a7oN0tz26ngyWVYQApOtZF9mMdEtO5Xml4W8IdgDFgEBkcuDsh3K8KHHWTDAzqJR8z7
         V4Wg==
X-Gm-Message-State: AOAM533f+j18LKyZm65HWX8lR/9S0WmMGNSgTaXVOMo3mhY4kBjZgbEh
        +k1DP3srmNMGWu/0i+cYW60=
X-Google-Smtp-Source: ABdhPJz7P/fnsDZ9BhplNsRMNvoNylvzmRaRO42d9DKzeVDD3QhObVHeVUgiaIolEmmFTNFX3kAAVg==
X-Received: by 2002:a17:90b:8c5:: with SMTP id ds5mr23122872pjb.127.1621825752879;
        Sun, 23 May 2021 20:09:12 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id v9sm11131863pjd.26.2021.05.23.20.09.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 20:09:12 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>, Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 06/51] scsi_transport_spi: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Sun, 23 May 2021 20:08:11 -0700
Message-Id: <20210524030856.2824-7-bvanassche@acm.org>
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

Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_transport_spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index c37dd15d16d2..10f98fc83854 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -1230,7 +1230,7 @@ int spi_populate_tag_msg(unsigned char *msg, struct scsi_cmnd *cmd)
 {
         if (cmd->flags & SCMD_TAGGED) {
 		*msg++ = SIMPLE_QUEUE_TAG;
-        	*msg++ = cmd->request->tag;
+		*msg++ = scsi_cmd_to_rq(cmd)->tag;
         	return 2;
 	}
 
