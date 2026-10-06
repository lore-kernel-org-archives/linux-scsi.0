Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C05BB3F1076
	for <linux-scsi@vger.kernel.org>; Tue,  6 Oct 2026 16:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791304983; cv=none; b=os1kswZwvvX3fV5QHrkRDwmy1u2iSPWwmBzOjf8+ZjUtYjESeCDfKDKWs2KazK+9dL55S5IkYTlX+i7QlP0v3Bkggx86U3YbgJQER/JUWRiCYp2gUSwkWb0IfQp4moEczDRc8oen1c4PrnvPnzSb0WXH907B2ZXczHBlBlh4fRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791304983; c=relaxed/simple;
	bh=jfJvfr89rXy64MMWsIBaEA7yOonYEnwIBF1fu0R3t7M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=slcbdieB+2VnpWrVgIk7XcxlhG38HgAzPa3k9kuppzAd/Eo62+dUd/DV0ULg2E3or4ImK8qhuIvkWL8aBtoEVbczaHEvMotdNRoHeWBeQgnsPczEIzjeWt0ZmAxeXJnCgQ92T8YIcRVfRWno8B5TErygOBJsXzDQ1K5F3uGLGYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gOw2bYqW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gOw2bYqW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791304980;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=qEhkSmrB5jo/uXvn1BSnMpH1g5FCocxbpQqiAleLqKI=;
	b=gOw2bYqWlcSONED4FTCwFljAxyx7d4VL8syRRdaWYm/r3TBmngT1Jldpwkw9tnt6uRfDP7
	QwzJEraDUt9xivpu/xEJyGuN6N41H5ky51xvPvRN4xhiginiEjcA+N+1GmbT5YjXl538M4
	XOjg810sZPUAxlEMt5ne1K74rL39cMM=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-462-dQFu4o6oNqyUxyuSuV4Sfg-1; Tue,
 06 Oct 2026 12:42:57 -0400
X-MC-Unique: dQFu4o6oNqyUxyuSuV4Sfg-1
X-Mimecast-MFC-AGG-ID: dQFu4o6oNqyUxyuSuV4Sfg_1791304976
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AB0D7192DD6B;
	Tue,  6 Oct 2026 16:42:55 +0000 (UTC)
Received: from loberman-thinkpadp16gen3.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 100D03001D31;
	Tue,  6 Oct 2026 16:42:53 +0000 (UTC)
From: Laurence Oberman <loberman@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Kai Makisara <Kai.Makisara@kolumbus.fi>,
	John Meneghini <jmeneghi@redhat.com>,
	emilne@redhat.com,
	bgurney@redhat.com
Subject: [PATCH] scsi: st: Save the visited block for the partition the drive is in
Date: Tue,  6 Oct 2026 12:42:50 -0400
Message-ID: <20261006164250.773840-1-loberman@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

set_location() saves the current tape location before switching
partitions, so that switch_partition() can return to it later. It reads
the location with READ POSITION but stores it in the st_partstat of
STp->partition, ignoring the partition the drive reports.

The two differ after a device reset. When the reset is recovered with
MTREW, MTSEEK or MTEOM, st_ioctl() sets STp->partition = 0 and calls
switch_partition() to return to STp->new_partition. A drive that was in
partition 1 is still there, so set_location() files the partition 1
position under partition 0. The next switch to partition 0 locates to
that block: if partition 0 holds less data, MTSETPART fails with EIO
(BLANK CHECK), otherwise the tape is silently positioned at the wrong
block.

IBM ULTRIUM-TD5 (LTO-5), LU reset in partition 1 at block 1025:

  st 12:0:0:0: [st0] Visited block 1025 for partition 0 saved.
  ...
  st 12:0:0:0: [st0] Setting block to 1025 and partition to 0.
  st 12:0:0:0: [st0] Error: 402, cmd: 2b 2 0 0 0 4
  st 12:0:0:0: [st0] Sense Key : Blank Check [current]
  st 12:0:0:0: [st0] Add. Sense: End-of-data detected

Store the location in the st_partstat of the partition reported by READ
POSITION. With the fix:

  st 12:0:0:0: [st0] Visited block 1025 for partition 1 saved.

This is a pre-existing issue. It was not caught when testing the
recent st reset series because the partition test was only run on
scsi_debug: on the LTO drive it was skipped, since can-partitions is
off in the test harness's stinit.conf, as is normal for LTO. scsi_debug
hides the problem because its emulated tape returns to the beginning of
partition 0 on an LU reset. It was found while validating a backport
of that series to RHEL 9.8, when the partition tests were run on real
hardware with can-partitions enabled. The same failure then reproduced
on unmodified RHEL 9.8 and on upstream, and the fix makes the test pass
on v7.3-rc3 and RHEL 9.8 with an LTO-5. 

The harness (https://gitlab.com/loberman/tapetest, test X03) now
refuses to silently skip the partition tests on hardware.

Fixes: 7081dc75df79 ("scsi: st: Restore some drive settings after reset")
Assisted-by: Claude
Signed-off-by: Laurence Oberman <loberman@redhat.com>
---
 drivers/scsi/st.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index e089d3ac063d..63ec9619d1b2 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3246,14 +3246,20 @@ static int set_location(struct scsi_tape *STp, unsigned int block, int partition
 	    partition >= ST_NBR_PARTITIONS)
 		return (-EINVAL);
 	if (partition != STp->partition) {
-		if (get_location(STp, &blk, &p, 1))
+		/*
+		 * Save the location for the partition the drive reports,
+		 * not for STp->partition: after a reset STp->partition may
+		 * not match the partition the drive is in.
+		 */
+		if (get_location(STp, &blk, &p, 1) ||
+		    p < 0 || p >= ST_NBR_PARTITIONS)
 			STps->last_block_valid = 0;
 		else {
-			STps->last_block_valid = 1;
-			STps->last_block_visited = blk;
+			STp->ps[p].last_block_valid = 1;
+			STp->ps[p].last_block_visited = blk;
 			DEBC_printk(STp, "Visited block %d for "
 				    "partition %d saved.\n",
-				    blk, STp->partition);
+				    blk, p);
 		}
 	}
 

base-commit: 9eaf6f9c2e50f67b7a3af1ba170a7da98201fbd5
prerequisite-patch-id: 7ff6c2a8facfef94f8d9e55d289671fc752572ec
prerequisite-patch-id: 8fc95d01ad41ddd3d884090c98b70d210ceb6b51
prerequisite-patch-id: 4fcffbe676c887709189baeb202ad2b5b58094ee
prerequisite-patch-id: 7f269b2366e79524769bca811886375d8a3e83f8
-- 
2.55.0

