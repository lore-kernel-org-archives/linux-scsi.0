Received: from mta0.migadu.com (out-102.mta0.migadu.com [91.218.175.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1AF4052A4
	for <linux-scsi@vger.kernel.org>; Thu,  1 Oct 2026 10:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790851930; cv=none; b=VAQLDt/uiuiLQZqJxYlz13V4ERdR8qJCmQw5Hj0J862CK2Ql92RNIo/cvGQKgvu6x5FRouZk5mESju0pynNVpDYa0sMFjKR3VdZxsMvXeLgojzGDhHcEjthnzdXlCvwOK4Fqs5+LZufhIVi3AsoN9tnkcM1VKOU1Vg09arAZO/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790851930; c=relaxed/simple;
	bh=F7/0Xze85k9s1voAnMLsmJkH6CTMb8VD14ZOkRUh8Js=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rHENI2YTJ7OQGyfmfuJ4y24ZlJEToOwQ5LAiKvUdIR9ux2ufSeJAf8afdA+KXIrZf34VL2DEg3XoqnVMCUGMRjrtQh5Q8rjAXDpLnXCfDSnVelIiK2TBBoxcr5XURGfgrh5o3bO/kNZB0p0dx6/zGYbe5Dxm4QFLaVCXjJ5Qfak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iCPu8ben; arc=none smtp.client-ip=91.218.175.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iCPu8ben"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=F7/0Xze85k9s1voAnMLsmJkH6CTMb8VD14ZOkRUh8Js=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790851926; v=1; x=1791456726;
 b=iCPu8benDN4QFFe+JgStna1GPWcI8VxQ5IxwXnOvpHKBZhbnYreJILZ4xT+N5TxCUmiNCUM5
 Xu5LSkMSysMoEpcw8LqNH2AYlBVE/AB8HpCQVk28SjlomrGWGKB6swHXnJJwdpnrxgAP4u4Qu1c
 hpzfqtsXMcmqnYKM3NP2fva0=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id 4dfc51004a80d778;
	Thu, 01 Oct 2026 10:52:05 +0000
X-Mizu-Trace-ID: 4dfc51004a80d778
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Usama Arif <usama.arif@linux.dev>
Cc: mkp@kernel.org,
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
Subject: Re: [PATCH 0/2] scsi: mpi3mr: Stop IRQ polling when no reply is ready
Date: Thu,  1 Oct 2026 03:51:57 -0700
Message-ID: <20261001105158.3456162-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260930145606.2632749-1-usama.arif@linux.dev>
References: 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 30 Sep 2026 07:55:47 -0700 Usama Arif <usama.arif@linux.dev> wrote:

> Once a reply queue has more than 8 I/Os pending, mpi3mr's IRQ thread
> polls it every ~20us until nothing is pending or it has processed
> max_host_ios replies. On busy HDDs that means about 45 seconds of
> polling at a time, with nearly every wakeup finding nothing. On Meta's
> HDD storage hosts, these threads used about 15% of the non-idle CPU
> on polling.
> 
> Patch 2 goes back to interrupts once a poll finds the queue empty while
> owning it. It relies on patch 1: an interrupt that finds the queue owned
> by another context now hands it to the thread, instead of leaving a
> reply until the next interrupt or a command timeout.
> 
> On a machine configured like those hosts (36 SATA HDDs behind a SAS40xx
> HBA), HDD random reads now wake the threads twice per I/O instead of 236
> times, and a co-located CPU-bound task loses 0.6% instead of 30%.
> Drive-cache reads still reach 270K IOPS, and a single reply queue whose
> CPU is saturated loses about 5%. With a kthread injected to hold a reply
> queue, replies waited up to 50ms, and timed out under light load,
> without patch 1, and at most 233us with it.

I believe all of the sashiko reviews are pre-existing conditions and not
introduced by these patches. I have replied in [1] and [2]

[1] https://lore.kernel.org/all/bdf2781e-fbcb-4356-b1eb-ccdbfb39c1b9@linux.dev/
[2] https://lore.kernel.org/all/0b1bb7ce-4720-4d12-96ff-ab04cd1b85bc@linux.dev/

> 
> Based on mkp/scsi 7.4/scsi-staging (f09d2c7485b32).
>  
> Usama Arif (2):
>   scsi: mpi3mr: Poll a reply queue that an interrupt found busy
>   scsi: mpi3mr: Stop IRQ polling when no reply is ready
> 
>  drivers/scsi/mpi3mr/mpi3mr.h    |  2 +-
>  drivers/scsi/mpi3mr/mpi3mr_fw.c | 65 ++++++++++++++++++++++++---------
>  drivers/scsi/mpi3mr/mpi3mr_os.c |  2 +-
>  3 files changed, 50 insertions(+), 19 deletions(-)
> 
> 
> base-commit: f09d2c7485b32adb82336d0d748935c8237a649e
> -- 
> 2.53.0-Meta
> 
> 
