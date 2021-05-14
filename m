Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBD4AC43461
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:34:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B24296143F
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:34:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232982AbhENVf2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:35:28 -0400
Received: from mail-pj1-f53.google.com ([209.85.216.53]:45818 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232880AbhENVf0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:35:26 -0400
Received: by mail-pj1-f53.google.com with SMTP id gc22-20020a17090b3116b02901558435aec1so458937pjb.4
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:34:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HxvTbn0qaSoC+rvCro+O/XB5CUhLvDTRo66mc/5aJUc=;
        b=MA5YPHUdMV+YnFRjfCqEVWcf224fzVnjTXbpxV7osrOxyZGqbIt5yld0nO/gsFosXF
         Giyl+V0HbTj3VcesRe3HiqnMhtcDZYUXjcC4J4C55I8TQYe3SrmaTFJjMe8rxsMvc7cs
         gwFvgIEQxR3gEElWiLgkzWKtqElksOoTnEt1wIFxEFAjR0w8QUrNV2lYj899keussB8n
         8EvUIfNxx5ZY0Q9OBU8Bfs/qHZyVUY8hwGh0PuqVNTmFk4/wIutvJKCHHumjjlCMpl+4
         DQwWcixZGMMtJoTNFLvuiGl/HoyubzfBio4D1XGtwW5ZVIHUgjv+p6Z7VWhtvT8MUeOd
         AIiQ==
X-Gm-Message-State: AOAM5315yPBqjs/wCuCtvvHFVnxJHPcPMx3QRpXr+QVexR7Bs/oouDqn
        tWie7SR1W3w9QcSI7UieAYkze0/CLfQ=
X-Google-Smtp-Source: ABdhPJzK+CSRkygwzuPQzx20PLp27RXxguQLV25vgDnUhLI0iCI9DmNgaAyDnTrK5SosF4Wd95fj2Q==
X-Received: by 2002:a17:90b:e09:: with SMTP id ge9mr10869071pjb.232.1621028054329;
        Fri, 14 May 2021 14:34:14 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.34.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:34:13 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 05/50] scsi_transport_fc: Use blk_req() instead of scsi_cmnd.request
Date:   Fri, 14 May 2021 14:32:20 -0700
Message-Id: <20210514213356.5264-6-bvanassche@acm.org>
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
