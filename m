Return-Path: <SRS0=+pba=Z2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58D4BC432C3
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Dec 2019 01:05:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 284B921556
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Dec 2019 01:05:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qTO+I90c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbfLDBFC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Dec 2019 20:05:02 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36980 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbfLDBFC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Dec 2019 20:05:02 -0500
Received: by mail-wm1-f67.google.com with SMTP id f129so6064213wmf.2;
        Tue, 03 Dec 2019 17:05:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=d1Atz/XejS8mWz5qCtXz1nNzHlSaf2idDPU/vTS2lvc=;
        b=qTO+I90cj6g2LDEoq+53RmUOc+wQ/rvg8PCvxoHV/TKq/hlqinkmZfUVAMsUl+DbLv
         AnyiF2eu9+uVXR+D9oUO4RmCqVifaN393leL3CJtlptPcnwUSYtujZnr1a+kCtreEywP
         qHMvhQDKXBdNuCnVB8edTw+DGIKfcZfx64rYX8EMn7+3+vBKd+kUaJ1Qmw22kmmYrCxB
         y2fsGhkJTNl5m1BhmLI5KzQFhYz4TckDHwV3DTKT/CwWiom+Cje3/R6Pc1elKP0cKZiY
         NIUSrWTlJuy7x3t4PRjvXiy96BAGAUtt+7FZPawHB5ci7LHowVENZyhw87lQziArxQJL
         DNqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=d1Atz/XejS8mWz5qCtXz1nNzHlSaf2idDPU/vTS2lvc=;
        b=o6gWIZ1mu0Y5Qt3TmsiBdCcWZguD5pCRxNlOtXswfQoQOtdIDwKcVcXrKh/XoxgQc9
         EOhs2H8Yxh8J65YFC5d7KVCopJ7sutDbfSM8DmSzYwxy5/2W7jfPfNeccfviJsJmfBVz
         GKZ98ZmzwMuDXcYO+aldD5yYRI5H2aL04LL2Xajsh2FPOPQsVfVOSaZY7Zk/O7VHqstV
         XmKdRK19RGpvPNUJzoLUClabe7zNjKlB7Be+GrZAYfooNo3WAsznVkDX3wAkv4X6eu2G
         G9IWqHsIgl3clJFFgLf0cohAP00YaFLXNVaqqKBZ96RaoKIuElWX0GCf+5bDN8OQrn+M
         lViw==
X-Gm-Message-State: APjAAAX7scsm/3+/QJsB5Gg09L/m6VqZ+J26m/q/q7pZpCKqXUka1EP4
        YMyFLVZ3t80AngF6vtsYud8=
X-Google-Smtp-Source: APXvYqwY7LkfIYy5X6aBfUL4S1sCgNiiFrCxqm6rBAL3vy0LiScxFGOA/y8y1n7bKj3egRD5VfOyxA==
X-Received: by 2002:a7b:c778:: with SMTP id x24mr22192300wmk.119.1575421500392;
        Tue, 03 Dec 2019 17:05:00 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfdc6.dynamic.kabel-deutschland.de. [95.91.253.198])
        by smtp.gmail.com with ESMTPSA id y139sm5072161wmd.24.2019.12.03.17.04.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 17:04:59 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        pedrom.sousa@synopsys.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: ufs: delete unsued structure filed tc
Date:   Wed,  4 Dec 2019 02:04:14 +0100
Message-Id: <20191204010414.3776-1-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Delete unused structure field tc in structure utp_upiu_req, since no person
uses it for task management.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 include/uapi/scsi/scsi_bsg_ufs.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/uapi/scsi/scsi_bsg_ufs.h b/include/uapi/scsi/scsi_bsg_ufs.h
index 9988db6ad244..d55f2176dfd4 100644
--- a/include/uapi/scsi/scsi_bsg_ufs.h
+++ b/include/uapi/scsi/scsi_bsg_ufs.h
@@ -68,14 +68,13 @@ struct utp_upiu_cmd {
  * @header:UPIU header structure DW-0 to DW-2
  * @sc: fields structure for scsi command DW-3 to DW-7
  * @qr: fields structure for query request DW-3 to DW-7
+ * @uc: use utp_upiu_query to host the 4 dwords of uic command
  */
 struct utp_upiu_req {
 	struct utp_upiu_header header;
 	union {
 		struct utp_upiu_cmd		sc;
 		struct utp_upiu_query		qr;
-		struct utp_upiu_query		tr;
-		/* use utp_upiu_query to host the 4 dwords of uic command */
 		struct utp_upiu_query		uc;
 	};
 };
-- 
2.17.1

