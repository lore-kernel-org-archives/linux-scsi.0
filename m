Received: from sender-of-o57.zoho.eu (sender-of-o57.zoho.eu [136.143.169.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6533DA7C8;
	Thu,  6 Aug 2026 21:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.169.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786050416; cv=pass; b=kKqBeQDYcAgQKo1DFch2WINZHHFfics+fTaV2K+1VWZTv18nnOTgezEtJBZkesfYF4Umx5FGjNdS0cUgf0xpfIHTwKEiecYNPU3zKLWqjVFNtQ+zbnokw4qSqXBvsgbwiqMT3ibNqqKZE6Q61G9ZDBGyioE8r+/Gq0n34Fwag4I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786050416; c=relaxed/simple;
	bh=bwahiOXWbgpAkkLaztYB+Uq+61wtH1Rt1LhIh/x0gFU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bvDl48iTqyEeRUsHS8gRDCn3fu56Cpo52iJZ9qd3xXsJgK+auUKAO3O8W7Gq3qKpg9cmHLGuDeVi2+muIqtpOHvch7fG0bLrCTrU3YtgDoSGh68S/Dr6bMf88wSBT18CPz4z3Q0AYuBlXBLpKSv2dynAVobW2p8z6oRei1iEUFo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=iusegentoo.com; spf=pass smtp.mailfrom=iusegentoo.com; dkim=pass (1024-bit key) header.d=iusegentoo.com header.i=ali@iusegentoo.com header.b=cwI+U3Fq; arc=pass smtp.client-ip=136.143.169.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=iusegentoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iusegentoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=iusegentoo.com header.i=ali@iusegentoo.com header.b="cwI+U3Fq"
ARC-Seal: i=1; a=rsa-sha256; t=1786050405; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=BB2bdMrAnjYnRTvh2Wlq5nz+PxR1b3cLvXbBGxLLKVZtDNpSNYchGmWlX/II+hnEljYaZBsLGDKZmGyeyMIw74BhtjugfjAQDY6CHZ0bxNdY7qu3HsN3IQhclr/Y3w4/9KSlOs9RhmOUvGO3OH7e4oXq5EYxzTg57FKVNSkUxFI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1786050405; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=bsRGz5KfAZBqftqbhrhHXBg0uBuUptzsv4RpWxjAuV4=; 
	b=H4v0qFRjGwpfD0qxLHHAwwlYQWy144xqBZKW+bPAOi9+B9nFelPrivy+lgapr6+erY7h6Dh0oaJNkL7uK1rEVpKl0JXYc5coc4Az+cefuJeV5CFOuVbmpgZJ5vcgEwrqyTGhvGaNAuaeT1naxoVLQAWJczBMqAk6Y7KO2KsuRT4=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=iusegentoo.com;
	spf=pass  smtp.mailfrom=ali@iusegentoo.com;
	dmarc=pass header.from=<ali@iusegentoo.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1786050405;
	s=zmail; d=iusegentoo.com; i=ali@iusegentoo.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=bsRGz5KfAZBqftqbhrhHXBg0uBuUptzsv4RpWxjAuV4=;
	b=cwI+U3FqadoMdgEPjV8FYra5NntVXbNlrHQMYk+LcD5bQ5TWaUSSnsnB8BdXb7h4
	H751Im1AmxRX2HZV4LExguo40ZBL18o8/iuBgCmyfs4BSn6IuGR3sreTuN+1iK8tjKu
	HCjV4WdtbjujKftKY8KjPS3Y4KK+zvyzYLfX3dyM=
Received: by mx.zoho.eu with SMTPS id 1786050404508364.3000579245661;
	Thu, 6 Aug 2026 23:06:44 +0200 (CEST)
From: Ali Ahmet Memis <ali@iusegentoo.com>
To: Ram Vegesna <ram.vegesna@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/2] scsi: elx: efct: fix two leaks on failure paths
Date: Thu,  6 Aug 2026 21:06:25 +0000
Message-ID: <20260806210631.357456-1-ali@iusegentoo.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

Two of the five patches in v2 fix real leaks. The other three cleaned up
error paths that cannot be reached from their callers, so they are
dropped here. Sashiko's review of v2 3/5 pointed at the first of them,
and checking that properly showed the same problem in the other two.
Sorry for the churn.

  v2 1/5, HW state checked after the HIO is taken. hw->state is only
  non-ACTIVE during efct_hw_teardown(), during efct_hw_reset(), and
  before init. efct_hw_reset() has one caller, efct_fw_reset(), which
  follows it with efct_device_detach() and efct_device_attach(), and
  hw->io[] is torn down and rebuilt by that pair. So an entry stranded
  on hw->io_inuse does not outlive the adapter incarnation, and the
  "the pool runs dry and no further ELS or CT traffic can be sent"
  argument in that commit message does not hold.

  v2 2/5, HIO not returned when the WQE cannot be built. None of the
  builders reachable there can fail from these callers.
  sli_els_request64_wqe() and sli_xmit_els_rsp64_wqe() have no error
  return at all. sli_gen_request64_wqe() and sli_xmit_sequence64_wqe()
  fail only on !sgl || !sgl->virt, but efct_els_hw_srrs_send() has
  already dereferenced hio->sgl->virt before it reaches them.
  sli_xmit_bls_rsp64_wqe() fails on an unknown BLS type, which
  efct_hw_bls_send() itself sets to ACC or RJT, and on rpi_registered
  together with an s_id, which none of its three callers passes:
  efct_scsi.c sets s_id to U32_MAX and efc_send_bls_acc() leaves
  rpi_registered false.

  v2 3/5, request tag not returned when the send frame WQE fails.
  sli_send_frame_wqe() has a single "return 0", as Sashiko noted.

What is left is one leak that a failing dma_alloc_coherent() produces,
and one that I could measure. For the second, binding the driver to a
PCI device that is not an SLI-4 adapter makes sli_setup() fail after the
mempools have been created, and efct_pci_probe() then frees the struct
efct that held the only pointers to them. Repeating that probe 61 times
under CONFIG_DEBUG_KMEMLEAK:

  before   1566 unreferenced objects, every one from efct_hw_setup()
  after    none, and the probe still fails the same way

The first patch needs a real Emulex SLI-4 adapter and an allocation
failure, so it is reasoned from the code rather than exercised. Each
patch builds on its own.

Still not addressed here, and not claimed by these patches:
efct_xport_initialize() jumps past the hw_init_out label when
efct_hw_init() fails, so efct_hw_teardown() never runs and everything
efct_hw_init() managed to set up before failing stays behind, and
efcport_init() returns without destroying node_pool and node_dma_pool
when els_io_pool fails. Those cross two modules and I would rather send
them separately once this is settled.

v3: dropped v2 1/5, 2/5 and 3/5 for the reasons above; named the second
    caller of efct_hw_setup() and said what efct_hw_rx_buffer_free()
    actually frees.
v2: the mailbox pool patch claimed it cleared hw_setup_called on the way
    out while one of its three error paths still returned directly;
    fixed with a shared not_setup label.

Ali Ahmet Memis (2):
  scsi: elx: efct: free the RQ buffers already allocated when one fails
  scsi: elx: efct: destroy the mailbox pools when setup fails

 drivers/scsi/elx/efct/efct_hw.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)


base-commit: 0d839570765118029aa8bf4a95444c6a11aacf85
--
2.55.0

