Received: from mail-pl1-f225.google.com (mail-pl1-f225.google.com [209.85.214.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DCDE3A6F04
	for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 17:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787075864; cv=none; b=mKUNZYGcoJy9ZJHaITgeidN7iFgtmaABcvDBrwfT/qkZnO/6LAPF2Ku/SKaL57a7xlyDVrHoJ75L/qPT+NXfZW+tCAsMdfYVEQZhryhERB8iYSdZVawfivOWQc+j1rNQ8VgmDxncRPz5TVWr3szNQHBM+xgbAoIBriQtb0hCT1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787075864; c=relaxed/simple;
	bh=ycy1fglb8VGHAwYEwkeBXI0wiqLBfaVmW9DvrI8AQJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XUlaHAdRmLOC42E0peWC7w92RzKTx5CJaJi+oNsEYh7b3IHER1dUZ4miDJxn3NpGJiTkKzwBZt7S90gL15+LJhg2Iguldzf+lrT8J39Np+kkVVdJ5GPu+tT0WCAFIzf4qX06aHAlTBMt25+EFIW9Rvbos71y6KQbWHp3mLqFnOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=C9tG2Hk3; arc=none smtp.client-ip=209.85.214.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="C9tG2Hk3"
Received: by mail-pl1-f225.google.com with SMTP id d9443c01a7336-2cf50c6f235so1435355ad.0
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 10:57:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787075862; x=1787680662;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3qvgtWraz3aOBEs0Ig4XRyOyRodPxDHEnzaWE9q5HHs=;
        b=YjolA1BCWIx/1xLM/DJTJ1Vndr1jVogH76ZS01T9B70K4K7UlkBrXcTaWkLlw5JYa5
         TiUhkCnDQZDKMa/06zXeLBZdf1kL66NHuKlMbXs2VjtNvjxwMDf6/SpCxAWfKnVneZUO
         iK+kBHPUTysadETWe2onQxdDOEFGhyGONlXcFAp6g8Yt2X3MHUPi5I4tVfY8MIEw9frs
         aebXBs5ruNAbp3OWxufNxTl67ziaQSPZnj1Fyoogp6KWFVc19de9ePwSig+DekADx2w7
         8bhiXKiS5QFmN/Excm4LOOTCp+V4M+Tsknuc2W+WxTJOUdIqi+lewN9ux/3YhATCRCW0
         ZKQQ==
X-Gm-Message-State: AOJu0YxIOwt0+nXJWeaWZ2lSFoyNGTVXdMealA76/1VqhLxEulZClnC9
	UKLgyW1tCkXLA5CERAX8jhj7E1tReVf2KOpf22FxAHRkF/P76mnqWq6A5tNyoKmTCtinLKRFAlQ
	dNRzvmikpprqOavROmBJngmCU/a/N4pZwtPyiBYu7fS9k4hw2JnmGhD3R+l13ch/yX/ZQFIa1XX
	QbVUPV8+lGZjPgusVb3Od2/ps/xbvLJ05fzpxGcxsNhwU86IyLX8t9NZnevhIyMq6aGzvXHpdyb
	vIGCgl/5c9DmzB4HIYDQmV/
X-Gm-Gg: AR+sD13z2E14Qc0D2UDt7uMLcP+eRZqDzBrr3CzNJ8N8i2cpeUjS0ZYNak08dWxLTYM
	Xc8e80XiW6GEgLy1j78wHx0h19Z/JCGvd8TaOxE7a9YkvCqNanjEtNrOiEYQ5r6pdHrt8GeMbN1
	LXRtkhhwtvcY/VA3CMdAC5Tjd1bA6H74K+8gjs/dFSvGPRd3qudWyNBSQ2WqunYSQnsRTd9Hvw5
	l3WZDStpsMSVVxdcqXEgq4KvUYvMqUpcSi/ZWLIwRV96KhbXlsR9Cv0J8fAAhssw64Y1LzlCaJW
	jQzZQPmKdrHujFzBCHT4hMfuUxR6noFIqr35bZk1UFe7AwxMylnpXNCdQVSVAvqUp4MgKhuXuhx
	v1r1bW7IAHdahVFJmTbGymBIrcSxLbvHXt8PqNeXhq4mi2u3+JZssWh1CvrubCN5icbCDQlNcBr
	953QyEgEw2ZVOz2qMVY4zB6hAdll/79VBM5x/G8AjEG5Q=
X-Received: by 2002:a17:90b:39a6:b0:37c:6130:7a5b with SMTP id 98e67ed59e1d1-3955a7467f8mr12307579a91.8.1787075862295;
        Tue, 18 Aug 2026 10:57:42 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-20.dlp.protect.broadcom.com. [144.49.247.20])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-39531fba87esm4146403a91.12.2026.08.18.10.57.41
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Aug 2026 10:57:42 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cb7d6ba548eso79987a12.1
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 10:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1787075860; x=1787680660; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3qvgtWraz3aOBEs0Ig4XRyOyRodPxDHEnzaWE9q5HHs=;
        b=C9tG2Hk3lwsRLqokm52S3IqC/5tY00tp4t4zEHLJK0RVsY/RKdfdrbxP4JOGhMq1+S
         kvIOvxQP/69Doht09S5oYZIWC6Tag1Mje4R3dd1Q7wSE4nMdcKDPwafCM4jCSfSzHBZV
         JFAjPUe88/Vp5A0gUzoabt71Hf0xoCcoWFheM=
X-Received: by 2002:a05:6a21:e098:b0:3c3:9993:d5c3 with SMTP id adf61e73a8af0-3ccda98b5eamr11846292637.9.1787075860460;
        Tue, 18 Aug 2026 10:57:40 -0700 (PDT)
X-Received: by 2002:a05:6a21:e098:b0:3c3:9993:d5c3 with SMTP id adf61e73a8af0-3ccda98b5eamr11846226637.9.1787075859746;
        Tue, 18 Aug 2026 10:57:39 -0700 (PDT)
Received: from dhcp-10-123-98-253.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14153187de4sm16741958c88.15.2026.08.18.10.57.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 10:57:39 -0700 (PDT)
From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	ranjan.kumar@broadcom.com,
	sweeti.vandure@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Subject: [PATCH 10/17] mpi3mr: Fix out-of-bounds read in SAS topology change events
Date: Wed, 19 Aug 2026 04:44:19 +0530
Message-ID: <20260818231426.58105-11-chandrakanth.patil@broadcom.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260818231426.58105-1-chandrakanth.patil@broadcom.com>
References: <20260818231426.58105-1-chandrakanth.patil@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

The number of entries in a SAS topology change event is used to walk
the entry array without being compared against the amount of event data
that was received, so the walk can run past the end of the buffer.

Work out how many entries the payload can hold and skip the event if it
claims more.

Fixes: 13ef29ea4aa0 ("scsi: mpi3mr: Add support for device add/remove event handling")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 9af236e70624..94625e5f6af8 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -2819,11 +2819,26 @@ static void mpi3mr_sastopochg_evt_th(struct mpi3mr_ioc *mrioc,
 	struct mpi3_event_data_sas_topology_change_list *topo_evt =
 	    (struct mpi3_event_data_sas_topology_change_list *)event_reply->event_data;
 	int i;
-	u16 handle;
-	u8 reason_code;
+	u16 handle, avail_len;
+	u8 reason_code, max_entries;
 	struct mpi3mr_tgt_dev *tgtdev = NULL;
 	struct mpi3mr_stgt_priv_data *scsi_tgt_priv_data = NULL;
 
+	avail_len = event_reply->event_data_length * 4;
+	if (avail_len < offsetof(struct mpi3_event_data_sas_topology_change_list, phy_entry)) {
+		ioc_err(mrioc, "SAS topology event: event data too small (%u bytes)\n",
+			avail_len);
+		return;
+	}
+	max_entries = (avail_len -
+		      offsetof(struct mpi3_event_data_sas_topology_change_list, phy_entry)) /
+		      sizeof(struct mpi3_event_sas_topo_phy_entry);
+	if (topo_evt->num_entries > max_entries) {
+		ioc_err(mrioc, "SAS topology event: num_entries(%d) exceeds max(%d)\n",
+			topo_evt->num_entries, max_entries);
+		return;
+	}
+
 	for (i = 0; i < topo_evt->num_entries; i++) {
 		handle = le16_to_cpu(topo_evt->phy_entry[i].attached_dev_handle);
 		if (!handle)
