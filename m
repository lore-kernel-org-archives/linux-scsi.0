Received: from mail-yx1-f99.google.com (mail-yx1-f99.google.com [74.125.224.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D16834D8D9D
	for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2026 18:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783536057; cv=none; b=dj3CtrUN4d/KHUpIMhd2Bw3P1dB+jduWcRQtdZiu4l1kUd3JzFzEozZYqp1u3Pd0YMzoSDswSLtNlpj2sOuuPD220DYH+BChrLCTuzMTJEjRfIeLe0NLR5SLbctp1fzjVHgv3opSHv3frzq6kp7Cex1bQk7zl6lox76h7VcWWWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783536057; c=relaxed/simple;
	bh=/coSEKvdfv2ygDy00Muep9khgNmD0IE4RdckJhgLClk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sfERL0FZeudKImaBBwB5AkCR7bXzUF8vA44X1bBSlxx/+9MdYXB6yW9w0lgr/9spmlT/I38ZWfD+KndDEfKom3AdeGGbA7SbRstYfIZCYyPaTeidZkmUpp/te1FZ8vCWqmdlfqCXgMLwsBOdg/W6osOEXS8D8Zyz0OqpW2syl7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=BvvMD55V; arc=none smtp.client-ip=74.125.224.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="BvvMD55V"
Received: by mail-yx1-f99.google.com with SMTP id 956f58d0204a3-667b0ced2d3so706135d50.2
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jul 2026 11:40:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783536055; x=1784140855;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cGJaBCHyG0cKu9ts2sNDVjyMs5gyGZginC8db5SRStg=;
        b=ZgtF8ZV3Dbe0Mursc3nTeoaql4YNkm1kbuDVakkZkz/2x2alFfX70CJvY4DCutJeya
         b1aMKO/o0voLOJ5oewHZ/ZRM/cKKtuqjXyRO3f/FL22tYs/xHWRPOimB2i4Yq2bPRPen
         UZrGe+yr7EA51CQQfn4PCLX4Vg5AbpbC73kgHy/R6HH2YXDb3kNmezr5AKOwez2N9yCL
         FXWMtJORnKA7E0nOESGf9/5iUaajXOKG6Yk4EIhZIK3L4NZn4H4CNlZOuYXxenbK3dGW
         XiDks5jOtzTXvMlG4UEigGiKsopr3V1AINdfl6vscWKPGSz581F8OSZLHhyIPboJHij8
         QS8A==
X-Gm-Message-State: AOJu0YwUEU/Ko3V9I/n7Iyt0emuGxPb3TiC8GADNAP9EobHj0pqUs2TM
	chs9/XwXMC/kJeev21FKZnEzbfpY+S1IbFIlhYNT+4e8GMiGaqxYEfUBAfNTJcuGKpUyGegTuhT
	HRxWFjX7wudRPQSAQgvD6e94ggbTa0hyztkp7TFORekiEyVG6iS82i8OxBtKa9vIoEo26fEKwZF
	BsI2KbSRkrcRZnEef3xeu1P/v05eSgvWAkoI6FEnorAzagSiJ9BJkqZul5RRRrPLTIZQB2T0oBR
	Yg3wUjY6h7I+qY9
X-Gm-Gg: AfdE7ckEZ1bt1KpbNWUAkwM/1nmM6mXpyUp1u0Ovk9SzVlOkbJ0ZlqvS2eYuZdj9gPu
	WNgrSrHuuLFRwg7XAakSatAt2cItsuOTn9ZDfEKRy97kUeLbEhSUBbNBgej+Lug7u3c5+29sY0a
	zhxD5oRZMG5Rj74bfwWGRFiWu6UmH9sYC+hREL1vZlvjKLIhRI9BkdKVhfIQNYQtWLcpBqMCBZ8
	g//jzwKhN3imKXLRmaGAAWOMQ2ffIzJTCtMGSFqDuvT8SI1RHpBKq1oEhFd53oaWJxTVbyg5yB6
	U7t/p1ks9Jr9N6zz7tJUwImRts1MyHoQjJeUxgFHk4CJgcnjfTAVR5gFs9OdUyTyOfArXm2ZdJA
	q6f1CglTlJv4IjF/82+tNGH3o/VITrZnV4PxGRjdbDJ75AqeASi+azeQlgCeQe0Z698Depwe8UK
	vD6l5DSpXIedc3uExiySFSF/67d31qFRNZnRzU8ztvk6I/2g==
X-Received: by 2002:a05:690e:4390:b0:667:72da:e787 with SMTP id 956f58d0204a3-6679f151831mr2270288d50.60.1783536054549;
        Wed, 08 Jul 2026 11:40:54 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-11.dlp.protect.broadcom.com. [144.49.247.11])
        by smtp-relay.gmail.com with ESMTPS id 956f58d0204a3-66787b447fasm311228d50.29.2026.07.08.11.40.54
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Jul 2026 11:40:54 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-c85798977dcso1568617a12.0
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jul 2026 11:40:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1783536053; x=1784140853; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cGJaBCHyG0cKu9ts2sNDVjyMs5gyGZginC8db5SRStg=;
        b=BvvMD55VlBeKx/XiBxOcFS4eIQCO0UQGhvVsrn9TVkFVeRD1dQcY+quBzOLv+VgeKn
         QiUSEMsP+klbueIXLGrtsB+3CA3PLtMogMsjqvn1Vhvbvfg8h6jh7zJqAmEpl57smbLL
         AyaXB9mgkPqPu0GgPWBzbxp072tK+/3KcVbHQ=
X-Received: by 2002:a05:6a21:7117:b0:3c0:9c19:65b4 with SMTP id adf61e73a8af0-3c0bd39dec9mr4478572637.76.1783536053215;
        Wed, 08 Jul 2026 11:40:53 -0700 (PDT)
X-Received: by 2002:a05:6a21:7117:b0:3c0:9c19:65b4 with SMTP id adf61e73a8af0-3c0bd39dec9mr4478527637.76.1783536052598;
        Wed, 08 Jul 2026 11:40:52 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3117d847e17sm19820599eec.18.2026.07.08.11.40.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 11:40:52 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v2 09/10] mpi3mr: Fix SAS PHY cleanup in host addition error paths
