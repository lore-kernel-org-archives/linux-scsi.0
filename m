Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935911BEF70;
	Wed, 19 Feb 2025 07:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739948428; cv=none; b=PgI6AnVcbwDwGgg8o2lsxi2xh0paj2zKdqSoQbIq91BikqC0pZ9em3U0NSW4XkxQ0iMy2SpNNkY+uq8pLzYXcsiToG/ou5dFsAj7KI5LDhrVFlKd8S7DK8PMsEoLmGFs4RvEodherpL0D5mqn9cB1sVr3V9DfogTyUe/V1rlWXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739948428; c=relaxed/simple;
	bh=EyPRnOEmDMGyro6oEufQ1Ac8HRmfHVqfKm+/uSQeBpE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=N9KhK3HeGQkP0I9Du7mVIkIwmk9l0A/adhEud7mxEm1jIidPA6c0Uv21pc4m8H6XyysFVt4cGNd+cF1keU/WvIa15ZzqJRsRiC+kVBbg3U0LO5S3CNcMEMa1x4WvX5O2WF89lk4B6/JQU/irIKaMpmY9j5laP1AvEo3VMrny9R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=n9nQAapI; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="n9nQAapI"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51J6gZPw020920;
	Wed, 19 Feb 2025 07:00:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=VSSxu6cd8Y1QoaX22sebDySSx5Ce5oG5XF+7BGDAK
	+E=; b=n9nQAapIhNPj6rKr4r50DF3Wz/uFCc2kKcELdyPIxzE5LjVhGLFnXomUL
	+x7R59WsoGvOAnEGQ/m9ZEkXce8Nyq/14pL9U1bdv6HHi1IT3pbAIEKxDjff+i3t
	66hMiyk6uXpcpxZ/pC3xcN+wdhsm6DpQUCcvfdmQEODxDXUzskPz+pI8Of8V1L0I
	1k4dn4pj4j+45Sgfk+hboqZXpPFCuYoIMPLxerRxmUx/6IYGHywtiMRNKHJ3sWoC
	5C/MkkDDPP7kxC7XnZUVyYuONL0DhxhAormh2f02P0M+vBAS+daPz+nol/wdoNQf
	2HLnd7xUPOyE65ekqSJ77K0MTJ54g==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44vyyptd4d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Feb 2025 07:00:17 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51J6tYhj005844;
	Wed, 19 Feb 2025 07:00:16 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44w02xan2n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Feb 2025 07:00:16 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51J70E5i52429082
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Feb 2025 07:00:14 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AE85720040;
	Wed, 19 Feb 2025 07:00:14 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C6D1A2004E;
	Wed, 19 Feb 2025 07:00:13 +0000 (GMT)
