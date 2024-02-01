Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2296F47F45
	for <linux-scsi@vger.kernel.org>; Thu,  1 Feb 2024 23:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706830461; cv=none; b=XrymjmK7raieJsyR3waUM23wlDQZdPFPMN/rgXUmppgwEGoWzTT1DDVkZVBZVezqkjKb0/iiTJ4pXL0QdEpYE0cmQDVmAfezxzXeDRhdU/RN7qb6A9RX1ZV74B4FWWmiCaWC83mOqjBGz9qaUTLaFpCwiCrWO4jkex0ZU+tpxEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706830461; c=relaxed/simple;
	bh=kw+ki3WM3q8qc2SsVqZ3aaq+zpP97OZDm6P5TkPPdhM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MHS500ajeawP68lRhZb899hGJ/wiA+F5guCdME2Yxw5LOcsNaK3pMNXJ82dKmmb7kzAsYJwhf4D8xuGP/QeyDsst0mRlkaSrBeRBkaDLbkzEj85ewX3JDyKtfTqBZV/5EVfs4sPKYMyfIdc2Xr2SzVPdSHBLJhtxyToZp6Izjyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AeZ0Vy3g; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AeZ0Vy3g"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706830458;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=+KNKvB+sVb0oHCzlVCeXjS4dy7AjP6uKhJvKZaZyiAA=;
	b=AeZ0Vy3gDl+oMHBRDCCOzBSZioBF8fHFN2KsoanguzlmDaW504kf9JisyV3H6c6u/KRMyR
	/wypRLGB4iJMFKIU2SCjMeuaIJBSxSX8ddhO2xiwTl7gBsMYL9HBqY+Wxv+RwSkXw5JGuK
	/+Isj36bpYUd+/DJH50ApNN2oDG11Ug=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-391-_2dxdNjMMFuAFSX8uqEhdw-1; Thu,
 01 Feb 2024 18:34:17 -0500
X-MC-Unique: _2dxdNjMMFuAFSX8uqEhdw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DD9C428C976B;
	Thu,  1 Feb 2024 23:34:16 +0000 (UTC)
Received: from rhel-developer-toolbox-latest.rmtusor.csb (unknown [10.2.16.182])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 741AC1BDB1;
	Thu,  1 Feb 2024 23:34:15 +0000 (UTC)
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
Subject: [PATCH v5 0/4] UIO_MEM_DMA_COHERENT for cnic/bnx2/bnx2x
Date: Thu,  1 Feb 2024 15:33:56 -0800
Message-ID: <20240201233400.3394996-1-cleech@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

During bnx2i iSCSI testing we ran into page refcounting issues in the
uio mmaps exported from cnic to the iscsiuio process, and bisected back
to the removal of the __GFP_COMP flag from dma_alloc_coherent calls.

The cnic uio interface also has issues running with an iommu enabled,
which these changes correct.

In order to fix these drivers to be able to mmap dma coherent memory via
a uio device, introduce a new uio mmap type backed by dma_mmap_coherent.

While I understand some complaints about how these drivers have been
structured, I also don't like letting support bitrot when there's a
reasonable alternative to re-architecting an existing driver. I believe
this to be the most sane way to restore these drivers to functioning
properly.

There are two other uio drivers which are mmaping dma_alloc_coherent
memory as UIO_MEM_PHYS, uio_dmem_genirq and uio_pruss.
These drivers are converted in the later patches of this series.

v5:
- convert uio_pruss and uio_dmem_genirq
- added dev_warn and comment about not adding more users
- put some PAGE_ALIGNs back in cnic to keep checks in
  uio_mmap_dma_coherent matched with uio_mmap_physical.
- dropped the Fixes trailer
v4:
- re-introduce the dma_device member to uio_map,
  it needs to be passed to dma_mmap_coherent somehow
- drop patch 3 to focus only on the uio interface,
  explicit page alignment isn't needed
- re-add the v1 mail recipients,
  this isn't something to be handled through linux-scsi
v3 (Nilesh Javali <njavali@marvell.com>):
- fix warnings reported by kernel test robot
  and added base commit
v2 (Nilesh Javali <njavali@marvell.com>):
- expose only the dma_addr within uio and cnic.
- Cleanup newly added unions comprising virtual_addr
  and struct device

previous threads:
v1: https://lore.kernel.org/all/20230929170023.1020032-1-cleech@redhat.com/
attempt at an alternative change: https://lore.kernel.org/all/20231219055514.12324-1-njavali@marvell.com/
v2: https://lore.kernel.org/all/20240103091137.27142-1-njavali@marvell.com/
v3: https://lore.kernel.org/all/20240109121458.26475-1-njavali@marvell.com/
v4: https://lore.kernel.org/all/20240131191732.3247996-1-cleech@redhat.com/

Chris Leech (4):
  uio: introduce UIO_MEM_DMA_COHERENT type
  cnic,bnx2,bnx2x: use UIO_MEM_DMA_COHERENT
  uio_pruss: UIO_MEM_DMA_COHERENT conversion
  uio_dmem_genirq: UIO_MEM_DMA_COHERENT conversion

 drivers/net/ethernet/broadcom/bnx2.c          |  1 +
 .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  |  2 +
 drivers/net/ethernet/broadcom/cnic.c          | 25 ++++++----
 drivers/net/ethernet/broadcom/cnic.h          |  1 +
 drivers/net/ethernet/broadcom/cnic_if.h       |  1 +
 drivers/uio/uio.c                             | 47 +++++++++++++++++++
 drivers/uio/uio_dmem_genirq.c                 | 22 ++++-----
 drivers/uio/uio_pruss.c                       |  6 ++-
 include/linux/uio_driver.h                    |  8 ++++
 9 files changed, 89 insertions(+), 24 deletions(-)


base-commit: 861c0981648f5b64c86fd028ee622096eb7af05a
-- 
2.43.0

