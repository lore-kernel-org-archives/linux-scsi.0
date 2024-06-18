Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF91C2139A4;
	Tue, 18 Jun 2024 12:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714421; cv=none; b=Ya+sDAKuzFwSPEf3jF9hYO+oxgU0EzspA5gtXYgFxClV7YUPoZJ3o4J1VcP1yLx4BsQUwy92FjjmysrYYpedGp8NonuAPGhj4JpRHSG30g4Ug8qP99MsoAtD7CQrsFARojWcCmSNDIYwZNZFL1D8cQnlmKK7FEfmR/iK9cjzU1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714421; c=relaxed/simple;
	bh=MUpmA9MZ4i76S7YO4RwWYwYhCpJTtuZDBDgbMrW0AAk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Tr1J7od/Z6dcquej8RovxYcVnJ+a4ka0cWxFgfEXn5XYkdipJKsyoVDYCS6Y1Xbxcskgq2lDolvZ4APWsJ/drju68+W7FJ/OP7pOFZF9pUjcG7Fym9H0FAZMWXAdNKoxdi6omfl5lc/GKDmeYWe6r73YF1VsQKBaBXW99zJi8EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f6nwjaSa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f6nwjaSa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BDEBC3277B;
	Tue, 18 Jun 2024 12:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718714420;
	bh=MUpmA9MZ4i76S7YO4RwWYwYhCpJTtuZDBDgbMrW0AAk=;
	h=From:To:Cc:Subject:Date:From;
	b=f6nwjaSa+7IYC+iDRxbJkfme21lTe/BE++FRgwgcJKEWBLy3tVv+L9AA1OeyjlEMM
	 xn0W8dSJ+zHtevzCSwqkv/51sE3027GBVGaKYJKBgze6dI+JKrw2xXvcHo71XOvrta
	 ek/X4jXjl4C0TNBf4T9x9JKe6yb6Eg9kDYEhcOORIUBW8jXNO+pQDl9Z3JVamEQmzP
	 4CZshPJOx4/Iu721cngJGx6Nd5cL8ddgvZ4VXgmKg4bt7xAQrawPWzUoBnIsbnQERC
	 UuhBI2WTdroag9ZZluhTRZerxZl/slgSmMkrQoD83vMQyuBMXooFimZ0m3V116yRjv
	 Ea9KHZEBIAdCA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Martin Wilck <martin.wilck@suse.com>,
	Rajashekhar M A <rajs@netapp.com>,
	Hannes Reinecke <hare@suse.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 01/29] scsi: core: alua: I/O errors for ALUA state transitions
Date: Tue, 18 Jun 2024 08:39:27 -0400
Message-ID: <20240618124018.3303162-1-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.94
Content-Transfer-Encoding: 8bit

From: Martin Wilck <martin.wilck@suse.com>

[ Upstream commit 10157b1fc1a762293381e9145041253420dfc6ad ]

When a host is configured with a few LUNs and I/O is running, injecting FC
faults repeatedly leads to path recovery problems.  The LUNs have 4 paths
each and 3 of them come back active after say an FC fault which makes 2 of
the paths go down, instead of all 4. This happens after several iterations
of continuous FC faults.

Reason here is that we're returning an I/O error whenever we're
encountering sense code 06/04/0a (LOGICAL UNIT NOT ACCESSIBLE, ASYMMETRIC
ACCESS STATE TRANSITION) instead of retrying.

[mwilck: The original patch was developed by Rajashekhar M A and Hannes
Reinecke. I moved the code to alua_check_sense() as suggested by Mike
Christie [1]. Evan Milne had raised the question whether pg->state should
be set to transitioning in the UA case [2]. I believe that doing this is
correct. SCSI_ACCESS_STATE_TRANSITIONING by itself doesn't cause I/O
errors. Our handler schedules an RTPG, which will only result in an I/O
error condition if the transitioning timeout expires.]

[1] https://lore.kernel.org/all/0bc96e82-fdda-4187-148d-5b34f81d4942@oracle.com/
[2] https://lore.kernel.org/all/CAGtn9r=kicnTDE2o7Gt5Y=yoidHYD7tG8XdMHEBJTBraVEoOCw@mail.gmail.com/

Co-developed-by: Rajashekhar M A <rajs@netapp.com>
Co-developed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Martin Wilck <martin.wilck@suse.com>
Link: https://lore.kernel.org/r/20240514140344.19538-1-mwilck@suse.com
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 31 +++++++++++++++-------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 0781f991e7845..f5fc8631883d5 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -406,28 +406,40 @@ static char print_alua_state(unsigned char state)
 	}
 }
 
-static enum scsi_disposition alua_check_sense(struct scsi_device *sdev,
-					      struct scsi_sense_hdr *sense_hdr)
+static void alua_handle_state_transition(struct scsi_device *sdev)
 {
 	struct alua_dh_data *h = sdev->handler_data;
 	struct alua_port_group *pg;
 
+	rcu_read_lock();
+	pg = rcu_dereference(h->pg);
+	if (pg)
+		pg->state = SCSI_ACCESS_STATE_TRANSITIONING;
+	rcu_read_unlock();
+	alua_check(sdev, false);
+}
+
+static enum scsi_disposition alua_check_sense(struct scsi_device *sdev,
+					      struct scsi_sense_hdr *sense_hdr)
+{
 	switch (sense_hdr->sense_key) {
 	case NOT_READY:
 		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x0a) {
 			/*
 			 * LUN Not Accessible - ALUA state transition
 			 */
-			rcu_read_lock();
-			pg = rcu_dereference(h->pg);
-			if (pg)
-				pg->state = SCSI_ACCESS_STATE_TRANSITIONING;
-			rcu_read_unlock();
-			alua_check(sdev, false);
+			alua_handle_state_transition(sdev);
 			return NEEDS_RETRY;
 		}
 		break;
 	case UNIT_ATTENTION:
+		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x0a) {
+			/*
+			 * LUN Not Accessible - ALUA state transition
+			 */
+			alua_handle_state_transition(sdev);
+			return NEEDS_RETRY;
+		}
 		if (sense_hdr->asc == 0x29 && sense_hdr->ascq == 0x00) {
 			/*
 			 * Power On, Reset, or Bus Device Reset.
@@ -494,7 +506,8 @@ static int alua_tur(struct scsi_device *sdev)
 
 	retval = scsi_test_unit_ready(sdev, ALUA_FAILOVER_TIMEOUT * HZ,
 				      ALUA_FAILOVER_RETRIES, &sense_hdr);
-	if (sense_hdr.sense_key == NOT_READY &&
+	if ((sense_hdr.sense_key == NOT_READY ||
+	     sense_hdr.sense_key == UNIT_ATTENTION) &&
 	    sense_hdr.asc == 0x04 && sense_hdr.ascq == 0x0a)
 		return SCSI_DH_RETRY;
 	else if (retval)
-- 
2.43.0

