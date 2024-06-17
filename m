Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810EA19AD6A;
	Mon, 17 Jun 2024 13:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718630592; cv=none; b=TcjpYxtRGv3yF30f1RI8NqbgPPdYqhwKofHuLGevyg7Op7E1O5fDB/M/K81s0HricnW0eWSPuSv0r3+bJ329IZ6hIrVpn3PyetHuV9o7dIIaWTmrD31phAntxwubghek8ybmVZ6KRCiqZcLxUHd0mELr28rr5r+J8FtbNMj3vvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718630592; c=relaxed/simple;
	bh=ElwEEKlltBx5dmTZseGkyQ9j+pnPgSlfITcDRLuO6OA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Osq2yRcm7mk94qr4m0z4rI/WdfX0gmAMB2rFC1DaqwAXqfnhQ4f66W3Twk0sF92sAHhaUAh2h/Ndn1yJFiY1NmcjqIqXKMzsmm4QHwogZqGa+izzn9OzszOEpbqQ5/T6tOn70WwdhDccSnKq4r02o9d+b/SMtGkTikXhT3wczfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=stRJnte4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="stRJnte4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6230C2BD10;
	Mon, 17 Jun 2024 13:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718630592;
	bh=ElwEEKlltBx5dmTZseGkyQ9j+pnPgSlfITcDRLuO6OA=;
	h=From:To:Cc:Subject:Date:From;
	b=stRJnte4Xe0sIklrTRurdGf+3lu1qu+x76nJd3BPQBQfga7PKRdp3y8p28P8CgOnC
	 +hyMCAL1HPCZ2wuQPWqvetysnId3JuolcG4G1IhH4G7G3bG/FocX+ql7Qo8I1UBxtB
	 vUdEPjPMD8uVvkwZsN52xRjMzoepzCWsaCqeywLDqkoWb5KkyfYCzdDMmqVxRdsJ2h
	 VWRHUglccbMuO7PGKgHVOW6IL9JjqLfug3DjuUk1+ggyynklGBpO2PwBmSQvTeQ2jD
	 4GTSiAyEiCaIC0unIm1VgDTI8yElZEFewk8MYYaF9kO/2WEHtDKXDIe8kzAWhnqpft
	 E7McK8P8ZJg5Q==
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
Subject: [PATCH AUTOSEL 6.6 01/35] scsi: core: alua: I/O errors for ALUA state transitions
Date: Mon, 17 Jun 2024 09:21:59 -0400
Message-ID: <20240617132309.2588101-1-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.34
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
index a226dc1b65d71..4eb0837298d4d 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -414,28 +414,40 @@ static char print_alua_state(unsigned char state)
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
@@ -502,7 +514,8 @@ static int alua_tur(struct scsi_device *sdev)
 
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

