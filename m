Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4DE30FC36
	for <linux-scsi@vger.kernel.org>; Fri, 14 Nov 2025 10:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763116246; cv=none; b=CelA3Yy2QzjjvkOgodZuXv/RykPJ8mcdxO9bYNTGHuwYCLcwIS2xxhNwK3ivbi6CyJFD730jRj6Uh1ohOliyEOFjd6oIOAHaIyMKrPvew1gCJfzMUalxQ01YGwvBWHxwNMKbDX57Yu4WKmjsr+7BVMqIIGIVwCcnQ0b477rJ9OU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763116246; c=relaxed/simple;
	bh=r5bHARdhR3DS/vqrjV0wzH5RIFJIIcLnxbC//3eB+Pg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tf3F9SMNphzwq3ejNX4gHBQELP+mlPN14f+UL7gArkI4svdnIZ4jiEd/OmNjEzkMtqdR9YjRAsq17WCATP+aX/j5H6wyHF/jJ3ak4FdeWmtXTRjBJWjfmikjb5uTqX7oyKijpctoi+sYP0D0HYqz3CTmdMNiszjxSfBvUB5KTvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id 98BA4180F2C0;
	Fri, 14 Nov 2025 11:30:35 +0100 (CET)
Received: from trufa.intra.herbolt.com.herbolt.com ([172.168.31.30])
	by mx0.herbolt.com with ESMTPSA
	id uCL9D8sEF2ktxDQAKEJqOA
	(envelope-from <lukas@herbolt.com>); Fri, 14 Nov 2025 11:30:35 +0100
From: Lukas Herbolt <lukas@herbolt.com>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	Lukas Herbolt <lukas@herbolt.com>
Subject: [PATCH 0/1] Fix unaligned queue_limit->io_opt on SAS and 4KN disk
Date: Fri, 14 Nov 2025 11:28:53 +0100
Message-ID: <20251114102853.1476938-2-lukas@herbolt.com>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If there is an SAS attached disk we set the SCSI host opt_sectors in 
sas_host_setup() to either dma_opt_mapping_size() or host->max_sectors 
this value can be later assigned to the device queue_limit as io_opt, but 
there is no further check if the io_opt is aligned with the device limits.

Rounding down to device logical_sectors will keep the io_opt large enough 
to keep benefit of bigger IO but still aligned within the device limits. 

Lukas Herbolt (1):
  scsi: sd: Rounddown host->opt_sectors to logical sectors reported by
    the disk.

 drivers/scsi/sd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

-- 
2.51.1

