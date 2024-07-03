Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89AFD18C329;
	Wed,  3 Jul 2024 18:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720032314; cv=none; b=l83p5htXgFCkE011MiU9hddouE2gn0P77P1k6QscJHwDgNaBOG1/x0cSdtP90rt7rpSjsf+N/m7jc6o/gnQUGQO0jIrgFKRNnnJN59TpUc+RELkixOk2h8PD5fxLRYOZLuA1vox92k2JJ992QDkRSLayrhBtHgY5a8Bs/5Ma+4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720032314; c=relaxed/simple;
	bh=LScu3KTtT8V2oLuw3+Jj58e5EN80mEeIxP4eOrJOtBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KMfkoEreK90V0ohUP762CqoDlK4wn0GYbaDibqaScOWR5mgN7Ky6DAyEsugOHwdhTojsAZRsxLUFoe6ID6W9bzNHjoWQjAEriMUUhl/IKoKfQnqCJtVRpoaU+oFFkNdzf2g159qe5OstexmZ+WSfyf746yXCflQoEJHDH1/UGc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mjVdJx+F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mjVdJx+F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A525C2BD10;
	Wed,  3 Jul 2024 18:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720032314;
	bh=LScu3KTtT8V2oLuw3+Jj58e5EN80mEeIxP4eOrJOtBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mjVdJx+FJ5UErZo24v5Nx8NOtpkjQwZqA3YGLmprj85eQa4xALk1Gs0xmMAR8SR9m
	 PAceL4MLVq1U3Ks5mnhAAGVhl9PvHcUaI+jlDmxeVix7m1EYlSfvhr+rcCKrn+KT2a
	 SRv++DA/tX6DmkveOETXW0Hqf1y4dtVmnBJH0JZCuabx55QKHlLQ+ZoaIq+IFExwhv
	 5MI8K0py6f61dbOAdptMrtFmj7TCpNPL+crbhvUc4/PAd/wbWAj2BUl1d6djZquxAo
	 UcXY6pIp28B893W+TpS/YhQq9s/HdoFRaecXsZow7ZGXcq1MaI0asjxTsuHzpxAvjc
	 lZ5sxs5OkC0zA==
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Hannes Reinecke <hare@suse.de>,
	linux-ide@vger.kernel.org
Subject: [PATCH v4 9/9] ata: ahci: Add debug print for external port
Date: Wed,  3 Jul 2024 20:44:26 +0200
Message-ID: <20240703184418.723066-20-cassel@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703184418.723066-11-cassel@kernel.org>
References: <20240703184418.723066-11-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=995; i=cassel@kernel.org; h=from:subject; bh=LScu3KTtT8V2oLuw3+Jj58e5EN80mEeIxP4eOrJOtBg=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGNJa5/Dtu7iyUVvxjvKcYG+9CaEpQd8vnf3jb6z3iJGtZ PbG2X6KHaUsDGJcDLJiiiy+P1z2F3e7TzmueMcGZg4rE8gQBi5OAZhIThDD//zaLVKpZjMXXnh5 TL2u4MUL7rmvC9ben/pGh43nYvKcawyMDBu+2X5Zy5U+yc5z5lfPY6mvvhpGHxMTVp67lWV/XvF eHXYA
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

Add a debug print that tells us if LPM is not getting enabled because the
port is external.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
 drivers/ata/ahci.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index fc6fd583faf8..a05c17249448 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1732,8 +1732,10 @@ static void ahci_update_initial_lpm_policy(struct ata_port *ap)
 	 * Management Interaction in AHCI 1.3.1. Therefore, do not enable
 	 * LPM if the port advertises itself as an external port.
 	 */
-	if (ap->pflags & ATA_PFLAG_EXTERNAL)
+	if (ap->pflags & ATA_PFLAG_EXTERNAL) {
+		ata_port_dbg(ap, "external port, not enabling LPM\n");
 		return;
+	}
 
 	/* If no LPM states are supported by the HBA, do not bother with LPM */
 	if ((ap->host->flags & ATA_HOST_NO_PART) &&
-- 
2.45.2

