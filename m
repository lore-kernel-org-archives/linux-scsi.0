Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A79437998A;
	Thu,  3 Sep 2026 03:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788406982; cv=none; b=ipEdpYdf28u7TDpg07ES6MJ/cRVhG4Kj7kqAVc/W8dK3SnW3eEwQGDi+5JK9yTJDBso/EPaf7uRWZMHx9JQ6sqNC/qp3y9tI5pbpWJKfcTTfLuwwqzonoqYznf4h9JIGJ5D7ON5OfCoYxfjjhBJrTrMIA5lCpUSiBk5pCF9Ziy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788406982; c=relaxed/simple;
	bh=sE92WhcpeO3vXUZC1JrCB0k7VUQpqP80L2UHUnChmmk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P/HYNkRyi9H1Itbx0Oq3JdgJ3WFvt62qtgTxJGfIg81ZONHJqVC+1jNHBUmzWjcww51lGgdz8YaIlEW9+mfOBoPVAyFx7LTvagmEP7zS5BFbX1UIkqGzShoBVQNTkOnKjTzOAfhoG1WB0x/PLl/jyvFaJN7vITPdg8JU1yNWdBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UW4J1zgi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UW4J1zgi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 830FD1F00AC4;
	Thu,  3 Sep 2026 03:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788406970;
	bh=lTENjnZrp7hhmGLMSADiexyYfPfX9y1p8zb2h9sN0zw=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=UW4J1zginUcLcfQjqvWkYPeg650Rik7nLzecHZ4Gnv1n/gKqQLTmDQMQZvtScuh4u
	 aJ//WSPzcDIxJOHI4jg4MXDZs38bRPIPzSG5IRm3BoVf+6yLTZbwExaJfzg4yOFMWE
	 lULrvN1Cs+47SQOcW/iUzqib/KVS//rSkXeUCd+rOCmj8ZNv56W88+48YS4RDunWvT
	 30638iGXmvP9SGOSM1LthMyAZceN9Qspj55D7OxW0pcRwXtasn+vOhntxF9V9zc6og
	 Ds85PXB0D2vLOgZd1AT7adMywF5V/hJi7BnVud2iy7LZ3qo6hySR0t6QeNrfNEeGdL
	 FADO2EXp6ih/w==
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
Subject: [PATCH v2 19/40] scsi: 3w-xxxx: use 16-bits defined sense codes
Date: Thu,  3 Sep 2026 12:41:40 +0900
Message-ID: <20260903034201.112211-20-dlemoal@kernel.org>
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

