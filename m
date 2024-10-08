Received: from mta-03.yadro.com (mta-03.yadro.com [89.207.88.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99BA0190055;
	Tue,  8 Oct 2024 13:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.207.88.253
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728394299; cv=none; b=bfyDeN6r21ku+7sNpfJtaH46TOm7vrFVs5NHFSueWgaHaEGREtei+94+0awU5w6o1rm4TEA0oDZUkGRbt+fq7cgzrSW9RZrmo5X4xCG8EG2qbPIZZP8cO+fnCITmqvX995YSwgez1gkxX6czOJE2ppA7UBC/bdtk77foNKQeagU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728394299; c=relaxed/simple;
	bh=95R7frcox+BpLSzcSxD73QmPKcWo05sbLhvOIqrwt/o=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O5gKLafA+vO5Jpdqtr6nx4jfCQRXQNFOIVKtkwOZLqQfDqMi+N9FUlqRQhA7MO/1yQslyH+Re/Z+3iCbxMxZoXCc0vvci5fFWBnE9ncBGU3M1+As03uN1yTHljSdDiMtdIJIvFx/7LFrvdYc81GpmbykAEvSuqDbFo/BTbGBUvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yadro.com; spf=pass smtp.mailfrom=yadro.com; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=j+nRcyis; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=ssqSsqUy; arc=none smtp.client-ip=89.207.88.253
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yadro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yadro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="j+nRcyis";
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="ssqSsqUy"
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-03.yadro.com B763FE0018
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-04;
	t=1728394294; bh=6Jaz5KTsUcnqJMhBopv+w18+cRGcBKKrscV7xAds5Og=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=j+nRcyisDDBz2ua7jQ4Dh0AyjzagptYvj8CoBQh9AqW3v4r+hYdKc3egCm3AskhC1
	 Gs1YyDhIHPAJc944m3rrGS2uoGKvqk666V9Gfd+QswtajqMlozOSP3ZIvtfTS/0fNJ
	 Fada7l6fcj7sgsSnwrT06EC6rE3B5QZ2ZQwFU89nGD7Y21c8f9/7HqRGsRvDOCdFL0
	 0mRHCccM0Uq837GTYXEps7k4gJ52Brdc9lgZQCzA81Y+zhao1CNAYLNxPUo6cNJ2fK
	 qaEdTAKQy/EZAlCzTvfRdpyuni5HyUb+h60L0F/Fd6skoK3qarp9uCuy55VbiBdRYh
	 3iU9Pj+E4u9bA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
	t=1728394294; bh=6Jaz5KTsUcnqJMhBopv+w18+cRGcBKKrscV7xAds5Og=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=ssqSsqUysxs+G5+oHMP3hAOWr6Bib0345pyP1q9/8MFyXSY36p7EqohomWU/WwKZt
	 9MyzfF73BCjC6BcAGO8+TGy6mKRi59K9Qd5rCEXBJ0c/0pk+GpePhHEHR+tkQzGr+n
	 FQCpONT4T9t6GCCKK0kAUJVlMjTaFKkVhvuiXTnBDksFd/e4nll9Y+zzvr9m7CoQiQ
	 8g9mSTH2bkgNTwLpH39f1uN5kJxHaYhR34OBaoC9/fX58/Xk/rYa5MeFr3BILOMrHl
	 gsalMwXzLGfEJpHBoEIO5sDNKVktpTU9oQLVDJVQfx41xB4ksLxoAVmiMkL7RO7Vxg
	 7i9CYHOlRA3ag==
From: Anastasia Kovaleva <a.kovaleva@yadro.com>
To: <target-devel@vger.kernel.org>
CC: <njavali@marvell.com>, <GR-QLogic-Storage-Upstream@marvell.com>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<bvanassche@acm.org>, <quinn.tran@cavium.com>, <nab@linux-iscsi.org>,
	<himanshu.madhani@cavium.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux@yadro.com>
Subject: [PATCH 3/3] scsi: qla2xxx: Remove incorrect trap
Date: Tue, 8 Oct 2024 16:24:02 +0300
Message-ID: <20241008132402.26164-4-a.kovaleva@yadro.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20241008132402.26164-1-a.kovaleva@yadro.com>
References: <20241008132402.26164-1-a.kovaleva@yadro.com>
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

This BUG_ON() is triggered when there is no fc_port with a certain
loop ID in the scsi host vp_fcports list, but there is one in
lport_loopid_map. As these two data structures do not change
simultaneously and atomically, such a trap is invalid.

Cc: stable@vger.kernel.org
Fixes: 726b85487067 ("qla2xxx: Add framework for async fabric discovery")
Signed-off-by: Anastasia Kovaleva <a.kovaleva@yadro.com>
Reviewed-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/scsi/qla2xxx/qla_target.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index bc7feef6ee79..9a5dbd00de01 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -5190,15 +5190,7 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 		ql_dbg(ql_dbg_disc, vha, 0x20fc,
 		    "%s: logo %llx res %d sess %p ",
 		    __func__, wwn, res, sess);
-		if (res == 0) {
-			/*
-			 * cmd went upper layer, look for qlt_xmit_tm_rsp()
-			 * for LOGO_ACK & sess delete
-			 */
-			BUG_ON(!sess);
-			res = 0;
-		} else {
-			/* cmd did not go to upper layer. */
+		if (res) {
 			if (sess) {
 				qlt_schedule_sess_for_deletion(sess);
 				res = 0;
-- 
2.40.1

