Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793881467;
	b=Rbb8kICYwecZ4Q4YeBAm43oqcTvGQt8GXSGgqcvHuwpoYnhqR2HBGy7GMU0zMlk2KRmb
	 8D49TS24HHRhi9R85FZIXr5HU45ACuVsJcB1dPMnI4elNUlDc1P6uL+JfTR6QbwgLDHWH
	 fjZau09htdx9dTQkxZrUoOWplLz6D3ZmaT6flim9QbJxECGbMDAsl4w9HKhmt9l+phYVK
	 GZMsle5qxkfmsZFgLs4RlxRmC9yBIc1fXkORtIlo2mnIdCE9fVmSVV94cPoAIoCuf7mSD
	 14y8odNFokGpO84yl9+nqdesijrQIM5ruTCeGzbCU9c6uR43/is9mMgLzejI9e40ESw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793881467;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=hZJeiaVH/GjKAUQoaK3P09WiycS+5a3Fe5WXL/jdsOg=;
	b=N8xEQ4Kpv5wFBhyepymQe5ebM3KYCX2+XSIeAhr8G8cyCrA1fefq9s8lQ3biNXx+HC2j
	 g6fLpV3AgfHU2pSghxZa/kB7W3cOcfQEiV/lesRM+qz5sZwepxfeKVqP9HYlvGROYqm/W
	 lYzncP2sbRMKTJe6EkVJB+0VTjmGG67HGj7lzSqw8xhuAfL1x3BjNNZjnV9wNhmUEVdX0
	 dn7DuKyqx5pe89EI+va3F51oWYWusI0nxc0Oyn0aaynHUltn+OYNX0H7BJyC9DbjfLPdX
	 KXjP7PHox2GfqJPRRkagt4q+ixwFk9EUgewtqLHzeFfau4/2L7kk2oDaEXbCg1LArjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=fWLawPGv;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=WUEioGiP;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09E7606A32C
	for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2026 12:24:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C09E7606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=fWLawPGv;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=WUEioGiP
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793881460;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hZJeiaVH/GjKAUQoaK3P09WiycS+5a3Fe5WXL/jdsOg=;
	b=fWLawPGvwtzWNqtc7PV7MO2zVqNlqTs3wbKfQnklMc/HOkrCY69lD1DR/IWV7e6eZdC47Z
	C62xsu221DI8A3OtDiKliD6lyCozx0XX5ie/OGFFvfhKqgze9jC1IM8ZqjUuvL3Q19/5I+
	ACFhGUObbYibDCVR9Hm4YWAZuY57ltw=
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com
 [74.125.82.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-425-iKmSbYPjNV-V8r16ZkUnvQ-1; Thu, 05 Nov 2026 07:24:19 -0500
X-MC-Unique: iKmSbYPjNV-V8r16ZkUnvQ-1
X-Mimecast-MFC-AGG-ID: iKmSbYPjNV-V8r16ZkUnvQ_1793881459
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-36998507c13so2165033eec.0
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 04:24:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793881458; x=1794486258; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hZJeiaVH/GjKAUQoaK3P09WiycS+5a3Fe5WXL/jdsOg=;
        b=WUEioGiPHxZI4O9j0y3J+cdPJ0b5ZAjlJyTd6Lx0mCFlCFL2w09wpc7YehmYg1VN+O
         cwFFLm1q3mT6GbbvyJNU9X13JlcgELvx8075n53p+aqvkcuZF4eErBKkJmFYPg4ri59A
         FIgw43Iq/i5wb8CQwbVatwvo6Y4SDbVMITBO8kgQbUn8DdDTk25UJNRjKscmeeCW+0NY
         Kuf41VIGe8/oqU65i+COG4yNsz6+smfP8OGOQOJlznm11oETrvC08hSw4pQe8jINkfiq
         PYjyw61lTbXhr1HZuzG4HRnLXYtnfY3LRMb6geFHRSl++Pvl2xvm6FtlU8980ip0rXUT
         6x1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793881458; x=1794486258;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hZJeiaVH/GjKAUQoaK3P09WiycS+5a3Fe5WXL/jdsOg=;
        b=zoLtDWgBzMowC5iOWODV98iFD4Cs5FgBJDPYNWhM3QIvkIBssSfSGV6L0b/7FcymUW
         zZWhrClSkaG7mVf5VtfFyzDCMpCFq0E66x49FnucrRSAXS0gvoezfyAO/e2oOUvER6hF
         6nRK1v5JLFo+PRaPrQyUAu3rFo0t+MVLAveLCbr4X46Eys/r+knuJH8IvwMz1E7nlt0I
         DbhEVCZyCmp/qjuz51oZibU1GkORbFvuo42aZs0YINh/ItcRa23LceLRuROq7v3ufHbX
         J3aWWbSV87HL503T1fC5oieqxnVPnV710p0CIC6ehXCp295zRxBADwg1WgItTROJn64J
         thEA==
X-Gm-Message-State: APuU4Z85xov8bBGXdHBk6OeiL4Og2y3K1veNHW/MUoM/BUFqfwGdo/NN
	dbq+JX9PLHPP/NSo06u7bWvQT5E+akfebriDYKJowVFVhl5clznOPQLmDyToTy6bHXftOk+VIgi
	iH706mbsamI2qdnI/C8st4ia6RGuneRCiYUtjM/twFShlN31qolmFpiR3r9z/rmk=
X-Gm-Gg: AYBFou21jitL4ci9k0zO66Q2VI/bhObqurv5LpgLHD62dIv/gwMeLBwkB+8sV6V0HZX
	2GvPYQelAInuodF0CMGpHu+CTPLnmXaXk11S6T65vBvX+opFQzt12/CZmJfymnW0bZ3jZiwvYRn
	O3NT0OrB2c+E55g/Fdzc0t4wkCXb1FwOOeYFPtvFuZAAcli4UxBPf9aEZj7M/WllN/jRgNa7Rzq
	/mqtzLR+ek+1oq1fckZaf+blc7XhsZ9sXbxabtzivg8nLEz/5vZqXV+R9edmnvLjh3Ci9R4jYGE
	t7aFYBMQ+hdysT514NIePvDQdUBDs7A4q5lA9gjneU2HlvxpYTGzEDF+wfMFErGPffGd6cie/e7
	qXYoQnMMkmLPdm5g4tKZgzsyRy80LQHmMOkKIuDdnJKgwDiZDvcfHVdkehn4z6m+qj0s/P8P2be
	fsbHebwiMQ7riaT6GYaYB5eH/2UuW8OWDFBBVAgKA=
X-Received: by 2002:a05:7022:1707:b0:183:3c2a:ae8 with SMTP id a92af1059eb24-1ac5cb19462mr26201846c88.41.1793881458103;
        Thu, 05 Nov 2026 04:24:18 -0800 (PST)
X-Received: by 2002:a05:7022:1707:b0:183:3c2a:ae8 with SMTP id a92af1059eb24-1ac5cb19462mr26201813c88.41.1793881457405;
        Thu, 05 Nov 2026 04:24:17 -0800 (PST)
Received: from mgandhi-thinkpadp16vgen1.redhat.corp ([2401:4900:88fb:e4bc:f699:bfa1:8ae:63f7])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245b8822fsm19713431c88.2.2026.11.05.04.24.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 04:24:16 -0800 (PST)
From: "Milan P. Gandhi" <mgandhi@redhat.com>
To: sathya.prakash@broadcom.com,
	kashyap.desai@broadcom.com,
	sumit.saxena@broadcom.com,
	sreekanth.reddy@broadcom.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	mgandhi@redhat.com,
	stable@vger.kernel.org
Subject: [PATCH v2] scsi: mpi3mr: Validate reply frame size bounds
Date: Thu,  5 Nov 2026 17:54:01 +0530
Message-ID: <20261105122401.266559-1-mgandhi@redhat.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261103123316.223917-1-mgandhi@redhat.com>
References: <20261103123316.223917-1-mgandhi@redhat.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Firmware provides reply_frame_size in dwords, which the driver multiplies
by 4 to compute facts.reply_sz (u16). If the reported size exceeds
U16_MAX / 4, the multiplication overflows u16 before assignment, causing
under-allocated DMA reply buffers.

Furthermore, several paths assume a minimal reply frame size:
- logdata_entry_sz calculations underflow or hit zero when reply_sz <= 20
  bytes, leading to zero-size allocations and divide-by-zero crashes.
- Unsolicited status descriptors and fixed replies (such as struct
  mpi3_iounit_control_reply, 64 bytes) require at least 16 dwords.

Validate reply_frame_size in mpi3mr_issue_iocfacts() to ensure it is
within [16, U16_MAX / 4] dwords before processing facts data.

Fixes: 824a156633df ("scsi: mpi3mr: Base driver code")
Cc: stable@vger.kernel.org
Signed-off-by: Milan P. Gandhi <mgandhi@redhat.com>
---
v2:
 - Check lower bound (16 dwords) to avoid downstream underflows.
 - Add MPI3MR_MIN_REPLY_FRAME_SZ_DWORDS define.
 - Clarify commit message and error message bounds.

 drivers/scsi/mpi3mr/mpi3mr.h    |  1 +
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 18 ++++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index d6e16707fd97..e78383df619c 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -83,6 +83,7 @@ extern atomic64_t event_counter;
 #define MPI3MR_ADMIN_REPLY_Q_SIZE	(8 * MPI3MR_PAGE_SIZE_4K)
 #define MPI3MR_ADMIN_REQ_FRAME_SZ	128
 #define MPI3MR_ADMIN_REPLY_FRAME_SZ	16
+#define MPI3MR_MIN_REPLY_FRAME_SZ_DWORDS	16	/* 64 bytes */
 
 /* Operational queue management definitions */
 #define MPI3MR_OP_REQ_Q_QD		512
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index f0d3cd398dd0..60a92366e590 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -3261,6 +3261,7 @@ static int mpi3mr_issue_iocfacts(struct mpi3mr_ioc *mrioc,
 	struct mpi3_ioc_facts_data *facts_data)
 {
 	struct mpi3_ioc_facts_request iocfacts_req;
+	u16 reply_frame_size;
 	void *data = NULL;
 	dma_addr_t data_dma;
 	u32 data_len = sizeof(*facts_data);
@@ -3318,6 +3319,23 @@ static int mpi3mr_issue_iocfacts(struct mpi3mr_ioc *mrioc,
 		goto out_unlock;
 	}
 	memcpy(facts_data, (u8 *)data, data_len);
+
+	reply_frame_size = le16_to_cpu(facts_data->reply_frame_size);
+	/*
+	 * Validate reply_frame_size:
+	 * - Must be at least 16 dwords (64 bytes) to accommodate fixed reply
+	 *   structures and avoid underflow/divide-by-zero in logdata sizing.
+	 * - Must not exceed U16_MAX / 4 to prevent integer overflow.
+	 */
+	if (reply_frame_size < MPI3MR_MIN_REPLY_FRAME_SZ_DWORDS ||
+	    reply_frame_size > (U16_MAX / 4)) {
+		ioc_err(mrioc, "Invalid reply_frame_size %u (must be %u..%u dwords)\n",
+			reply_frame_size, MPI3MR_MIN_REPLY_FRAME_SZ_DWORDS,
+			(unsigned int)(U16_MAX / 4));
+		retval = -EINVAL;
+		goto out_unlock;
+	}
+
 	mpi3mr_process_factsdata(mrioc, facts_data);
 out_unlock:
 	mrioc->init_cmds.state = MPI3MR_CMD_NOTUSED;
-- 
2.56.0

