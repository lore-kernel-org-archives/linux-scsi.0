Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92B95C47080
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:09:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67EFA6117A
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:09:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232212AbhEXDKl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 23:10:41 -0400
Received: from mail-pl1-f172.google.com ([209.85.214.172]:35812 "EHLO
        mail-pl1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232196AbhEXDKj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 23:10:39 -0400
Received: by mail-pl1-f172.google.com with SMTP id t21so13920091plo.2
        for <linux-scsi@vger.kernel.org>; Sun, 23 May 2021 20:09:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l6VDWq6IVEh87e1uNmLaYE9v1k4d4/jK9l4qdKk6+CY=;
        b=OwHdphPAQF/WUKlbg4l1VyxPXTlmGqlXtVaADrhYMuHZ04rVQuO9gaGwimZf/rsppq
         xaYgDu/s/TulHCw6UlGEOizi96sZ8SMqSPFqPbzp1RCeT4ZwLaYZUNy4DbawNcbjyEgL
         1x5NqnqaAJ0C+HPhD9dpjLazRleK6+poba2MmCx4ylU8ddoMQVY+1B2y53Ooa8IXI0Mo
         WpLFmYpwYQD+3GDHLgfWjDTUTYElvICpF+TDOmECc/hQYAg/1i/1u1xsYLjlAzt8Hyf7
         nT9anwI2CLgLeuYNVNkZ4L2mpn26NmpnzlSNSTy71RYSJTCZ7SYOR/ARwk9QMQUlSn3A
         I0Rg==
X-Gm-Message-State: AOAM533JeUv5RfTj8mDbfvGq8qZiRmvho9OlOuelAmSB/+v8r3gmtGg6
        Xw8JDQOYoPUgKpEXgeZp4Q68GZ6N+8I=
X-Google-Smtp-Source: ABdhPJzrTg5Nuz4/wQDtdj81tGy20JmNI03w0fb5TSBShWIBEB+ABElzfCqvPli6kE/Ml5NXSQzvTw==
X-Received: by 2002:a17:90b:4b0f:: with SMTP id lx15mr21780311pjb.184.1621825751369;
        Sun, 23 May 2021 20:09:11 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id v9sm11131863pjd.26.2021.05.23.20.09.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 20:09:10 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>, Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 05/51] scsi_transport_fc: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Sun, 23 May 2021 20:08:10 -0700
Message-Id: <20210524030856.2824-6-bvanassche@acm.org>
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
