Return-Path: <SRS0=twx4=B3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAE5BC433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Aug 2020 08:55:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9F212067C
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Aug 2020 08:55:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O1KR3V0x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728640AbgHQIzT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Aug 2020 04:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728605AbgHQIy5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Aug 2020 04:54:57 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFD4CC061388;
        Mon, 17 Aug 2020 01:54:57 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id t6so7379296pjr.0;
        Mon, 17 Aug 2020 01:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MVeuxsGilJwDL1o41vPJ1mEVYW9QRgNmhG//SeEinm0=;
        b=O1KR3V0xt4SN/ZoKkNI3dZUiICUjTsddCUbWlu6xJyQX2dkRzE5xFbbKhZZeergtlg
         63B9sFolljH7d9AXSVyuoNmD9Q8TbIxjlqgVN1gA6PoSC9b9poCTF/1nQqgD8wGFfgqv
         /rgl9fAJezU0La98PCZfWBtdnG9+7Vm5DcXYbtsUFyNkrx2X3wt3KyyY/h02l1HQOapd
         s40GTgbKIEbOXV10TZKdgkaJbUNxiL5WwlskC2ReFPqW2G8RzC04aUhYsBr3YD6dtC13
         KyCNUe1CeZT5tlB06UxZoBocmfFpHearUksDtHK/nURWZ12LzTuMTrPO6Rg1UbAMUl8O
         ayAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=MVeuxsGilJwDL1o41vPJ1mEVYW9QRgNmhG//SeEinm0=;
        b=ZOJIPz0/RYHkmpzFDLayGgqcBoqhMzYsDJEy69ctUf0PoF+wmCCrrDKLjlP4Oq9KN0
         hzVXAItZmzhAeuc3exzcyT7Rck6Tk8HJWpI2v+Po+yx+SftjXwOlEB8SUMBRxJXC1ujq
         aveT07z/4TIgTa5usuPXvFb0SJuA+qhkMtma9lAcO9/uOMj6CUPJ9V/rQqwD582p7u7N
         u4kfV4awJ/Jo5SVzVYTaNfnmKgz2a8/REOqLCyyJD/gb6W9tDcv9uvxkrD9T2iAhozJu
         8AyuWp87iS9Md3ZPMr8fawYJ3gLsIpVIHdJ7tTmfHXerng/ItwpmQCXIZOotFlpOTRFn
         V1PA==
X-Gm-Message-State: AOAM532n7VFh7WgaFu8ZTt+ds0j5lFx6zwDfA3JK/fIIFkgPaEVSxkI9
        wFzW0NbuCSSQDF1AE8SzSLA=
X-Google-Smtp-Source: ABdhPJwTYhGdSFSvnvbCYxYT5raIJmcHlwmf7/MdtOZWzcK9+tdf9lhZ8Svj9gLMlxhtozJBDyxnlQ==
X-Received: by 2002:a17:902:b28b:: with SMTP id u11mr10332716plr.317.1597654497255;
        Mon, 17 Aug 2020 01:54:57 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id x12sm18236990pff.48.2020.08.17.01.54.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:54:56 -0700 (PDT)
From:   Allen Pais <allen.cryptic@gmail.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com
Cc:     keescook@chromium.org, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        target-devel@vger.kernel.org, megaraidlinux.pdl@broadcom.com,
        Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH 6/8] scsi: mvsas: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 14:24:07 +0530
Message-Id: <20200817085409.25268-7-allen.cryptic@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200817085409.25268-1-allen.cryptic@gmail.com>
References: <20200817085409.25268-1-allen.cryptic@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Allen Pais <allen.lkml@gmail.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/scsi/mvsas/mv_init.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 978f5283c883..53b2d463fa13 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -147,13 +147,14 @@ static void mvs_free(struct mvs_info *mvi)
 }
 
 #ifdef CONFIG_SCSI_MVSAS_TASKLET
-static void mvs_tasklet(unsigned long opaque)
+static void mvs_tasklet(struct tasklet_struct *t)
 {
 	u32 stat;
 	u16 core_nr, i = 0;
 
 	struct mvs_info *mvi;
-	struct sas_ha_struct *sha = (struct sas_ha_struct *)opaque;
+	struct mvs_prv_info *mpi = from_tasklet(mpi, t, mv_tasklet);
+	struct sas_ha_struct *sha = pci_get_drvdata(mpi->mvi[0]->pdev);
 
 	core_nr = ((struct mvs_prv_info *)sha->lldd_ha)->n_host;
 	mvi = ((struct mvs_prv_info *)sha->lldd_ha)->mvi[0];
@@ -564,8 +565,7 @@ static int mvs_pci_init(struct pci_dev *pdev, const struct pci_device_id *ent)
 	} while (nhost < chip->n_host);
 	mpi = (struct mvs_prv_info *)(SHOST_TO_SAS_HA(shost)->lldd_ha);
 #ifdef CONFIG_SCSI_MVSAS_TASKLET
-	tasklet_init(&(mpi->mv_tasklet), mvs_tasklet,
-		     (unsigned long)SHOST_TO_SAS_HA(shost));
+	tasklet_setup(&(mpi->mv_tasklet), mvs_tasklet);
 #endif
 
 	mvs_post_sas_ha_init(shost, chip);
-- 
2.17.1

