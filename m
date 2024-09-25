Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67749229081;
	Wed, 25 Sep 2024 12:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727266641; cv=none; b=kEZ3X2l9hm36aCNXUrusXy+vLsulyjOBI46EEDshKszA7o/ZYTu771OicMb0HQ+0r6zD4tAwq2fu0BYUdFY7KWeLiu+P18K2gyPgRmKwpE8rq2DIFwAt5Z/GsgP7E4inmVOgHC0QpMNUt3ufxVB9poFD3S+BAm54YsYyiW8tujU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727266641; c=relaxed/simple;
	bh=uwvlE86YHQU/hfeMbPJqPOnWFDozBb2zVNDOcuYEcH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LKFi16d+UojfAtEPiJHCOStRo3tvV5fIC1lH3RoTf7f/RGK6QBpHIEcztaNN2GMXCQtyVgyNBjFv8xbBMg+JJjvpRDEtkOmjh/IZSni3PmUIU2NLu1+5kmOnsalx4j81GnVN/5LvIZWmideVTtNpIP3OgMfsHQ07pNzkSKdErrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jOgRo8Nv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jOgRo8Nv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 240D6C4CEC7;
	Wed, 25 Sep 2024 12:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727266641;
	bh=uwvlE86YHQU/hfeMbPJqPOnWFDozBb2zVNDOcuYEcH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jOgRo8NvSnerCYCJgANvzwjOKrpw+k0JO5+l+ZqZahTVGtD7TRJ7I2s0nxCIJzl31
	 9y3Rz6gDoidtTgveBtyYhQjLHLnEjtY3WhLjBWFUEEAaJk75W4icdD0xkAaqj8AwKx
	 ob4J/3L/byee0g8exgnA3q8+H/oQ3VLdpnVfckFPkp6UIck3iJZ8J5eWU3u15zGx8P
	 CC+lGMdOlqH84f/agk7CyBrkpROf5ZzwxrcBmIHxeUuvtr5G1nH3H/UwNVZsMIhei5
	 ctx1qKlom7QfR40rpExkAgsAfU6XcIE+V9TEk9VgYON0M0jfUw4rP6rhoZzniUsN2J
	 7u2LGguefyteQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	schmitzmic@gmail.com,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 120/139] scsi: NCR5380: Initialize buffer for MSG IN and STATUS transfers
Date: Wed, 25 Sep 2024 08:09:00 -0400
Message-ID: <20240925121137.1307574-120-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240925121137.1307574-1-sashal@kernel.org>
References: <20240925121137.1307574-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.52
Content-Transfer-Encoding: 8bit

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit 1c71065df2df693d208dd32758171c1dece66341 ]

Following an incomplete transfer in MSG IN phase, the driver would not
notice the problem and would make use of invalid data. Initialize 'tmp'
appropriately and bail out if no message was received. For STATUS phase,
preserve the existing status code unless a new value was transferred.

Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Link: https://lore.kernel.org/r/52e02a8812ae1a2d810d7f9f7fd800c3ccc320c4.1723001788.git.fthain@linux-m68k.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/NCR5380.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index cea3a79d538e4..a99221ead3e00 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -1807,8 +1807,11 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 				return;
 			case PHASE_MSGIN:
 				len = 1;
+				tmp = 0xff;
 				data = &tmp;
 				NCR5380_transfer_pio(instance, &phase, &len, &data, 0);
+				if (tmp == 0xff)
+					break;
 				ncmd->message = tmp;
 
 				switch (tmp) {
@@ -1996,6 +1999,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 				break;
 			case PHASE_STATIN:
 				len = 1;
+				tmp = ncmd->status;
 				data = &tmp;
 				NCR5380_transfer_pio(instance, &phase, &len, &data, 0);
 				ncmd->status = tmp;
-- 
2.43.0

