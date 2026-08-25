Received: from mail-pj1-f100.google.com (mail-pj1-f100.google.com [209.85.216.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB0331F99C
	for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 15:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787672717; cv=none; b=NVUj+GJ81mBjnnmhDBbWYbxOSXDBcpal8Eh4h6lLMJdREV1dA2A1rCb0mRyu/EMX63zTl8OkvfzrFQmMCW7OafbbLy0oZNkDwqoXAYvIc0bQ2CtMu3cp7x/2U0cUr2uCWoOoLQb9Q+B4ZHqCb3Om37NjyoF1ssLlpAtZPQmkH6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787672717; c=relaxed/simple;
	bh=TXn+KX+9sb655B874wY75OlngMa4JQUx6lioc+Ghv2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MNFlNpkfq9Z4WwFnX6/voqrvV+y9r02eTE0BjlMVk+qA3VTYaUXtIKqvqnhjLA5AjFKdx33/RO1nAswTPvrKueyrNdZoFV/SDBG/qRAXWnOwVj/8viNbHONWnpumZS4X1CB1GoXHSK9VG1nwgf7y5Fx/ou69t2lhKkkjl30+s5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=MqZi5ewq; arc=none smtp.client-ip=209.85.216.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="MqZi5ewq"
Received: by mail-pj1-f100.google.com with SMTP id 98e67ed59e1d1-38ea87caafeso3790870a91.3
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 08:45:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787672715; x=1788277515;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5SG68dDupXfLaorzhNW0d/2ss11Voe2ZELst7K2mj+8=;
        b=PvmP3qduTlxdzLjSS7twK3OqiES48mn09JIoJZKIWfH0fKVQd8xB+6yCkViYxwZ9z6
         AWMQeOO25BJgJHH7Nz/v5v0Gc2HOxrylAliF1l6sSWDi+iGOgOKDD+oBqt9KJcAMmh7l
         jD6MSRud0oLivwL78viJQsIsBT0TM3L3OYsS989TJIgQAb5qT+0EfcYDSw0IX8OPVBTF
         /T31EOjze4ovv1/OK48A9jCATdL0yc0GRTd4wYUY1dZO9pdOd8moThayloxAt6CpUQ+R
         LrvsdFrI67WbwtKxH6puhr8rc/8/SVyEX91dDvAf0iUNpH3KTuzbrZx9koLqgoReCpSR
         hqgg==
X-Gm-Message-State: AFuF++nEHqdhcHIthF2iz0gyCk8da8JApeZon3PweRSug3Fw+9u180Qj
	UO/6q+dqZBojafkQW5X1nhuRzaMGrxycJO66ytAw3GHHJylQShT44qvWFL//X7lAeA0l6tyYf4G
	+UJ4FN4w+yHomMCJIQc/wAgeOuAjMYSu047neI4qdjYWBxv42smqNOirAJ7MsCKcsh4q5v01Bqy
	iICxoUiuRZ+ByueuEmnhNWbG2E4LsOSVGMY1lQJaTiBMpDzRGGyDBVEx1M6NiLN1Wn+nz3/LJkD
	IEb+gSjTmDpnHh+9vm1hQsf
X-Gm-Gg: AR+sD11/T76mdA2Xy1URDFA/lqwy7kKUmDS/k72F9KEkZP8BZ27H58oYXqk2IVPkgbt
	DUXdCUlMWXAvQ9phoRU3YkAGGjdApGpkoMHR1mpCEvbvjZDTGmZOO4OpN15WHELa13j9daVysDz
	fBn3LgcxyT1HUBRoEKFm+Y7jrV0Lv333padLXt7PPW2PPCPTPxUPnATh8kwmjAU04wO+hZ2qJX9
	tfwwzBdCJ+bvpn/d5xa+FIh1/WXsZAYWLVMRwImMqcwDcAOJl0KPirpJ2T38akBgCXlmzKSL0rz
	By2yk0PgAsXhJtw1RzRmiCOWZzEoMcY6jSl2OXZPHiwbsFB2OJoZBodPmtkAPS0XUGOKqUri8GI
	mEvWTo7hPcW0wj52/yQ9ea7JiktkBPmouLBNeel//ke+I5ruaUmgjKCE4rqhLT7cKc9XQvjKmKv
	8sddbC4xguCIrv4bnkz+agMTrO9g+W6ZvBamz3RFaKzcA=
X-Received: by 2002:a17:90b:2c88:b0:380:f85c:94b4 with SMTP id 98e67ed59e1d1-3966d20e7aamr210417a91.7.1787672715407;
        Tue, 25 Aug 2026 08:45:15 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-20.dlp.protect.broadcom.com. [144.49.247.20])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3966871dd1bsm97063a91.4.2026.08.25.08.45.14
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Aug 2026 08:45:15 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38e4758ab46so16311a91.0
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 08:45:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1787672714; x=1788277514; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5SG68dDupXfLaorzhNW0d/2ss11Voe2ZELst7K2mj+8=;
        b=MqZi5ewqZd7ST60VJqXFkctWF6FvLcKeXHjkcksjWF7Y4nsffj5yRLNa+vxba2Rp5J
         H56XowhsNMmFO8WRz7ehoEpvKxr62IvBzwMdgYrCsMDSxUUKlF7MZpslaiVwKBFHxzq/
         nyb8T8w+kd6hwz9fkY+L2OBg8YDUKh/dxMfaU=
X-Received: by 2002:a17:90b:4a8d:b0:381:28e0:6259 with SMTP id 98e67ed59e1d1-3966d412ab2mr115280a91.9.1787672713702;
        Tue, 25 Aug 2026 08:45:13 -0700 (PDT)
X-Received: by 2002:a17:90b:4a8d:b0:381:28e0:6259 with SMTP id 98e67ed59e1d1-3966d412ab2mr115122a91.9.1787672713019;
        Tue, 25 Aug 2026 08:45:13 -0700 (PDT)
Received: from dhcp-10-123-98-253.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327f9209fafsm63445311eec.23.2026.08.25.08.45.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 08:45:12 -0700 (PDT)
From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	sumit.saxena@broadcom.com,
	sweeti.vandure@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Subject: [PATCH v2 14/17] mpi3mr: Fix out-of-bounds read in PCIe topology change events
Date: Wed, 26 Aug 2026 02:34:08 +0530
Message-ID: <20260825210411.301535-15-chandrakanth.patil@broadcom.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260825210411.301535-1-chandrakanth.patil@broadcom.com>
References: <20260825210411.301535-1-chandrakanth.patil@broadcom.com>
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
v2:
 - Cached num_entries in a local variable before bounds check and used it
   for the loop condition to prevent re-fetching from DMA memory (TOCTOU).
 drivers/scsi/mpi3mr/mpi3mr_os.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 65a6192cf396..543e9b8e3fc3 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -2761,12 +2761,28 @@ static void mpi3mr_pcietopochg_evt_th(struct mpi3mr_ioc *mrioc,
 	struct mpi3_event_data_pcie_topology_change_list *topo_evt =
 	    (struct mpi3_event_data_pcie_topology_change_list *)event_reply->event_data;
 	int i;
-	u16 handle;
-	u8 reason_code;
+	u16 handle, avail_len;
+	u8 reason_code, max_entries, num_entries;
 	struct mpi3mr_tgt_dev *tgtdev = NULL;
 	struct mpi3mr_stgt_priv_data *scsi_tgt_priv_data = NULL;
 
-	for (i = 0; i < topo_evt->num_entries; i++) {
+	avail_len = event_reply->event_data_length * 4;
+	if (avail_len < offsetof(struct mpi3_event_data_pcie_topology_change_list, port_entry)) {
+		ioc_err(mrioc, "PCIe topology event: event data too small (%u bytes)\n",
+			avail_len);
+		return;
+	}
+	max_entries = (avail_len -
+		      offsetof(struct mpi3_event_data_pcie_topology_change_list, port_entry)) /
+		      sizeof(struct mpi3_event_pcie_topo_port_entry);
+	num_entries = topo_evt->num_entries;
+	if (num_entries > max_entries) {
+		ioc_err(mrioc, "PCIe topology event: num_entries(%d) exceeds max(%d)\n",
+			num_entries, max_entries);
+		return;
+	}
+
+	for (i = 0; i < num_entries; i++) {
 		handle = le16_to_cpu(topo_evt->port_entry[i].attached_dev_handle);
 		if (!handle)
 			continue;
-- 
2.52.0

