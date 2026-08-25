Received: from mail-pj1-f99.google.com (mail-pj1-f99.google.com [209.85.216.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2262933938C
	for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 15:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787672673; cv=none; b=Q8TdHN5QQLeZUuKZfYRaGC0JA5Q8L8kBAJ77yK2tQ7/GdD62gJId98NDUEiuAixmfhxTXtqVM0cv6OCHqZItfKaAVdOhtcFEX8R0cmkN4y2GasbmK33G25IPkgLTvFKRKJVlkVNF7c85+i0G3T8RQAdINF5RsoXKXIvb7ivowD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787672673; c=relaxed/simple;
	bh=Z3KvurDE21sNszh4z+wzb9pouTSUUHJW2q+ZuN1yS4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VS/YLeoi+ZCKsHE2/aIP0EXrnSCJLLH0PL6hLtrRwomPpqcf5haxnc+/lXS6U4W5CYZcMJDJglanchilpMl93chdl8qYPOp0HOIBOSUQihzXyCRlPgYza3tTSMv4j4kh5dMOVUJ8qb4Fha7L3CzhJ2gX+Emt0PLpAAr5jQ+Vt5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=gKKvpvEL; arc=none smtp.client-ip=209.85.216.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="gKKvpvEL"
Received: by mail-pj1-f99.google.com with SMTP id 98e67ed59e1d1-3900e39d935so5394388a91.0
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 08:44:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787672671; x=1788277471;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JTY0R0nKef6JrgsduGvudwoAwNZrsLBIUFMHnZ0aViY=;
        b=Usj/CPCY0psY41Zt3GtarXcHR7QF0vI6E2SRZK36GqpOapiIHp2cc8Nuwebkh9rS+S
         WFgBkhwedbitNFLfU+etWyJ2yOWSb0HRRAJUjm1IUpW+9C2OLDhMr03fFG/L2eVmwGK0
         I+9ddM/xcxfRSGD6Q0ku7/vx5yo+kX0eIXKSxFtZhvAz+K0HdUPsPFq7/ytqJK/xCbxZ
         iXWJnkYmgQXROkZ6DCahlXly8Tsbu5PKoo7F/VMlrS3Edy+BMn2YyVxw9ywYOKCh9XNd
         7wFDc86E/SyB74Oci+kh/0usDNpJ/Y5d76sd4kDg6Y7anRZnu7DAQTFdrpF5LycSc3pl
         0FFg==
X-Gm-Message-State: AFuF++l/T4gdr9Di4pSv9vwGHYu4WyBD1ULjFQDT+V9wios3gi34KrPL
	/geAHD6P7FGYGnL51dwUHGLqhOGOiXsX58cx8HH6NayZotjUTLm8p9ER2MThQ4GnTkrm4mTmGBf
	cIioHaiJLoHLD+XvFA8qY0399ZtBfZYxS4cZxywllxgunRmdNCk/xazZ/GXLSaD8I8EgCrWzcre
	OPG40tAUMIhATgDiqktEhfX9aUGES0spcxJD6cFqS+3kvfj7eHe7v7f8VN+jWscIs5Myi6c/4Xp
	QH08aeKS2sj0Fq83YEGFcVT
X-Gm-Gg: AR+sD11CcffnKgnSNutKQjNIWtBMzPW8auw1KZGIR/fFSCfGi02czjLDyHEtJQJrWKB
	yhXJ7D5FlNfi0vY+eYSFJE5QJ/vHAGzupl1ZWqhji4CI/swDlSLKIOZb9Bz1iJvB1p5HdQ0IsmE
	4ajcTe98elGa+3gqadvacZl59ZwIDmeObtmz+ByWIbnJunKMde6UxzZbopjDIlEoCEY3PX0QMyO
	QFIQmNgJug4ps3LJxB+EmUVQbeWqMxzryd6N3AIxOtLB69mR1paSV7D9a+ySC+tXFLHOktUKxb+
	bS8z1d9Jhr5xtToN/hQiK88cGtrE48yTbnwKfd8wMy+7eF+7lA0Kuqn5yNt38dI5sWpFFwDYNR1
	YajB+XBkr23inwZRjZi6sTZ0OvGg45AS4tAriROhdojHM64ukBEz6C50F9C0omV1xh2ukpaXxPY
	ovEzRGZS4dxCLrMFnv2y0PeNqSb8c1R0JtPOMOd9tzMR8=
X-Received: by 2002:a17:90a:c107:b0:381:a766:efc9 with SMTP id 98e67ed59e1d1-3966d412aa5mr112526a91.7.1787672671216;
        Tue, 25 Aug 2026 08:44:31 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-20.dlp.protect.broadcom.com. [144.49.247.20])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-39645cadcfesm1515288a91.11.2026.08.25.08.44.30
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Aug 2026 08:44:31 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38ea32e57e2so10560888a91.1
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 08:44:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1787672669; x=1788277469; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JTY0R0nKef6JrgsduGvudwoAwNZrsLBIUFMHnZ0aViY=;
        b=gKKvpvEL2itgKrV2wOLGL1DmEArXUrg9FieI5wwzmBbHZQQvrclJJEMsbL5vvHbjF/
         vWOFl8JAuZBJhmpBkL68SCdHvzFxrZZtusnWvK4DpVcdS9rTTU07euj45M5H0OTh6cVo
         9JmPImBnTwpknZDG8MIzi/knVnm8u9AI1Slso=
X-Received: by 2002:a17:90b:5626:b0:38e:5964:97a8 with SMTP id 98e67ed59e1d1-3966d4700dfmr78052a91.16.1787672669508;
        Tue, 25 Aug 2026 08:44:29 -0700 (PDT)
X-Received: by 2002:a17:90b:5626:b0:38e:5964:97a8 with SMTP id 98e67ed59e1d1-3966d4700dfmr77890a91.16.1787672668778;
        Tue, 25 Aug 2026 08:44:28 -0700 (PDT)
Received: from dhcp-10-123-98-253.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327f9209fafsm63445311eec.23.2026.08.25.08.44.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 08:44:28 -0700 (PDT)
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
Subject: [PATCH v2 05/17] mpi3mr: Fix buffer overflow when caching log data
Date: Wed, 26 Aug 2026 02:33:59 +0530
Message-ID: <20260825210411.301535-6-chandrakanth.patil@broadcom.com>
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

Each log data slot holds a header followed by the payload, but the copy
was sized against the whole slot and so wrote one header length past
the end of it. Subtracting the header on its own is not enough either,
because the entry size is derived from the controller reply size and
can be smaller than the header.

Work out the payload room first and clamp the copy to it.

Fixes: 43ca11005098 ("scsi: mpi3mr: Add support for PEL commands")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
---
v2:
 - No changes from v1.
 drivers/scsi/mpi3mr/mpi3mr_app.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 94b992acb233..cd772b2cb98a 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -2947,7 +2947,8 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 void mpi3mr_app_save_logdata_th(struct mpi3mr_ioc *mrioc, char *event_data,
 	u16 event_data_size)
 {
-	u32 index = mrioc->logdata_buf_idx, sz;
+	u32 index = mrioc->logdata_buf_idx;
+	size_t entry_payload_len, sz;
 	struct mpi3mr_logdata_entry *entry;
 
 	if (!(mrioc->logdata_buf))
@@ -2956,7 +2957,12 @@ void mpi3mr_app_save_logdata_th(struct mpi3mr_ioc *mrioc, char *event_data,
 	entry = (struct mpi3mr_logdata_entry *)
 		(mrioc->logdata_buf + (index * mrioc->logdata_entry_sz));
 	entry->valid_entry = 1;
-	sz = min(mrioc->logdata_entry_sz, event_data_size);
+	if (mrioc->logdata_entry_sz > MPI3MR_BSG_LOGDATA_ENTRY_HEADER_SZ)
+		entry_payload_len = (size_t)mrioc->logdata_entry_sz -
+		    MPI3MR_BSG_LOGDATA_ENTRY_HEADER_SZ;
+	else
+		entry_payload_len = 0;
+	sz = min_t(size_t, entry_payload_len, event_data_size);
 	memcpy(entry->data, event_data, sz);
 	mrioc->logdata_buf_idx =
 		((++index) % MPI3MR_BSG_LOGDATA_MAX_ENTRIES);
-- 
2.52.0

