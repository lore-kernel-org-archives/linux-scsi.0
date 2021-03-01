Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B68C4C433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 18:21:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7ED9A64DEE
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 18:21:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234226AbhCASVh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 13:21:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239501AbhCASTn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 13:19:43 -0500
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78D7DC061756
        for <linux-scsi@vger.kernel.org>; Mon,  1 Mar 2021 10:19:03 -0800 (PST)
Received: by mail-qk1-x749.google.com with SMTP id h126so14712516qkd.4
        for <linux-scsi@vger.kernel.org>; Mon, 01 Mar 2021 10:19:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=E+NBL9rkiV5wAQH+xHaWKWyyTvZoX0yJVauTWV+yfeI=;
        b=Npsev0zSXYB+v1xtlbdCQENDJCsvar+GfZHOTvsLLfHprz4BQxynt73VcSN7YharXO
         RunfZYIYkhsElLOn6/9VhuCqC8Wli55L1pPXde//Pix9VNiOKyY1sJmeT7Yw4mcCGwEH
         HaiKkkdlcJRVE4JRFevDHovG4jYThzjQNUIbGfaBymKg+zMFUGlmzLFL12jweyVgEIrr
         7qJ0IvvvVlAkyj/ZlJ+vdpiCS3TgoQL6vWTZ0GUuRYAQX2yfx/H7b3smk/Q9vq6hVEDz
         Kr+c2p3QsWQ1wsMbVVtT0fKhMVrbwxPotLyRHRa+sElh63+UbOG3m8+TokvqogqnyzA/
         xe8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=E+NBL9rkiV5wAQH+xHaWKWyyTvZoX0yJVauTWV+yfeI=;
        b=mMsE/4WDk2Nxbd4lPV/RY1gCtJw6aanRdsWJ4Hhl5vK1+uDp/25tfFCM71VEANzIev
         hJ78kwueLwP9qasynW8d3LhF/8bCVZk7tKhjPX3UHlVDGUM+WsqSIi2ySQJWEPnblV15
         BLK1doFT3EFcnlxLh43xo2JYM24RlEW57Skn4VH7KTjcYNjiRrpjO6Zf1aplqWlFqaqd
         WVB1loJgbFR8op3BRTD5T6sgHOzbk+5nFWF0zLyQ7AUA48ScrdrgOjj+NkbOnjf1ujaU
         DRWDXXwi3JsxN6IJD7aKRsaUSAE9pS+x+26pstvaOjvGdm+BCF24Yvw9AP7IsiTncvwT
         loVQ==
X-Gm-Message-State: AOAM530hREZYin0X44zuUZ44tvaPNvAn8qX7dBDrvDt4/uGhS9YAK/nq
        DTz5I4H5qNzYj0UvgKTKHAbc8r+Jzm2hFA==
X-Google-Smtp-Source: ABdhPJyZBFoYoI1zXxGvCCcc1Cep1xFMXIdMVEA5UQKjhBAtdV97y5mQ8nq3ktiEQNzH9ObspWiBsTRiVdXIUA==
Sender: "ipylypiv via sendgmr" <ipylypiv@ipylypiv.svl.corp.google.com>
X-Received: from ipylypiv.svl.corp.google.com ([2620:15c:2c5:11:3d0d:412:7757:f65])
 (user=ipylypiv job=sendgmr) by 2002:a0c:99d2:: with SMTP id
 y18mr15888590qve.8.1614622742523; Mon, 01 Mar 2021 10:19:02 -0800 (PST)
Date:   Mon,  1 Mar 2021 10:18:47 -0800
Message-Id: <20210301181847.2893199-1-ipylypiv@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH] scsi: pm80xx: Remove list entry from pm8001_ccb_info
From:   Igor Pylypiv <ipylypiv@google.com>
To:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Vishakha Channapattan <vishakhavc@google.com>,
        Akshat Jain <akshatzen@google.com>,
        Jolly Shah <jollys@google.com>, linux-scsi@vger.kernel.org,
        Igor Pylypiv <ipylypiv@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

List entry is not used.

Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
---
 drivers/scsi/pm8001/pm8001_sas.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index 039ed91e9841..9ae9f1e61b54 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -281,7 +281,6 @@ struct pm8001_prd {
  * CCB(Command Control Block)
  */
 struct pm8001_ccb_info {
-	struct list_head	entry;
 	struct sas_task		*task;
 	u32			n_elem;
 	u32			ccb_tag;
-- 
2.30.1.766.gb4fecdf3b7-goog

