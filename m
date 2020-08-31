Return-Path: <SRS0=g0vc=CJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E7B3C433E2
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Aug 2020 02:54:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 685592076D
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Aug 2020 02:54:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbgHaCyP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 30 Aug 2020 22:54:15 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:46400 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726573AbgHaCyK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Aug 2020 22:54:10 -0400
Received: by mail-pl1-f195.google.com with SMTP id k13so2328333plk.13
        for <linux-scsi@vger.kernel.org>; Sun, 30 Aug 2020 19:54:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HUKSBOdCli73E40HgK4a0srrRRXVezp10WSLTZYZcj0=;
        b=ow49/JPbc9h/EQAsXW3Y8G5vqMaGQNUrKX+kSDZbsTNtDkK54x6CSsz/xNMOJp+gJw
         3+TnXtkMkoLVpj78a5xho+Uc8ihJrjx75tE3UuZQrz/07dDmK3yvsqBd3NNg0WDNAz0/
         EIuuS0HHtSrxtV2+3u9kqtt2tePBXqhEfQTZxncrn7nvG0nbtXkpeYmZeIymTTxO2hTm
         asG1IyIKLItIyyFj9/Y0DjHtyfv3xNkYSyg5c7Le+yZPe1AxyQ6tqo45anoiDkMdrVZL
         6C7j0YIJho98vkUZaHWEld7PIPVwDYsKBzScrU6ogyypnodXm09PEa08Bp7TzASjGyNF
         ms+A==
X-Gm-Message-State: AOAM530MomXEGDwnc34mae8B9kQhFXEUjAK4jLl6jFKM6dpbEtEAxUxt
        +EY8cUJ9eEoZyC4lHjoEqKg=
X-Google-Smtp-Source: ABdhPJxbgFMdKy7l6KubWC5cOqNgU7NaoEKJweDwUt/29dlHM0F6o8aIkrEpxd/F1rldC5XiM7Dc2A==
X-Received: by 2002:a17:90b:289:: with SMTP id az9mr7116465pjb.31.1598842449797;
        Sun, 30 Aug 2020 19:54:09 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id l123sm583569pgl.24.2020.08.30.19.54.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2020 19:54:08 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     linux-scsi@vger.kernel.org,
        Martin Kepplinger <martin.kepplinger@puri.sm>,
        Can Guo <cang@codeaurora.org>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH RFC 2/6] scsi: Remove an incorrect comment
Date:   Sun, 30 Aug 2020 19:53:53 -0700
Message-Id: <20200831025357.32700-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200831025357.32700-1-bvanassche@acm.org>
References: <20200831025357.32700-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_device.sdev_target is used in more code than the single_lun code,
hence remove the comment next to the definition of the sdev_target member.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 include/scsi/scsi_device.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index bc5909033d13..264501d23aea 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -144,7 +144,7 @@ struct scsi_device {
 	struct scsi_vpd __rcu *vpd_pg80;
 	struct scsi_vpd __rcu *vpd_pg89;
 	unsigned char current_tag;	/* current tag */
-	struct scsi_target      *sdev_target;   /* used only for single_lun */
+	struct scsi_target      *sdev_target;
 
 	blist_flags_t		sdev_bflags; /* black/white flags as also found in
 				 * scsi_devinfo.[hc]. For now used only to
