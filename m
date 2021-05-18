Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2507C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7FBE61074
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237923AbhERRq1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 13:46:27 -0400
Received: from mail-pg1-f170.google.com ([209.85.215.170]:40468 "EHLO
        mail-pg1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351196AbhERRqW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 13:46:22 -0400
Received: by mail-pg1-f170.google.com with SMTP id j12so7531730pgh.7
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2021 10:45:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RYHArbRbYelYrYQU2DTlW90aaLQP5FB1bfOWxs+KAd8=;
        b=sqdXIfcmoZ8uOOt8TKsgsgOAF8cwZo7NFCvaAU1TT1IrTiHH0ax5QMKKEgkePIYRNk
         ZwJ/6XtBI16ARUVNw2a3BO5bGT3S8/6gbQSI6VjF2gHBBXxWdic2uIXqdgUJbYiP59Hv
         LyucA4k3fMCtTJBxRh3tkbZTKlIJ+avO3trlc0O+dAUKU/oh559Wtzpq5/VK99hrwzaM
         XHflU1QvKQB/D/cNzyplca8LGJKHH9PCNWEz+8BlZvWBLRbNynGSJEmVbpA9PQFhVm6G
         Z7nbKHZUjQFHvhVg2wYfGBjaUcAYN8XoGWjYSWQXCttrx+Bz/RMklxq1hhCm/UutNqvU
         c4MQ==
X-Gm-Message-State: AOAM5303NX+6sla3eGRmfqxc7MXCTjxmBX19Fg7zS4/466pCAcDstbxX
        Gt2EGPS6uxdrMAAKoUv+qsQ=
X-Google-Smtp-Source: ABdhPJzihnj5ByDvfooc7UVv6D4FLXLG7OyiHoZjRvu+nJ8qYnM0UZ8ulddUlRWMlSMRBY08LiA/zw==
X-Received: by 2002:a63:4b43:: with SMTP id k3mr6235100pgl.450.1621359903836;
        Tue, 18 May 2021 10:45:03 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:4ae4:fc49:eafe:4150])
        by smtp.gmail.com with ESMTPSA id z27sm12656920pfr.46.2021.05.18.10.45.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 10:45:03 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 06/50] scsi_transport_spi: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Tue, 18 May 2021 10:44:06 -0700
Message-Id: <20210518174450.20664-7-bvanassche@acm.org>
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
 
