Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A334A148825;
	Tue,  2 Jul 2024 16:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719936545; cv=none; b=VgIIRDYP5BpFYB7SZpaKMLJsfw1I77wTzxEFjRGfOE/Ps8V6sFjHSXeczqvcuZ7IPbMojNozce/oSdBqooi0fn8WVVnU+SSph9N/L9Jjy8LDN57HlBzM4NXP/TEQjcDK0qJzzLud0CM5DJ/iMcd1t9814E/2JruII5I3DsDRuQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719936545; c=relaxed/simple;
	bh=LScu3KTtT8V2oLuw3+Jj58e5EN80mEeIxP4eOrJOtBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jIRsbYFnmnvYhatD01scq7pIQAU1tIOLJkx7BB5U6qOqoL/uIC3HzaYDPVEbbuMh/nbJW+qq9ZEM7m+5yUHjdgNyP83N/Bfn4SIH7SShee9h4o3Es3nCxH1srgK79R2sdmlfMJPNSjW4R8f9fKZHgM3lFq5ljTSfJpWFNAFs1/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tX5sOWoe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tX5sOWoe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A4F2C116B1;
	Tue,  2 Jul 2024 16:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719936545;
	bh=LScu3KTtT8V2oLuw3+Jj58e5EN80mEeIxP4eOrJOtBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tX5sOWoe/yXCZ2iHUw3dVF3mWeeMJNyvPNXX3rB4vt6yo6HMeWVHFraiYPqfWO2zB
	 YPla3mjQ6ba4ljV5Hya5EiA9bG6+jKWSzMkVMIgyniSEDIeu2OM6cfdVdArU/sxxP1
	 M1Kn6idBdqoFIDEoHVRxR+ivs5KWebvn5OOwiXX1NFa6XFtSUZl5eyAD++zbZlhg9A
	 t42JosbTeP1C5JlW3NJwHElYWs+xP1qomIgSCA8xbH1COmu9/ep7FiDk/7wNYy0iT6
	 qzEe4b0A6tI+J5UJrT5su6W8T/uyoq2tiV9vF+XMaObymmTlaFuhqxkM2U79t/OP3v
	 RciaYAIU+LfvA==
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
Subject: [PATCH v3 9/9] ata: ahci: Add debug print for external port
Date: Tue,  2 Jul 2024 18:08:05 +0200
Message-ID: <20240702160756.596955-20-cassel@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702160756.596955-11-cassel@kernel.org>
References: <20240702160756.596955-11-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=995; i=cassel@kernel.org; h=from:subject; bh=LScu3KTtT8V2oLuw3+Jj58e5EN80mEeIxP4eOrJOtBg=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGNJaVJ/tu7iyUVvxjvKcYG+9CaEpQd8vnf3jb6z3iJGtZ PbG2X6KHaUsDGJcDLJiiiy+P1z2F3e7TzmueMcGZg4rE8gQBi5OAZhIDjcjw+u7zAen3HKWdhaK 2r67y+N/zoP0aZvFjrhUWHf3tdhfjGVkeL9l1sZo6c83yt/VSM3YWb8swkQ+92hnyc85lQtetKi XcwIA
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

