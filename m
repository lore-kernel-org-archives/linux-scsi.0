Return-Path: <SRS0=Qtkh=6S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95DF4C47257
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 17:25:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7473520721
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 17:25:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jj7aodih"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729738AbgEDRZu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 May 2020 13:25:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729549AbgEDRZt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 May 2020 13:25:49 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDFD8C061A0E;
        Mon,  4 May 2020 10:25:49 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id x77so5867664pfc.0;
        Mon, 04 May 2020 10:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=bxyngs7ScABszWTp3cRRYAAivc+75uL16s+Y0Qohbfk=;
        b=jj7aodihYRtL/Aw1lPJ/3uTzmW49L9lY1DGjeVBjf7DW9zhTuaG50kqPgjCdGddlKX
         nlf4DVmygLqa1P85K9FnX7PW9Jw6fPAX2+JXiUDlMp6uYqdJRQLzomxPglLErsPKZDXe
         i2d9CNFOBPIreCFDWPHUc/cehaHrkwzvQwUDKOnQbtEK+XEPiIM+dgYoK4zB46IbAKMB
         9KHI9b1Pdwhyrx5iD3glTL+c4Z06Se+zohsKiJVDvdosKhNBtDkGZKdNqSQE62sxPx33
         V7zUjh/OCmILdDqTEWd94apwGO+nYxWYS/25lD8H9xiBe15VenABslSJ0ngEBiewHr9B
         6IBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=bxyngs7ScABszWTp3cRRYAAivc+75uL16s+Y0Qohbfk=;
        b=Yi7Vg/G5ng6q9XQ8ojD+XEAZy6/L+LWyc7XqA4P3lI0vNfpmhmnwjV57vfbBtXgguv
         /ZOK8R5htzeW4Esg7YAuFOfofskqJSKupYkqLzXCsXq8IlemiLn11L6MSz0ZVuFLXz35
         rWNj5IHQSIvVI+tzOE18aLmHpjGoA+Au8VIqhCmk9rIiWLc02XpLXOYAe+58v0BMpgPT
         Ssu7qSWjJRk5kZ+jrjgW7urAwaLoL7EPwrw1WI0n8cgyMSK27e4u+ui8lPqgKFu4K3UQ
         3hj+Sxg3KfQJePIijJgDLhGQMIrV0ZUxY9zBBr43BR9r/m5MSmFiY7VkntaFEP8GDZAP
         DnwQ==
X-Gm-Message-State: AGi0Pubq5ZIitS4Oa0TNfTnuGO/J692NbVm6xYhtKgzb2MYOG3MjNf9Q
        H2gt2733yS5Re8pE52eNkEIhjqLJcH0=
X-Google-Smtp-Source: APiQypK8ncf0X4fEweYDbiw4wdqgxEAnU2BJWCdANx6PY/JlaECuMfUPchTUQDqsE1EcG/UEBD4ZJg==
X-Received: by 2002:a63:7b4e:: with SMTP id k14mr6497pgn.267.1588613149331;
        Mon, 04 May 2020 10:25:49 -0700 (PDT)
Received: from localhost.localdomain ([120.244.110.63])
        by smtp.gmail.com with ESMTPSA id 6sm6415552pgw.47.2020.05.04.10.25.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 10:25:48 -0700 (PDT)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     linuxdrivers@attotech.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] scsi: esas2r: reduce the risk of a possible buffer-overflow vulnerability caused by DMA failures/attacks in esas2r_process_vda_ioctl()
Date:   Tue,  5 May 2020 01:24:12 +0800
Message-Id: <20200504172412.25985-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The function esas2r_read_vda() uses a DMA value "vi":

  struct atto_ioctl_vda *vi =
			(struct atto_ioctl_vda *)a->vda_buffer;

Then esas2r_read_vda() calls esas2r_process_vda_ioctl() with vi:
  esas2r_process_vda_ioctl(a, vi, rq, &sgc);

In esas2r_process_vda_ioctl(), the DMA value "vi->function" is 
used at many places, such as:
  if (vi->function >= vercnt)
  ...
  if (vi->version > esas2r_vdaioctl_versions[vi->function])
  ...

However, when DMA failures or attacks occur, the value of vi->function 
can be changed at any time. In this case, vi->function can be
first smaller than vercnt, and then it can be larger than vercnt when it
is used as the array index of esas2r_vdaioctl_versions, causing a
buffer-overflow vulnerability.

To avoid the risk of this vulnerability, vi->function is assigned to a 
non-DMA local variable at the beginning of esas2r_process_vda_ioctl(), 
and this variable replaces each use of vi->function in the function.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/scsi/esas2r/esas2r_vda.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/esas2r/esas2r_vda.c b/drivers/scsi/esas2r/esas2r_vda.c
index 30028e56df63..c3a6811145cf 100644
--- a/drivers/scsi/esas2r/esas2r_vda.c
+++ b/drivers/scsi/esas2r/esas2r_vda.c
@@ -70,16 +70,17 @@ bool esas2r_process_vda_ioctl(struct esas2r_adapter *a,
 	u32 datalen = 0;
 	struct atto_vda_sge *firstsg = NULL;
 	u8 vercnt = (u8)ARRAY_SIZE(esas2r_vdaioctl_versions);
+	u8 function = vi->function;
 
 	vi->status = ATTO_STS_SUCCESS;
 	vi->vda_status = RS_PENDING;
 
-	if (vi->function >= vercnt) {
+	if (function >= vercnt) {
 		vi->status = ATTO_STS_INV_FUNC;
 		return false;
 	}
 
-	if (vi->version > esas2r_vdaioctl_versions[vi->function]) {
+	if (vi->version > esas2r_vdaioctl_versions[function]) {
 		vi->status = ATTO_STS_INV_VERSION;
 		return false;
 	}
@@ -89,14 +90,14 @@ bool esas2r_process_vda_ioctl(struct esas2r_adapter *a,
 		return false;
 	}
 
-	if (vi->function != VDA_FUNC_SCSI)
+	if (function != VDA_FUNC_SCSI)
 		clear_vda_request(rq);
 
-	rq->vrq->scsi.function = vi->function;
+	rq->vrq->scsi.function = function;
 	rq->interrupt_cb = esas2r_complete_vda_ioctl;
 	rq->interrupt_cx = vi;
 
-	switch (vi->function) {
+	switch (function) {
 	case VDA_FUNC_FLASH:
 
 		if (vi->cmd.flash.sub_func != VDA_FLASH_FREAD
-- 
2.17.1

