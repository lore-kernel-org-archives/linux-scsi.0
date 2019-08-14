Return-Path: <SRS0=JpCa=WK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0875BC32753
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D115520866
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rldBfYQR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729817AbfHNX5t (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Aug 2019 19:57:49 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:44455 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729274AbfHNX5r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Aug 2019 19:57:47 -0400
Received: by mail-pl1-f195.google.com with SMTP id t14so318508plr.11
        for <linux-scsi@vger.kernel.org>; Wed, 14 Aug 2019 16:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vuIHq6NfJZ8B7T/6h/z7Wvmf5fj4Ed9Aszj3ylocewY=;
        b=rldBfYQR7hB/ThkpXh3/yt8fTtYvHO0G5H58xd0Syx6P/OdyLdLNzc7dw5jQ4adYBF
         Ig8egX+fPFIkwTjiRVTiSUs7tjFMIDHV0zNP003vDZVqA39uGOogPWSgNPq0DlCH4mTW
         gMvRIY5OC6CqHdqxAInlV0uyTebRdoDbvdC94M7DyEmBJfTlr36QCmmEvTAgs1wAZTSX
         vGKz+gzNpBHbkvwAO6h0WIz7z0YvttVD5OyjYQ4OyMkcv2JcSBvAs7NGvWUTUPzEKh+G
         axQC+RdDRziGu49M1oWg/uWBoeDat+eXpo4zCf3iJYG9pl3+eRt9HslNPgjvZ/0VNXF4
         kYmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vuIHq6NfJZ8B7T/6h/z7Wvmf5fj4Ed9Aszj3ylocewY=;
        b=GoEj9pnkGRrLD/PU1NVxiGpm36w6z45HltreySuZWj6VDPg8HMksUR2ppybmFZVMfr
         c/aMuplliKh0od/iKLaBqPG+uRhJt98ujqOHNgoKFMGJl2Tg3X8TSObBjxKhobhHO4q5
         nTY8HxAN3xWqbMfNArNDdGXuWMjeW3hB8ofw2E+MOIEVB0uBx9G4aSnY2Z4ZGXJjVKIa
         sIR737uF5zdp9SfCQaDPWeSlfS0BWyg6aZvGONvm0jgXKGoos2/ZnV1+SDAtcUnApVSi
         IXYxAf2bLH+aEpHqJkc85oJvOny0Z2IVS1iRS5SZ/fFju9PWJpGeuITz8ISknQy9NqhJ
         wMRA==
X-Gm-Message-State: APjAAAWUIeG8jii3/75oz/Yz216vCGukvgn6D93ArhKQQHn1dmeYvugc
        l55jS/pmchQ0N0QkOZfEVSzJZnNc
X-Google-Smtp-Source: APXvYqzmIaId433mZZFEaKtICaLNwP/Xbf6EhGLfCi+U7iJXR4paNUmXqDVeRtGyMpZyU4ophcsRFw==
X-Received: by 2002:a17:902:a606:: with SMTP id u6mr1792292plq.224.1565827066388;
        Wed, 14 Aug 2019 16:57:46 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k22sm987299pfk.157.2019.08.14.16.57.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 14 Aug 2019 16:57:46 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 31/42] lpfc: Fix reported physical link speed on a disabled trunked link
Date:   Wed, 14 Aug 2019 16:57:01 -0700
Message-Id: <20190814235712.4487-32-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190814235712.4487-1-jsmart2021@gmail.com>
References: <20190814235712.4487-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

GetTrunkInfo is displaying an incorrect link speed when the link is
a trunk and the link has gone down.  The driver is not clearing the
logical speed as part of the link down transition.

Fix by setting the logical speed to UNKNOWN SPEED when the link goes
down.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 44e779e4c885..95db23adc96d 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -905,6 +905,8 @@ lpfc_linkdown(struct lpfc_hba *phba)
 			phba->trunk_link.link1.state = 0;
 			phba->trunk_link.link2.state = 0;
 			phba->trunk_link.link3.state = 0;
+			phba->sli4_hba.link_state.logical_speed =
+						LPFC_LINK_SPEED_UNKNOWN;
 		}
 		spin_lock_irq(shost->host_lock);
 		phba->pport->fc_flag &= ~FC_LBIT;
-- 
2.13.7

