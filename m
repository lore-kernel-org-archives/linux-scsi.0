Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE73FC43470
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:35:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D54DB61442
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:35:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233535AbhENVhA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:37:00 -0400
Received: from mail-pf1-f176.google.com ([209.85.210.176]:42868 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230123AbhENVgz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:36:55 -0400
Received: by mail-pf1-f176.google.com with SMTP id h127so642769pfe.9
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:35:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HxvTbn0qaSoC+rvCro+O/XB5CUhLvDTRo66mc/5aJUc=;
        b=hmf/GPbLRpn42LxYaeACAO+RpN2v7+5xl3sEHHkMf4Ee3KbDUHTOuhw1KvVZMqmiR+
         uAzIe3oa4ECCT22BxVvtZH5DPaFi0A7KU2VrTrT4l9z7tlmdGCtOMs07MMWFADJhbwap
         MID7drvGfVCDUgWssG7bDHAIC4qG0rPgSEAfMeO3BGm5FB8gp4lfvmigbAQhEGHPcFhH
         dQdL+lK+6ajpiQwaYtJMe+J28ygm5NimjNExb3z/ftGwf3oF8VCS+PuOud1dLnGtnOPX
         8GbCJ6dGtKfeRZPl09mQBKu9r7OxjxKbqdfxgsyyD50Bh+wEydV8lh3V3cGTRzFUyCyc
         Lujw==
X-Gm-Message-State: AOAM530ubpRmFtL+RgqUmwqHECTD/cWzfy36VQwnG50HtRSZHD7zKntm
        qAMu1U34K0dsdwwMkmNOI6A=
X-Google-Smtp-Source: ABdhPJwwD+byCaZsc9LmZ8dc7KgA+px/C1hx1PhSAGcKjPnubzugGRDtySfBsehStc0W/wieCvKQMw==
X-Received: by 2002:a63:eb10:: with SMTP id t16mr50122094pgh.393.1621028142754;
        Fri, 14 May 2021 14:35:42 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.35.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:35:42 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 05/50] scsi_transport_fc: Use blk_req() instead of scsi_cmnd.request
Date:   Fri, 14 May 2021 14:33:11 -0700
Message-Id: <20210514213356.5264-57-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210514213356.5264-1-bvanassche@acm.org>
References: <20210514213356.5264-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using blk_req() instead. This
patch does not change any functionality.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_transport_fc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index da5b503dc7a1..8134a5ea5921 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3804,7 +3804,7 @@ bool fc_eh_should_retry_cmd(struct scsi_cmnd *scmd)
 	struct fc_rport *rport = starget_to_rport(scsi_target(scmd->device));
 
 	if ((rport->port_state != FC_PORTSTATE_ONLINE) &&
-		(scmd->request->cmd_flags & REQ_FAILFAST_TRANSPORT)) {
+		(blk_req(scmd)->cmd_flags & REQ_FAILFAST_TRANSPORT)) {
 		set_host_byte(scmd, DID_TRANSPORT_MARGINAL);
 		return false;
 	}
