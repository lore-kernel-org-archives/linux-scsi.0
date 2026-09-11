Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC6046D2B4
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 09:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789117846; cv=none; b=DfgvrNbM36iJLW/XZHEfqnUO8OOXjktEZ/gu96Bvh0as5TQJiBVyYPASJURuXi62tEOyKYdnYOWw6NMiiLRW9OKos3aFKrNYJsmg3EXccABILW5nZRcSFNagv1QlPoKMgiehcrsyCnuB6bqUGUnZVx6lsmkWfYWvt0Uuso4/Ztg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789117846; c=relaxed/simple;
	bh=d6HRwdeNmQg4i4XlfUtlLW0h4ANTUQL5OsgKLbQyEWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AVV0MwZouqYRLbIFb2dx9NBi+GqxBuvHkGZi1yOTpan6fXEx8Ncti1pIi2SdcMavvevUS5oIsuPgQnFrtWsK8Ft+n73ME9nnpwCdiGnAFhedI0DQPUiCblvYb8+XQgw8LPSw9Na0HKRw6wR9OqVJfFWWl3sY5orW0iKnFjlVWSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CpLUIFH4; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CpLUIFH4"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-86b32af25f6so656159b3a.2
        for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 02:10:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789117838; x=1789722638; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7UiZcan4emGUmfQrprsh52fFTfsNRd6QNO+8WmhA9RE=;
        b=CpLUIFH4HuWAhCzVNMtZpBQ6XCp7AguQGMO++TXnpkrjNBBxoocCM+H35DGUmBhMKn
         7ELGzttlDhXHD8/2OTlKG1W2Prb7jehFZ3zyjA4iS4AaOEF0a/ckeey2ZA6Omf3O/LJF
         uFyXYjdf3YnsgK4mEKkTdFbRRDxflQHKtguKo9h1Er6HU4hPnJ6ZRAhZ6ZUhSjtzwbv5
         qJwTUP+vQXGfev+dTvBi3HtCcOf7slnKYAm9rfCYS+KkT7IJRQmgZ0ka4rKCb6EgdgKg
         WQhzHAnjP8l+/Wia136v+IOO2UCPt/xfV8k9zbI2YEulMrNai2ZJK/kPeob22ZHQRAPC
         TJNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789117838; x=1789722638;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7UiZcan4emGUmfQrprsh52fFTfsNRd6QNO+8WmhA9RE=;
        b=c3ofcOarsXSTNrZOV55J1fEDEixlEGREK8NXi21nNos6NPG/VGdE8bpqIl5YiNMRcc
         eyHbqOLZhdSchOdzevX2ZjkS0GIqJHsgQOr87gBmtaz4ALEdrGcqdL+m0oGCaMAFcBaq
         YuJ4861lztRapU0IOCLjnPwSuSCJ/ZF338NkV1Ir34IOWhb3YwMjNcFkZReQDe5C6zfG
         YPhTTaCxxVMH5LF3oVLSQoTWEVZr8n9snWOjBigHny2K5tDrpyiwMz97EmEs6KR3uquE
         nfmBbzXd6/cADs+PalG5ZYgXKJwa7y1/yPFTbjtrGIS81oG3erKcLEjA/AkhoDLy2VqV
         scKw==
X-Gm-Message-State: AFuF++nRuz3x4DxHJqPq+HbQIIgFB4FHwXXGkvgY3+5fhp6V4ZfbdTnA
	qV0Tlov9tmrXRPfuoNOmUAfTRI4K0S1tonFXunwQyJamGK4OJyZs1Y/NU9IYX3Qd
X-Gm-Gg: AYBFou3jStaqKoDwxoMBQ17PgNZ36XNCzsBE0pcPI15WrmnjbjUawe+UAEbxAiv4rlI
	KYU8bJXsbe05twIxQsGn3RMZWtvSV1wUvy3DO/4pByrmD+coJvUDHG5O74TK5rQ6sHGGWkof3aq
	rzIFsNqz2Tlgzz219avsrH0VVrOXST9sztYN/ayYo/EcSA6SB0NgdRh0Lqx+q35cZ6tPKcYZqyB
	KzAkAw2V9OIgWFxLonDv3A/9UvMNsD4XCONEQFUxdhL0xO3mGJS5b2IpTnqU7CS+K2urc/ik2L7
	NO1VwK2iVJsjCtbcfyDj0CHaDZn/dO3/HwobBaUu5nU1mEzIlG48HETzb/KbOiZfQ//azJ6SUTX
	LWHMHh9N6IiLPRsfqTIUM3HGTXkYxcQBWvEZwpJyXO/syGD9Ly/b3UBFOk+8tTvsACw4+cS8/xj
	IkuzZLy449vuWvrQ6g82zUJIWuTSlegjQ/OaJik+PiIiCshy1lsM15IaKMdbs9vi3AKsG85VqSu
	8zlHwxE/Kq+tXBaNZrCkWI8QxpM/Ch7QcHpsVu6mQ==