Date: Thu,  9 Jul 2026 00:03:04 +0530
Message-ID: <20260708183305.244485-10-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260708183305.244485-1-ranjan.kumar@broadcom.com>
References: <20260708183305.244485-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

When adding a SAS host, the driver allocates a PHY array and subsequently
creates individual SAS PHYs. If a later step fails, the error path exits
without cleaning up previously allocated resources, resulting in leaks of
both the PHY array and any registered SAS PHYs.

Additionally, the return value of mpi3mr_add_host_phy() was being ignored.
If it failed, mr_sas_phy->phy would be left as NULL, which could later
lead to a NULL pointer dereference in mpi3mr_sas_port_add() when the
attached device triggers a device addition event.

Add a dedicated cleanup path that deletes any successfully created SAS
PHYs and frees the PHY array before returning from initialization
failure paths. Also, check the return value of mpi3mr_add_host_phy()
and jump to the cleanup path on failure.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260626114109.43685-1-ranjan.kumar@broadcom.com?part=9
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 33 ++++++++++++++++++--------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index b51edbb921eb..a8b79da25d38 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -1216,13 +1216,14 @@ void mpi3mr_sas_host_add(struct mpi3mr_ioc *mrioc)
 	}
 	num_phys = sas_io_unit_pg0->num_phys;
 	kfree(sas_io_unit_pg0);
+	sas_io_unit_pg0 = NULL;
 
 	mrioc->sas_hba.host_node = 1;
 	INIT_LIST_HEAD(&mrioc->sas_hba.sas_port_list);
 	mrioc->sas_hba.parent_dev = &mrioc->shost->shost_gendev;
 	mrioc->sas_hba.phy = kzalloc_objs(struct mpi3mr_sas_phy, num_phys);
 	if (!mrioc->sas_hba.phy)
-		return;
+		goto out;
 
 	mrioc->sas_hba.num_phys = num_phys;
 
