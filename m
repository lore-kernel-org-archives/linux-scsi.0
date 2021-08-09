Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B418C432BE
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:04:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7998C60EE7
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:04:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235520AbhHIXEf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 19:04:35 -0400
Received: from mail-pl1-f177.google.com ([209.85.214.177]:38821 "EHLO
        mail-pl1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235676AbhHIXEb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 19:04:31 -0400
Received: by mail-pl1-f177.google.com with SMTP id a5so2656075plh.5
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2021 16:04:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l6VDWq6IVEh87e1uNmLaYE9v1k4d4/jK9l4qdKk6+CY=;
        b=f0XDGhghGcp01AjxSx4P/Oz5dnbbJshI4FYfhEvCkT+NRr7fRgIOY9AnGOnZLrTRDD
         EDYyNPH1faO/oHCAY8KgrM+IP2vlS/Lt7O4RNQdHB+ScFP+W2nRdcbQWEnmctiNITg4j
         4UihcBXPwPHFToIZ6iXA78bJNbpaWJpwSS272MPidj7iWwmbfSihNe50cwN7q7yAQ+NM
         wri+iCwcN8dIFzNBD2r+WN9xfa056uZGln8m+w8TWcaNj9vsFHzf4D5N3Ife5/nTxJUk
         ll8aA6t0dpUDWFlox1hBLUXyrFiiOTrjclAacE85FXMN3G5SsTqFChggCD4dkFdfBZZp
         SQOA==
X-Gm-Message-State: AOAM530l4UP7eknKNCHayTnjfflPXGJGJiGvWXSg62x8igVJKCl8fMzH
        mMI9DqIaYq7VLRmINCPQt28=
X-Google-Smtp-Source: ABdhPJyv2xaiCyCj0X+Tgb37URVGrXScI4466Hgz3mh/AlvtH4ZqwOnxQUaUlBpt6+Ytb0uLuUz8JQ==
X-Received: by 2002:aa7:9254:0:b029:3c9:268e:ae68 with SMTP id 20-20020aa792540000b02903c9268eae68mr14697510pfp.58.1628550250550;
        Mon, 09 Aug 2021 16:04:10 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7dd4:e46e:368b:7454])
        by smtp.gmail.com with ESMTPSA id j6sm24102260pgq.0.2021.08.09.16.04.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 16:04:09 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 05/52] scsi_transport_fc: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Mon,  9 Aug 2021 16:03:08 -0700
Message-Id: <20210809230355.8186-6-bvanassche@acm.org>
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

Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_transport_fc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 49748cd817a5..60e406bcf42a 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3804,7 +3804,7 @@ bool fc_eh_should_retry_cmd(struct scsi_cmnd *scmd)
 	struct fc_rport *rport = starget_to_rport(scsi_target(scmd->device));
 
 	if ((rport->port_state != FC_PORTSTATE_ONLINE) &&
-		(scmd->request->cmd_flags & REQ_FAILFAST_TRANSPORT)) {
+		(scsi_cmd_to_rq(scmd)->cmd_flags & REQ_FAILFAST_TRANSPORT)) {
 		set_host_byte(scmd, DID_TRANSPORT_MARGINAL);
 		return false;
 	}
