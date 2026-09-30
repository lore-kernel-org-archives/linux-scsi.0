Received: from mta0.migadu.com (out-17.mta0.migadu.com [91.218.175.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E00A4E36D0
	for <linux-scsi@vger.kernel.org>; Wed, 30 Sep 2026 14:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790780181; cv=none; b=B77yBTWFibxs7qPa/pvDcxr5oWAOIseB7VMh0kuf4Zj6/WWX41K2EYO8ylOdAJ1bpICcSOVqsWnljJn8NnjzHF9T30jwvEuKJ2+AGTLdXwZMJCxlpLFeC9PAbyeMP8vyzZsN7FRIY6IluagmJHHFZzzecREHyi/A3HXrKGnMKQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790780181; c=relaxed/simple;
	bh=1ZhA08mF8Ah2Lwc9DAcLEBJfj//8Kx71iQyWaq74mY8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UEU6/prtVycYVHs8tKjy+YNESIYba9zMTNJ5cvsKECKUi+TAVy+/Db7DNM4VfVb9B2GkI2BJd3h0XYTa3q2Uj5RqwgJs+gRCBJnRQlOaAm+uaatT6ER7f3IGKlF80K+KedlRiGXz/srHhAbwJi1vkPeEG3juf+sr9Rkm5/kJjUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vDWOCCmZ; arc=none smtp.client-ip=91.218.175.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vDWOCCmZ"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=1ZhA08mF8Ah2Lwc9DAcLEBJfj//8Kx71iQyWaq74mY8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790780169; v=1; x=1791384969;
 b=vDWOCCmZv9CFFKUU7r1aGohKX1qHCQEzVt+MB9yHuJ9BTMUdJwrrW29Bq7LNEDos81UGuQ3l
 VAHc5hU+2zlAD8G+4wOCwwp8VSeusGFXgWZTvjqMOMkfr6w6XcW7u+ff5IdGSFbK1ahmj9IE9+I
 SNzlMMsLvWhAaq7sBnAx35wQ=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id e4d7d53d04f53449;
	Wed, 30 Sep 2026 14:56:08 +0000
X-Mizu-Trace-ID: e4d7d53d04f53449
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: mkp@kernel.org,
	sathya.prakash@broadcom.com,
	kashyap.desai@broadcom.com,
	sumit.saxena@broadcom.com,
	sreekanth.reddy@broadcom.com,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	ranjan.kumar@broadcom.com,
	chandrakanth.patil@broadcom.com,
	thenzl@redhat.com,
	hare@suse.de,
	himanshu.madhani@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Usama Arif <usama.arif@linux.dev>
Subject: [PATCH 0/2] scsi: mpi3mr: Stop IRQ polling when no reply is ready
Date: Wed, 30 Sep 2026 07:55:47 -0700
Message-ID: <20260930145606.2632749-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Once a reply queue has more than 8 I/Os pending, mpi3mr's IRQ thread
polls it every ~20us until nothing is pending or it has processed
max_host_ios replies. On busy HDDs that means about 45 seconds of
polling at a time, with nearly every wakeup finding nothing. On Meta's
HDD storage hosts, these threads used about 15% of the non-idle CPU
on polling.

Patch 2 goes back to interrupts once a poll finds the queue empty while
owning it. It relies on patch 1: an interrupt that finds the queue owned
by another context now hands it to the thread, instead of leaving a
reply until the next interrupt or a command timeout.

On a machine configured like those hosts (36 SATA HDDs behind a SAS40xx
HBA), HDD random reads now wake the threads twice per I/O instead of 236
times, and a co-located CPU-bound task loses 0.6% instead of 30%.
Drive-cache reads still reach 270K IOPS, and a single reply queue whose
CPU is saturated loses about 5%. With a kthread injected to hold a reply
queue, replies waited up to 50ms, and timed out under light load,
without patch 1, and at most 233us with it.

Based on mkp/scsi 7.4/scsi-staging (f09d2c7485b32).
 
Usama Arif (2):
  scsi: mpi3mr: Poll a reply queue that an interrupt found busy
  scsi: mpi3mr: Stop IRQ polling when no reply is ready

 drivers/scsi/mpi3mr/mpi3mr.h    |  2 +-
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 65 ++++++++++++++++++++++++---------
 drivers/scsi/mpi3mr/mpi3mr_os.c |  2 +-
 3 files changed, 50 insertions(+), 19 deletions(-)


base-commit: f09d2c7485b32adb82336d0d748935c8237a649e
-- 
2.53.0-Meta

