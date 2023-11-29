Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9061A210E2
	for <linux-scsi@vger.kernel.org>; Wed, 29 Nov 2023 16:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hkKaGBe1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD7A1C433C8;
	Wed, 29 Nov 2023 16:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701277119;
	bh=DJVXUbcukE10rkfMlJhT2I5u7DfVRwTczDIe5/khTZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hkKaGBe1CVrZlmDMTgLMXAXuFYd3u+lKKs7CYsLFD636Ivks4OrXebgRXx9FNxH/1
	 OBdKzSV7yNnVW7kEfdTbuwFlK7Wg1IbZxg0b25NRQUgp3f1f6hCXL4CGRzO7W25xx9
	 JDITFescfYyRt947JULeF2fhdr86t5EYby/zNNuB2aRlrJgJHqF7Q40mJ/oMIV+ezx
	 DgcMqs+DLMGUaVPmjTiTSRjoiuo1FuN+03lvnNsTwiNKG4Rm6jQSnzqpyShpMU91/G
	 U8WNo7ah1eFges15e5yXTT3laHFNrD7C8Ir6qh+aHHVfiqh73QfGQCnxAWYkeWvsY7
	 olF5Z3oZBf13g==
From: hare@kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/3] libfc: map FC_TIMED_OUT to DID_TIME_OUT
Date: Wed, 29 Nov 2023 17:58:32 +0100
Message-Id: <20231129165832.224100-4-hare@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20231129165832.224100-1-hare@kernel.org>
References: <20231129165832.224100-1-hare@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Hannes Reinecke <hare@suse.de>

When an exchange is completed with FC_TIMED_OUT we should map it
to DID_TIME_OUT to inform the SCSI midlayer that this was a command
timeout; DID_BUS_BUSY implies that the command was never sent which
is not the case here.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/libfc/fc_fcp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 05be0810b5e3..80be3a936d92 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -2062,9 +2062,9 @@ static void fc_io_compl(struct fc_fcp_pkt *fsp)
 		sc_cmd->result = (DID_PARITY << 16);
 		break;
 	case FC_TIMED_OUT:
-		FC_FCP_DBG(fsp, "Returning DID_BUS_BUSY to scsi-ml "
+		FC_FCP_DBG(fsp, "Returning DID_TIME_OUT to scsi-ml "
 			   "due to FC_TIMED_OUT\n");
-		sc_cmd->result = (DID_BUS_BUSY << 16) | fsp->io_status;
+		sc_cmd->result = (DID_TIME_OUT << 16);
 		break;
 	default:
 		FC_FCP_DBG(fsp, "Returning DID_ERROR to scsi-ml "
-- 
2.35.3

