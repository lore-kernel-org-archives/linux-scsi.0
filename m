Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6000DC433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Nov 2021 23:29:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FC5C60F3A
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Nov 2021 23:29:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbhKAXbe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Nov 2021 19:31:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230505AbhKAXbd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Nov 2021 19:31:33 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32D72C061714
        for <linux-scsi@vger.kernel.org>; Mon,  1 Nov 2021 16:29:00 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id s39-20020a056a0017a700b00481146e614cso1937682pfg.9
        for <linux-scsi@vger.kernel.org>; Mon, 01 Nov 2021 16:29:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=0AzsJhkimlVDnNzRhtFh4NkjiXk28BcHhpgCYuiZin0=;
        b=ozeXM+T7SJ4DUqmCdgy9l7pF9jMFQhafE3KZ2lthJCAKmH0UGsptWzxVkcp0Z9xaUK
         goQbEaPXVuTO9IVrQnKsSMJXP2DrVszIQGMwBrKX0JYkTZS/wYUm1EfyJ+uPcFUtC0pi
         zIzgosaM8X3qevG2llp8W3EBPWpXCFEQVWhqhdu72wlh0bsjd0nVfQJ3cbaDDrnqq5cy
         XiKTCTky0JuDUDPbbMJWbJgUNTHzRGxfHYkeRb2rwCgbuqf2KgFmbHsaeI8WxT3F4HGe
         z9WJovvE3+GZ6DQeD6qVgCGbCpHF7WDuxFVcyN6pfMp43Ac6ToZp2Bm/H+1JYIvTQBOF
         Cdlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=0AzsJhkimlVDnNzRhtFh4NkjiXk28BcHhpgCYuiZin0=;
        b=TPQ6cuOxgAvnk0mE1GS+TpTX3+iaMADZXUuoSC6lhLnXNhyf8kkW5eSvkYW1rd8any
         tCYiJIllvTo2D2iypG6xo+mbR+ZvXvFIPmS1RXMB+zrEHDxviGjHU6cw2o/2E6gCT8AE
         4oboOdUW8YRSD4wXPX8sbEnvVIzFnhZIxnfMk+dyR4rw8vOAJs4oIvtx9v6ox0fSrRQr
         1gDJECReKPWZ8XBnDXNgjK77UtoBOo9r+bCOEzCW1N1Z7eC6UTL0txl78OqZ+8kgMBhP
         IgZb42VM5eFUnj1y2aW9c4SWfSeeWvLZdvmknNeD5p/UahWXzUAX3r5T36OMqkjPlx0A
         O0eQ==
X-Gm-Message-State: AOAM532tn/mbAjaOkbxWd5aO58+6HRFZe8kDOUQp8xtRBavC78Y4jg42
        /UqgfI+RMV8FWo01RsovQCTSJeqUQL8lBA==
X-Google-Smtp-Source: ABdhPJx5wSSNdtJdIO6p/I3bSO1QkKyuJik+9A9q/4/1BKvIeW18UQSFYeza9tUX4tlRky4kR6bbAziY9iiUpQ==
X-Received: from ipylypiv.svl.corp.google.com ([2620:15c:2c5:11:3684:4dd2:e6b6:ef66])
 (user=ipylypiv job=sendgmr) by 2002:a17:902:b697:b0:141:c7aa:e10f with SMTP
 id c23-20020a170902b69700b00141c7aae10fmr15248873pls.18.1635809339684; Mon,
 01 Nov 2021 16:28:59 -0700 (PDT)
Date:   Mon,  1 Nov 2021 16:28:24 -0700
In-Reply-To: <20211101232825.2350233-1-ipylypiv@google.com>
Message-Id: <20211101232825.2350233-4-ipylypiv@google.com>
Mime-Version: 1.0
References: <20211101232825.2350233-1-ipylypiv@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH 3/4] scsi: pm80xx: Update WARN_ON check in pm8001_mpi_build_cmd()
From:   Igor Pylypiv <ipylypiv@google.com>
To:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Vishakha Channapattan <vishakhavc@google.com>,
        Changyuan Lyu <changyuanl@google.com>,
        linux-scsi@vger.kernel.org, Igor Pylypiv <ipylypiv@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Starting from commit 05c6c029a44d9 ("scsi: pm80xx: Increase number of
supported queues") driver initializes only max_q_num queues.
Do not use an invalid queue if the WARN_ON condition is true.

Fixes: 7640e1eb8c5de ("scsi: pm80xx: Make mpi_build_cmd locking consistent")
Reviewed-by: Vishakha Channapattan <vishakhavc@google.com>
Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 1a593f2b2c87..3d41f0ac6595 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -1325,7 +1325,9 @@ int pm8001_mpi_build_cmd(struct pm8001_hba_info *pm8001_ha,
 	int q_index = circularQ - pm8001_ha->inbnd_q_tbl;
 	int rv;
 
-	WARN_ON(q_index >= PM8001_MAX_INB_NUM);
+	if (WARN_ON(q_index >= pm8001_ha->max_q_num))
+		return -EINVAL;
+
 	spin_lock_irqsave(&circularQ->iq_lock, flags);
 	rv = pm8001_mpi_msg_free_get(circularQ, pm8001_ha->iomb_size,
 			&pMessage);
-- 
2.33.1.1089.g2158813163f-goog

