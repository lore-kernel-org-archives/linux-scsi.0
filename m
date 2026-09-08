Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11DB5111B9;
	Tue,  8 Sep 2026 09:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788858255; cv=none; b=puytVySuafW+7Fwuin+vjryVWUsdK0ggsEDO1F9bNkVsqSSD4eEWbTPUi0z4K6FBV1QZRtSwE8Mdh6Cp5VJMVMjHYnk28lFHe1ZBbckTf8qStMJCwYklDdNJvn6zAcBlQri5dqZUAqGXLPXwEeiFaF3UQdjLiQJRpbbsr8ybIgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788858255; c=relaxed/simple;
	bh=549G6Pv0WQP27bQM7RJj7iqDhmLhvPzaVmaaqA3aIQ0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E15gDKPUAZ+P4T8ThsWXuNaDEvgS+TAPA1zRQ9wH+Y8WVX+hMtJ28mTaKlWcZ7rEqL62MHkK99yr6sjdx1MoJx/+7fCQ1Lgg0P6MdRzA8y7mvCFanATs2a9r+Fvh1wAtWLzeIXzKRMeAVlJ19S2dl2SsH6wh238H5gTbqwvMCzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cue7FEec; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cue7FEec"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AF1C1F00ACF;
	Tue,  8 Sep 2026 09:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788858249;
	bh=gmkAMAoXlGXsMXXdsD2ZTH7dSBTvOQH4EE5WZzDvuDc=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=Cue7FEecRBkZkZ8Ve264djFOEj9xDsNcLU2TXJgsP2DzuUrwH7X8gnVxxiUjyS9FV
	 B5uH5PwTkD0kIFOUd53WD+2/MI/anBnQlI2s0ee3ruhZgd7QfJX3+ittqSoJ3U9qrt
	 7TRWd7FS+IwOxZLLAAlQeTsDiGk9Ee+2Le0c4zWZJlMc1SdppZRG2FopzFqKC/BLzO
	 b1iXejNf6SLHadPngRYZwD1TiQyN/QCmGbquN6pVnknd8WjUlHr5T1Lr1v9dPlSxpc
	 oW52d1nOAqLEncdAGpwOU1nDhi3r5eEnEVSpxOMTh+yyXEwwXTXm7N02cUXXRdaq6M
	 UhWpGWNEk4/0A==
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
Subject: [PATCH v6 28/40] scsi: mvumi: use 16-bits defined sense codes
Date: Tue,  8 Sep 2026 18:02:56 +0900
Message-ID: <20260908090308.1085097-29-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260908090308.1085097-1-dlemoal@kernel.org>
References: <20260908090308.1085097-1-dlemoal@kernel.org>
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
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/mvumi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index e9e2c25cde68..91c2db697c69 100644
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

