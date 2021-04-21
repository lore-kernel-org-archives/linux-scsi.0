Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38E5AC433B4
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 23:41:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CB0161424
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 23:41:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243719AbhDUXmN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 19:42:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241090AbhDUXmL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Apr 2021 19:42:11 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14BF2C06174A
        for <linux-scsi@vger.kernel.org>; Wed, 21 Apr 2021 16:41:36 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id s22so10380134pgk.6
        for <linux-scsi@vger.kernel.org>; Wed, 21 Apr 2021 16:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9H8mWYELIfc22cLBpOSV4sg2KNZvxtwdAqOPBPp2FV4=;
        b=pc7F3I3eFSjdDTXssEYNQgAkRgF7KhXZVqR+nTV16ATP7kj3BauP/wOoIiwzs7NPQ4
         r6e0dITn/G9VP/6GhKvjAlqhYiWDFFPQGJZMs62A9d1HvgYXy4zb9okhGrtM52wG09Fn
         9nTyGuOf1L1IGAn+TyxJucx7WjlD03mZgUXjFXaxQv/X4g9Xk0F+TEQ0hML4H7fpqHGz
         7m/NzFwPRi2463Zf2B45RpB2Zrf6Iev9TwZGd3vcnTLkgRXFjKbHnKAu1vfKOkig80Wx
         7OEmY9xtj/9RoNfc8tH3YHyH+egocb3m5lMHphkOv+IPrXSqQ/pI5Z4BKV5UBA02E5jB
         jy5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9H8mWYELIfc22cLBpOSV4sg2KNZvxtwdAqOPBPp2FV4=;
        b=FdKJLN5JwGhM8zOnECu73JUdHA6gky4ZmrWmj3Xo2JXxW3CwA/rHv4eaMnR2a4i588
         tolZnfGpzuDDszsVx/+ll4p4FCdaRNKBnGpPjnhv5DhUCo4KzY/wsNj3OBEJEiL72+q2
         lyYw1uNqV8qAhgRjjH7hVyh8721a4V5FI+wvmC6e4igMxv/0L7whSaAxJa6cNGrDyWaX
         TU9Xo2WWTEWEat38maahPrKrwJXgGv6L6hdh5jxCmfnrv65QlnBNV6dTv1DipRGSQG4G
         8zrJkYh9VsillMQN2EfZ2adBMP50wujJG/co7CzrV0vEHwh35tUMvTULyfzxJWsQfgsL
         B+OA==
X-Gm-Message-State: AOAM533G+Nvo3PV4nz+qT/mPb4K05wzDv5g4q7L6JhkZOfCpSoimPLTk
        G0bPzLrWa/by+DoUL5o1qQWNdfbZAPM=
X-Google-Smtp-Source: ABdhPJw9waWgL32o/E0gy3xKsBwbtm1VyxeDmA3ZOnXK2ig9CWeLXzATtG/S5ItmGBoHcTbkNLPjqw==
X-Received: by 2002:a17:90b:380c:: with SMTP id mq12mr13922049pjb.109.1619048495575;
        Wed, 21 Apr 2021 16:41:35 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t11sm393961pji.54.2021.04.21.16.41.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 16:41:35 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH] lpfc: Fix dma virtual address ptr assignment in bsg
Date:   Wed, 21 Apr 2021 16:41:31 -0700
Message-Id: <20210421234131.101842-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

lpfc_bsg_ct_unsol_event routine acts assigns a ct_request to the
wrong structure address, resulting in a bad address that results
in bsg related timeouts.

Correct the ct_request assignment to use the kernel virtual buffer
address (not the control structure address).

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>

Notes:
   ECD submit header:

                ****************************************

    COMMIT-TITLE: Fix loopback test failure on saturn
    COMMIT: r64560
    COMMIT-BZ: 225555
    COMMIT-QC:

r64560 | vg888570 | 2019-04-26 09:12:33 -0700 (Fri, 26 Apr 2019) | 51 lines

Fix loopback test failure on saturn
Bugs: 225555

Reviewers: jinfante pely rkennedy hpaidakul

Symptoms:
The loopback tests started failing on saturn cards

Cause:
The lpfc_bsg_ct_unsol_event() is broken during
E2E code changes. This routine acted on a wrong ct_request
pointer causing the ct_evt_waiters to timeout.

Fix:
Assign a correct virtual addr for ct_request, so that
the driver wakes up the matching waiter of the event.

Notes:

Unit Testing:
Tested on Saturn and G5 presented on the system

Saturn:
hbacmd loopback 10:00:00:00:c9:cd:ce:50 1 20 1

Test to be run: Internal Loopback
Test runs with default test pattern

Loopback test status:
Test pending. Polling for results....
Test running....
Loopback Test Succeeded; cycles complete = 20; time to execute = 858 ms

G5:
 hbacmd loopback 10:00:00:90:fa:73:93:9c 1 10 1

Test to be run: Internal Loopback
Test runs with default test pattern

Loopback test status:
Test pending. Polling for results....
Test running.............
Loopback Test Succeeded; cycles complete = 10; time to execute = 5230 ms

System Testing:

Review_ID: http://cmengapps1.lvn.broadcom.net/r/29471/
---
 drivers/scsi/lpfc/lpfc_bsg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index c2776b88d493..38cfe1bc6a4d 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -934,7 +934,7 @@ lpfc_bsg_ct_unsol_event(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	INIT_LIST_HEAD(&head);
 	list_add_tail(&head, &piocbq->list);
 
-	ct_req = (struct lpfc_sli_ct_request *)bdeBuf1;
+	ct_req = (struct lpfc_sli_ct_request *)bdeBuf1->virt;
 	evt_req_id = ct_req->FsType;
 	cmd = ct_req->CommandResponse.bits.CmdRsp;
 
-- 
2.26.2

