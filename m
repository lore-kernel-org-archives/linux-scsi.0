Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00AE2C7619A
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Mar 2023 20:35:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbjC3Ufi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Mar 2023 16:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbjC3Ufh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Mar 2023 16:35:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03C295243
        for <linux-scsi@vger.kernel.org>; Thu, 30 Mar 2023 13:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680208490;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=eGkxwG96GrqLVw0TE58Wpxl+P5cmdIKahbzznaGzN4I=;
        b=U+/r2q9O8oRlWftuZ8B/W4SNyr0Bb5fWiKmen9uNETaRwDNZ4GsTn1tBdQAUQsIGuiba/u
        fsHiMk5HV3iK5ZoxjwiKFJOd7EHnxvxx/ouk7oRHkyTcc79Gi3Rl0YNcwExj2Jdo9Bxja5
        7oloun+UrSmb6g3exvHQYCQtIsc2io4=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-50-FmDpaio9MgKo2Z5KKqZ6Vg-1; Thu, 30 Mar 2023 16:34:48 -0400
X-MC-Unique: FmDpaio9MgKo2Z5KKqZ6Vg-1
Received: by mail-qk1-f200.google.com with SMTP id 72-20020a37044b000000b0074694114c09so9413807qke.4
        for <linux-scsi@vger.kernel.org>; Thu, 30 Mar 2023 13:34:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680208488;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eGkxwG96GrqLVw0TE58Wpxl+P5cmdIKahbzznaGzN4I=;
        b=hK+ACwJHpzP+PnQ9f5D01JenePyrOf2vBAtQ/qgP8a+AXaVFGY9qbanHQOXSgxzsXP
         O9ugjcX9N4ldSIPuTKs94XWcAwGrsPUb4654V7TULxHcQBTtgHb9s9vQFJTlqcVtyDae
         TgCy3r1/3sfn1sJlBUJcowClAwF56BJwwS8QqLK5fk9g0omfHJ1yj7U5GA+dsEnTAEKu
         flEgMHNZdXzQkVWkJXQIVmfFEwScAbNUSsZoEysLRr7cdGuMcXEv2kQk4iqK8h/mT4YY
         mw9hmkyFuXhQfHykRDT3m+NfUJ8oSrIaCxiO3NpKX6g0yQGv/U2YKyzeDsL5i+xrB2D6
         sWwA==
X-Gm-Message-State: AAQBX9em3bsnV/XlH23xCpnYQoGKLuCtZybaoOTUhy6t3MZi5PWQW5+Z
        BLBrcUx9Ml/HMGTICqZvy8rnDeGGAUedexotPGuuAe9m3kmC33mMXqSclUUXa0fFBudwRxhjP2J
        yu19H26iFAqHiDa0qlZ/vrQ==
X-Received: by 2002:ac8:584f:0:b0:3e1:6c7e:2ee0 with SMTP id h15-20020ac8584f000000b003e16c7e2ee0mr14242004qth.11.1680208488244;
        Thu, 30 Mar 2023 13:34:48 -0700 (PDT)
X-Google-Smtp-Source: AKy350a1wvKlZbAtmYILYnVwfQgOtt39xMFyExjgnV3KppLGpi4BEL0uQtNYwb/Tvs8MCv4NdLJl4Q==
X-Received: by 2002:ac8:584f:0:b0:3e1:6c7e:2ee0 with SMTP id h15-20020ac8584f000000b003e16c7e2ee0mr14241984qth.11.1680208488012;
        Thu, 30 Mar 2023 13:34:48 -0700 (PDT)
Received: from dell-per740-01.7a2m.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id u17-20020ac87511000000b003e38f8d564fsm110512qtq.66.2023.03.30.13.34.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 13:34:47 -0700 (PDT)
From:   Tom Rix <trix@redhat.com>
To:     skashyap@marvell.com, jhasan@marvell.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, nathan@kernel.org,
        ndesaulniers@google.com
Cc:     GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] scsi: qedf: remove unused num_handled variable
Date:   Thu, 30 Mar 2023 16:34:44 -0400
Message-Id: <20230330203444.1842425-1-trix@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

clang with W=1 reports
drivers/scsi/qedf/qedf_main.c:2227:6: error: variable
  'num_handled' set but not used [-Werror,-Wunused-but-set-variable]
        int num_handled = 0;
            ^
This variable is not used so remove it.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/scsi/qedf/qedf_main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index e7f2560b9f7d..3b64de81ea0d 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -2224,7 +2224,6 @@ static bool qedf_process_completions(struct qedf_fastpath *fp)
 	u16 prod_idx;
 	struct fcoe_cqe *cqe;
 	struct qedf_io_work *io_work;
-	int num_handled = 0;
 	unsigned int cpu;
 	struct qedf_ioreq *io_req = NULL;
 	u16 xid;
@@ -2247,7 +2246,6 @@ static bool qedf_process_completions(struct qedf_fastpath *fp)
 
 	while (new_cqes) {
 		fp->completions++;
-		num_handled++;
 		cqe = &que->cq[que->cq_cons_idx];
 
 		comp_type = (cqe->cqe_data >> FCOE_CQE_CQE_TYPE_SHIFT) &
-- 
2.27.0

