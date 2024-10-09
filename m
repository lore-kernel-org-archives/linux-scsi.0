Received: from mta-03.yadro.com (mta-03.yadro.com [89.207.88.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF6A192D6D;
	Wed,  9 Oct 2024 11:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.207.88.253
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728472671; cv=none; b=tBv0E7F0oijCzOm765SIdqSdSw63BOuG+efn0lcUtLNslFGSxhlOi8ip4fmiHf+aNsSttR3ZGK2nkjZqmjY6qcPNmT98V35pSYEAC4iIoStbGs6cFY7SlERNSaOeKcBqhn7BwQAg7AISDbbVxbjybXwJ9yTfJcQjr9HuLr0cFOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728472671; c=relaxed/simple;
	bh=KIxBJHEXLmkaHDuNyoNCEDlOFyVyaazsAK0OclfC2qM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WZHEx8i13izMSkdU9c58/vPyG7cxSwsxRiYPgdAWUXw2eKQArF2v9XiM7HaW/l9n0IdnThf6sEprt8+KjH8pNHWTH/W87T6zYUwEuENC0Meo99Kx3AATg438x+0BKiH9x6sQktJsDw7yKJcxtPoanI5ZtKrWYxfEn7yN550SUu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yadro.com; spf=pass smtp.mailfrom=yadro.com; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=k4YL0XWN; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=rBMh1To3; arc=none smtp.client-ip=89.207.88.253
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yadro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yadro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="k4YL0XWN";
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="rBMh1To3"
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-03.yadro.com 09BC6E0017
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-04;
	t=1728472668; bh=y20oOosez36zWrQ1+4E1TZpFUVdNhnGMc9YF2n3uVr4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=k4YL0XWN9dbw/6xMrJidRW9nu8U1a387extJQfFm3H4pCQ3xBzbdN3q+AlFbsNi1s
	 mVn2aL5KyrIMRDMSJ6E0wlAAYk20DGQix20Oqpsu001gzPuQTG7cYy9LXtH2ldrwT6
	 kQV2jXTcwFnaG3fv3T+kRvpzrvF+JYYTpCJ5GsMb5PHvNs9SQP7Pn/41Ogvr6lezsL
	 WvLtrJJBp5oLd0eMKGr82B3xu65MRIWrcO1bvDBOWXpc51OMqEErn7TfRpjmANHjd8
	 p2xWpJQWQ2LVOuOKotZIDj43J/Lgiq7amYbQaQ5MG2vSLver7gSj3j/wg4bmes3rfy
	 6yIXU+rUXgpNg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
	t=1728472668; bh=y20oOosez36zWrQ1+4E1TZpFUVdNhnGMc9YF2n3uVr4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=rBMh1To3soGpmcdyhDIq7lpW/uKlfBjoww6e2GYkRzvOpe7h5azwm7RwskNui5CxQ
	 9g8vxuJHhsPXJIw9vAfOB6VG/qVKxAuKsd5lJB7JBl6CXfunPARwl3M+GY8iznBXiE
	 MDr6Nkhx0JvD1xxsBlIuahirNdGRN3tatO3ygoPtKHlvp6r6hW9moRBkMhe7f1dg3o
	 wE0wwW9EznuT1r4s4qWuPRvZ1nG05Ulx01E8jKwqwj+79TtANLTH3fpWE2rmmmkWdU
	 YksSemKlvUWmWlDvUMAw9n4hqO4O5n/ieqbqnacqZeGKk9vXOYsb2o2YDQY5ppzrxw
	 GTO2a5wY8Jf5w==
From: Anastasia Kovaleva <a.kovaleva@yadro.com>
To: <target-devel@vger.kernel.org>
CC: <njavali@marvell.com>, <GR-QLogic-Storage-Upstream@marvell.com>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<bvanassche@acm.org>, <quinn.tran@cavium.com>, <himanshu.madhani@cavium.com>,
	<linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux@yadro.com>, <hare@suse.de>, <stable@vger.kernel.org>
Subject: [PATCH v2 3/3] scsi: qla2xxx: Remove incorrect trap
Date: Wed, 9 Oct 2024 14:16:54 +0300
Message-ID: <20241009111654.4697-4-a.kovaleva@yadro.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20241009111654.4697-1-a.kovaleva@yadro.com>
References: <20241009111654.4697-1-a.kovaleva@yadro.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-ClientProxiedBy: T-EXCH-10.corp.yadro.com (172.17.11.60) To
 T-EXCH-09.corp.yadro.com (172.17.11.59)

This BUG_ON() is triggered when there is no fc_port with a certain
loop ID in the scsi host vp_fcports list, but there is one in
lport_loopid_map. As these two data structures do not change
simultaneously and atomically, such a trap is invalid.

Cc: stable@vger.kernel.org
Fixes: 726b85487067 ("qla2xxx: Add framework for async fabric discovery")
Signed-off-by: Anastasia Kovaleva <a.kovaleva@yadro.com>
Reviewed-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/qla2xxx/qla_target.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index bc6b014eb422..492fc1627354 100644
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

