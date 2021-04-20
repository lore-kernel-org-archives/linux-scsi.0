Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3E16C43461
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:14:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B12A6613AE
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:14:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233732AbhDTCPE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 22:15:04 -0400
Received: from mail-pf1-f172.google.com ([209.85.210.172]:46980 "EHLO
        mail-pf1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233635AbhDTCPC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 22:15:02 -0400
Received: by mail-pf1-f172.google.com with SMTP id d124so24449805pfa.13
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 19:14:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vKRAGrmNrV6XNdcW0QOmOpXDH2DWQaSuG+Gc8BFTrTk=;
        b=LaxG42UVzvUYaEL8I6fXyBswvD/pmASpzeZs4wQZUc93tgyOigK4EmfGA37qy0tbg/
         dg1IskRaBfG+SAAUAVh/7oQtTnbEJjgy9vuJPJdkmaR2kya1zHTouN1yWU8IOPdnV0kP
         bzjW8/ciOCe4YtkU79ZadnBhYFCdzDIG491Hqaz+XNXHEabFHHJ/ugl25YOWMYX8rO8v
         KwLReUw8nVHbkkLVadOZkr54ocj49qRZKmRmt4SV6BUfyXK6LFkDqjaIPkAxm6emu+UM
         76wXR2gCZfjcEU6C53veT6Csx2AYegEbfPj4s9Jgyb9whf41v5zPl2FeuueuxPjKZP02
         o9Cg==
X-Gm-Message-State: AOAM531NqUvDl48Ca9JyXYN20FO9utPDZvM2PKg+QQFmo/8v1eP7esb+
        3C1ruUBz7PHUD0KsglMAS7E=
X-Google-Smtp-Source: ABdhPJxIFH7JZGOug+jvxbsMmSIYUfukjPAMZs8HZLq104FW7mqwnw7RPRqTcFSzjeDDDqONNErH0Q==
X-Received: by 2002:a63:ea06:: with SMTP id c6mr14780441pgi.401.1618884871321;
        Mon, 19 Apr 2021 19:14:31 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id mq2sm630984pjb.24.2021.04.19.19.14.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 19:14:30 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 109/117] xen-scsifront: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 19:13:54 -0700
Message-Id: <20210420021402.27678-19-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210420000845.25873-1-bvanassche@acm.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

An explanation of the purpose of this patch is available in the patch
"scsi: Introduce the scsi_status union".

Cc: Juergen Gross <jgross@suse.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/xen-scsifront.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/xen-scsifront.c b/drivers/scsi/xen-scsifront.c
index 259fc248d06c..3f5af399c68c 100644
--- a/drivers/scsi/xen-scsifront.c
+++ b/drivers/scsi/xen-scsifront.c
@@ -261,7 +261,7 @@ static void scsifront_cdb_cmd_done(struct vscsifrnt_info *info,
 	scsifront_gnttab_done(info, shadow);
 	scsifront_put_rqid(info, id);
 
-	sc->result = ring_rsp->rslt;
+	sc->status.combined = ring_rsp->rslt;
 	scsi_set_resid(sc, ring_rsp->residual_len);
 
 	sense_len = min_t(uint8_t, VSCSIIF_SENSE_BUFFERSIZE,
@@ -533,7 +533,7 @@ static int scsifront_queuecommand(struct Scsi_Host *shost,
 	unsigned long flags;
 	int err;
 
-	sc->result = 0;
+	sc->status.combined = 0;
 
 	shadow->sc  = sc;
 	shadow->act = VSCSIIF_ACT_SCSI_CDB;
@@ -551,7 +551,7 @@ static int scsifront_queuecommand(struct Scsi_Host *shost,
 		spin_unlock_irqrestore(shost->host_lock, flags);
 		if (err == -ENOMEM)
 			return SCSI_MLQUEUE_HOST_BUSY;
-		sc->result = DID_ERROR << 16;
+		sc->status.combined = DID_ERROR << 16;
 		sc->scsi_done(sc);
 		return 0;
 	}
