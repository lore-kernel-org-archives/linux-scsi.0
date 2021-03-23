Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4A29C433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 17:28:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72A0A619C1
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 17:28:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbhCWR2X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Mar 2021 13:28:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:60048 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230196AbhCWR2F (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 23 Mar 2021 13:28:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1616520484; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=L02vSD2iV5caKoc94Jjj4zKwysi3k7OVdT/x3alFu68=;
        b=bTin+/E/UncL6sXJd6Yjt9l7GJ3rj+cNo/7k/gdntJifpwTchFy51MpZUGbua0vci/atkX
        wptN/3M5B06t8DbL2dbtqqEkh4PFbQkJ9PdQQM6sns9g3f/CYSdlpNh4WCNONnXjVer0ul
        LVa1OVlrm2a7oKZ6D6t7E5yqLyYRGMw=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4A969AD38;
        Tue, 23 Mar 2021 17:28:04 +0000 (UTC)
Received: by localhost (Postfix, from userid 1000)
        id 39DF59CB7; Tue, 23 Mar 2021 10:28:02 -0700 (PDT)
From:   <lduncan@suse.com>
To:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Lee Duncan <lduncan@suse.com>
Subject: [PATCH] Fix fnic driver to remove bogus ratelimit messages.
Date:   Tue, 23 Mar 2021 10:27:56 -0700
Message-Id: <20210323172756.5743-1-lduncan@suse.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Lee Duncan <lduncan@suse.com>

Commit b43abcbbd5b1 ("scsi: fnic: Ratelimit printks to avoid
looding when vlan is not set by the switch.i") added
printk_ratelimit() in front of a couple of debug-mode
messages, to reduce logging overrun when debugging the
driver. The code:

>           if (printk_ratelimit())
>                   FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host,
>                             "Start VLAN Discovery\n");

ends up calling printk_ratelimit() quite often, triggering
many kernel messages about callbacks being surpressed.

The fix is to decompose FNIC_FCS_DBG(), then change the order
of checks so that printk_ratelimit() is only called if
driver debugging is enabled.

Signed-off-by: Lee Duncan <lduncan@suse.com>
---
 drivers/scsi/fnic/fnic_fcs.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
index e0cee4dcb439..332b31493e79 100644
--- a/drivers/scsi/fnic/fnic_fcs.c
+++ b/drivers/scsi/fnic/fnic_fcs.c
@@ -1343,9 +1343,10 @@ void fnic_handle_fip_timer(struct fnic *fnic)
 	if (list_empty(&fnic->vlans)) {
 		spin_unlock_irqrestore(&fnic->vlans_lock, flags);
 		/* no vlans available, try again */
-		if (printk_ratelimit())
-			FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host,
-				  "Start VLAN Discovery\n");
+		if (unlikely(fnic_log_level & FNIC_FCS_LOGGING))
+			if (printk_ratelimit())
+				shost_printk(KERN_DEBUG, fnic->lport->host,
+						"Start VLAN Discovery\n");
 		fnic_event_enq(fnic, FNIC_EVT_START_VLAN_DISC);
 		return;
 	}
@@ -1363,9 +1364,10 @@ void fnic_handle_fip_timer(struct fnic *fnic)
 	case FIP_VLAN_FAILED:
 		spin_unlock_irqrestore(&fnic->vlans_lock, flags);
 		/* if all vlans are in failed state, restart vlan disc */
-		if (printk_ratelimit())
-			FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host,
-				  "Start VLAN Discovery\n");
+		if (unlikely(fnic_log_level & FNIC_FCS_LOGGING))
+			if (printk_ratelimit())
+				shost_printk(KERN_DEBUG, fnic->lport->host,
+					  "Start VLAN Discovery\n");
 		fnic_event_enq(fnic, FNIC_EVT_START_VLAN_DISC);
 		break;
 	case FIP_VLAN_SENT:
-- 
2.30.2

