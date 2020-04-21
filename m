Return-Path: <SRS0=Tsb4=6F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8840EC54FCC
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 21:15:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 555E320724
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 21:15:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=umn.edu header.i=@umn.edu header.b="AvoLb6Ie"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbgDUVPE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Apr 2020 17:15:04 -0400
Received: from mta-p6.oit.umn.edu ([134.84.196.206]:54482 "EHLO
        mta-p6.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726012AbgDUVPD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Apr 2020 17:15:03 -0400
X-Greylist: delayed 359 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Apr 2020 17:15:03 EDT
Received: from localhost (unknown [127.0.0.1])
        by mta-p6.oit.umn.edu (Postfix) with ESMTP id 496GQR4Zzlz9vJyC
        for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2020 21:09:03 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p6.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p6.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id O3es5mbsrvaG for <linux-scsi@vger.kernel.org>;
        Tue, 21 Apr 2020 16:09:03 -0500 (CDT)
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p6.oit.umn.edu (Postfix) with ESMTPS id 496GQR3S1Yz9vJy3
        for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2020 16:09:03 -0500 (CDT)
Received: by mail-qk1-f197.google.com with SMTP id x8so323037qkf.3
        for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2020 14:09:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=W230/sPUtrSZ9ChaTDlVXjpS2KjEcvhlwm/p53ONQvg=;
        b=AvoLb6Ieal43ACfvqYH880cV9d+xFvKYLVpWPUEur08gn0owG/q4oVdMu9+JKefMRS
         qrvwUh9FamMtxKj8hXcp7iEUpZj1An04ckZ0PoOu/yUEQsc7lI7fxZE0srTFziyx4J9r
         FM6gLG/9OfV+CTlEMPlz5MkjxuTABowbbbEzDgOTksvQbcNN8de/wFYlxHhi6OO00G4Q
         st+P3/lxaXPyitgwiOXxbCBYQsJINtOBs975NKt/pSGDB7wD/ZXHelWF63B68Ro6KcC3
         oa03+fLq2hcxZHOW76sXjtOGhypo4mGKv9smNuAYCZMtu80DwYfpsxJP4khssv4bvXJS
         Pl2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=W230/sPUtrSZ9ChaTDlVXjpS2KjEcvhlwm/p53ONQvg=;
        b=II/grmBqs/Ky43vQiZDJ0lSQZ4KP01ZC648gwfMbbNd83ThlUcg0dylqX71eDVseO5
         auUc0c7k740GQd/1yyTCwERi5J4wueQSouOAOwtAqGrP9gWdljwGK4AxG1+4mZ2zc01E
         2SIyKptB3vl1LgY2u+ZcD8WpBVWD2C6/7MKVq6B+i7apCj7MnzVie9r7vIUAonPVJ8X3
         WX7WHhNitpS9qPmsxcO+7ivxY+2XyAUN+wpJ+k9wbdFG0Cg2SsE52voctGHdOvS7oJ/f
         CCACnAQIRQUNgrDfWPgtcQBHGDpH+8fc/qUZ46NP9/TNBfcpIDjWXNojSqP5zbHslSLT
         9cCg==
X-Gm-Message-State: AGi0PuYeoq0zQCWjO7P2sWcaXmFXx2mE9nbpEpzSbWQFeTuKqfyh6urf
        FTVUur9+s6w7xekzzaqhmi+IDOuqMXKk8sgx2a9H7daz3XnsmhOxzMYnaNZL1wirrFTDyHx9/VB
        CyfxGh865NPF1epq+ecLV9G9+vA==
X-Received: by 2002:aed:2ac4:: with SMTP id t62mr23981531qtd.381.1587503342773;
        Tue, 21 Apr 2020 14:09:02 -0700 (PDT)
X-Google-Smtp-Source: APiQypLdR3F1Di5Dew+F3+Kr/c7o2DI0FiW0dSLJ1NG40UhZMsxQKBkOwhJHe3/Hmrcpl4D4OAcL0Q==
X-Received: by 2002:aed:2ac4:: with SMTP id t62mr23981500qtd.381.1587503342361;
        Tue, 21 Apr 2020 14:09:02 -0700 (PDT)
Received: from qiushi.dtc.umn.edu (cs-kh5248-02-umh.cs.umn.edu. [128.101.106.4])
        by smtp.gmail.com with ESMTPSA id z40sm2641551qtj.45.2020.04.21.14.08.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 14:08:37 -0700 (PDT)
From:   wu000273@umn.edu
To:     jejb@linux.ibm.com
Cc:     QLogic-Storage-Upstream@qlogic.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kjlu@umn.edu, wu000273@umn.edu
Subject: [PATCH] scsi: qla4xxx: Fix a potential race condition.
Date:   Tue, 21 Apr 2020 16:08:22 -0500
Message-Id: <20200421210822.18994-1-wu000273@umn.edu>
X-Mailer: git-send-email 2.17.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Qiushi Wu <wu000273@umn.edu>

In the function qla4xxx_eh_abort, we should use lock protect both
kref_get() and kref_put(), because we must serialize access where a
kref_put() cannot occur during the kref_get(). Otherwise, the object
"srb" may not remain valid during the kref_get(), and a race condition
can happen.

Signed-off-by: Qiushi Wu <wu000273@umn.edu>
---
 drivers/scsi/qla4xxx/ql4_os.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 5504ab11decc..a1400cadb91a 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -9222,8 +9222,10 @@ static int qla4xxx_eh_abort(struct scsi_cmnd *cmd)
 		    ha->host_no, id, lun));
 		wait = 1;
 	}
-
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
 	kref_put(&srb->srb_ref, qla4xxx_srb_compl);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	/* Wait for command to complete */
 	if (wait) {
-- 
2.17.1

