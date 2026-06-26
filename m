Received: from mail-pj1-f98.google.com (mail-pj1-f98.google.com [209.85.216.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6280D2EDD6C
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2026 11:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782474531; cv=none; b=VzOfNlT+ECQ4eW48gZ8TVyPkJ04YPvfp7MmL9NVehDZRmpqxCfDCaHfinPW7guCYxv2jpWdFA+c8BkdPK4JsjRHBjs9XTrrjAWwclX5/Fu6Xnq2t9783TYC2Q3zPAmUOH2N1Z4D+zAKgC8JKptkhmPdcmmC4hHGshbpWVry0ktk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782474531; c=relaxed/simple;
	bh=8OBlmmNLzGqN3ORbTuVH8r5No+laUHf6GHFXWAPkW5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W26kMqLCo9n/V1mHcwqWgo1z8t29M0as07DtgqprCvoVjhQl0OgcanN7w8yL2icINPgrEiw+n1KiAszgr/t8TsPqg2Ir8aCh7Djvrvjp4AJWOwSbKETeetRPeLfHI2eNRSQat9GBTTk9AqmfoCn7yN7bkVnvM1V/0opfuj7wtVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=B2xxLiZD; arc=none smtp.client-ip=209.85.216.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="B2xxLiZD"
Received: by mail-pj1-f98.google.com with SMTP id 98e67ed59e1d1-37df6d9ec2dso392158a91.3
        for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2026 04:48:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782474529; x=1783079329;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CabAgbBN0lnoPQkWEjJ13P5DmIdEOfvqX1ItqvUsc3Y=;
        b=pt4zsG415lCcsAPhtHl+bNu9a8cMNDS0ndaOrphDR08PKiGLxJOA8c8qXo5khg+gFO
         J1NJmeZeZ8PUhip4xgCA2jeyABzNequvntRf+gNr507PVC1bNDIagWDunefCk2CEWGh2
         dgB56FeqJ0IVjnNYWrGhI6OurnUylbriG/6mV85SCS3c0tSIc5jsJpSm/inrHgbrRok3
         U+XWNyQR2DzWGyBY48vzQag84n2ZZW5GG9cB58Ed3JOXwVYqy6418YqidiLy6eY60mGj
         sDXv/4QVTI6jBHXtYrkJ6/HgocyHPHLEOBEDCSF85RNmeEWefd1MzLLkVbEDjjG9eQYx
         nHcw==
X-Gm-Message-State: AOJu0YyfOAK2qnx2rfXxLqtE+ZqOOHxwfqumIGb9y0eb4RzBl1Z5lOn2
	2sw7xXmK0xIuFdODy2VmwMYIGXq4X2shETWOHaHIDtUCvjYQBr6KLWH4WNjNxkErXNcWRORPxV/
	Tl5pONcxeNiVrqMrF5w+uL860CiwcXLj2jDqrXppvcXsMx4oum8hVOYWbH9vkHWlRVUxCYkk6ou
	gaV71PVUWIXnTBhHkIn0x1XT/+Pwp1E/4mS3XwnolvZgB1DjFYbmFAmaxmr/UgVpmr5jxuhJhEZ
	X58ACQDQYqgrlWV
X-Gm-Gg: AfdE7ckxfdnqWHjBEujBupBVhBrmhDo/xaqOjnCNGSw7HnNlNHY3U0n5wdiMM5tz32B
	VPr6pywI2AJQSgttAP6mc/gXtZ5DCWeKwgViGO4JN0qJjMlfDwWJC9sjsP6HBDkWfznvOB+Hjmp
	2xeKCbEn7hcnGDWzyZ6lNcX9pyQQ/Zb7V0G5auMik6LRzalQWCEAfOoMUueQ8lPiJJ2i2LG8SY4
	xgE4R2q6nmTmUTuPcozW0gkRHZZksry7r5fVGk1h9I0FZW3ouW+wdcOec4KtGAY+4CqpHQXBeLQ
	9oSaBVeutj6eFBzsoTXGohVvuPZOmarjYrjKXDwrywVHJNTpjX6SeHFcU2U+6vz9kMVIBjALkaT
	/r68UnREr8Ea4WvVvIqNS1IAmJS8IObk+yKlEdD9XbCbI+ZecbDcUaZ2qYA6fwg9BbtZNKZIZNv
	aV1jMTAPM+ZQuBiUBvFPJ1EYJj2x8wzFYgEihK0KYYihFtwg==
X-Received: by 2002:a17:90b:58e8:b0:366:3517:1aa2 with SMTP id 98e67ed59e1d1-37df9ec8ccamr6509966a91.0.1782474529390;
        Fri, 26 Jun 2026 04:48:49 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-25.dlp.protect.broadcom.com. [144.49.247.25])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-37f320b94a3sm39899a91.4.2026.06.26.04.48.48
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jun 2026 04:48:49 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-30c0d568830so4004125eec.1
        for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2026 04:48:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1782474527; x=1783079327; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CabAgbBN0lnoPQkWEjJ13P5DmIdEOfvqX1ItqvUsc3Y=;
        b=B2xxLiZDwfl4hOjI74JlGNYEhVr5nVqtdlTaW/KpEu3TTwLCVKuYicrG6994ZBRBLW
         s24VqPMg5D7uhMxBDi3d02pD3Jm1ezSiweyc813si2qUGw2UqAli4p3+NpsvN/GfL/6a
         4CiuWNgDYbXnGN31QxJd3C5WFgfAtPr6zflT8=
X-Received: by 2002:a05:7300:fd07:b0:30b:d31f:1577 with SMTP id 5a478bee46e88-30c84e596bemr7420754eec.34.1782474527581;
        Fri, 26 Jun 2026 04:48:47 -0700 (PDT)
X-Received: by 2002:a05:7300:fd07:b0:30b:d31f:1577 with SMTP id 5a478bee46e88-30c84e596bemr7420709eec.34.1782474526778;
        Fri, 26 Jun 2026 04:48:46 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c7c58831asm18844838eec.13.2026.06.26.04.48.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 04:48:46 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 06/10] mpi3mr: Fix memory leak on operational queue creation failure
Date: Fri, 26 Jun 2026 17:11:05 +0530
Message-ID: <20260626114109.43685-7-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260626114109.43685-1-ranjan.kumar@broadcom.com>
References: <20260626114109.43685-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

When operational queue creation fails after one or more queues have
been created, the error path frees the queue information arrays but
does not release the DMA memory segments associated with the created
queues, resulting in a memory leak.

Free the allocated request and reply queue segments before freeing the
queue information arrays.

Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 32aeae20481e..88444f04fb6a 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -2529,6 +2529,10 @@ static int mpi3mr_create_op_queues(struct mpi3mr_ioc *mrioc)
 
 	return retval;
 out_failed:
+	for (i = 0; i < num_queues; i++) {
+		mpi3mr_free_op_req_q_segments(mrioc, i);
+		mpi3mr_free_op_reply_q_segments(mrioc, i);
+	}
 	kfree(mrioc->req_qinfo);
 	mrioc->req_qinfo = NULL;
 
-- 
2.47.3

