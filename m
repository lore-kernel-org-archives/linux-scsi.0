Received: from mail-m15591.qiye.163.com (mail-m15591.qiye.163.com [101.71.155.91])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E3F32E9730
	for <linux-scsi@vger.kernel.org>; Mon,  1 Jun 2026 12:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.71.155.91
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780316843; cv=none; b=ao0zmB26iANKCt7yvKYto9BOqZi62gYtRGLqqWXYKYLWS8YLqsePLzuQ9TrODaMsA9TCxSlfrOQEc9tVJ6EGQYmk2R9G74VtrSELz2tQ/uZzblzAxdizJWoKvpBaw5xGzTTUir2BBUEdnPYMXh+BAtYFviRXXtWLK4whfxJeW+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780316843; c=relaxed/simple;
	bh=b8sikl8mGUh0lYKMnMqJbgwqFYGSZZrRtuCfgbcx3Bs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=gjSIbwFc3tYvkg3OV5VcNviw/SPva5ciF6WoRf6lYUqBl6riokx5O+jTQA66cVU5S6NjFBM3OcvNK0bi2wp/L/7HDXFtn/QchjlFMzMUClO4UXc7F0SsxfhmJ0E5l17HzYeOwev9wPrNe8POoI5CQvdlUWfGVU+v/HOtALqJboo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=leap-io-kernel.com; spf=pass smtp.mailfrom=leap-io-kernel.com; dkim=pass (2048-bit key) header.d=leap-io-kernel.com header.i=@leap-io-kernel.com header.b=LAbqAubo; arc=none smtp.client-ip=101.71.155.91
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=leap-io-kernel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leap-io-kernel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leap-io-kernel.com header.i=@leap-io-kernel.com header.b="LAbqAubo"
Received: from localhost.localdomain (unknown [222.130.22.242])
	by smtp.qiye.163.com (Hmail) with ESMTP id 409944e5d;
	Mon, 1 Jun 2026 19:51:48 +0800 (GMT+08:00)
From: Dongdong Hao <doubled@leap-io-kernel.com>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: doubled@leap-io-kernel.com,
	yjzhang@leap-io-kernel.com,
	kezijie@leap-io-kernel.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH 0/2] scsi: leapraid: Add new scsi driver
Date: Mon,  1 Jun 2026 19:51:45 +0800
Message-Id: <cover.1780312123.git.doubled@leap-io-kernel.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9e8306986103aekunmd071acc9634e0e
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaGhhDVhoeGUJKHktMGkJISlYVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlJSUlVSkhLVUlJVUlPSVlXWRYaDxIVHRRZQVlPS0hVSk
	tISk9ITFVKS0tVSkJLS1kG
DKIM-Signature: a=rsa-sha256;
	b=LAbqAubo332NEeIdob0AvaiEMNBaiUG604dnq5HeJTief8XMzFons5cJ+/rNVBAzgMbQqAqSxoxd2o+qFhLbJW+AFz6qUNtcWYsJap/i2wDMpVEDYW//q1Y0jmy1Fi0EPfeZqkcXhwHErvP+uKbitgVnl+q3O8h/pUxQ3mcqTVcyVyb3ok46VZfWqEUaSXY1oHznbDWLJOEuV0Z4gVIIwGXwo+FWVscqRiFdnZGlXhwpoOLkBA/Fha3aQThlWVdSlM/9PmrycwxRVwlAr6tfEG/cHMaTQI/er5NmqFcdCbkXKSlFxy7L7s3WSMY3gOmlt4jmFzDcdDkByZ30M5yM8w==; c=relaxed/relaxed; s=default; d=leap-io-kernel.com; v=1;
	bh=GayGnWova0n+aBZrxwyFw0C3bbHcinI+vkKohLa5hzw=;
	h=date:mime-version:subject:message-id:from;

Dongdong Hao (2):
  scsi: leapraid: Add new scsi driver
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

