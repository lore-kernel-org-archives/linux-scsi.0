Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A54B1C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:46:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FB34600D4
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:46:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240950AbhJGUsx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:48:53 -0400
Received: from mail-pj1-f47.google.com ([209.85.216.47]:45760 "EHLO
        mail-pj1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234546AbhJGUsv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:48:51 -0400
Received: by mail-pj1-f47.google.com with SMTP id ls14-20020a17090b350e00b001a00e2251c8so6120421pjb.4
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:46:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+v5ujaNJjXmcRXqt0UqZBXyj/iRiPSi6W3kLWeZdqW4=;
        b=Yh1Id2BlonwAfwBGCAMfgF7vhkw7e9wBiWqkmc0vygLxFXYEO1kIlS2zw13NICvOZU
         Qa7i1q8t0YttOV/B/k94cgq5dFghVZmDNoDoFrXL28onp0+R7bAk31kMu9S2rzV3LpJZ
         dffOpakhLte1HgE9K7nL+EUKGrSQu3fbA0C09PnOd3W+uPl7OiPX0YkPcoyY+t5092nh
         fMphl1/SE4/xHYa0Qh/0419Y6C1GYShPeQtSgTexLHqmsRcg+a5fDeNmXpRPWQgvuHfS
         DwwKh+gox2YKUxYZNVfs66rHbUxZoaGfe1Q8DsNkVulU40ezkq+JTRn+kUqR1/qZDVYi
         iuDQ==
X-Gm-Message-State: AOAM533LYvahbkpfUuEh5MYDBYDSwiVzn7+oTioMD79hpQx2W7NCEqOC
        VWixwdzmMhRg6qMFWUTOm9NxHPSJ61DaMg==
X-Google-Smtp-Source: ABdhPJyB02CWpGSRbuZq/fONtC9ZkY5062mfIvO0n0jUkx1ivYDeDjmO+RCqSCZA5q11g27vwVszXg==
X-Received: by 2002:a17:90a:db51:: with SMTP id u17mr2128242pjx.171.1633639617406;
        Thu, 07 Oct 2021 13:46:57 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id 17sm280831pfh.216.2021.10.07.13.46.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:46:56 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Bean Huo <beanhuo@micron.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Mike Christie <michael.christie@oracle.com>,
        Finn Thain <fthain@linux-m68k.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Colin Ian King <colin.king@canonical.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Hannes Reinecke <hare@suse.de>
Subject: [PATCH v3 83/88] target/tcm_loop: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:46:09 -0700
Message-Id: <20211007204618.2196847-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211007202923.2174984-1-bvanassche@acm.org>
References: <20211007202923.2174984-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/target/loopback/tcm_loop.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 52db28d868d5..4407b56aa6d1 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -71,7 +71,7 @@ static void tcm_loop_release_cmd(struct se_cmd *se_cmd)
 	if (se_cmd->se_cmd_flags & SCF_SCSI_TMR_CDB)
 		kmem_cache_free(tcm_loop_cmd_cache, tl_cmd);
 	else
-		sc->scsi_done(sc);
+		scsi_done(sc);
 }
 
 static int tcm_loop_show_info(struct seq_file *m, struct Scsi_Host *host)
@@ -165,7 +165,7 @@ static void tcm_loop_target_queue_cmd(struct tcm_loop_cmd *tl_cmd)
 	return;
 
 out_done:
-	sc->scsi_done(sc);
+	scsi_done(sc);
 }
 
 /*
