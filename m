Return-Path: <SRS0=Mkh6=3G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42485C33CB1
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 13:40:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1761F20661
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 13:40:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rfGNejPU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbgAQNkm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jan 2020 08:40:42 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:52866 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726936AbgAQNkm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jan 2020 08:40:42 -0500
Received: by mail-pj1-f65.google.com with SMTP id a6so3198284pjh.2;
        Fri, 17 Jan 2020 05:40:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zXrfRGNxYaptzdQKW3ruvzzoYeLM85KhG9IY8/I3S9U=;
        b=rfGNejPUGagicxyRLxw219tfyG1rWkQUrCufiG/ctiahenXe6veGihg1afmK6k7fRD
         HjqzJaOuJ0cZ6hKv3Q5dvTsOriNgi8CIf/dgIVfu4BhSVCc2HZ9V60/zQsrrgSkcmz45
         GcHb1sAPN64xCEuHl7nh+/9hTJb96sQSxucahqnXOpNARYiyaLf1D3CqGoS9WEPEVkET
         41z4H4Oyb2K3667qt8ZT9nZ57LL0FO7wz0DeeIqHFKrOEyAlD9B2Grv1xe/2VgS9Eh0P
         97smQtjSUd8uig9i+qSUvCEs6W8DyR8J9ssHB1sy8crxrcxJbrntR6P7NpYBVeKUJGqn
         cruw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zXrfRGNxYaptzdQKW3ruvzzoYeLM85KhG9IY8/I3S9U=;
        b=fdVuEuHX4Qum4YnYjXpzyiKqMPxxWB2U7tw0l4D2Ool/diLc8WJi8I38NwbbYoqEOE
         TC6vQ2Hh+wd8saFEYAkbutqUQ6yT1v5TIpm/gi2aMgTYk7PCK92g6fQkbNiHzcfnXR/p
         KVrRF4qe1TtSL2hFg491ISADkZw+i7vEy/IMSHz1qrZrjpQdJUXcQD0OKBbmwd8oWgqE
         EPaLdQ1gz07IuCmvKg8NJMlZTaVlIue/yGYN+dbbUgF1LqzawGZtui2a+2rl9HMuYJLv
         zAAYw5wzwc7lCT/eyV1ZHSDuwwUfThpIR5wBeDjyEJOxRL5IVgYvx1t6yJc1PYup3VE+
         leIw==
X-Gm-Message-State: APjAAAXCNeJOstHAIZzxYRy9Gm/Pf5AEx2QZ3ftz1jEg78DoUQ5W4koQ
        tsbFCExVwMf3QX5J7UJKCZo=
X-Google-Smtp-Source: APXvYqyVc05WyoVE5bUoLutO0bBZRHMtNK98gCIWNtZTIBNQWPX3L9VS2Qlm+6mjOLaR241hPcn+/g==
X-Received: by 2002:a17:902:d915:: with SMTP id c21mr38236848plz.295.1579268441647;
        Fri, 17 Jan 2020 05:40:41 -0800 (PST)
Received: from localhost.localdomain ([103.211.17.168])
        by smtp.googlemail.com with ESMTPSA id s18sm29522422pfh.179.2020.01.17.05.40.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2020 05:40:41 -0800 (PST)
From:   Amol Grover <frextrite@gmail.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Joel Fernandes <joel@joelfernandes.org>,
        Madhuparna Bhowmik <madhuparnabhowmik04@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Amol Grover <frextrite@gmail.com>
Subject: [PATCH v3 2/3] drivers: target: target_core_tpg: Pass lockdep expression to RCU lists
Date:   Fri, 17 Jan 2020 19:08:55 +0530
Message-Id: <20200117133854.32550-2-frextrite@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200117133854.32550-1-frextrite@gmail.com>
References: <20200117133854.32550-1-frextrite@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

tpg->tpg_lun_hlist is traversed with hlist_for_each_entry_rcu
outside an RCU read-side critical section but under the
protection of tpg->tpg_lun_mutex.

Hence, add the corresponding lockdep expression to the list traversal
primitive to silence false-positive lockdep warnings, and
harden RCU lists.

Signed-off-by: Amol Grover <frextrite@gmail.com>
---
 drivers/target/target_core_tpg.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index d24e0a3ba3ff..7aa0240a7948 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -110,7 +110,8 @@ void core_tpg_add_node_to_devs(
 	struct se_device *dev;
 
 	mutex_lock(&tpg->tpg_lun_mutex);
-	hlist_for_each_entry_rcu(lun, &tpg->tpg_lun_hlist, link) {
+	hlist_for_each_entry_rcu(lun, &tpg->tpg_lun_hlist, link,
+				 lockdep_is_held(&tpg->tpg_lun_mutex)) {
 		if (lun_orig && lun != lun_orig)
 			continue;
 
-- 
2.24.1

