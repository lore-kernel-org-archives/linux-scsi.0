Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41304317162;
	Fri,  4 Sep 2026 00:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788481671; cv=none; b=cSrmxko/+WeqNGMxhUx1rZBj2ahUJs6XTdfcviCeqjOEveTPaFYKuiCx7M3cDX7igUsVgFDmqes/HvRz8xRi9zidX7lZ2IbQ2G+BUgfi9hZdZA0jSiSta6Hy58aHyC2TRKp99mEevXFoBkJGaje0YIY1zB1iE8mOnmVGPBuGjKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788481671; c=relaxed/simple;
	bh=czEvGvequjNPcuTW4mQPvet0E5w0nP8lxOvbX5Y4qv4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M7lRmI5t+khlR9AxTKWANIxrYXArBGnK31UWRr6jwyioD/FpBSLpnwSb+9fWitJA2YGeY7RcZXxf9bieOJBEt8NRxwC0D1XSar4faLOJj8Q4/hsR2hft2gna3QCz+yWqgmI7LGXok3hmvBzfWNmCCRB7hZ19r8mumozGdmz/QJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f+HCyVex; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f+HCyVex"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E7A91F000E9;
	Fri,  4 Sep 2026 00:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788481669;
	bh=y5531/ziW4yYSlUfHnpSR1gRaWvxio9dXP0OqmFFusg=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=f+HCyVex70Plgz7AIZYsZYhefG8jZwv3gJvw/CHi42mmlQeum0eQ1BPdg6AWoD82m
	 Aa0AWvKLoRjfjODzXaDIcOq2HITPIfO1Ne2dUuqNbOUcHbjIXjna0C4ZGsenTjhw8U
	 qkWF2XkSUJmRr3iTxX7tgjl1FScnOcZeVsRlNGE6JiTCeH+0dzgVIQftNN+xHmaG1X
	 INL+Arpk4MLp31VD4OzFc9oEXzUXQUOpYwoiYa3Yn169l22Hpzy2p2hQZUKhsSKsio
	 Q8XEiAHHOzygyLM1Ed9orWzOkZ6PIMrwPw9Lld946tFIZiSftyIUqG7dIuoomomqlw
	 9Oo1QBUEWpVOQ==
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
Subject: [PATCH v3 30/40] scsi: ibmvscsi_tgt: use 16-bits defined sense codes
Date: Fri,  4 Sep 2026 09:26:34 +0900
Message-ID: <20260904002644.157668-31-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904002644.157668-1-dlemoal@kernel.org>
References: <20260904002644.157668-1-dlemoal@kernel.org>
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