X-Received: by 2002:a05:6300:4044:b0:3d3:ae40:51e6 with SMTP id adf61e73a8af0-3daed3ff637mr6487074637.26.1789117838156;
        Fri, 11 Sep 2026 02:10:38 -0700 (PDT)
Received: from FLYINGPENG-MC2.tencent.com ([43.132.141.21])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc4c6572ecasm822522a12.22.2026.09.11.02.10.36
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 11 Sep 2026 02:10:37 -0700 (PDT)
From: Peng Hao <flyingpenghao@gmail.com>
X-Google-Original-From: Peng Hao <flyingpeng@tencent.com>
To: jinpu.wang@cloud.ionos.com,
	James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org
Subject: [PATCH 3/4] scsi: pm8001: free CCB resources on allocation failure
Date: Fri, 11 Sep 2026 17:10:10 +0800
Message-ID: <20260911091011.94676-4-flyingpeng@tencent.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20260911091011.94676-1-flyingpeng@tencent.com>
References: <20260911091011.94676-1-flyingpeng@tencent.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If allocation of a CCB PRD buffer fails, pm8001_init_ccb_tag() leaks the
buffers allocated by earlier loop iterations, along with ccb_info and
the reserved-tag bitmap. The same resources, as well as the devices
array, are leaked when probe fails after CCB initialization because
pm8001_free() does not release them.

Add a common CCB cleanup helper and use it from both the partial
allocation error path and pm8001_free(). Move devices teardown into
pm8001_free() and remove the duplicate teardown from the remove path.

Signed-off-by: Peng Hao <flyingpeng@tencent.com>
---
 drivers/scsi/pm8001/pm8001_init.c | 42 ++++++++++++++++++++++---------
 1 file changed, 30 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 412079b5652c..594f8c0595e9 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -176,6 +176,33 @@ static void pm8001_phy_init(struct pm8001_hba_info *pm8001_ha, int phy_id)
 	sas_phy->lldd_phy = phy;
 }
 
+/**
+ * pm8001_free_ccb - free CCB resources
+ * @pm8001_ha:	our hba structure.
+ */
+static void pm8001_free_ccb(struct pm8001_hba_info *pm8001_ha)
+{
+	int i;
+
+	if (pm8001_ha->ccb_info) {
+		for (i = 0; i < pm8001_ha->ccb_count; i++) {
+			if (!pm8001_ha->ccb_info[i].buf_prd)
+				continue;
+
+			dma_free_coherent(pm8001_ha->dev,
+					  sizeof(struct pm8001_prd) *
+					  PM8001_MAX_DMA_SG,
+					  pm8001_ha->ccb_info[i].buf_prd,
+					  pm8001_ha->ccb_info[i].ccb_dma_handle);
+		}
+	}
+	kfree(pm8001_ha->ccb_info);
+	pm8001_ha->ccb_info = NULL;
+	pm8001_ha->ccb_count = 0;
+	bitmap_free(pm8001_ha->rsvd_tags);
+	pm8001_ha->rsvd_tags = NULL;
+}
+
 /**
  * pm8001_free - free hba
  * @pm8001_ha:	our hba structure.
@@ -198,7 +225,8 @@ static void pm8001_free(struct pm8001_hba_info *pm8001_ha)
 	}
 	PM8001_CHIP_DISP->chip_iounmap(pm8001_ha);
 	flush_workqueue(pm8001_wq);
-	bitmap_free(pm8001_ha->rsvd_tags);
+	pm8001_free_ccb(pm8001_ha);
+	kfree(pm8001_ha->devices);
 	kfree(pm8001_ha);
 }
 
@@ -1285,8 +1313,8 @@ static int pm8001_init_ccb_tag(struct pm8001_hba_info *pm8001_ha)
 	return 0;
 
 err_out_noccb:
-	kfree(pm8001_ha->devices);
 err_out:
+	pm8001_free_ccb(pm8001_ha);
 	return -ENOMEM;
 }
 
@@ -1294,7 +1322,6 @@ static void pm8001_pci_remove(struct pci_dev *pdev)
 {
 	struct sas_ha_struct *sha = pci_get_drvdata(pdev);
 	struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
-	int i;
 
 	sas_unregister_ha(sha);
 	sas_remove_host(pm8001_ha->shost);
@@ -1306,15 +1333,6 @@ static void pm8001_pci_remove(struct pci_dev *pdev)
 	pm8001_kill_tasklet(pm8001_ha);
 	scsi_host_put(pm8001_ha->shost);
 
-	for (i = 0; i < pm8001_ha->ccb_count; i++) {
-		dma_free_coherent(&pm8001_ha->pdev->dev,
-			sizeof(struct pm8001_prd) * PM8001_MAX_DMA_SG,
-			pm8001_ha->ccb_info[i].buf_prd,
-			pm8001_ha->ccb_info[i].ccb_dma_handle);
-	}
-	kfree(pm8001_ha->ccb_info);
-	kfree(pm8001_ha->devices);
-
 	pm8001_free(pm8001_ha);
 	kfree(sha->sas_phy);
 	kfree(sha->sas_port);
-- 
2.43.7

