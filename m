Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7DA37CD2F;
	Sat,  5 Sep 2026 03:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788578607; cv=none; b=IYmS3j9II+DxnoaVyWI859RyJJZqkqlt0TcI56KhUPZ0NKG0qDjdQp95yjRfSfI37uiXFF2Ysv0cJCpMfDJ9jc0eWqg4qU3CQVnBo93pRvZH2NlYewsykBiYUMUN7k7Uivg3l2CY03uWwN1DQBe0PFaMgiqV+Bw1T/pdKM41njs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788578607; c=relaxed/simple;
	bh=h2CZRQ6Oo3g276R48xMfwzQxvWfrNs/330QG2PdMt64=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fEsBM0wFAGsuxuzrcRB7LfyaMPIFHTjikuUj0t3c63RImlcipb1vbWsqFit/x4TcIO54okiUm9a8ZHg3oBqllg8HVdk4tNHEvfnpZHosdjk5qK7m1n80jYDEaEq531Yrod80QQzGRJ8Dg3yftrm3bxzpwtiQLcAyf0nhS7UFayk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ocntd4Bl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ocntd4Bl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 396B91F00A3D;
	Sat,  5 Sep 2026 03:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788578605;
	bh=6eI25ncEW1bDWA/ZZsGmt5838PGE09d+oj3dEi8b7Tc=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=Ocntd4Bl49XSK5ANsPerwfYREYd5jNZk3Hz+A9R88DzJuQCBn2k+ECpah9AMoN7bC
	 fKfcjvKMrcbK0GZdCGgwI/svhC+mrWniWbEkgHTk49h9wdSaPj78taJKCRBDMQ4Tt4
	 dywOVVdoFXzIOvd+emcEpqACQc8AVR4o1FyRqGA1iD0Ue2G7WweFRMOcuOZI7qtb8e
	 bIzSrxP63srcswRPn6Jcy+J5/NA67GF3ex06HpeqWAO0ywpWYIli5Zr+OFwPbm/2xx
	 qeDzMuHQqiDVXl08o7YexGI8a/WYJyY8nEF9M8iK2MmuHnLa6QTERrB2Th2pT+SUEP
	 2NBwvgEFGQy4g==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-scsi@vger.kernel.org,
	linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-usb@vger.kernel.org,
	Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-s390@vger.kernel.org,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH v4 27/40] scsi: stex: use 16-bits defined sense codes
Date: Sat,  5 Sep 2026 12:22:11 +0900
Message-ID: <20260905032224.509860-28-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260905032224.509860-1-dlemoal@kernel.org>
References: <20260905032224.509860-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refactor the stex driver to use scsi_set_sense() and replace all
hard-coded additional sense codes and additional sense code qualifiers
with the enum values defined in include/scsi/scsi_sense.h. This helps with
code clarity as the sense codes being processed are easier to test and
self-documented.

No functional change intended.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/stex.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index e69a3779a32a..d4899816f7dc 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -401,8 +401,7 @@ static struct status_msg *stex_get_status(struct st_hba *hba)
 static void stex_invalid_field(struct scsi_cmnd *cmd,
 			       void (*done)(struct scsi_cmnd *))
 {
-	/* "Invalid field in cdb" */
-	scsi_build_sense(cmd, 0, ILLEGAL_REQUEST, 0x24, 0x0);
+	scsi_set_sense(cmd, 0, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB);
 	done(cmd);
 }
 
-- 
2.55.0

