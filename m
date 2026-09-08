Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA5434041E;
	Tue,  8 Sep 2026 09:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788858253; cv=none; b=Wt0ds8mii71mRbHVoVrpCgeKhw7p8H9+HmmbNC3Me6y0vR2KFq5REBJee/ZKrCmx4hmPtGPtGvyc/REWV95hiAZcXvOFF2uDuiTBGEhrT/pKeeaHVpSlcZ/cx1/XVacN+0rPF6f4sTZOERrjxBoPf6xZDRuXOW8NiQsgJIyu8pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788858253; c=relaxed/simple;
	bh=ZsvHA2Nl/6MS6+lggYSYyHe16uqqWhY+SZz3PJ0t+/M=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WnUkSJCfBgSh2KAmg7gKETqZs3icBtolIctRlHwyPdd2KmqvJsmKddBJEmpelvSibcx6GMLyT1euqurFUir3vqP7O75asVJhkItOSI54m5DAtALgvaCpGHQkQnbnF5DW8qzjnOfCh5nEM6VR1AH0RQSxcvfg+l6FyBgAUr7U7V4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GfMcG2FW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GfMcG2FW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 781391F00A3E;
	Tue,  8 Sep 2026 09:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788858247;
	bh=wcfizUUtBoIHUo1FczP75riSb4IQ97gjRDsK/Mkd7Kw=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=GfMcG2FWXog8EqxNOsJACUnAehjIUeS6CQEw0umEnmE10nAYx1iIcM/5bCFugljrZ
	 LzCK8gmn/26dDVJHPBo8Emh7RPhswkUdGkOr/SeODAYpdPUvj9R0gziBTX5pCVTnh8
	 8xZE+f7f0p/44LiuIRcht7HmeBpjZrACiNM58iFhSrz3c18x52EwsBzRZCqD8way0U
	 oxRuxGygP8iU6YIs6VtFhuvoeyfJwPD7aJdrL91uS15qucw+z0ht2WRV/w2XKXriIj
	 HnNH680R5eAe123nEKF0dwBoORPhp8uBIeu0J+9y6YO+1D5+Tx3yz1mBICXooCsL6N
	 Iy39djdrmPNFw==
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
Subject: [PATCH v6 27/40] scsi: stex: use 16-bits defined sense codes
Date: Tue,  8 Sep 2026 18:02:55 +0900
Message-ID: <20260908090308.1085097-28-dlemoal@kernel.org>
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

Refactor the stex driver to use scsi_set_sense() and replace all
hard-coded additional sense codes and additional sense code qualifiers
with the enum values defined in include/scsi/scsi_sense.h. This helps with
code clarity as the sense codes being processed are easier to test and
self-documented.

No functional change intended.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
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

