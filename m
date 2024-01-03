Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3A7F182AA
	for <linux-scsi@vger.kernel.org>; Wed,  3 Jan 2024 09:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="YAelByVw"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 4037XRCq020394;
	Wed, 3 Jan 2024 01:11:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding:content-type; s=pfpt0220; bh=rIC/CVOS
	67vabjXX1zN+AQTyDpfVJTrt/ynUCpWxTvE=; b=YAelByVw/Ikyu/pbdWZF268h
	kO5ecfE3uVSdrQZc7IBDksPyD5ZioF0g92Efng5xtnC49vOKtU3Z2a0Upli1G2kI
	vy6n41NFhEDpv/MS1bCbrlCMBxiKivI7vC0v2y7Hzwt/xArYxT9K/yNI3fStHsPG
	NE0XJW8WGxBdG3tBKLqW0Jb7y9Asdna20PqcAs2+s/AcxOf6dNPQo791nqmHfWPT
	O66+jowItSPcMIWSaZS1egqSISj90fD4r5wrnJpvoJ3gg+ojnW3vWbSqP17SXTO/
	P0vtA1W+11Js0pUewHXBlSqmbBYlUM4iT+08XxDVgz3TvDttMr6lR+qNTZN9iw==
Received: from dc5-exch01.marvell.com ([199.233.59.181])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3vd39q8evu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
	Wed, 03 Jan 2024 01:11:56 -0800 (PST)
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Wed, 3 Jan
 2024 01:11:54 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Wed, 3 Jan 2024 01:11:54 -0800
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.187])
	by maili.marvell.com (Postfix) with ESMTP id 663F63F707A;
	Wed,  3 Jan 2024 01:11:52 -0800 (PST)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>, <lduncan@suse.com>, <cleech@redhat.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH v2 0/3] UIO_MEM_DMA_COHERENT for cnic/bnx2/bnx2x
Date: Wed, 3 Jan 2024 14:41:34 +0530
Message-ID: <20240103091137.27142-1-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: iyr4TZUTTFmpU8eXoojSWPxMb7kaoDCg
X-Proofpoint-GUID: iyr4TZUTTFmpU8eXoojSWPxMb7kaoDCg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-09_02,2023-12-07_01,2023-05-22_02

During bnx2i iSCSI testing we ran into page refcounting issues in the
uio mmaps exported from cnic to the iscsiuio process, and bisected back
to the removal of the __GFP_COMP flag from dma_alloc_coherent calls.

In order to fix these drivers to be able to mmap dma coherent memory via
a uio device, without resorting to hacks and working with an iommu
enabled, introduce a new uio mmap type backed by dma_mmap_coherent.

While converting the uio interface, I also noticed that not all of these
allocations were PAGE_SIZE aligned. Particularly the bnx2/bnx2x status
block mapping was much smaller than any architecture page size, and I
was concerned that it could be unintentionally exposing kernel memory.

v2:
- expose only the dma_addr within uio and cnic.
- Cleanup newly added unions comprising virtual_addr
  and struct device

Chris Leech (3):
  uio: introduce UIO_MEM_DMA_COHERENT type
  cnic,bnx2,bnx2x: use UIO_MEM_DMA_COHERENT
  cnic,bnx2,bnx2x: page align uio mmap allocations

 drivers/net/ethernet/broadcom/bnx2.c          |  2 +
 .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  | 10 +++--
 drivers/net/ethernet/broadcom/cnic.c          | 26 ++++++++-----
 drivers/net/ethernet/broadcom/cnic.h          |  1 +
 drivers/net/ethernet/broadcom/cnic_if.h       |  1 +
 drivers/uio/uio.c                             | 38 +++++++++++++++++++
 include/linux/uio_driver.h                    |  2 +
 7 files changed, 67 insertions(+), 13 deletions(-)

-- 
2.23.1

