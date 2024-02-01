Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C5C481D7
	for <linux-scsi@vger.kernel.org>; Thu,  1 Feb 2024 23:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706830468; cv=none; b=Jwhk+JX1w+uMCS0svpmN6ZXu30lxcumJjQHKDcTCg3UmL79Ay41vxbq6dPOHoNP50zG5mNgZ3IAky0YZ+dLPntFfr3AvBlyh4xXG7cFmBF1X8L2gASOTjHt4IU8ZCB7Kfj4dvSvSJC4Uv8fF9a60ymEhwNBS712Ntb9Muq0o4LM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706830468; c=relaxed/simple;
	bh=3FokyUnI5P5cmAhKtt6pFHX6NyRCuaS0/kuNt9gir80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=soe5DFc/48BJ8N41c1PJ/cKDqAyKAJpJQr2cnkbBQQSR4NwP14e9bfIt0C2vDOQhSc0dYW0/Pqk99VOLTYu0oOBDeLkQ50WcM385lToZn/xmuIkCFdcG0fYJTG+tWeRr/egbtOU2+yq4tCLCMhQV05InM0sNcbUnLiPDq2jRKy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YY1Du3WK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YY1Du3WK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706830465;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Feaa7ltqMImVUAF90OIsH77NDPTc4xlAwHCDaWrW23I=;
	b=YY1Du3WK3Nf5viqrzwlha2/X0tXmrm2sSmiMMtTCsqF6Xx0/maEnwNay18e99tnVxAjMyA
	DlGDp2yhsG22+ult4U6KYv8wxW5hJvp6zDrLL1eJjQsxiopscmQPxDQA7HSqA/4pYp5Fo7
	oXoiacLnO/GMeC1LDSoj89nJF+92PEw=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-333-gWWzCNdgOoS9f3Qu8Af-FQ-1; Thu,
 01 Feb 2024 18:34:21 -0500
X-MC-Unique: gWWzCNdgOoS9f3Qu8Af-FQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E9CA829AC00A;
	Thu,  1 Feb 2024 23:34:20 +0000 (UTC)
Received: from rhel-developer-toolbox-latest.rmtusor.csb (unknown [10.2.16.182])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BB9661BDB1;
	Thu,  1 Feb 2024 23:34:19 +0000 (UTC)
From: Chris Leech <cleech@redhat.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Nilesh Javali <njavali@marvell.com>
Cc: Christoph Hellwig <hch@lst.de>,
	John Meneghini <jmeneghi@redhat.com>,
	Lee Duncan <lduncan@suse.com>,
	Mike Christie <michael.christie@oracle.com>,
	Hannes Reinecke <hare@kernel.org>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	GR-QLogic-Storage-Upstream@marvell.com
Subject: [PATCH v5 3/4] uio_pruss: UIO_MEM_DMA_COHERENT conversion
Date: Thu,  1 Feb 2024 15:33:59 -0800
Message-ID: <20240201233400.3394996-4-cleech@redhat.com>
In-Reply-To: <20240201233400.3394996-1-cleech@redhat.com>
References: <20240201233400.3394996-1-cleech@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

Conversion of this driver to use UIO_MEM_DMA_COHERENT for
dma_alloc_coherent memory instead of UIO_MEM_PHYS.

Signed-off-by: Chris Leech <cleech@redhat.com>
---
 drivers/uio/uio_pruss.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/uio/uio_pruss.c b/drivers/uio/uio_pruss.c
index 77e2dc4048855..72b33f7d4c40f 100644
--- a/drivers/uio/uio_pruss.c
+++ b/drivers/uio/uio_pruss.c
@@ -191,9 +191,11 @@ static int pruss_probe(struct platform_device *pdev)
 		p->mem[1].size = sram_pool_sz;
 		p->mem[1].memtype = UIO_MEM_PHYS;
 
-		p->mem[2].addr = gdev->ddr_paddr;
+		p->mem[2].addr = (phys_addr_t) gdev->ddr_vaddr;
+		p->mem[2].dma_addr = gdev->ddr_paddr;
 		p->mem[2].size = extram_pool_sz;
-		p->mem[2].memtype = UIO_MEM_PHYS;
+		p->mem[2].memtype = UIO_MEM_DMA_COHERENT;
+		p->mem[2].dma_device = dev;
 
 		p->name = devm_kasprintf(dev, GFP_KERNEL, "pruss_evt%d", cnt);
 		p->version = DRV_VERSION;
-- 
2.43.0

