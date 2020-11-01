Return-Path: <SRS0=rQSi=EH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90216C2D0A3
	for <linux-scsi@archiver.kernel.org>; Sun,  1 Nov 2020 14:38:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41E7622242
	for <linux-scsi@archiver.kernel.org>; Sun,  1 Nov 2020 14:38:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GyPNeg6E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbgKAOiW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 1 Nov 2020 09:38:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47307 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726480AbgKAOiV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Nov 2020 09:38:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604241500;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=yF2H9VamO/Tll8pOx08HeoHBpSFSmObT+cyhnQuDOz0=;
        b=GyPNeg6EnPEwRVgmyP/NMf3DW2DXI7ClQ0AhGc8aGUVTztYgI4dOgpFLkpNKuxP1NCFDRH
        TzChYzBZR91g22nmIOyeAubxcpVQq0DoKfHSEp0bqFGyXhYd6GGgtWVBiDLegSWrBYad9j
        0FRiWaM5xvdfWPtFjXszPvdM/7/Dtjk=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-75-RQwb1r2fOJmxG5QizKY6nw-1; Sun, 01 Nov 2020 09:38:18 -0500
X-MC-Unique: RQwb1r2fOJmxG5QizKY6nw-1
Received: by mail-ot1-f71.google.com with SMTP id g51so5152856otg.9
        for <linux-scsi@vger.kernel.org>; Sun, 01 Nov 2020 06:38:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=yF2H9VamO/Tll8pOx08HeoHBpSFSmObT+cyhnQuDOz0=;
        b=BEhCZ2OUblcbKRWiDqoNlszfgMFs9v4Jt9g+qZfy3jSYyCXJki16eDIMBrbnol/Pt8
         l5bYjppp5hArBOwiTT5zWxMr/WO50DJMY7zlSPEENUqE0sQYYsNfZePfh5uQXb4Wp/xq
         +b0LjKSuvD4Hj/pffn08BkTRvWgBtYUIn8hJVuD+QEq6w8qh7Pjs+mHs6rRoVlNLg9Q5
         IuXHnu7mnWhmoPGkhI2qzdep3+lZwdSXD2YIp62wamIBJrHnPf/Ru8Tosj/nPG9MTiPh
         Ukj1ZqMkjvGIFFJAmAiBveM06i2/Vm3/a0kCKuDicbbzvsltQ+o7SwzCRWFVODR6hA4E
         uL6Q==
X-Gm-Message-State: AOAM531prHrET/3BDcgcx6UbJVk9BffsojvHjbxxRNRyJv+Yy2vjZlmw
        Ie+JYaUvQ8yRq09geVUflFujR5Gq1WLBLkmbXodndoQwao7TSxB9RCQ9PphWWL3lbu8i0p675tq
        SVTXEpWQBa8LSnOiquLKo0g==
X-Received: by 2002:a54:449a:: with SMTP id v26mr7513062oiv.16.1604241498104;
        Sun, 01 Nov 2020 06:38:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzjTxqUzVJc18z2qTLQHnlRYFXx4YOeCh/Q5B8AiiSjFkMZ4gTWY/eZUlhjTV66TdCgE7+1mw==
X-Received: by 2002:a54:449a:: with SMTP id v26mr7513049oiv.16.1604241497934;
        Sun, 01 Nov 2020 06:38:17 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id p10sm2876495oig.37.2020.11.01.06.38.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2020 06:38:17 -0800 (PST)
From:   trix@redhat.com
To:     skashyap@marvell.com, jhasan@marvell.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tom Rix <trix@redhat.com>
Subject: [PATCH] scsi: bnx2fc: remove unneeded semicolon
Date:   Sun,  1 Nov 2020 06:38:12 -0800
Message-Id: <20201101143812.2283642-1-trix@redhat.com>
X-Mailer: git-send-email 2.18.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Tom Rix <trix@redhat.com>

A semicolon is not needed after a switch statement.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 6890bbe04a8c..a436adb6092d 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -2275,7 +2275,7 @@ static int bnx2fc_ctlr_enabled(struct fcoe_ctlr_device *cdev)
 	case FCOE_CTLR_UNUSED:
 	default:
 		return -ENOTSUPP;
-	};
+	}
 }
 
 enum bnx2fc_create_link_state {
-- 
2.18.1

