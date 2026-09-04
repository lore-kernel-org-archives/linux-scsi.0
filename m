Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A1367DA66;
	Fri,  4 Sep 2026 00:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788481652; cv=none; b=Fe7onIRUiYgVB42kLjkNd1q+lngZ6eLPeuBWKmAh7xTeoL7m/h9aTNs0/nyONU8myFQK5m+GLISNvezQrdSbzx4HbAm8GDl5pCe1gf6hRAQfsGIDa4i0JIZpXXwqEk3wZG0z3MT5bHYlVbgQ2r4R/pWmKXNEakU9IFkmW6c9wOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788481652; c=relaxed/simple;
	bh=sE92WhcpeO3vXUZC1JrCB0k7VUQpqP80L2UHUnChmmk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VlE427OFvwByxF10V22NIFwf8rPBvi8DbHvc+lWLeJf7EZWyjV6QCoxPqyHlULsAl5wY0Dvg0ycs9y4dwkOZn1F+aNwsqG/9eyo0Ddzoi/Ndy94AsGNNoMRkscRU+maI2iRjmq7NbhcvPQ0HRPMyknWbztSdNb27EwqyXgn59Pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ej3SIlq5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ej3SIlq5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DF991F000E9;
	Fri,  4 Sep 2026 00:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788481650;
	bh=lTENjnZrp7hhmGLMSADiexyYfPfX9y1p8zb2h9sN0zw=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=Ej3SIlq57+VPnP2pSk3MDi/zdVmjNZQW0yLMPUfL4Dj2DuV33yTLYPi4vtAzBuhG1
	 fhkWC4QSjJ8tBIPeUj2AjUhZb9zppQEQ4sfxh0ntp9FxZGLx/XDVW97dowb390o353
	 3J+AiXlYc/LWRTJskjCZtObipRMDFnoW+qKaOdeBgRSJIJDWYI552k3iWqD/LPoxCA
	 n8G0V+CTKO3eGOZXXKM/WYfXu1ii9Mtuie6cIg6wMGZbS95mfe0H8PLsUQqVle/Us6
	 dJ3pG/Mw49j84y+2+qGnKFgLMnJWE204LsM2uj7S/djOtqS6KfqXIpudS6TNmLqHED
	 drFqLzqevwzOQ==
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
Subject: [PATCH v3 19/40] scsi: 3w-xxxx: use 16-bits defined sense codes
Date: Fri,  4 Sep 2026 09:26:23 +0900
Message-ID: <20260904002644.157668-20-dlemoal@kernel.org>
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

Modify the function tw_scsi_queue_lck() of the 3w-xxxx driver to use
scsi_set_sense() and replace the hard-coded additional sense codes and
additional sense code qualifiers with the enum values defined in
include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
being processed are easier to test and self-documented.

No functional change intended.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/3w-xxxx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index c68678fa72c1..1e1692f776d3 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -1977,7 +1977,8 @@ static enum scsi_qc_status tw_scsi_queue_lck(struct scsi_cmnd *SCpnt)
 		printk(KERN_NOTICE "3w-xxxx: scsi%d: Unknown scsi opcode: 0x%x\n", tw_dev->host->host_no, *command);
 		tw_dev->state[request_id] = TW_S_COMPLETED;
 		tw_state_request_finish(tw_dev, request_id);
-		scsi_build_sense(SCpnt, 1, ILLEGAL_REQUEST, 0x20, 0);
+		scsi_set_sense(SCpnt, 1, ILLEGAL_REQUEST,
+			       INVALID_COMMAND_OP_CODE);
 		done(SCpnt);
 		retval = 0;
 	}
-- 
2.55.0

