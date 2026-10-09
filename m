Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D254347FC0;
	Fri,  9 Oct 2026 10:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791541447; cv=none; b=TcyjUH9d44sqoEqzY22AEoOH8vFUG6GMsONT3A8H4m0lLAyUfa19TIXSNQMl8FLyrqn2VnSF9inyGwZGrHemTbBxTnOwoBmTNRMcd+zLiS3CuORF/PspgkDCHkdY4nOH2oKorPqEw/NLluYG7VWyOEkbQSPbN7LAAFS6DZNlRGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791541447; c=relaxed/simple;
	bh=GP1lUcEwADCxU5EZrjt4kV96nOI30AAZhnSJQXXALpE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dpm262mPNWZQG1PWJe7zT9dqErJoE3Dq7bE9Cq9dfNTaGSm0yXTeefUiaYQNQ8PMufQ6aW4OF38SSoRjWTTD9fNmXx+bIQmTOVgzja4qNkiTkc8yi7eF12x2ltXJAObIcpIEycQw4OpaNzCT9hC21/L/AEbJN+mYVMh1p9b7bJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=jN0sB4x9; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="jN0sB4x9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=8b
	0qVGruCYX88mJhl0Y4rhQRLeI6Yh8hL+4KKjvTBxk=; b=jN0sB4x9pIHz0/QjZi
	bmk/qYfbtl2aLfMNjFWb4D0bGqjxKX6V6RP4ieY2GFyrN2NgDE77Kiw/j2qqth4j
	9M/psnHMgfAw1r8MXnermzExuEn4FunDiQVP5R6Rqr+wWYALXyLhIJng3ZT5Z4xr
	mNmdQwY8cLvWOdPR8rPfY4hrs=
Received: from WIN-TOG0NDEIICD.localdomain (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wBnjvSRwMhqk4VBDQ--.5655S2;
	Fri, 09 Oct 2026 18:23:14 +0800 (CST)
From: Shirong Zhao <shxzhaosr@163.com>
To: "Martin K . Petersen" <mkp@kernel.org>,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Dongdong Hao <doubled@leap-io-kernel.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	MPT-FusionLinux.pdl@broadcom.com,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] scsi: check set_identify result in update_links
Date: Fri,  9 Oct 2026 18:23:09 +0800
Message-ID: <20261009102313.18-1-shxzhaosr@163.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBnjvSRwMhqk4VBDQ--.5655S2
X-Coremail-Antispam: 1Uf129KBjvdXoWruw45Gw1xGw48uFy7tF4ruFg_yoWkCFb_u3
	9Yq34aq3y09r1fAayUCFs0qrZ0yay2qrnru3sFq39rGryfur4DWF1DJ3sxurn7GayYyFZY
	kFykX34fCrsxZjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU8MKZJUUUUU==
X-CM-SenderInfo: hvk06xhdrv2qqrwthudrp/xtbC7hIhX2rIwJKdNAAA3b

update_links() in mpt3sas, mpi3mr and leapraid all ignore the return
value of their set_identify helper.  On firmware query failure the
identify struct is left untouched, and the phy is then attached using
a stale sas_address from before the failed query.

This series fixes all three the same way: fold the call into the if
condition so a failed query takes the existing zeroing else path, the
same "no valid identify" state as an invalid handle or link rate.
The next successful link event re-fills the identify.

All three were verified against scsi.git fixes (469fa055664b): each
applies cleanly, passes checkpatch --strict with no warnings, and
its transport object builds warning-free before and after the change.

Shirong Zhao (3):
  scsi: mpt3sas: check set_identify result in update_links
  scsi: mpi3mr: check set_identify result in update_links
  scsi: leapraid: check set_identify result in update_links

 drivers/scsi/leapraid/leapraid_transport.c | 6 +++---
 drivers/scsi/mpi3mr/mpi3mr_transport.c     | 6 +++---
 drivers/scsi/mpt3sas/mpt3sas_transport.c   | 6 +++---
 3 files changed, 9 insertions(+), 9 deletions(-)

