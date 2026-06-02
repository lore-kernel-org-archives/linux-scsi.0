Received: from mail-m49212.qiye.163.com (mail-m49212.qiye.163.com [45.254.49.212])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B79811DDC3F
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jun 2026 07:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.212
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780385145; cv=none; b=J1oAWDGM/gi9w+gSVtBGAXox7f7SSD/xnz31QMCayoRk8fbjuRvWxfSh1miUGbfGGFv+1sjcZg7ScxiNu68SwHyUL4lx/vHUsWyXTgUnN7QhjoLaA34L7PHIlkdtTshUASWI+QXLe4m2ObxCkoV3rf67DPlGqB+U3q4Dq78Du/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780385145; c=relaxed/simple;
	bh=u68bzi5Jmyh70QI0w7LAv3SQHqAfpBEKVdkKN/S/xIM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=p3xuyxPfexMeQ7rDOp2+D+MaQybBpfEoaqNGDj41Dz+FrHc/HMJCt3ClXfuO2K8imQZwuAmQ3PtngQdqMGrTPRVwkt7/b8z+slplb5Kg7HQjFCrrohXzD5gcJC/gq4ClnXLfX1wbXAiUeJKc/vq4ndimrYyb7sSNOYxe2eDCcV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=leap-io-kernel.com; spf=pass smtp.mailfrom=leap-io-kernel.com; dkim=pass (2048-bit key) header.d=leap-io-kernel.com header.i=@leap-io-kernel.com header.b=rJeae/sw; arc=none smtp.client-ip=45.254.49.212
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=leap-io-kernel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leap-io-kernel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leap-io-kernel.com header.i=@leap-io-kernel.com header.b="rJeae/sw"
Received: from localhost.localdomain (unknown [222.130.22.242])
	by smtp.qiye.163.com (Hmail) with ESMTP id 40b8bc0ed;
	Tue, 2 Jun 2026 15:10:18 +0800 (GMT+08:00)
From: Dongdong Hao <doubled@leap-io-kernel.com>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: doubled@leap-io-kernel.com,
	yjzhang@leap-io-kernel.com,
	kezijie@leap-io-kernel.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH v2 0/2] scsi: Add LeapRAID driver support
Date: Tue,  2 Jun 2026 15:10:16 +0800
Message-Id: <cover.1780383814.git.doubled@leap-io-kernel.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9e872b3d1103aekunma6f7b9307054f4
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaQxgeVkpMGU5PHxkdTUxKGVYVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlJSUlVSkhLVUlJVUlPSVlXWRYaDxIVHRRZQVlPS0hVSk
	tISk9ITFVKS0tVSkJLS1kG
DKIM-Signature: a=rsa-sha256;
	b=rJeae/swlj/RamBZ7IVGhb0LXhc7dbPuvbtczu0KkSQXP6vJzz6iArB3GbrLex0ieCF6R9kXrCyVoTtFh0Sm8Fy3Cyx3Z3tcFP9IWUzYNIb6BcIMLUpCC5iLVNfWiwUDEBwD6gfbv4dxzlOZ8CT61B0Y7gPrM+dNzbjzaQTAaHsjE4jSZLAK8tLxOTxuUeEoYXCcAzwPslFMIImHqqceUPkVklchqg+4G6vHVdkg8G7VM00Ind7RdhLrMDAcMbVtgdld8EJt5SXs0bvMOVfnprjprEoB2pOQOTsHdGtEbdWjguR4v+s4FQV+xjlrOAO0na8QMhvjXX+29PjuiuwZfw==; c=relaxed/relaxed; s=default; d=leap-io-kernel.com; v=1;
	bh=wrkSNmfnyL73s2Bxcn0xp3ETlehiuN+lfk7CiuS41OU=;
	h=date:mime-version:subject:message-id:from;

Hi,

This series adds initial upstream support for the LeapIO LeapRAID PCIe
SAS/SATA RAID controller driver.

Patch 1 adds the new leapraid SCSI driver under drivers/scsi/leapraid/,
hooks it into the SCSI build system, and adds a MAINTAINERS entry.

Patch 2 adds the driver documentation under Documentation/scsi/.

Changes in v2:
- resend the series with corrected threading
- no code changes since v1

The earlier resend accidentally reused old threading information, which
caused the series to appear incorrectly in the public archive.

Thanks,
Dongdong Hao

Dongdong Hao (2):
  scsi: leapraid: Add new SCSI driver
  scsi: leapraid: Add driver documentation

 Documentation/scsi/index.rst               |    1 +
 Documentation/scsi/leapraid.rst            |  139 +
 MAINTAINERS                                |    7 +
 drivers/scsi/Kconfig                       |    1 +
 drivers/scsi/Makefile                      |    1 +
 drivers/scsi/leapraid/Kconfig              |   14 +
 drivers/scsi/leapraid/Makefile             |   10 +
 drivers/scsi/leapraid/leapraid.h           | 2071 +++++
 drivers/scsi/leapraid/leapraid_app.c       |  705 ++
 drivers/scsi/leapraid/leapraid_func.c      | 9053 ++++++++++++++++++++
 drivers/scsi/leapraid/leapraid_func.h      | 1566 ++++
 drivers/scsi/leapraid/leapraid_os.c        | 2516 ++++++
 drivers/scsi/leapraid/leapraid_transport.c | 1387 +++
 13 files changed, 17471 insertions(+)
 create mode 100644 Documentation/scsi/leapraid.rst
 create mode 100644 drivers/scsi/leapraid/Kconfig
 create mode 100644 drivers/scsi/leapraid/Makefile
 create mode 100644 drivers/scsi/leapraid/leapraid.h
 create mode 100644 drivers/scsi/leapraid/leapraid_app.c
 create mode 100644 drivers/scsi/leapraid/leapraid_func.c
 create mode 100644 drivers/scsi/leapraid/leapraid_func.h
 create mode 100644 drivers/scsi/leapraid/leapraid_os.c
 create mode 100644 drivers/scsi/leapraid/leapraid_transport.c

-- 
2.25.1

