Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABD14C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:14:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F50D61107
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:14:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233438AbhDTCOv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 22:14:51 -0400
Received: from mail-pj1-f50.google.com ([209.85.216.50]:36583 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231693AbhDTCOp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 22:14:45 -0400
Received: by mail-pj1-f50.google.com with SMTP id f2-20020a17090a4a82b02900c67bf8dc69so21499219pjh.1
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 19:14:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1anv0wQUuXOURRkQt1L0vphtgMt7lXBytSr/6odvRMk=;
        b=AsG9RAsKm4Q59BOFLscS0vvCgmmGEf5BVjmDxMvimVTGAhJqgsKTtUKsuRxYv7Bdc3
         AQFLKIyG0T8x795idSgEh4Rkuq++4exZypROybgCv7/3E6at7cU++E7kMuq8En7rShCk
         nizc+KFFxRChorXkQ0e3rrs/dCvoa2zcAlxg8nysWrBulVbtnFIfgeg2uL+H5DEV2kou
         8OKeyEw0Rf6E3sV1ZYpNmbYcI+ruOmih9tng5Ey+0V49CsLJxSloEX+eTDNhihaq8vAN
         J1PRfgxTBZqcq6uEWpU0lo98/oDEdxKLMfMxLDspOr7mw88kcDO8Fb2IWMDlyRZHWbuq
         dVhw==
X-Gm-Message-State: AOAM531sJTek85b/jq6RbCCWf0JBkPt6k18lcd+hVXNknUx4SKsJk9Ic
        Aoa0v5PLMGvBePsacmk/hg8=
X-Google-Smtp-Source: ABdhPJya13hFTTngzyLPij713mRoAL+zoIltX0yvB/T6MyDYrBf555NSI+y/nKEwFMVPr+FRxJLJtw==
X-Received: by 2002:a17:90a:bd8c:: with SMTP id z12mr2313222pjr.83.1618884854237;
        Mon, 19 Apr 2021 19:14:14 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id mq2sm630984pjb.24.2021.04.19.19.14.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 19:14:13 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>
Subject: [PATCH 095/117] storvsc: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 19:13:40 -0700
Message-Id: <20210420021402.27678-5-bvanassche@acm.org>
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

Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/storvsc_drv.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index e6718a74e5da..69918c924825 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1096,9 +1096,9 @@ static void storvsc_command_completion(struct storvsc_cmd_request *cmd_request,
 	vm_srb = &cmd_request->vstor_packet.vm_srb;
 	data_transfer_length = vm_srb->data_transfer_length;
 
-	scmnd->result = vm_srb->scsi_status;
+	scmnd->status.combined = vm_srb->scsi_status;
 
-	if (scmnd->result) {
+	if (scmnd->status.combined) {
 		if (scsi_normalize_sense(scmnd->sense_buffer,
 				SCSI_SENSE_BUFFERSIZE, &sense_hdr) &&
 		    !(sense_hdr.sense_key == NOT_READY &&
@@ -1675,7 +1675,7 @@ static bool storvsc_scsi_cmd_ok(struct scsi_cmnd *scmnd)
 	 * this. So, don't send it.
 	 */
 	case SET_WINDOW:
-		scmnd->result = DID_ERROR << 16;
+		scmnd->status.combined = DID_ERROR << 16;
 		allowed = false;
 		break;
 	default:
