Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D67D381DA
	for <linux-scsi@vger.kernel.org>; Tue,  9 Jan 2024 12:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="gZKMDGVx"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 409BvUYJ018215;
	Tue, 9 Jan 2024 04:15:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:content-type; s=
	pfpt0220; bh=qaOwoCxoV4gEUMRbXAzyGEEYtiSsMammCVbWpD7wIKU=; b=gZK
	MDGVxK9gA2CxO6sMLXaeQd2yQ6I1wlnT0Ask9029RNuHmnIU6lJ7ri7Y29eEzh3c
	hCgFKO38Irt3wc4iB16L5WZ/tTn4FYpYNlZimbV75oZOG/ZodkKmSpIBxsvSUGKw
	pUUkBPf9OFCfXZ+Dl2b1cRjcCq7dEcOi8igyLSeUR5VAxDEkmsuKdT2RBuOgKhBG
	fGORmuqDu9L6UKywdEQz3lMJbhbnYeCSaVJ3cYM26xvtequStEc0avCoQkVjQEVo
	hg7wkFMRTN2bClE1JM31TgNlvQvmkvK7u5Y8AywZFWmK5GntPbRMUjh8+owY+Tuz
	owKZlS/ePuT1ZwDK4Eg==
Received: from dc5-exch02.marvell.com ([199.233.59.182])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3vh5qt02td-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
	Tue, 09 Jan 2024 04:15:21 -0800 (PST)
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Tue, 9 Jan
 2024 04:15:19 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Tue, 9 Jan 2024 04:15:19 -0800
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.187])
	by maili.marvell.com (Postfix) with ESMTP id CB15F3F70B4;
	Tue,  9 Jan 2024 04:15:17 -0800 (PST)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>, <lduncan@suse.com>, <cleech@redhat.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH v3 1/3] uio: introduce UIO_MEM_DMA_COHERENT type
Date: Tue, 9 Jan 2024 17:44:56 +0530
Message-ID: <20240109121458.26475-2-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20240109121458.26475-1-njavali@marvell.com>
References: <20240109121458.26475-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: c5s46ZUEAaEXriuU8INH1nc94IW1MHRM
X-Proofpoint-GUID: c5s46ZUEAaEXriuU8INH1nc94IW1MHRM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-09_02,2023-12-07_01,2023-05-22_02

From: Chris Leech <cleech@redhat.com>

Add a UIO memtype specifically for sharing dma_alloc_coherent
memory with userspace, backed by dma_mmap_coherent.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202401042222.J9GOUiYL-lkp@intel.com/
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Chris Leech <cleech@redhat.com>
---
v3:
- fix warnings reported by kernel test robot
v2:
- expose only the dma_addr within uio_mem
- Cleanup newly added unions comprising virtual_addr
  and struct device
 drivers/uio/uio.c          | 40 ++++++++++++++++++++++++++++++++++++++
 include/linux/uio_driver.h |  2 ++
 2 files changed, 42 insertions(+)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 62082d64ece0..01d83728b513 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -24,6 +24,7 @@
 #include <linux/kobject.h>
 #include <linux/cdev.h>
 #include <linux/uio_driver.h>
+#include <linux/dma-mapping.h>
 
 #define UIO_MAX_DEVICES		(1U << MINORBITS)
 
@@ -759,6 +760,42 @@ static int uio_mmap_physical(struct vm_area_struct *vma)
 			       vma->vm_page_prot);
 }
 
+static int uio_mmap_dma_coherent(struct vm_area_struct *vma)
+{
+	struct uio_device *idev = vma->vm_private_data;
+	struct uio_mem *mem;
+	void *addr;
+	int ret = 0;
+	int mi;
+
+	mi = uio_find_mem_index(vma);
+	if (mi < 0)
+		return -EINVAL;
+
+	mem = idev->info->mem + mi;
+
+	if (mem->dma_addr & ~PAGE_MASK)
+		return -ENODEV;
+	if (vma->vm_end - vma->vm_start > mem->size)
+		return -EINVAL;
+
+	/*
+	 * UIO uses offset to index into the maps for a device.
+	 * We need to clear vm_pgoff for dma_mmap_coherent.
+	 */
+	vma->vm_pgoff = 0;
+
+	addr = (void *)mem->addr;
+	ret = dma_mmap_coherent(&idev->dev,
+				vma,
+				addr,
+				mem->dma_addr,
+				vma->vm_end - vma->vm_start);
+	vma->vm_pgoff = mi;
+
+	return ret;
+}
+
 static int uio_mmap(struct file *filep, struct vm_area_struct *vma)
 {
 	struct uio_listener *listener = filep->private_data;
@@ -806,6 +843,9 @@ static int uio_mmap(struct file *filep, struct vm_area_struct *vma)
 	case UIO_MEM_VIRTUAL:
 		ret = uio_mmap_logical(vma);
 		break;
+	case UIO_MEM_DMA_COHERENT:
+		ret = uio_mmap_dma_coherent(vma);
+		break;
 	default:
 		ret = -EINVAL;
 	}
diff --git a/include/linux/uio_driver.h b/include/linux/uio_driver.h
index 47c5962b876b..7efa81497183 100644
--- a/include/linux/uio_driver.h
+++ b/include/linux/uio_driver.h
@@ -37,6 +37,7 @@ struct uio_map;
 struct uio_mem {
 	const char		*name;
 	phys_addr_t		addr;
+	dma_addr_t		dma_addr;
 	unsigned long		offs;
 	resource_size_t		size;
 	int			memtype;
@@ -158,6 +159,7 @@ extern int __must_check
 #define UIO_MEM_LOGICAL	2
 #define UIO_MEM_VIRTUAL 3
 #define UIO_MEM_IOVA	4
+#define UIO_MEM_DMA_COHERENT	5
 
 /* defines for uio_port->porttype */
 #define UIO_PORT_NONE	0
-- 
2.23.1

