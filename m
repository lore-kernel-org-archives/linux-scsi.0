Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64DE2157A6B
	for <linux-scsi@vger.kernel.org>; Thu,  5 Jun 2025 06:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749104433; cv=none; b=srbaxDpDpbiN/fiGxj5/fnD3F7qciZKLqmPeBrRLFvd28j+7tMHsuEygt60GH3+nkICFDXOTyU2PcKCrzLqZweXs/1SthgTwRviHnE3V/2rOkKMqlibBKlAfWjlLyTLRx8ghiVa/VwWOSw2A0j8n0TCKO25cNtX+C8D1BswIfF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749104433; c=relaxed/simple;
	bh=KVOuIaZArIEAs0MZo7FUbjcL7nFtnYf3xM80mHwsN60=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=KmWkB38mGhyNPPzKzvpRFx+0EP/10Iv1u4IrWsJI9rtWarLXxy7WD0ooxqRD5UtOLUU1e0KikY+/hWO1F7NXHQgkuveIjAglJ86FSwm4lWa9wGVExkV6SLJreh8nmIJ4JOxG/FDCumWUsm+v6Z+Eon7s6wC05AmRlJQDvOVjmRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n7H6TAnR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n7H6TAnR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FC21C4CEE7;
	Thu,  5 Jun 2025 06:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749104431;
	bh=KVOuIaZArIEAs0MZo7FUbjcL7nFtnYf3xM80mHwsN60=;
	h=From:To:Cc:Subject:Date:From;
	b=n7H6TAnRE8FUwtwFSMj5Dmtxh9BKrjXnqsXcZ2Ku7OjarwCtTWZ3Czc+chFp7IEJD
	 VHvJiovFaSbAHMUNUt8w9FgnASZ9mrHmGixtszR1gcAANgAK4lKkTgvWrjOEbaj8Lv
	 O58q3Viw3pyIhyo9WSLg5ofjn6lHuFZPMM+O5enwWP8owqdc+dPcptSnWW1BxFqbLp
	 5TS/bvUCnEuDJ6pIv2v8L4ZMFgFfvT9GgpqKPZRhylQKSWc8S7tYTJ6kVHoVbchi+Y
	 64D2J/Ma4cc+Hi6L7We8wJDVClRYWcZdNVDneY+tvITzkAxbk5f3gvyXPg97TMuIkg
	 poUX7o+26Qj2A==
From: Hannes Reinecke <hare@kernel.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>,
	Bart van Assche <bvanassche@acm.org>,
	Yury Norov <yury.norov@gmail.com>,
	linux-scsi@vger.kernel.org,
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCH] scsi/fcoe: remove fcoe_select_cpu()
Date: Thu,  5 Jun 2025 08:20:14 +0200
Message-Id: <20250605062014.105302-1-hare@kernel.org>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The function fcoe_select_cpu() is just used to distribute incoming
skbs which start a new FC command sequence. But the network stack
already received (and processed) that skb, and there is a _really_
good chance that all subsequent skbs for this sequence will be
handled with the same CPU. So we should just use the cpu on which
this skb was allocated on and save ourselves some overhead due
to pointless scheduling.

Signed-off-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/fcoe/fcoe.c | 22 +---------------------
 1 file changed, 1 insertion(+), 21 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index b911fdb387f3..4912087de10d 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1299,26 +1299,6 @@ static void fcoe_thread_cleanup_local(unsigned int cpu)
 	flush_work(&p->work);
 }
 
-/**
- * fcoe_select_cpu() - Selects CPU to handle post-processing of incoming
- *			command.
- *
- * This routine selects next CPU based on cpumask to distribute
- * incoming requests in round robin.
- *
- * Returns: int CPU number
- */
-static inline unsigned int fcoe_select_cpu(void)
-{
-	static unsigned int selected_cpu;
-
-	selected_cpu = cpumask_next(selected_cpu, cpu_online_mask);
-	if (selected_cpu >= nr_cpu_ids)
-		selected_cpu = cpumask_first(cpu_online_mask);
-
-	return selected_cpu;
-}
-
 /**
  * fcoe_rcv() - Receive packets from a net device
  * @skb:    The received packet
@@ -1405,7 +1385,7 @@ static int fcoe_rcv(struct sk_buff *skb, struct net_device *netdev,
 		cpu = ntohs(fh->fh_ox_id) & fc_cpu_mask;
 	else {
 		if (ntohs(fh->fh_rx_id) == FC_XID_UNKNOWN)
-			cpu = fcoe_select_cpu();
+			cpu = skb->alloc_cpu;
 		else
 			cpu = ntohs(fh->fh_rx_id) & fc_cpu_mask;
 	}
-- 
2.35.3

