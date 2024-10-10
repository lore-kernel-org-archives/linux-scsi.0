Received: from mta-03.yadro.com (mta-03.yadro.com [89.207.88.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87DAF199FA2;
	Thu, 10 Oct 2024 16:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.207.88.253
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728578062; cv=none; b=lb3LdpvMy31ZMzhOBY/or8iunlEh8eMIz5Cpb6cwY37l942QspGx9tnHV6Uur6sRrgkSXOCig05QIG3C1eJLOyatIeJyb5jVIBxSW79ATr1LR1ZvzNcepi3djU796TLFtv2Lr9X45TjfMJp3298FsHxPQAiDMGni446LrpdNbIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728578062; c=relaxed/simple;
	bh=wvb8X9iXh1YzBeg65BelV1fZ5HxBj+DXRWco+WsOfG4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gPKGLJzKDLF4l22Cciez/omTpR3zzpoCUHc5kXM9tTplJggHgwM7usojH3+RWrGwoeZw9vrjlTFDgeWYgn0UGwclZ3VJ6DspV+L2DlkKqAQ2DxcykrZRczCugZFx3oe5pys0EFZ49reMmo5nowgo0QpRpiw0bDwK1AGZjWKEkYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yadro.com; spf=pass smtp.mailfrom=yadro.com; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=PJxHyJLX; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=uv7OwiuR; arc=none smtp.client-ip=89.207.88.253
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yadro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yadro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="PJxHyJLX";
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="uv7OwiuR"
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-03.yadro.com 00F84E0002
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-04;
	t=1728578057; bh=Fz+WYqdvn39bUA1V6fkpoN6K3evri9MLq+McbaOga8E=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=PJxHyJLXnJ1o3wvROix7TsJVEJePVuiimJX5ccKwTvA31qHFLoxVNlQcXoiuQrYoR
	 T1K7wEnsRF7s0e7q6/fZh4rAI8chcWQmLdvMFmh1ATNyQ3cH8GvNp0RHa3xXc8MWo8
	 oBy9C7VCW5/o+6GHGB7wf6Vf3cDViyVv2dt+SNMcSCoKKXQp8yt1a4ucbS2qs7LiI4
	 p8O/JuLTjM2HcRnwf8Wb4Rt+PrGba7QLbEwu1LLtDutCWUK/7v9Ew2D1s58VjI8qqw
	 n7wo2LQRNxeixerTkJZV0YnKtJz3imT+wDJKVuURhOar9RjgXBoN01V+d/nYr7M0Sd
	 BEIBgl/wg1JwA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
	t=1728578057; bh=Fz+WYqdvn39bUA1V6fkpoN6K3evri9MLq+McbaOga8E=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=uv7OwiuR8PiMOZVYDPqnCPKimdDTyX/0PtTc1gOKf4EDaftpvyUt8928vVamzXRL4
	 vzUMeK9Eg2BAyjl6KL18RkXEA7jXPjWRHTf/s5VBQt3WwiMaY1rT39IKJ6Lyew3NsF
	 h5ej3RwbItTJznFLNaD/D/km3BdacRdCQv325dWzW9wx+OsXNmD96iMiS/Qph//rvs
	 VoVy0fWkFbETWcUBmKkPkO36k9g/jMX2cpWwipfW2N1KAmE87LdETqrKaygQ39Yd2n
	 LTj8NCN/X6sH6EmKpNXR3AhCpqK28c9+v1tk4Ai1cas7ZzdrAz6TkuWQXaZlRvKjMV
	 fPCSXdpkUjgHw==
From: Anastasia Kovaleva <a.kovaleva@yadro.com>
To: <target-devel@vger.kernel.org>
CC: <njavali@marvell.com>, <GR-QLogic-Storage-Upstream@marvell.com>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<bvanassche@acm.org>, <quinn.tran@cavium.com>, <himanshu.madhani@oracle.com>,
	<linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux@yadro.com>, <hare@suse.de>, <stable@vger.kernel.org>
Subject: [PATCH v3 3/3] scsi: qla2xxx: Remove incorrect trap
Date: Thu, 10 Oct 2024 19:32:37 +0300
Message-ID: <20241010163236.27969-4-a.kovaleva@yadro.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20241010163236.27969-1-a.kovaleva@yadro.com>
References: <20241010163236.27969-1-a.kovaleva@yadro.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-ClientProxiedBy: T-EXCH-07.corp.yadro.com (172.17.11.57) To
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
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_target.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 0a82360141f8..6f359677f554 100644
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

