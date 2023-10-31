Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58399C4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 31 Oct 2023 18:59:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233231AbjJaS7U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 Oct 2023 14:59:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234263AbjJaS7S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Oct 2023 14:59:18 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 223FDE8
        for <linux-scsi@vger.kernel.org>; Tue, 31 Oct 2023 11:59:16 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1cc55bcd51eso4353235ad.0
        for <linux-scsi@vger.kernel.org>; Tue, 31 Oct 2023 11:59:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698778755; x=1699383555; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NDTqE7DBDC1j/pMX1esEVkDNCh0SMey5rbfN1InPrtY=;
        b=LAXucowOopTaIsVFkRSg4o28VbQjHN6WzA3nD6RGXlx2Om0NuTnYLA4OVuIwnjqE46
         aJrP/oVH1wJEuxtSCjc2dBo62i7uAVubgivUvvbKjONK0TfLt5AK4g2icv/RIZnnOMQg
         mws29bcqWfryXu3IL6477v/ocZtuFm6N7IIVm5WhKH+HrI23HUpOq/6h0g81DTVDxfSk
         +EZkJexfG+ZtWy5D2kgfFEnoh1C1WEjYtIoPOzM9d93IMSxWPcWVwK3leK/eQFADYH0h
         lWoZagrHWXssgNbB68D8dMANNlZzWYIpviffKKGYpddBNxTwHzaegR0pQ2ol9YiB7qlE
         +qIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698778755; x=1699383555;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NDTqE7DBDC1j/pMX1esEVkDNCh0SMey5rbfN1InPrtY=;
        b=gU0OUEsXqjudLF36Lsv7lQ96C+ogu1bgvslzjeOA7X9QNfFxF/AaEVEdN/+UEG0d94
         tLs3yRkrYL8BUmRVe/WN5wCT3NoQnXX0Fplkv5J6i4fP1jfqulVehAwC1xiWz/UxSKZ1
         gP+JSyNM7e1Ai9tR0m36nhE2dsC8Kh+8HbokxZVD6issV0ZXVFMsf4b/KVBlfHkcc2lV
         5xKLdcsjwzmXNmEDGe+TqPJzQ9+AgFR1DYLuKgnRnsi9c2cUPKUeTHxZhrHK6nzSnDkt
         nM/4kiYcm68zWxfVU6wfjKBYHxwMTFP5Kf3IDPJhU+9Jx5X9jZ0bMRvQnXgSabqZUFT+
         WKWQ==
X-Gm-Message-State: AOJu0YydJMmaaiiP5qWNzQLX7etNJ5vOcAW4WBWsaJC/5ATnLjvBQss3
        ukMRq3gCo1EwOrssvOgH6qTCJHMUE9g=
X-Google-Smtp-Source: AGHT+IEcrnyS3BVsXjQb1jQ+loEauQ8RdunW1SgyfKEUG0DXcwz77wWAkxh9cbbiL6hvU8PqjOE7ww==
X-Received: by 2002:a17:902:ced1:b0:1cc:e66:f994 with SMTP id d17-20020a170902ced100b001cc0e66f994mr14573276plg.1.1698778755488;
        Tue, 31 Oct 2023 11:59:15 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id bh6-20020a170902a98600b001c9d6923e7dsm1628657plb.222.2023.10.31.11.59.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 31 Oct 2023 11:59:15 -0700 (PDT)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 5/9] lpfc: Return early in lpfc_poll_eratt when the driver is unloading
Date:   Tue, 31 Oct 2023 12:12:20 -0700
Message-Id: <20231031191224.150862-6-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20231031191224.150862-1-justintee8345@gmail.com>
References: <20231031191224.150862-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add a check in lpfc_poll_eratt when the driver is unloading.  There is no
point to check for error attention events if the driver is rmmod'ed.

If the driver is reloaded, as part of insmod initialization, then a fresh
reset is always asserted to start clean and free of error attention events.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 9386e7b44750..2cb327efd57d 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -3938,6 +3938,9 @@ void lpfc_poll_eratt(struct timer_list *t)
 	if (!(phba->hba_flag & HBA_SETUP))
 		return;
 
+	if (phba->pport->load_flag & FC_UNLOADING)
+		return;
+
 	/* Here we will also keep track of interrupts per sec of the hba */
 	sli_intr = phba->sli.slistat.sli_intr;
 
-- 
2.38.0

