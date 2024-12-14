Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [96.44.175.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 698982940D;
	Sat, 14 Dec 2024 23:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=96.44.175.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734217700; cv=none; b=jwYjmRWjXi2vKfhWMxPHmIPYfrwK+4MXA8XsIxCVpRfPh40+u5y6YETUfJ1iag/L0eC1TojK0gLxhCkaa2EYTH8FVUcem4jUiYU1zAvlSKbILYQfQ813GysZpI3x5u0tM+DeLNRy5S8HK6Pc0Wr/Ra6zfzxDgK5J0HA3CMXP1mQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734217700; c=relaxed/simple;
	bh=GWw4KF+hRKBFAMhgE48/YsktFgqqrM1h+5Pz+RgAa1s=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=CA9Jqp80RMPfDA0BZhQ3FrxZ9kV5k8eN+LuSfOPcBVsR2efs4eP3FqAGgOjBvRzO57/vWWhRlH6dGG41q6D+X5AXFm5I72zSgrcV/LsSJBjeae1Di0I6bOa2iF+ANpj+Ipi0wXN1n2EKLi0i6KncGUOJK7+u4yYIcCyYBKCPCpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=IJ5HbDFS; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=IJ5HbDFS; arc=none smtp.client-ip=96.44.175.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="IJ5HbDFS";
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="IJ5HbDFS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1734217697;
	bh=GWw4KF+hRKBFAMhgE48/YsktFgqqrM1h+5Pz+RgAa1s=;
	h=Message-ID:Subject:From:To:Date:From;
	b=IJ5HbDFSz9s9McpQ/dv9zaNAS4KLZ5fpEXvd1uMKjXtRrLfSx/Rno/D6cgwJ/PusN
	 UdIW7nadQNqvLDZ1ARitK3K4FOnduvygpSeRUMSpu4iSDv3w8WaGEgndArMvw0ibwc
	 CprgA1Nf6QNmOjLmRFOYiaKRHJrxMPVE6M6DKcxY=
Received: from localhost (localhost [127.0.0.1])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id 6188E128728E;
	Sat, 14 Dec 2024 18:08:17 -0500 (EST)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
 by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavis, port 10024)
 with ESMTP id kzL4dClgryJt; Sat, 14 Dec 2024 18:08:17 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1734217697;
	bh=GWw4KF+hRKBFAMhgE48/YsktFgqqrM1h+5Pz+RgAa1s=;
	h=Message-ID:Subject:From:To:Date:From;
	b=IJ5HbDFSz9s9McpQ/dv9zaNAS4KLZ5fpEXvd1uMKjXtRrLfSx/Rno/D6cgwJ/PusN
	 UdIW7nadQNqvLDZ1ARitK3K4FOnduvygpSeRUMSpu4iSDv3w8WaGEgndArMvw0ibwc
	 CprgA1Nf6QNmOjLmRFOYiaKRHJrxMPVE6M6DKcxY=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4302:c21::a774])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id C811F128724F;
	Sat, 14 Dec 2024 18:08:16 -0500 (EST)
Message-ID: <395d805645f141b15ef818dadf39c8689986e8b4.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 6.13-rc2
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds
	 <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel
	 <linux-kernel@vger.kernel.org>
Date: Sat, 14 Dec 2024 18:08:14 -0500
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

Simple one-line fix in the ufs driver.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

liuderong (1):
      scsi: ufs: core: Update compl_time_stamp_local_clock after completing a cqe

And the diffstat:

 drivers/ufs/core/ufshcd.c | 1 +
 1 file changed, 1 insertion(+)

With full diff below.

Regards,

James

---

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index b7ec5797d5ba..8a01e4393159 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5556,6 +5556,7 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba, int task_tag,
 
 	lrbp = &hba->lrb[task_tag];
 	lrbp->compl_time_stamp = ktime_get();
+	lrbp->compl_time_stamp_local_clock = local_clock();
 	cmd = lrbp->cmd;
 	if (cmd) {
 		if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))

