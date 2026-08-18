Received: from mail-vk1-f225.google.com (mail-vk1-f225.google.com [209.85.221.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B861D48425A
	for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 17:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787075885; cv=none; b=Ax8pS0KQyaf3w3Wmm+qJoftUXbk+kgQJ+lF1hoauBtvi6xK3+MIrM8WrqGyqgYP9+OMpa9Yl4IWf1FYsf7vTEk6v/PQNNYNtJ9hbGQLj8M3JIIgIwMFWW3G8hv4fARpTR7M6GK4f0BIi/KMwvOxZyq5HVsc5Ut/2fTx3+W6EuXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787075885; c=relaxed/simple;
	bh=8CHC80390IPAcgXNQpVC1rE+LNudgUaB9ICTgPF1Aaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oa7CRInpLX8lEH/R3GtfHpGwMpRYt3g8vaJttQyKREH05hBGGcXu8ycJYa8Z1/enzi50TFwoRJMaLYWg93s0y5Lz2rtZj4gWVDW7wzkLv8pO/XoFGmGBVoaXXcC8C8vcBh/35HW+Cw4MQPThxGWCdi+402aEZuvyuOc64PzdinY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=KmjeQTqN; arc=none smtp.client-ip=209.85.221.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="KmjeQTqN"
Received: by mail-vk1-f225.google.com with SMTP id 71dfb90a1353d-5c2c96286f0so58767e0c.3
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 10:58:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787075882; x=1787680682;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mE8scpz59s8WNQUmXSpXIDjZBFsbdT3cREyJ3Z+xOXI=;
        b=hzBSaVRbpwIyu0V2MIg9X0bBZpXc0SjJ+R3BXoaFHFhl3p11QKnYdSZjoKyLfUlTWg
         fDtWqgh7HT2ZpftsdiChy6pBARVV5SzpTMRZpF9dmMyIWNvhzwyItJU/KbJEcks/ZHrL
         60NJP/LDqBOJXDXOtSDB3WUW2+9Um5sLZWikaxII7JZOJaV0i7Cw3eleEtNZiCjF7gCz
         I/KLGwsxs/qA86DgcogNkbth3eULvLoFKjfpU02b5+UkRTy9SyGrXofZQluwYQKWq2n3
         ZuAWPRnsZHj1TJAPc+Mq7gTRPioemkKclDK6k1mtD36juF3ib+3XeXSoh0QtAvAfqZVA
         FoZw==
X-Gm-Message-State: AOJu0YwJiibdXvXt57Y8dFnGtz999Tt1AWpiz//s7KERl9DPhvGkBf5b
	IMKiZtkQ2Utpxn/XXnRL3BcIgZ+s63HFMFfMz/xIHXIztJ/WDaxFZ3ZYbmXmydQgYpqQ/rO59AF
	LkQDgjuvjAouWn4HQlfNq4s7exSCjE4oTn3elXEonB3Ac/pCdER2N7SD/BBwW1ejkIxxR2W3JgV
	F5k44Xvmq/0tlH8fZ368eNzL5AEAzuj8tSSGgaauPJ3k8aBLUj9qeiMSDpOS1qGMv5isYvtGaT8
	gvnHNX3ga+9XOpakiyOiVaA
X-Gm-Gg: AR+sD13/aDoYLskPyHyklCH+dAImu33RIwngFyJZbUD22E6q76fD9W2vn5VZqMDbmFT
	61po+VHiY2iTpFE+U0fsly1BLdHp5hw+CyH35g32wmOmHi1dFkIMAXdEGKBmsRXtWy654ouY+Np
	emIACNCpxYwKtR1fo97JYFxu/GpCw6cXMMT24jKa3AUpzw11QNQvk1BdXRQJO8LkeKiKJto1rnz
	hhnP1VfNvi8PMncFXRjdvy1klLwaOexjQAWOfB1kJQlEoMK73mglNWAMH1ob8MBsD6g6Q1OWCYx
	GO8hBLQE3lElGsEo2klTUgPEaF22T9gDLzp01tAiqkhUu0fZ/8tfQPplfv28kmOK5Dp7olc+Riq
	B9xxhuB/fT7RDCCY6uJImUmtuYDV5JjzSS2cv7DHCYHJ26lBqm+kUIngPYC60e4YSX1vBx6fngl
	CC07eHclff8zcN7iJvbnDR0HM53HtyEQUFzU6X/HP6ksY=
X-Received: by 2002:a05:6122:3c48:b0:5bf:a181:d46d with SMTP id 71dfb90a1353d-5c591c97fd1mr7704229e0c.3.1787075882339;
        Tue, 18 Aug 2026 10:58:02 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-16.dlp.protect.broadcom.com. [144.49.247.16])
        by smtp-relay.gmail.com with ESMTPS id 71dfb90a1353d-5c5d2e68ed2sm672189e0c.3.2026.08.18.10.58.02
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Aug 2026 10:58:02 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2d54187d8b0so2475155ad.0
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 10:58:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1787075881; x=1787680681; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mE8scpz59s8WNQUmXSpXIDjZBFsbdT3cREyJ3Z+xOXI=;
        b=KmjeQTqN9ROzIivZcGNz6FakH20Rfh5RUBMl5kfIUsBqFdNcCC84GptquoKE/GDzt0
         3LCZJH9Tt6a3imZTc9BXnsj4woqEra+Z0b8d7rDV/hRUNeO5Y15kFPP1RoCdPyfotnQC
         3li9CxUFXTDuq9sNsqo+q0lgCIcI8t61IGLsQ=
X-Received: by 2002:a17:90b:520d:b0:38f:5801:cd76 with SMTP id 98e67ed59e1d1-3933b6d0171mr42965723a91.3.1787075881051;
        Tue, 18 Aug 2026 10:58:01 -0700 (PDT)
X-Received: by 2002:a17:90b:520d:b0:38f:5801:cd76 with SMTP id 98e67ed59e1d1-3933b6d0171mr42965647a91.3.1787075880480;
        Tue, 18 Aug 2026 10:58:00 -0700 (PDT)
Received: from dhcp-10-123-98-253.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14153187de4sm16741958c88.15.2026.08.18.10.57.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 10:57:59 -0700 (PDT)
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
Subject: [PATCH 14/17] mpi3mr: Fix out-of-bounds read in PCIe topology change events
Date: Wed, 19 Aug 2026 04:44:23 +0530
Message-ID: <20260818231426.58105-15-chandrakanth.patil@broadcom.com>
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

The number of entries in a PCIe topology change event is used to walk
the entry array without being compared against the amount of event
data that was received.

Bound the entry count to the received event data before use.

Fixes: 8e653455547a ("scsi: mpi3mr: Add support for PCIe device event handling")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 6d4ddc78bcd0..00bd654d7f24 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -2753,11 +2753,26 @@ static void mpi3mr_pcietopochg_evt_th(struct mpi3mr_ioc *mrioc,
 	struct mpi3_event_data_pcie_topology_change_list *topo_evt =
 	    (struct mpi3_event_data_pcie_topology_change_list *)event_reply->event_data;
 	int i;
-	u16 handle;
-	u8 reason_code;
+	u16 handle, avail_len;
+	u8 reason_code, max_entries;
 	struct mpi3mr_tgt_dev *tgtdev = NULL;
 	struct mpi3mr_stgt_priv_data *scsi_tgt_priv_data = NULL;
 
+	avail_len = event_reply->event_data_length * 4;
+	if (avail_len < offsetof(struct mpi3_event_data_pcie_topology_change_list, port_entry)) {
+		ioc_err(mrioc, "PCIe topology event: event data too small (%u bytes)\n",
+			avail_len);
+		return;
+	}
+	max_entries = (avail_len -
+		      offsetof(struct mpi3_event_data_pcie_topology_change_list, port_entry)) /
+		      sizeof(struct mpi3_event_pcie_topo_port_entry);
+	if (topo_evt->num_entries > max_entries) {
+		ioc_err(mrioc, "PCIe topology event: num_entries(%d) exceeds max(%d)\n",
+			topo_evt->num_entries, max_entries);
+		return;
+	}
+
 	for (i = 0; i < topo_evt->num_entries; i++) {
 		handle = le16_to_cpu(topo_evt->port_entry[i].attached_dev_handle);
 		if (!handle)
