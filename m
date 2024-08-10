Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588FD13B5A5
	for <linux-scsi@vger.kernel.org>; Sat, 10 Aug 2024 04:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723264026; cv=none; b=Y/6rOmHXWHZXNKHdgRN9sifx6miln/avfdGtuztQJ/9/pLrGunfj+nDiTAfO+DP4MMb3ZP3PXn6GUdgubPmOu2V6SikGgfU86hcI9Iwdk5AEyhmDETha03O2Uc8qKHNaR/77rrBrR6fNnueqGjKAMIWV4Ykz4eyO6R86xwMYGKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723264026; c=relaxed/simple;
	bh=MUF4a5JgO0vlKMz3BxvcL04PLe+tvGjoXRF9TIfqLNM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IFb1mvjCiVzRpr+h2hBvm/oLcdRMU4S3ZhwQj4IboX72+6hO1JhJfSTSkIK5wEHGLwFdaWjmVe75I1GZb7LkS/gk81cMfxb9frptbZNywRVjd7DYyjt+4lzY9t0lY7MsohEIXF39W2tIEhUtZK0T4uV5HUtRaac9v3jGNWAu7vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=koRfNGQG; arc=none smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="koRfNGQG"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1723264024; x=1754800024;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=MUF4a5JgO0vlKMz3BxvcL04PLe+tvGjoXRF9TIfqLNM=;
  b=koRfNGQGxegRW2KTXHsMPm3PqEDnjZDZv7TUSZ0DNUBpYDbUWED+eM1L
   4Gxmiv8yxw8Qp+6RpoF5ajzow3rtqOYLtFNEWSd1FXNfuhAHMQIuIuv0n
   CH+Bm9+3Vr7OZNTfZB1W8fJSX1QuG31EsjOrmOlSYApZqV+zCPPuzyoDT
   DP3x8K7VzSk+r5CVNRz6jOXUZemmTzq81kEfqwybTVSxQdhy0TTrpHl9X
   GIPSVKJOFkihN9wEO+Zpl0itwnlFZJBTY4gBi5/B6Zfl7EwqLPCJvONVi
   P7pnm6f3zzAkqxI1oQBfvdqOgSKZn1CHVLC6aEMdzmYptoYVRV3pANzpA
   w==;
X-CSE-ConnectionGUID: QAy7gTlUTSC4rtrzdZuPPw==
X-CSE-MsgGUID: Aki7lucHRtiihwzAokTX+A==
X-IronPort-AV: E=Sophos;i="6.09,278,1716220800"; 
   d="scan'208";a="23359477"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 10 Aug 2024 12:27:03 +0800
IronPort-SDR: 66b6df6d_pXt/xtjmFtOSXXgiI1kreIzm2vPbVKMS87MqyFlDuFvOEW3
 UKHVL/W4zxtwZ88+N02NztRKa503MDT+G34V27w==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 09 Aug 2024 20:33:02 -0700
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.66.30])
  by uls-op-cesaip02.wdc.com with ESMTP; 09 Aug 2024 21:27:02 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: linux-scsi@vger.kernel.org,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 0/2] scsi: mpi3mr: Fix two bugs in the new buffer allocation code
Date: Sat, 10 Aug 2024 13:26:59 +0900
Message-ID: <20240810042701.661841-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The commit fc4444941140 ("scsi: mpi3mr: HDB allocation and posting for
hardware and firmware buffers") in the kernel version v6.11-rc1
triggered an INFO and a WARN. Two patches in this series address them
respectively.

Shin'ichiro Kawasaki (2):
  scsi: mpi3mr: Add missing spin_lock_init() for mrioc->trigger_lock
  scsi: mpi3mr: Avoid MAX_PARE_ORDER WARNING for buffer allocations

 drivers/scsi/mpi3mr/mpi3mr_app.c | 11 ++++++++---
 drivers/scsi/mpi3mr/mpi3mr_os.c  |  1 +
 2 files changed, 9 insertions(+), 3 deletions(-)

-- 
2.45.2

