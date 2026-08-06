Received: from sender-of-o57.zoho.eu (sender-of-o57.zoho.eu [136.143.169.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26EF93DD87B;
	Thu,  6 Aug 2026 20:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.169.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786047748; cv=pass; b=LKX48dF7T/FoGLmDdwfMkC3o8/QZ6810kihmr9WqjsfiEglSufsc6dUuE8djr2GXvXLMPFvifCeTuL8+ci4bw9uzzkj3+8FVNlaFAF8tYh1ihIGsWG+4uqFHICTO0PWkCoHE53Gq9mQkApX058O4aWNkASXSdo2HSor3+JPlIBQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786047748; c=relaxed/simple;
	bh=7F5acONEP8oUUtb5oy4Z5K8fvlQzzati+v3JqPZ7QZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G6zkgvA2vjqDU5OdOJX6i5xhGaJij3asOwix5hqmSOX/UZEq9kHl/pCovpbAV9OBuOW5KvsBZ0hesL3Nj/UDuOH/rP6gysRjAozHbgy0pF+T1oHyKNolWZOmISit5qkOhZaRHvbMYzQ1Ef6lB+if+VEpnX09paOKnhKSaw61zdU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=iusegentoo.com; spf=pass smtp.mailfrom=iusegentoo.com; dkim=pass (1024-bit key) header.d=iusegentoo.com header.i=ali@iusegentoo.com header.b=Jdn+J29h; arc=pass smtp.client-ip=136.143.169.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=iusegentoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iusegentoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=iusegentoo.com header.i=ali@iusegentoo.com header.b="Jdn+J29h"
ARC-Seal: i=1; a=rsa-sha256; t=1786047738; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=B+W6cq2RwTT3fcvcRgm0LmtgcZwoNKfMV4Ew6TO9F+DDRGu6CihVe3G4X4dMdrTwUbD+7pKSVCqy3WAQnxU1LknROKEiEkcJOBLKImFUvhLxx67+3lPMkW0y89fwU42KmiBSspM0hBZAfAoc1vypz5PhWYCmrTViFB99l4l1Uwc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1786047738; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=vcxR3eOLacgLmqT+8EIBN01ziK3zbpNqDJt8nUmNyiI=; 
	b=dX0EYx/GBN2kbDbFPcUGmunlge3iISo9XCxXDFFU8PfmfrYI1A2yT+RdmlbBqA6Y0+ykpOowjfj15Q+YBiMryfRHJcnVAbHwV7dmrzrE0gUiDmzznfh7yBY1R1z5iVGuX3KGNHBF/BP0Aw8S+mOauMzKL5YsZF0jejiW0MANP+Y=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=iusegentoo.com;
	spf=pass  smtp.mailfrom=ali@iusegentoo.com;
	dmarc=pass header.from=<ali@iusegentoo.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1786047738;
	s=zmail; d=iusegentoo.com; i=ali@iusegentoo.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=vcxR3eOLacgLmqT+8EIBN01ziK3zbpNqDJt8nUmNyiI=;
	b=Jdn+J29hsZi5J5Em4wB21WzkdbBhffHkb1JapAPSYIwZmxC9T1Bl/8unLz3llgzS
	V62BwxHSY+2lFxfIouF1tDDjb14AcP7E0/7VCR49PiDN4D+B3E51ZkzAFqqlZvzJaPe
	scorEpMO3Qldrc6ytgHxdShB5MzI2BqATp0HFiag=
Received: by mx.zoho.eu with SMTPS id 1786047735908909.7313663210379;
	Thu, 6 Aug 2026 22:22:15 +0200 (CEST)
From: Ali Ahmet Memis <ali@iusegentoo.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	Ram Vegesna <ram.vegesna@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/5] scsi: elx: efct: fix resources stranded on failure paths
Date: Thu,  6 Aug 2026 20:22:00 +0000
Message-ID: <20260806202205.345326-1-ali@iusegentoo.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260806192345.328621-1-ali@iusegentoo.com>
References: <20260806192345.328621-1-ali@iusegentoo.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

Five places in efct take a resource and then return an error without
giving it back. Three of them lose an entry from a fixed size pool, which
stops the driver working once the pool is empty rather than growing
memory; the other two are ordinary leaks.

  1  efct_els_hw_srrs_send() checks hw->state after taking an HIO
  2  the WQE builders in efct_els_hw_srrs_send() and efct_hw_bls_send()
  3  the WQE builder in efct_hw_send_frame(), which loses a request tag
  4  efct_hw_rx_buffer_alloc() drops the coherent buffers it mapped
  5  efct_hw_setup() leaves its two mempools behind

Changes in v2:
- Patch 5: the first error path, the one taken when the cmd_ctx_pool
  allocation fails, returned without clearing hw_setup_called while the
  two paths below it cleared it. The commit message described the
  behaviour the other two paths had, so it claimed more than the patch
  did. All three now clear it. Pointed out by the Sashiko review of v1.
- No other change, patches 1 to 4 are as sent.

Patch 5 is the one I could exercise. Binding the driver to a PCI device
that is not an SLI-4 adapter makes sli_setup() fail after the mempools
have been created, and efct_pci_probe() then frees the struct efct that
held the only pointers to them. Repeating that probe 61 times under
CONFIG_DEBUG_KMEMLEAK:

  before   1566 unreferenced objects, every one from efct_hw_setup()
  after    none, and the probe still fails the same way

The same run against the v2 patch reports none as well.

Patches 1 to 4 are reasoned from the code. They need a real Emulex SLI-4
adapter, and for 1 to 3 a live FC link as well, which I do not have. Each
patch builds on its own.

I deliberately left the efct_hw_wq_write() failure paths alone.
efct_hw_wq_write() appends to wq->pending_list and drains from the head,
so it can return an error while this request is still linked there.
Releasing the HIO or the request tag at that point would leave a later
completion looking at something that has been handed back, which needs
more than a free on the error path.

Also not addressed here: efct_xport_attach() and efct_xport_initialize()
return without efct_hw_teardown() on some paths, and efcport_init() leaves
its first two pools behind when the third allocation fails. Those cross
two modules and I would rather send them separately once this is settled.

v1: https://lore.kernel.org/all/20260806192345.328621-1-ali@iusegentoo.com/

Ali Ahmet Memis (5):
  scsi: elx: efct: check the HW state before allocating an HIO
  scsi: elx: efct: free the HIO when the WQE cannot be built
  scsi: elx: efct: free the request tag when the send frame WQE fails
  scsi: elx: efct: free the RQ buffers already allocated when one fails
  scsi: elx: efct: destroy the mailbox pools when setup fails

 drivers/scsi/elx/efct/efct_hw.c | 74 +++++++++++++++++++++------------
 1 file changed, 47 insertions(+), 27 deletions(-)


base-commit: 0d839570765118029aa8bf4a95444c6a11aacf85
-- 
2.55.0

