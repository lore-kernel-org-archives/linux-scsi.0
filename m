Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 746F1CA9ED3
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 00:57:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4943F20717
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 00:57:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NmCivw7e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729789AbfKEA50 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 19:57:26 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44057 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728602AbfKEA5Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Nov 2019 19:57:25 -0500
Received: by mail-wr1-f68.google.com with SMTP id f2so10369838wrs.11
        for <linux-scsi@vger.kernel.org>; Mon, 04 Nov 2019 16:57:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VSiHvgU21MYmgnby89YYU5aZvPtnScGTfhY7GhIfITo=;
        b=NmCivw7e7Ic9yOXTjQfJbx7D314X6V2lH9Rx2ZpPPpSa3+FGANk4oNY5rAiJIEiBgr
         ey9LVeMBzH/1Ol1G65YRwVdRMT34LnUmWO8ig0sknNHpUfK9kfEAHYclSOWMchssRfGn
         H+/rua7x2V2mAYI7HicACPQTShfkra/1fRS6MjDddPz5AhaXomiJADeJfHb6cvWo1gVZ
         D86rlh5hRqZhVqsKo58XznN4HynxJLuEE6O4F7THO7HlZrG4upIbDeyxHbBluPUh1Y53
         ZtulLkC9oK9UqyJkPNOguJOjjL3lXrNQ2qf4Fd9C5Ltdh1rdv7OtSxp7AXYishoZTFWb
         qPpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VSiHvgU21MYmgnby89YYU5aZvPtnScGTfhY7GhIfITo=;
        b=Yiaj+a4m+9FcvDMa9m9FTZ5Ves36UIoUiywg7cRjxViiFXr5zEkjeXECfH0RCsXHX2
         cHdcBkEk0/Vo6w5tBJ3gYE6CQvFgHF42SRNevhRk2Lohvn7rfgMhhdOoWyHxT7dACUyU
         PGuWgw4qBqZFm+QUoM2BXb2MwlHy7keCopAGPBN97JBkBbUUGZUbwMc1Vj2Wl7J6i/FN
         IEiT6+rnWVW4CeULoIMVdfIOuAFJm5szxbcW49A9qOhnrCUgLzEC+hGCMjn1YhEKPiGw
         ji+gq3qXnbl+h5iRYBULD0aP8m/qXZrXrEdW6gBfsz6UD6Ye4ZVQI2wOmG9PD5ElAS+7
         UyPA==
X-Gm-Message-State: APjAAAUhXH4EtieZetde9S85CLKROofDysREAR/HqXk+/P9dHweqMlYK
        95cwu0HKuSZF1H4/xqN0YcZwNyZm1p4=
X-Google-Smtp-Source: APXvYqwWF6ZQBN8Qf9QIee2NAAaeKcu295kK/qQhj0VHu37T44eDV1LOd4dNOGre2VHn1+PntZroMw==
X-Received: by 2002:a05:6000:128c:: with SMTP id f12mr27547830wrx.279.1572915442452;
        Mon, 04 Nov 2019 16:57:22 -0800 (PST)
Received: from pallmd1.broadcom.com ([192.19.224.250])
        by smtp.gmail.com with ESMTPSA id g5sm16920991wma.43.2019.11.04.16.57.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 04 Nov 2019 16:57:22 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 01/11] lpfc: Fix duplicate unreg_rpi error in port offline flow
Date:   Mon,  4 Nov 2019 16:56:58 -0800
Message-Id: <20191105005708.7399-2-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191105005708.7399-1-jsmart2021@gmail.com>
References: <20191105005708.7399-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If the driver receives a login that is later then LOGO'd by the remote
port (aka ndlp), the driver, upon the completion of the LOGO ACC
transmission, the will logout the node and unregister the rpi that is
being used for the node.  As part of the unreg, the node's rpi
value is replaced by the LPFC_RPI_ALLOC_ERROR value.  If the port is
subsequently offlined, the offline walks the nodes and ensures they
are logged out, which possibly entails unreg'ing their rpi values.
This path does not validate the nodes rpi value, thus doesn't detect that
it has been unreg'd already.  The replaced rpi value is then used when
accessing the rpi bitmask array which tracks active rpi values.
As the LPFC_RPI_ALLOC_ERROR value is not a valid index for the bitmask,
it may fault the system.

Revise the rpi release code to detect when the rpi value is the replaced
RPI_ALLOC_ERROR value and ignore further release steps.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 294f041961a8..660f96218b25 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -18247,6 +18247,13 @@ lpfc_sli4_alloc_rpi(struct lpfc_hba *phba)
 static void
 __lpfc_sli4_free_rpi(struct lpfc_hba *phba, int rpi)
 {
+	/*
+	 * if the rpi value indicates a prior unreg has already
+	 * been done, skip the unreg.
+	 */
+	if (rpi == LPFC_RPI_ALLOC_ERROR)
+		return;
+
 	if (test_and_clear_bit(rpi, phba->sli4_hba.rpi_bmask)) {
 		phba->sli4_hba.rpi_count--;
 		phba->sli4_hba.max_cfg_param.rpi_used--;
-- 
2.13.7

