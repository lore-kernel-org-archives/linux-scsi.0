Received: from mail-pj1-f100.google.com (mail-pj1-f100.google.com [209.85.216.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0778033938C
	for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 15:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787672683; cv=none; b=kArmsUUHG7+89Hor+71fKSz5UX/HiVYhujLOFyO8wnGu1BcR6mn0vGnVtoajYr8FbS6r7AuqFiRSfwe/GnQWjbP2lhg+ZpjB7hDgd1+Bta8tH7oM70DiAuOhiUNK09evE1d2GO35cdY0vKjM3SBEjPPgaX4NzH9wqQsdRF5J4hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787672683; c=relaxed/simple;
	bh=c5nvPNl4/jbQlOYEvZ1XzsCxahey+JxK4HPZP0W1dvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Grw2B6hYrrt7Z6p50oFJOjZM6J93ChPnTH+At/Q5oaX32usb1oXmsihIfj3b4HJAyJVyqeWxkqdRxZi5xckeMH1SpuUIYjRtUzrijP7MsBaPynDL5wjBGi3zFXocDIZkjZq5hQOlYME5sUPz7tlpHXZh1lqOTr3GpRAqHOMuiDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Bm9NyBji; arc=none smtp.client-ip=209.85.216.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Bm9NyBji"
Received: by mail-pj1-f100.google.com with SMTP id 98e67ed59e1d1-3964dfb5a69so1190543a91.1
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 08:44:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787672681; x=1788277481;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aSl6yz/XDFgasIZRHZwBh+iQEZwLBzx/hrLBpRZpMFw=;
        b=X6Qjtpk9Kg63cD8KGf13MPhhSWtMtpODLcI2lBNTaxhaeVSDq1YvjmlQSDf0sxULlH
         fi0S7rdVZ45NOeWYhIqnRiZPniGWZd86a4sfXLbFwUp7U32ZGT47H2n61uye4i8op6Ox
         Osqeusbgfe7pWYQ9MvqBqLDovRyWqO5UNNL64i/aJuWZq3rCt9/xbqxRF60R4Y0/eEvp
         QTs5NLlIpjyOq7KjVFq3V60UjuBmFqJ0y6+jRq9byYAurqFi1zGr6YkQkFjui8d2hTDK
         tAmmCn4Px5y7L01Wo3qGkLih7JlS3lP8Rv4K+84GSwe6+XbRhgeHumdj2/vIqTzY+pmV
         RLSw==
X-Gm-Message-State: AFuF++k/WP1NsCZXUE2zOIzbxwP1OfyjxF3A4tUMOivz1Szr6k7rblwt
	5yUgT5Nrmuy3JiHzSnh1IqH+tmW+umD3plpMJOBJrU7hodFExb8EgRc4R6jr5BAzW8p1mcJKdsG
	i6ZI796pkvvFiMZTYKjjiW7KVbH8GgJ81YNZK4AfMBlmqy6YkJUTq6M0AhuIaAww2+jpfYfYDr3
	VH5PZhlzOPAq+Cypfu9q6MoayDPerlUsdMjh6doR59vdVRS/lvvmXAAPBIk/TgwNm4pUIW8YrNE
	r3GP41xWN1dLzDINimBTDY3
X-Gm-Gg: AR+sD13tywUtc9soQTtrVsacen3gW0nm2WyxS75YcFvntDG3aGnbl2pBfM9VA10HLw4
	7PELZi0heKYq+NtBp8UkWuX9p+PxIdLGC1ONgDLdjO0IQ4DGBp+dnFepEIjcPKXuNSVK8APTfeu
	TwXscIBhIks+/b8rT44bgYlP5SrrhMa1EJ3u6uHfhaeLpXpaG6lh+k5IFpbdbmfTyZUnaGfl0ak
	jcpSTKzgkSQ/7yKa/CnO1aP6Blc5HBnXb1cfQ9OioMqzUGRvV5jrkyLo2q9radGtZ+SrG593GWB
	KxPdwbltxQVmW/n3V4L/FGTSv8ZpuPvimNHQeD81XoyZanu0DOrSQ3FkyholYf9CXeuqdUpui7J
	XAXb5GHUg9BEZ08U84gJaoRaWIZBMjLlcnabQjO2MVOiV42b0FrNy1H1BL8bwgnrXUg8MbYBG81
	Sjqi6wDkoFtrNIYrHbbVHoJ+qzpowobkjbi4f9QmM3CXQ=
X-Received: by 2002:a17:90a:c10f:b0:390:8361:a532 with SMTP id 98e67ed59e1d1-3966d373968mr166272a91.7.1787672681123;
        Tue, 25 Aug 2026 08:44:41 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-20.dlp.protect.broadcom.com. [144.49.247.20])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-39645a4b71bsm1551812a91.3.2026.08.25.08.44.40
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Aug 2026 08:44:41 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2d6df0a1e18so22162775ad.1
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 08:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1787672679; x=1788277479; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aSl6yz/XDFgasIZRHZwBh+iQEZwLBzx/hrLBpRZpMFw=;
        b=Bm9NyBji5HBYIXX7JgX0t8YlmC+cElLTJD6vLRYdI84zRPNc1trsz3YN9y+NArw5kr
         ZjtFu34MFndq/2rbmpkn1EcqQA0Re5EAPV2C3h3hbXVQUjoYYasG7MGEQt7cPt0T+kF7
         SvGOH/8VhZdd5J9PHtqjHVTyMcp1VcpWaa1WQ=
X-Received: by 2002:a17:903:1ae6:b0:2d6:d3f9:d394 with SMTP id d9443c01a7336-2d6d3f9d8bdmr200832915ad.0.1787672679560;
        Tue, 25 Aug 2026 08:44:39 -0700 (PDT)
X-Received: by 2002:a17:903:1ae6:b0:2d6:d3f9:d394 with SMTP id d9443c01a7336-2d6d3f9d8bdmr200831085ad.0.1787672678545;
        Tue, 25 Aug 2026 08:44:38 -0700 (PDT)
Received: from dhcp-10-123-98-253.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327f9209fafsm63445311eec.23.2026.08.25.08.44.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 08:44:37 -0700 (PDT)
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
Subject: [PATCH v2 07/17] mpi3mr: Fix out-of-bounds sense buffer access
Date: Wed, 26 Aug 2026 02:34:01 +0530
Message-ID: <20260825210411.301535-8-chandrakanth.patil@broadcom.com>
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

The sense buffer address reported on completion is turned into a
virtual address with no range check, so an address outside the pool
resolves to memory that does not belong to it.

Check that it lies within the pool and is correctly aligned.

Fixes: 824a156633df ("scsi: mpi3mr: Base driver code")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
---
v2:
 - Switched to do_div() for alignment checking to avoid potential 64-bit
   division issues on 32-bit platforms.
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index c90358a9e950..4f1e6293d576 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -141,9 +141,19 @@ void *mpi3mr_get_reply_virt_addr(struct mpi3mr_ioc *mrioc,
 void *mpi3mr_get_sensebuf_virt_addr(struct mpi3mr_ioc *mrioc,
 	dma_addr_t phys_addr)
 {
+	u64 offset;
+
 	if (!phys_addr)
 		return NULL;
 
+	offset = phys_addr - mrioc->sense_buf_dma;
+
+	if (phys_addr < mrioc->sense_buf_dma ||
+	    (phys_addr > mrioc->sense_buf_dma +
+	     (mrioc->num_sense_bufs * MPI3MR_SENSE_BUF_SZ) - MPI3MR_SENSE_BUF_SZ) ||
+	    do_div(offset, MPI3MR_SENSE_BUF_SZ))
+		return NULL;
+
 	return mrioc->sense_buf + (phys_addr - mrioc->sense_buf_dma);
 }
 
-- 
2.52.0

