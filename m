Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BABC535A3BF;
	Mon, 31 Aug 2026 02:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788141949; cv=none; b=bC2MXpdMKXwcu0HDYGDlKQpy9mNDqURZYzd8Y7YtWVIO0AwCjPE+ELNnBkfBnKxeUAOjrYQwYClPqBYUC0nFnp4lqDmC+CrCHZnbPV9otcWYqjRrwknHsUc3E/abnCOtQBD9o9lpWFV6fQhZwO6o2BVyXniKT3z+pWFLBTWkDzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788141949; c=relaxed/simple;
	bh=0EYWFEYW65Y16rbTiCerbOr1TaGf/UwUikK6l+Fxl2k=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tjNUGO2BfpB5Z2xH7hym8Js8SLMztUYvJMAUfsS7dQgTDUEzb9jJiDbJIi1wNYicqly25j3upFuJoX9EhkbC+6SJbJVKX94bB6N0iSPVy9VbYNk1C8XFUaRTUEHFFDNREgb7GfVH+ok07kfcRyP0JSiNvyA6p2PBOvypvj5F7zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jpnE1oRN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jpnE1oRN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 782711F00A3D;
	Mon, 31 Aug 2026 02:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788141948;
	bh=OOmP+AAn35Yx6p3Mt4dGknMDab/j7jCN8TP38qbLk7c=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=jpnE1oRNEics4ZOiBE1L8WuszsN3jKA3F5DA9AoZacz3N0i6KVb9YttnuRRp6Q6aD
	 /Ku/m2LBETWAOpqhQfOPi7R3zmwK+lHVk5KeQE9zgGiYXAke9QUNnRXxvQBFt0Ua4W
	 MMp2967MvjE+v6Y4kcMhsIgDKSRn6RMkFcpcTUf1d9xl66DEpN+wcvW0Dnr1vQzP7W
	 5gVmrG2J2XzGRIFOKvnRL8E5W1hNq7ahtMl3mqvx4F2uxtsuC0rcMQ4WwJG+a81G3J
	 vjtAKCtcQVKLDCJbf5a/k5jw/3h4hI9KYTC4Ugxe6Vxk8MqejzfwjgGYQUVl/HEtU7
	 Qe7aqFQZB+YVw==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-scsi@vger.kernel.org,
	linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-usb@vger.kernel.org,
	Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 28/37] scsi: mvumi: use 16-bits defined sense codes
Date: Mon, 31 Aug 2026 11:04:42 +0900
Message-ID: <20260831020451.585944-29-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831020451.585944-1-dlemoal@kernel.org>
References: <20260831020451.585944-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refactor the Marvell UMI driver to use scsi_set_sense() and replace all
hard-coded additional sense codes and additional sense code qualifiers
with the enum values defined in include/scsi/scsi_sense.h. This helps with
code clarity as the sense codes being processed are easier to test and
self-documented.

No functional change intended.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/mvumi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index e70d336b4ab3..a5bd3258a399 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -2067,7 +2067,7 @@ static unsigned char mvumi_build_frame(struct mvumi_hba *mhba,
 	return 0;
 
 error:
-	scsi_build_sense(scmd, 0, ILLEGAL_REQUEST, 0x24, 0);
+	scsi_set_sense(scmd, 0, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB);
 	return -1;
 }
 
-- 
2.55.0

