Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C013939C2;
	Thu,  3 Sep 2026 03:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788406994; cv=none; b=WH+WAhQKpaXIUZLeEbS8q3UiiiNtHiOXHLnyki8Wg+YBtw5FuE3391LrDruM35j8GQLAHjUW9UQ+O1aEaLFqH0ew3r0WiuRS2l9sc4jYZDEmLzUk29zfoY9iG6AkZ0z+f1cVZrp0ynHYamCozlmv0fEgLbCtFwUcj6kEUrl5R6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788406994; c=relaxed/simple;
	bh=aniMHomtNRiybiTm9qmt1bbUmYk2bJon40xjoPETuaw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iqrJ4O33sSXsMZ+RvUA5sivBwNxz/JxTwgjqo7o9NiLXF70iOrxbIJnS3OX9r25kx4R7PVWO3cVy4VUXF4x+DwH5r9t4Qf9xv2vINZNxO3B21T4lOjSdKzpwFOtqeGcpPkyEGC84RQgut5HhJ/6MykF3VJzNU34Xmcl5W0YcMeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lf0Mc0Xg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lf0Mc0Xg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0958F1F00A3F;
	Thu,  3 Sep 2026 03:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788406984;
	bh=GmKRJhMjMSX4APigNgrN8PgSWVi01i8DN3Nci0Few5w=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=lf0Mc0Xg2HYZjbei6M/lDo+oGilV8dET8capTBuMCBb2BU3NZLwTxz5Z6cBK7yian
	 Bdv4zbnb9112jmyd7CvrA4S6n/Kd7gm8WdlIPsdaDwKpFq7HNgC+EG8gtTyj7P4pIr
	 vmLu3Dfq/LMTdmH7nb2a2QRxPPpsGsBgNPrNO9ajpcG/rE86FHzrGu6ScJDjY8kOYK
	 MMigpuzgN70F24JbHWa0M0ALzt/uquWEFWvD5NpZMWFd0nBWbiX24/zK7RHacU0THz
	 naopurJ7oacyBlinSkDxTsb8d5fRJVI2dZnPteWfUg6iPPF/Wl0jQLLPv1Xtq6wryA
	 B5MvpsLZ9Qatw==
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
Subject: [PATCH v2 27/40] scsi: stex: use 16-bits defined sense codes
Date: Thu,  3 Sep 2026 12:41:48 +0900
Message-ID: <20260903034201.112211-28-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260903034201.112211-1-dlemoal@kernel.org>
References: <20260903034201.112211-1-dlemoal@kernel.org>
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
index 6aeeb338633d..056ff0eb5455 100644
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

