Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9D6E359A66;
	Mon, 31 Aug 2026 02:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788141953; cv=none; b=A+Y6MJzaqWfP/ZY4r4CoGh7OxNYDTARrnsA5zJtzM+9td9oST5COSM5sl+PGXTGE7HRjX8j5iyoiUao6aDzFVU4uaOs9UxyiNaWsKGRIIIwwNhnL5E6O/sfs6XXJ3kSMU8fPX5Y9BW3nz2REznxkPT7ObJrR2sE2N2JUn3JAh5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788141953; c=relaxed/simple;
	bh=czEvGvequjNPcuTW4mQPvet0E5w0nP8lxOvbX5Y4qv4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pflADA0zdkrn5ggjCauc8lEvjqqI5txIMiBYDBlBKFCoMfCg+u8o6U3PNL30+j66xBataT4QT8oINv6JgXiST7rsGUKgGKAHt9shC9gEfgGDpNpVI+5Z0na+PkiJU82xbHdvTQ8/k+6/TT60a9td5/lTpJ4pmw1jQh5P9OOxvbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C8ImbgJZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C8ImbgJZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C7EA1F00A3E;
	Mon, 31 Aug 2026 02:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788141952;
	bh=y5531/ziW4yYSlUfHnpSR1gRaWvxio9dXP0OqmFFusg=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=C8ImbgJZZDxf4He1IwAcOSEyEDGxnKpX8WwNzStddpAWlVugvOrKERW0bN2iAtGBw
	 fCAmEFW1PES1XcBDdlUKFrwIp5GMdd7Gskk+nmuycHE44h+QwBxd4xOmdGnQZF/okN
	 SP1DFwV/FZIp1XvpgG43bpLJuB/ENUKlDFLcHYuA3hIeM8VVyTrlsK9hiRIwDNHNne
	 WASAWoUikzYlF4DuE6JJllbeGu2lQILNlnq+mVqweD3GPOpgpHshYZbvHI9Fji6p4y
	 qBUrdSZX33ZLTBPYlJhRy2lsKCB60XZwEpiJLCdECntQIlR7N6SRkJssaT91hfEGCA
	 lE9sjIP6Hxcgw==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-scsi@vger.kernel.org,
	linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-usb@vger.kernel.org,
	Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 30/37] scsi: ibmvscsi_tgt: use 16-bits defined sense codes
Date: Mon, 31 Aug 2026 11:04:44 +0900
Message-ID: <20260831020451.585944-31-dlemoal@kernel.org>
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

