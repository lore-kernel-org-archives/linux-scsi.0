Received: from mail-m19731102.qiye.163.com (mail-m19731102.qiye.163.com [220.197.31.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F97328504D
	for <linux-scsi@vger.kernel.org>; Mon, 22 Jun 2026 07:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782114998; cv=none; b=Jtsm7ON6wkNDaQCJQtcGF8gsuJGDDtNNSq98OPfC1SERn+LyXh0J1y23OaiKpE3x2sw2J98sXEEwHQMyJt8Sr/0Ibd+WhFfwPGUpX/AzScHDLCzpGubq9wQJbcOVaMKreCIeKzEYEs/Uzx2an5OHx5o3N4cQsUsndvRk9eRLPWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782114998; c=relaxed/simple;
	bh=LMp9+LV5kgFE5HEIh2L9W9npgmYUZ0JoLJjZ0okf1TY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Pv5oo3LLyjol5HQ69kQh0FhNs+Y+mHggwpqI7t88cSG55tEt8NgASLW+2UBcnw7wajk1Gjj+IU4pUoiwLni+O4gW5o+ZRlDmt8lHwy+zSRzGLIOpcg+6x12j9qu+W3qccXMz43wYaL9xSMfMSkbQL+btXK33Iqiy4qZQwWD8xeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=leap-io-kernel.com; spf=pass smtp.mailfrom=leap-io-kernel.com; dkim=pass (2048-bit key) header.d=leap-io-kernel.com header.i=@leap-io-kernel.com header.b=TrNCwoUe; arc=none smtp.client-ip=220.197.31.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=leap-io-kernel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leap-io-kernel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leap-io-kernel.com header.i=@leap-io-kernel.com header.b="TrNCwoUe"
Received: from localhost.localdomain (unknown [222.130.22.242])
	by smtp.qiye.163.com (Hmail) with ESMTP id 433ea5bd2;
	Mon, 22 Jun 2026 15:51:15 +0800 (GMT+08:00)
From: Dongdong Hao <doubled@leap-io-kernel.com>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: dlemoal@kernel.org,
	doubled@leap-io-kernel.com,
	yjzhang@leap-io-kernel.com,
	kezijie@leap-io-kernel.com,
	qtian@leap-io-kernel.com,
	jzzhang@leap-io-kernel.com,
	baikefan@leap-io-kernel.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH v4 0/2] scsi: Add LeapRAID driver support
Date: Mon, 22 Jun 2026 15:51:13 +0800
Message-Id: <cover.1782110784.git.doubled@leap-io-kernel.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9eee4fec8c03aekunm2c2703fa82288c
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCGR5OVkJPGR1OGUgaGh8dHVYVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlJSUlVSkhLVUlJVUlPSVlXWRYaDxIVHRRZQVlPS0hVSk
	tJT09PSFVKS0tVSkJLS1kG
DKIM-Signature: a=rsa-sha256;
	b=TrNCwoUee2jk1shGAiTjE2I6+xcvSYRSUSlQbUPJqaERerIoy8su8Af5HF+ab1OPpLZ+/Vhq8dFpc7ZPIt64tpicolp9RxAW/scpkTPqhFylbOsCVKYpfPe04DLCNBzXkH4T9Ca0FEH7R5QVzw7oI/dc1X1Pa50VLFdXW9BJscmYQcnmzBQyacijgNvf7I87IsJXkAW9baaqiLlIhKEWLmn0RogI7pqw9ac03m2BouyyOfbD9XwZO8eSeXGRRL6uKaF48zzKkn+bH54PBxeg62FR2HMeRyFbRA5b2kiDE2rDS9S7Nl5MT8xEO0UbcBn0hib+kRXutxQuX0/uVKD/SA==; c=relaxed/relaxed; s=default; d=leap-io-kernel.com; v=1;
	bh=L2sIV1RXXuVRqJJLVhIs2jf8QfgMw7CvWnL3a0Hh5TM=;
	h=date:mime-version:subject:message-id:from;

This series adds the LeapRAID driver and its documentation.

Changes in v4:
 - Fix the documented multipath module parameter name to enable_mp
 - Polish documentation wording and naming consistency

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
 drivers/scsi/leapraid/leapraid.h           | 2050 +++++
 drivers/scsi/leapraid/leapraid_app.c       |  699 ++
 drivers/scsi/leapraid/leapraid_func.c      | 8980 ++++++++++++++++++++
 drivers/scsi/leapraid/leapraid_func.h      | 1558 ++++
 drivers/scsi/leapraid/leapraid_os.c        | 2516 ++++++
 drivers/scsi/leapraid/leapraid_transport.c | 1387 +++
 13 files changed, 17363 insertions(+)
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

