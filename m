Return-Path: <SRS0=XSNP=53=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 129F6C2D0EC
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Apr 2020 00:20:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAFE621744
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Apr 2020 00:20:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="r8orfjhL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbgDKAUZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Apr 2020 20:20:25 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42377 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726883AbgDKAUW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Apr 2020 20:20:22 -0400
Received: by mail-wr1-f65.google.com with SMTP id j2so4044273wrs.9;
        Fri, 10 Apr 2020 17:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O9b/dTxnP3pkeLImyemjxWnk87nyS0C4fdjH2jH+qHw=;
        b=r8orfjhLMG/0hza2PWsZbyXhxiI18aYNRYCiWCP3avl3+kWwYhU6WIynlaL32lngM8
         rwvIPYHj8nGKDnBUMPFH5PeuVdQVH0K/kuEqF4p8vxsVa6nFUbPfTCq/cZTSxACqkTDa
         MKxV00rU2M47GA8geQ5cgHQ11cP9RB9p8onGYJn5jKUNoesoVDKo/MuIMIxu5X8WMT7Z
         0kmT929SWRrhJXPLNkvTe5t/MrS0n51PXLy8XCXNoKyWb3EDxPpoDsMgFy7xc4AE98LD
         6phlWSo/2v+AL4Tkmery3vBqxs1zCsUacH4QYL8fmEAknchGfGZqQj9NnTua8eKI3hhh
         DSrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O9b/dTxnP3pkeLImyemjxWnk87nyS0C4fdjH2jH+qHw=;
        b=gTbNDVm/4t4K/18/vllUmRcK6zyUAqz4Ukd3jsnHYymGuHekmARIftE1AQouwwAo6Y
         G/ec+armXkHyo8t4D7BgancRqnm2hyE/k9GJlsYfJXCsW8DkuMJO0s3Euj9uFz/t+xpy
         8MIXxSap8nRoapwAaGspczl7LSW1LcJ54XoN3MqsNkvw+ldnqhP8U30QZ7NwqdMGtAqL
         2oNPR3vba5FigiEHjNko1ObA2TkoF0BZdO/bcbx5LSXgacX+V7LyEy/Kere+UwrxN9lv
         kLHy++u2eeCeIxX/qh/hJpA0a6DwL4c8Um4LSfiyaakZ9dA6DPEgAoKIIvUK6ysBg7lZ
         B6lg==
X-Gm-Message-State: AGi0PubozMdL5RwUatTDZ4n9N6IbmaDLuazCu/6k/F+m4YsGSTm4C12v
        GTWavYWpAJlWIKh9eYEeMoFk+Y2Cfjus
X-Google-Smtp-Source: APiQypIja6lxbNGo6M+D5FXZavVLgNGpXfZDMZy5KKEVg59S4vkiTctDAOl6HJz1UyArTsPqoEUTpA==
X-Received: by 2002:a5d:4290:: with SMTP id k16mr6810714wrq.406.1586564421205;
        Fri, 10 Apr 2020 17:20:21 -0700 (PDT)
Received: from ninjahost.lan (host-2-102-14-153.as13285.net. [2.102.14.153])
        by smtp.gmail.com with ESMTPSA id b191sm5091594wmd.39.2020.04.10.17.20.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2020 17:20:20 -0700 (PDT)
From:   Jules Irenge <jbi.octave@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     boqun.feng@gmail.com,
        QLogic-Storage-Upstream@qlogic.com (supporter:BROADCOM BNX2FC 10
        GIGABIT FCOE DRIVER), "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org (open list:BROADCOM BNX2FC 10 GIGABIT FCOE
        DRIVER)
Subject: [PATCH 7/9] scsi: bnx2fc: Add missing annotation for bnx2fc_abts_cleanup()
Date:   Sat, 11 Apr 2020 01:19:31 +0100
Message-Id: <20200411001933.10072-8-jbi.octave@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200411001933.10072-1-jbi.octave@gmail.com>
References: <0/9>
 <20200411001933.10072-1-jbi.octave@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Sparse reports a warning at bnx2fc_abts_cleanup()

warning: context imbalance in bnx2fc_abts_cleanup() - unexpected unlock

The root cause is the missing annotation at bnx2fc_abts_cleanup()

Add the missing  __must_hold(&tgt->tgt_lock) annotation

Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
---
 drivers/scsi/bnx2fc/bnx2fc_io.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 4c8122a82322..b45f40db9379 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1081,6 +1081,7 @@ int bnx2fc_eh_device_reset(struct scsi_cmnd *sc_cmd)
 }
 
 static int bnx2fc_abts_cleanup(struct bnx2fc_cmd *io_req)
+	__must_hold(&tgt->tgt_lock)
 {
 	struct bnx2fc_rport *tgt = io_req->tgt;
 	unsigned int time_left;
-- 
2.24.1