Received: from ozlabs.au.ibm.com (unknown [9.63.197.14])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 19 Feb 2025 07:00:13 +0000 (GMT)
Received: from jarvis.ozlabs.ibm.com (haven.au.ibm.com [9.63.198.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ozlabs.au.ibm.com (Postfix) with ESMTPSA id 1E37A6033C;
	Wed, 19 Feb 2025 18:00:11 +1100 (AEDT)
From: Andrew Donnellan <ajd@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, fbarrat@linux.ibm.com, ukrishn@linux.ibm.com,
        clombard@linux.ibm.com, vaibhav@linux.ibm.com,
        martin.petersen@oracle.com
Subject: [PATCH v3 0/1] Remove cxl driver
Date: Wed, 19 Feb 2025 18:00:05 +1100
Message-ID: <20250219070007.177725-1-ajd@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Gz0sNBoF71q4pxq9lVYy0b_9lYRbLv1T
X-Proofpoint-ORIG-GUID: Gz0sNBoF71q4pxq9lVYy0b_9lYRbLv1T
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-19_03,2025-02-18_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=619 clxscore=1015
 suspectscore=0 bulkscore=0 lowpriorityscore=0 adultscore=0 malwarescore=0
 phishscore=0 spamscore=0 impostorscore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2502100000
 definitions=main-2502190053

This series removes the cxl for IBM CAPI devices.

CAPI devices have been out of production for some time, and we're not
aware of any remaining users who are likely to want a modern kernel.
There's almost certainly some remaining driver bugs and we don't have much
hardware available to properly test the drivers any more. Removing these
drivers will also mean we can get rid of a non-trivial amount of support
code in arch/powerpc.

Thanks to everyone who's worked on these drivers over the last decade.

This series does not affect the OpenCAPI/ocxl driver, nor does it affect
Compute Express Link (the other cxl, an amusing but unfortunate naming
collision).

The previous version of this series also removed the cxlflash driver,
which has now been merged into the scsi tree as 772ba9b5bd27 ("scsi:
cxlflash: Remove driver").

This series applies on top of 772ba9b5bd27 and the patch at [0].

[0] https://patchwork.ozlabs.org/project/linuxppc-dev/patch/20250219064807.175107-1-ajd@linux.ibm.com/

v1: https://patchwork.ozlabs.org/project/linuxppc-dev/list/?series=436014&state=*
v2: https://patchwork.ozlabs.org/project/linuxppc-dev/list/?series=442572&state=*

v1->v2: rebase and update docs
v2->v3: rebase on docs changes

Andrew Donnellan (1):
  cxl: Remove driver

 .../ABI/{obsolete => removed}/sysfs-class-cxl |   55 +-
 Documentation/arch/powerpc/cxl.rst            |  470 ----
 Documentation/arch/powerpc/index.rst          |    1 -
 .../userspace-api/ioctl/ioctl-number.rst      |    2 +-
 MAINTAINERS                                   |   12 -
 arch/powerpc/configs/skiroot_defconfig        |    1 -
 arch/powerpc/include/asm/copro.h              |    6 -
 arch/powerpc/include/asm/device.h             |    3 -
 arch/powerpc/include/asm/pnv-pci.h            |   17 -
 arch/powerpc/mm/book3s64/hash_native.c        |   13 +-
 arch/powerpc/mm/book3s64/hash_utils.c         |   10 +-
 arch/powerpc/mm/book3s64/pgtable.c            |    1 -
 arch/powerpc/mm/book3s64/slice.c              |    6 +-
 arch/powerpc/mm/copro_fault.c                 |   12 -
 arch/powerpc/platforms/powernv/Makefile       |    1 -
 arch/powerpc/platforms/powernv/pci-cxl.c      |  153 --
 arch/powerpc/platforms/powernv/pci-ioda.c     |   43 -
 arch/powerpc/platforms/powernv/pci.c          |   61 -
 arch/powerpc/platforms/powernv/pci.h          |    2 -
 drivers/misc/Kconfig                          |    1 -
 drivers/misc/Makefile                         |    1 -
 drivers/misc/cxl/Kconfig                      |   28 -
 drivers/misc/cxl/Makefile                     |   14 -
 drivers/misc/cxl/api.c                        |  532 -----
 drivers/misc/cxl/base.c                       |  126 -
 drivers/misc/cxl/context.c                    |  362 ---
 drivers/misc/cxl/cxl.h                        | 1135 ---------
 drivers/misc/cxl/cxllib.c                     |  271 ---
 drivers/misc/cxl/debugfs.c                    |  134 --
 drivers/misc/cxl/fault.c                      |  341 ---
 drivers/misc/cxl/file.c                       |  699 ------
 drivers/misc/cxl/flash.c                      |  538 -----
 drivers/misc/cxl/guest.c                      | 1208 ----------
 drivers/misc/cxl/hcalls.c                     |  643 -----
 drivers/misc/cxl/hcalls.h                     |  200 --
 drivers/misc/cxl/irq.c                        |  450 ----
 drivers/misc/cxl/main.c                       |  383 ---
 drivers/misc/cxl/native.c                     | 1592 -------------
 drivers/misc/cxl/of.c                         |  346 ---
 drivers/misc/cxl/pci.c                        | 2103 -----------------
 drivers/misc/cxl/sysfs.c                      |  771 ------
 drivers/misc/cxl/trace.c                      |    9 -
 drivers/misc/cxl/trace.h                      |  691 ------
 drivers/misc/cxl/vphb.c                       |  309 ---
 include/misc/cxl-base.h                       |   48 -
 include/misc/cxl.h                            |  265 ---
 include/misc/cxllib.h                         |  129 -
 include/uapi/misc/cxl.h                       |  156 --
 48 files changed, 42 insertions(+), 14312 deletions(-)
 rename Documentation/ABI/{obsolete => removed}/sysfs-class-cxl (87%)
 delete mode 100644 Documentation/arch/powerpc/cxl.rst
 delete mode 100644 arch/powerpc/platforms/powernv/pci-cxl.c
 delete mode 100644 drivers/misc/cxl/Kconfig
 delete mode 100644 drivers/misc/cxl/Makefile
 delete mode 100644 drivers/misc/cxl/api.c
 delete mode 100644 drivers/misc/cxl/base.c
 delete mode 100644 drivers/misc/cxl/context.c
 delete mode 100644 drivers/misc/cxl/cxl.h
 delete mode 100644 drivers/misc/cxl/cxllib.c
 delete mode 100644 drivers/misc/cxl/debugfs.c
 delete mode 100644 drivers/misc/cxl/fault.c
 delete mode 100644 drivers/misc/cxl/file.c
 delete mode 100644 drivers/misc/cxl/flash.c
 delete mode 100644 drivers/misc/cxl/guest.c
 delete mode 100644 drivers/misc/cxl/hcalls.c
 delete mode 100644 drivers/misc/cxl/hcalls.h
 delete mode 100644 drivers/misc/cxl/irq.c
 delete mode 100644 drivers/misc/cxl/main.c
 delete mode 100644 drivers/misc/cxl/native.c
 delete mode 100644 drivers/misc/cxl/of.c
 delete mode 100644 drivers/misc/cxl/pci.c
 delete mode 100644 drivers/misc/cxl/sysfs.c
 delete mode 100644 drivers/misc/cxl/trace.c
 delete mode 100644 drivers/misc/cxl/trace.h
 delete mode 100644 drivers/misc/cxl/vphb.c
 delete mode 100644 include/misc/cxl-base.h
 delete mode 100644 include/misc/cxl.h
 delete mode 100644 include/misc/cxllib.h
 delete mode 100644 include/uapi/misc/cxl.h

-- 
2.48.1
