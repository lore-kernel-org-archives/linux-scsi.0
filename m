Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D00131722
	for <linux-scsi@vger.kernel.org>; Thu, 22 Feb 2024 21:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708638352; cv=none; b=bOvHER4RUT+ddvi+NCuJ1jyFb5TPyMynQJ6d0aOC4dxjCuqQVPnbjsxwoQ+4om7lgn1Rbf5FsAn/Dolgi92C1MqFydp/cxN+jIKC/8gJ7oOt/7mqNEn2l+Ur1rGCAMfIw9oxa4H1NVDlg5KPIfWEh2QC9CJNOsljrOMDfW8GYUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708638352; c=relaxed/simple;
	bh=pGSlucTX1aa7NSOV1toYrh+mVFV8y0R0cQ5zCPzahHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m1gOSnWkF3ajIm39DzUn8xx6+Y1RT4DYqeP7ZuW2rZEOE9B7m8kY+gKEPCRFqxsNbqeKS6nmWhmpSISkag+skjZTMVDhgNsyaXtBMkPF1YIm3B5Nbc5HxKPmtVTHCCo8hxVqxGbcaELeu6YXKFFwWRwRF74PY3ZjAAANxWBu9ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-6e47a104c2eso81648b3a.2
        for <linux-scsi@vger.kernel.org>; Thu, 22 Feb 2024 13:45:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708638350; x=1709243150;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e8d++JaxF6VU87K9paur+P9+uK/jbaFQAG39Cl7Itqo=;
        b=patRSZmzhOHCc3RVpIgi0qejtTHZ8G2YGUTOTogA8E/KW8DnmhV400EIBvTtnV3jZq
         qm8UatuGefSQYb7mWlbPkPPCIoWIgyuQsJCPb1gW2iPf2A8H1J01yj91DtCwHFJD/q8X
         N0DMYmvKQqboTJ31OxW09c/HGfezEE7zuFdjnCkoxC/dq4W/92YWrQjXZ587b6hvK3Av
         UhItgOSMoOyVs/VLnn50f1zE7gn2YYhv8opMVWFNDg7qRM9t7zEAE7j3TUxvkCcr2c7N
         RGi2PUNp9QG6aWNbaVi5qcm9p5mjr5XSfgZb/VPe24Q7DAw2XMEwtL1WR8Nct9rseGxD
         w46g==
X-Gm-Message-State: AOJu0Ywvx2yfCKCCqdirWWwnjHP/ldr5X3bCHXDorXgo//q9YFfT/RRX
	VGf/zse9AtuZrnQSAq2dorK6XwXHw2ixHu8RiPQAbw3hKgC0ig4XswiXsmVa
X-Google-Smtp-Source: AGHT+IE20CTHM5bY/kL7TZHCZhKRoNQv18BcD8pfPz4+mLKs0IPSntl7QETagxEQlANFrAigkZVRpQ==
X-Received: by 2002:a05:6a00:b91:b0:6e4:8c40:3f09 with SMTP id g17-20020a056a000b9100b006e48c403f09mr155086pfj.25.1708638350110;
        Thu, 22 Feb 2024 13:45:50 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:0:1000:8411:bcee:4c5d:88b9:5644])
        by smtp.gmail.com with ESMTPSA id a1-20020aa78e81000000b006e414faff99sm9598203pfr.180.2024.02.22.13.45.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Feb 2024 13:45:49 -0800 (PST)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Daejun Park <daejun7.park@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Douglas Gilbert <dgilbert@interlog.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v10 10/11] scsi: scsi_debug: Implement GET STREAM STATUS
Date: Thu, 22 Feb 2024 13:44:58 -0800
Message-ID: <20240222214508.1630719-11-bvanassche@acm.org>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
In-Reply-To: <20240222214508.1630719-1-bvanassche@acm.org>
References: <20240222214508.1630719-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implement the GET STREAM STATUS SCSI command. Report that the first
five stream indexes correspond to permanent streams.

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Tested-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_debug.c | 50 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index ccf59b3e7602..497045e54300 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -533,6 +533,8 @@ static int resp_write_scat(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_start_stop(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_readcap16(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_get_lba_status(struct scsi_cmnd *, struct sdebug_dev_info *);
+static int resp_get_stream_status(struct scsi_cmnd *scp,
+				  struct sdebug_dev_info *devip);
 static int resp_report_tgtpgs(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_unmap(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_rsup_opcodes(struct scsi_cmnd *, struct sdebug_dev_info *);
@@ -607,6 +609,9 @@ static const struct opcode_info_t sa_in_16_iarr[] = {
 	{0, 0x9e, 0x12, F_SA_LOW | F_D_IN, resp_get_lba_status, NULL,
 	    {16,  0x12, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
 	     0xff, 0xff, 0xff, 0, 0xc7} },	/* GET LBA STATUS(16) */
+	{0, 0x9e, 0x16, F_SA_LOW | F_D_IN, resp_get_stream_status, NULL,
+	    {16, 0x16, 0, 0, 0xff, 0xff, 0, 0, 0, 0, 0xff, 0xff, 0xff, 0xff,
+	     0, 0} },	/* GET STREAM STATUS */
 };
 
 static const struct opcode_info_t vl_iarr[] = {	/* VARIABLE LENGTH */
@@ -4573,6 +4578,51 @@ static int resp_get_lba_status(struct scsi_cmnd *scp,
 	return fill_from_dev_buffer(scp, arr, SDEBUG_GET_LBA_STATUS_LEN);
 }
 
+static int resp_get_stream_status(struct scsi_cmnd *scp,
+				  struct sdebug_dev_info *devip)
+{
+	u16 starting_stream_id, stream_id;
+	const u8 *cmd = scp->cmnd;
+	u32 alloc_len, offset;
+	u8 arr[256] = {};
+	struct scsi_stream_status_header *h = (void *)arr;
+
+	starting_stream_id = get_unaligned_be16(cmd + 4);
+	alloc_len = get_unaligned_be32(cmd + 10);
+
+	if (alloc_len < 8) {
+		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 10, -1);
+		return check_condition_result;
+	}
+
+	if (starting_stream_id >= MAXIMUM_NUMBER_OF_STREAMS) {
+		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 4, -1);
+		return check_condition_result;
+	}
+
+	/*
+	 * The GET STREAM STATUS command only reports status information
+	 * about open streams. Treat the non-permanent stream as open.
+	 */
+	put_unaligned_be16(MAXIMUM_NUMBER_OF_STREAMS,
+			   &h->number_of_open_streams);
+
+	for (offset = 8, stream_id = starting_stream_id;
+	     offset + 8 <= min_t(u32, alloc_len, sizeof(arr)) &&
+		     stream_id < MAXIMUM_NUMBER_OF_STREAMS;
+	     offset += 8, stream_id++) {
+		struct scsi_stream_status *stream_status = (void *)arr + offset;
+
+		stream_status->perm = stream_id < PERMANENT_STREAM_COUNT;
+		put_unaligned_be16(stream_id,
+				   &stream_status->stream_identifier);
+		stream_status->rel_lifetime = stream_id + 1;
+	}
+	put_unaligned_be32(offset - 8, &h->len); /* PARAMETER DATA LENGTH */
+
+	return fill_from_dev_buffer(scp, arr, min(offset, alloc_len));
+}
+
 static int resp_sync_cache(struct scsi_cmnd *scp,
 			   struct sdebug_dev_info *devip)
 {
