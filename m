Received: from mta-03.yadro.com (mta-03.yadro.com [89.207.88.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE2A91DE89F;
	Tue,  8 Oct 2024 13:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.207.88.253
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728394298; cv=none; b=cBcMU7fTBX+ijC2uVeEe/xa8Nf6IMCLrzJtOrFb3gjN0IVgBQeqQCDd25sqciJ8DObR9ufqIPr/4ngoviWClPLFjGGah+qMHTnDhx/KqJkMSTkp87UcbONf+fdLtCiFgetkmTr+0PgnHtVEVfDhEi/gyRs6aAH+eyQld6q4dpOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728394298; c=relaxed/simple;
	bh=+bURHDW1zXCtiAD9N+c9kvwLuZzFe8wpbzI8L4zxdHI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=mkNFuQATfpjwMD7VWh9nNnyZND0ZYmpFuDqduWi8YmTGbaW2LuF+4OQ1E1Za4zP2fhUN0vHB6d0RRQVoRM3jkl5h+wZ3GDnM89fh4gdyL5mPH2BHaHlcnm/GCJwjDvGtYz911kGPQZQP0Z56bwPUwTXheCDCcrjurXVicP/5FTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yadro.com; spf=pass smtp.mailfrom=yadro.com; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=rjRLyNfc; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=vJNl3ABD; arc=none smtp.client-ip=89.207.88.253
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yadro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yadro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="rjRLyNfc";
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="vJNl3ABD"
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-03.yadro.com F02E6E0018
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-04;
	t=1728394285; bh=NI26YxtnlPI8PCKS5w9xUUDiSDrbLNakfEZ1X9++Fjc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=rjRLyNfcbLz/2hqcVQCMAZoRw8MsqidBEIMAzkMz9zroIpC3xWCaOG0YT/WzbRLJ1
	 /XrVVwFVOcxMag/Mi+zHKL8wCZD+muLiP7xDGigEcb17HmaiuSvW+nXFVbvAc36e+B
	 9r8aoUBx1Gv7KshqaioRwX4YEPp4MDI4Vskk5Rz36y74//SA4Ci4E+ED5sUtjo5FEv
	 sXDrXfarynWGb5KqVrUdzCKkw5B7Kj023exWyZBJErERXasQGzsLZ2GWCdEkBGzWJf
	 IULKOLvoXpfuKM3qZAp5boQ8U2KMWzJ4ufh8QfC0GYiA0KkuFZ8MdhHBFnuMOqXctB
	 frK//N1UMR1Ag==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
	t=1728394285; bh=NI26YxtnlPI8PCKS5w9xUUDiSDrbLNakfEZ1X9++Fjc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=vJNl3ABDxivtHYMGDimdOeMMFTtPST5m5bxK6yqbjQtSWgvtyFX5xM6+OtdCyweF4
	 xrtZNWbcl+t74tvHc9QbVjTdUqCuAAa9DlrE5DFO5dChf5AOG2HHg8IIptZU6qSQMK
	 ntfM4cMHIpiL7KOT6uEdmnIKgAO4A1mppwrEPLVE0my2u/QcBlDMKEeNoDvHUxYWDu
	 1tvmzZJk9KfEfsAosc6UhdvGhBq1/xii2qc7yeJUuMcraO5FwKi/UyP4vmyoBCSLrX
	 4pxIi522jk5khcMYZ6ckQQTYUop4mTqIW3gRWe5EA9tzAWJR10UixR/ll7zzAgE/30
	 wShXJIXY6rYQQ==
From: Anastasia Kovaleva <a.kovaleva@yadro.com>
To: <target-devel@vger.kernel.org>
CC: <njavali@marvell.com>, <GR-QLogic-Storage-Upstream@marvell.com>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<bvanassche@acm.org>, <quinn.tran@cavium.com>, <nab@linux-iscsi.org>,
	<himanshu.madhani@cavium.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux@yadro.com>
Subject: [PATCH 0/3] Fix bugs in qla2xxx driver
Date: Tue, 8 Oct 2024 16:23:59 +0300
Message-ID: <20241008132402.26164-1-a.kovaleva@yadro.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-ClientProxiedBy: T-EXCH-08.corp.yadro.com (172.17.11.58) To
 T-EXCH-09.corp.yadro.com (172.17.11.59)

This series of patches contains 3 separate changes that fix some bugs in
the qla2xxx driver.

Anastasia Kovaleva (3):
  scsi: qla2xxx: Drop starvation counter on success
  scsi: qla2xxx: make target send correct LOGO
  scsi: qla2xxx: Remove incorrect trap

 drivers/scsi/qla2xxx/qla_iocb.c   | 11 +++++++++++
 drivers/scsi/qla2xxx/qla_isr.c    |  4 ++++
 drivers/scsi/qla2xxx/qla_target.c | 21 ++++++++++++---------
 3 files changed, 27 insertions(+), 9 deletions(-)

-- 
2.40.1

