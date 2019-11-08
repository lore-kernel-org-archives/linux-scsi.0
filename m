Return-Path: <SRS0=OHhN=ZA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42CA1FC6196
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 11:44:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B1D6222CE
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 11:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573213496;
	bh=i7cCvh+uPeAS+8By3+xyuq47pYVcGmyoHO0qG3CM9nY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=PIh6UAakWcuJtXamsAam1eV8dqPX8vfjn0vsdUBUn0u2/scj4bgUCAcjdJuk8vpS0
	 LnmB/VXtdRTfYcg5B8QlbPguvWmp6WK0qFn1EIqHRlzDNfi95xBoLBSqpdY+MjDvif
	 nFL+IUKF33Wf0yX6lYNwKyaDxp7Bcg2gZtQvtoPc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390957AbfKHLoy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Nov 2019 06:44:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:59912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390945AbfKHLoy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 8 Nov 2019 06:44:54 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8448D2245A;
        Fri,  8 Nov 2019 11:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213493;
        bh=i7cCvh+uPeAS+8By3+xyuq47pYVcGmyoHO0qG3CM9nY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mYTV8tLEH9YiBOrzTYiWbO6yob0havQG8wKmPKO//lEiR9PEhpZu+QtQ8VHPmFrwo
         TSoBxWwMpfU2UaOWLAmr9v+751FFfloK2vo9JkpaN0c3SGVLw3PpUDZvXahFMAw7L/
         lYtHURyA9jG2HbPEQov8eIHmwYtWBfgNtLbQE0NY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     George Kennedy <george.kennedy@oracle.com>,
        Matthew Wilcox <matthew.wilcox@oracle.com>,
        Mark Kanda <mark.kanda@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 072/103] scsi: sym53c8xx: fix NULL pointer dereference panic in sym_int_sir()
Date:   Fri,  8 Nov 2019 06:42:37 -0500
Message-Id: <20191108114310.14363-72-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108114310.14363-1-sashal@kernel.org>
References: <20191108114310.14363-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: George Kennedy <george.kennedy@oracle.com>

[ Upstream commit 288315e95264b6355e26609e9dec5dc4563d4ab0 ]

sym_int_sir() in sym_hipd.c does not check the command pointer for NULL before
using it in debug message prints.

Suggested-by: Matthew Wilcox <matthew.wilcox@oracle.com>
Signed-off-by: George Kennedy <george.kennedy@oracle.com>
Reviewed-by: Mark Kanda <mark.kanda@oracle.com>
Acked-by: Matthew Wilcox <matthew.wilcox@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sym53c8xx_2/sym_hipd.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index 378af306fda17..b87b6c63431dd 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -4371,6 +4371,13 @@ static void sym_nego_rejected(struct sym_hcb *np, struct sym_tcb *tp, struct sym
 	OUTB(np, HS_PRT, HS_BUSY);
 }
 
+#define sym_printk(lvl, tp, cp, fmt, v...) do { \
+	if (cp)							\
+		scmd_printk(lvl, cp->cmd, fmt, ##v);		\
+	else							\
+		starget_printk(lvl, tp->starget, fmt, ##v);	\
+} while (0)
+
 /*
  *  chip exception handler for programmed interrupts.
  */
@@ -4416,7 +4423,7 @@ static void sym_int_sir(struct sym_hcb *np)
 	 *  been selected with ATN.  We do not want to handle that.
 	 */
 	case SIR_SEL_ATN_NO_MSG_OUT:
-		scmd_printk(KERN_WARNING, cp->cmd,
+		sym_printk(KERN_WARNING, tp, cp,
 				"No MSG OUT phase after selection with ATN\n");
 		goto out_stuck;
 	/*
@@ -4424,7 +4431,7 @@ static void sym_int_sir(struct sym_hcb *np)
 	 *  having reselected the initiator.
 	 */
 	case SIR_RESEL_NO_MSG_IN:
-		scmd_printk(KERN_WARNING, cp->cmd,
+		sym_printk(KERN_WARNING, tp, cp,
 				"No MSG IN phase after reselection\n");
 		goto out_stuck;
 	/*
@@ -4432,7 +4439,7 @@ static void sym_int_sir(struct sym_hcb *np)
 	 *  an IDENTIFY.
 	 */
 	case SIR_RESEL_NO_IDENTIFY:
-		scmd_printk(KERN_WARNING, cp->cmd,
+		sym_printk(KERN_WARNING, tp, cp,
 				"No IDENTIFY after reselection\n");
 		goto out_stuck;
 	/*
@@ -4461,7 +4468,7 @@ static void sym_int_sir(struct sym_hcb *np)
 	case SIR_RESEL_ABORTED:
 		np->lastmsg = np->msgout[0];
 		np->msgout[0] = M_NOOP;
-		scmd_printk(KERN_WARNING, cp->cmd,
+		sym_printk(KERN_WARNING, tp, cp,
 			"message %x sent on bad reselection\n", np->lastmsg);
 		goto out;
 	/*
-- 
2.20.1

