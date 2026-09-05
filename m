Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E45BB39657A;
	Sat,  5 Sep 2026 03:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788578612; cv=none; b=oySw6kKihF2fv4BRGTvsZtVRnN8gGbW8h2hYj/SDdvNbqL9SAzV3Sb7uBBRdm3WJitgdl7bIondcC6SS7LlsOP55RuLeyrD++NnoQ6K9QFntPCCrgyc4F1o6YFzchcL4lqY7k/kYBthKALW4jWWckmOPtH6yX8s/JBt+/6PgKwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788578612; c=relaxed/simple;
	bh=czEvGvequjNPcuTW4mQPvet0E5w0nP8lxOvbX5Y4qv4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bzr3YGALV60VZnJvjdhGsMyZhQZwNLS1SBYKPQrkp0C86JQrTXPA6xK3pQY1tMRNubTm/cuUfx0xm6KVW//wwYXoQBWIzUfGsYZWBjsPvODN1ujx0lVaHAo3wTeVvci/oCRGM+ThS+6NedOX0VgUM0d7qKMWnoaGQjg1Nr8hWAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bkol9/Lz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bkol9/Lz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D12C1F00A3D;
	Sat,  5 Sep 2026 03:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788578610;
	bh=y5531/ziW4yYSlUfHnpSR1gRaWvxio9dXP0OqmFFusg=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=Bkol9/Lz29Dcs0+sUDzW3P9sOHzPG86wZ3ns9cX2BsVUORNnRjmhn8/zWkBsj7e/a
	 furE0dCkhFHcw32J1UX/E1TcOFudDAxB36K1Y2kMo+tolPb/aECWkpX0GVxUh/7PzO
	 G9/ygvtd1I1dz1yO8ZCvJlWWizRH0b/EN3nPXWwPLGt15l/Gf5CUpjilcQoZgzdLOr
	 HE/iUP4kwK7D4B5mJ1tEw9QvGDnfW/gRtE+odTejfVOcerrEDYmFTpE2Fsbl8m200y
	 ZcCKKMxHqURgyE/Owq/tD0T57DRPf4SGvApf8dDPVXgufvV7t0/hH2aiYryPRhmpXE
	 Dn4hUZF3hCtmQ==
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
Subject: [PATCH v4 30/40] scsi: ibmvscsi_tgt: use 16-bits defined sense codes
Date: Sat,  5 Sep 2026 12:22:14 +0900
Message-ID: <20260905032224.509860-31-dlemoal@kernel.org>
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

Refactor the IBM virtual SCSI target driver to use scsi_set_sense_buffer()
and replace all hard-coded additional sense codes and additional sense
code qualifiers with the enum values defined in include/scsi/scsi_sense.h.
This helps with code clarity as the sense codes being processed are easier
to test and self-documented.

No functional change intended.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index 61f682800765..e2af90b6da39 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -3757,9 +3757,8 @@ static int ibmvscsis_queue_data_in(struct se_cmd *se_cmd)
 		dev_err(&vscsi->dev, "srp_transfer_data failed: %d\n", rc);
 		se_cmd->scsi_sense_length = 18;
 		memset(se_cmd->sense_buffer, 0, se_cmd->scsi_sense_length);
-		/* Logical Unit Communication Time-out asc/ascq = 0x0801 */
-		scsi_build_sense_buffer(0, se_cmd->sense_buffer, MEDIUM_ERROR,
-					0x08, 0x01);
+		scsi_set_sense_buffer(0, se_cmd->sense_buffer, MEDIUM_ERROR,
+				      LU_COMMUNICATION_TIMEOUT);
 	}
 
 	srp_build_response(vscsi, cmd, &len);
-- 
2.55.0

