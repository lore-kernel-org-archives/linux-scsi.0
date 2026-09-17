Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C3E14D4880;
	Thu, 17 Sep 2026 15:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789657408; cv=none; b=HpLLsQyo6vrTZgGDj0GqRy99DdXrYBqoGZ/0LFjIgtuTAnKa5FMD9qz2YxBdlVWlhhdajUhvuLVvBZPEcXV5qZG8XCxPesXpByUsvrVeIkpOk2ooPu+GtXvLmlPu2Z61sdaUkOw1yq2Xabkwfq1KiTfEfE8h01HroL1pPpP+Mhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789657408; c=relaxed/simple;
	bh=F35nGChAZzO11BFzjdu4A80FeSkvaVVCbjyDWb4q6T4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=SAxJ5TXOFtSQ1qV+u944KYF4A4u/2uKisj80pre98epZ5XM7za+qLcC8qZ8B5kCNdbPGLxmxXLl5wqVlX+RMcyg6vrPjMn3maM3ohNh8w7n51O+BX/Zo0gP8/WDtJhiDAe0TNWtxTrdj79V4j32nbBltSDPRmCx+2rcyZOEw+zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-05 (Coremail) with SMTP id zQCowAB34jwlAaxqBhuDCA--.5428S2;
	Thu, 17 Sep 2026 23:03:01 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: James.Bottomley@HansenPartnership.com
Cc: hare@suse.de,
	himanshu.madhani@oracle.com,
	kashyap.desai@broadcom.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	sathya.prakash@broadcom.com,
	sreekanth.reddy@broadcom.com,
	sumit.saxena@broadcom.com,
	thenzl@redhat.com,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: mpi3mr: Fix tgtdev reference count in mpi3mr_pcietopochg_evt_bh()
Date: Thu, 17 Sep 2026 15:03:01 +0000
Message-Id: <20260917150301.2158080-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowAB34jwlAaxqBhuDCA--.5428S2
X-Coremail-Antispam: 1UD129KBjvdXoWrZr4xXF1DtrW8Xw4kKw48JFb_yoWkurg_GF
	savrZrGw4FkF47Gw48CryrZFsFyr4DX34vkF18twn3ArZ7XFyxZr1fXw13Zw47Za15Jwsx
	Jw1UXF43AryUWjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbqAYjsxI4VWkKwAYFVCjjxCrM7CY07I20VC2zVCF04k26cxKx2IY
	s7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4
	kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_
	Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26r
	xl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
	6xIIjxv20xvE14v26r126r1DMcIj6I8E87Iv67AKxVWxJr0_GcWlOx8S6xCaFVCjc4AY6r
	1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq62Iq12xI8VA0II8E6IAqYI8I648v4I1lFIxG
	xcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l42
	xK82IY6x8ErcxFaVAv8VW8GFyrJr1UJwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02
	F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GF
	ylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r
	4UJVWxJr1lIxAIcVC2z280aVCY1x0267AKxVW0oVCq3bIYCTnIWIevJa73UjIFyTuYvjxU
	Dg10UUUUU
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCRINA2qr9LYeVgAAse

mpi3mr_get_tgtdev_by_handle() takes a reference on the target device
and the loop drops it with mpi3mr_tgtdev_put() at the end of every
iteration. The MPI3_EVENT_PCIE_TOPO_PS_NOT_RESPONDING branch drops the
same reference a second time before breaking out, so the reference is
put twice and the kref can be released prematurely.

Drop the redundant put and let the loop release the reference once.

Fixes: 8e653455547a ("scsi: mpi3mr: Add support for PCIe device event handling")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 8a2575171e1f..0c974f2627d1 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -2027,7 +2027,6 @@ static void mpi3mr_pcietopochg_evt_bh(struct mpi3mr_ioc *mrioc,
 			if (tgtdev->host_exposed)
 				mpi3mr_remove_tgtdev_from_host(mrioc, tgtdev);
 			mpi3mr_tgtdev_del_from_list(mrioc, tgtdev, false);
-			mpi3mr_tgtdev_put(tgtdev);
 			break;
 		default:
 			break;
-- 
2.34.1