@@ -1230,12 +1231,12 @@ void mpi3mr_sas_host_add(struct mpi3mr_ioc *mrioc)
 	    (num_phys * sizeof(struct mpi3_sas_io_unit0_phy_data));
 	sas_io_unit_pg0 = kzalloc(sz, GFP_KERNEL);
 	if (!sas_io_unit_pg0)
-		return;
+		goto out_free_phy;
 
 	if (mpi3mr_cfg_get_sas_io_unit_pg0(mrioc, sas_io_unit_pg0, sz)) {
 		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
 		    __FILE__, __LINE__, __func__);
-		goto out;
+		goto out_free_phy;
 	}
 
 	mrioc->sas_hba.handle = 0;
@@ -1249,12 +1250,12 @@ void mpi3mr_sas_host_add(struct mpi3mr_ioc *mrioc)
 		    MPI3_SAS_PHY_PGAD_FORM_PHY_NUMBER, i)) {
 			ioc_err(mrioc, "failure at %s:%d/%s()!\n",
 			    __FILE__, __LINE__, __func__);
-			goto out;
+			goto out_free_phy;
 		}
 		if (ioc_status != MPI3_IOCSTATUS_SUCCESS) {
 			ioc_err(mrioc, "failure at %s:%d/%s()!\n",
 			    __FILE__, __LINE__, __func__);
-			goto out;
+			goto out_free_phy;
 		}
 
 		if (!mrioc->sas_hba.handle)
@@ -1264,26 +1265,27 @@ void mpi3mr_sas_host_add(struct mpi3mr_ioc *mrioc)
 
 		if (!(mpi3mr_get_hba_port_by_id(mrioc, port_id)))
 			if (!mpi3mr_alloc_hba_port(mrioc, port_id))
-				goto out;
+				goto out_free_phy;
 
 		mrioc->sas_hba.phy[i].handle = mrioc->sas_hba.handle;
 		mrioc->sas_hba.phy[i].phy_id = i;
 		mrioc->sas_hba.phy[i].hba_port =
 		    mpi3mr_get_hba_port_by_id(mrioc, port_id);
-		mpi3mr_add_host_phy(mrioc, &mrioc->sas_hba.phy[i],
-		    phy_pg0, mrioc->sas_hba.parent_dev);
+		if (mpi3mr_add_host_phy(mrioc, &mrioc->sas_hba.phy[i],
+		    phy_pg0, mrioc->sas_hba.parent_dev))
+			goto out_free_phy;
 	}
 	if ((mpi3mr_cfg_get_dev_pg0(mrioc, &ioc_status, &dev_pg0,
 	    sizeof(dev_pg0), MPI3_DEVICE_PGAD_FORM_HANDLE,
 	    mrioc->sas_hba.handle))) {
 		ioc_err(mrioc, "%s: device page0 read failed\n", __func__);
-		goto out;
+		goto out_free_phy;
 	}
 	if (ioc_status != MPI3_IOCSTATUS_SUCCESS) {
 		ioc_err(mrioc, "device page read failed for handle(0x%04x), with ioc_status(0x%04x) failure at %s:%d/%s()!\n",
 		    mrioc->sas_hba.handle, ioc_status, __FILE__, __LINE__,
 		    __func__);
-		goto out;
+		goto out_free_phy;
 	}
 	mrioc->sas_hba.enclosure_handle =
 	    le16_to_cpu(dev_pg0.enclosure_handle);
@@ -1306,6 +1308,17 @@ void mpi3mr_sas_host_add(struct mpi3mr_ioc *mrioc)
 				le64_to_cpu(encl_pg0.enclosure_logical_id);
 	}
 
+	goto out;
+
+out_free_phy:
+	for (i = 0; i < mrioc->sas_hba.num_phys; i++) {
+		if (mrioc->sas_hba.phy[i].phy)
+			sas_phy_delete(mrioc->sas_hba.phy[i].phy);
+	}
+	kfree(mrioc->sas_hba.phy);
+	mrioc->sas_hba.phy = NULL;
+	mrioc->sas_hba.num_phys = 0;
+
 out:
 	kfree(sas_io_unit_pg0);
 }
-- 
2.47.3

