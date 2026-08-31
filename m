Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7BB9357D1A;
	Mon, 31 Aug 2026 02:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788141936; cv=none; b=BexRFgUrZQNqwUwx5Dh/2m/ZCF0xHzx7E4MrrL5mfzKhdHLrgqZmJOwP2F6NufBSeU6QPGqG5cLkZsSF1981hPT0CoLhcc6y13hl5tbzV5kkU0SUNWGGihjCptsS9Ej00G2AoezuzaJM42pb7Fc2k4ZtXc90yTRL2+3+gEEPFzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788141936; c=relaxed/simple;
	bh=sE92WhcpeO3vXUZC1JrCB0k7VUQpqP80L2UHUnChmmk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iJ2iec1OHIeJJf67ltQt+hZf1iOSTmmtIm+UPMN8XQYpc74uQNGZRPFSfZDkpip/VpU4OhXHDo2NZNqU9l+LkLa10in2nPQNfuI2drRekjGL7Rq9R5oJD17lOY2mYbicZG35So7pABzIF8D4qBL5+0vMj1tCNWXvEKXPTSwxaeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mQ1uBhA2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mQ1uBhA2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 147831F00A3D;
	Mon, 31 Aug 2026 02:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788141934;
	bh=lTENjnZrp7hhmGLMSADiexyYfPfX9y1p8zb2h9sN0zw=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=mQ1uBhA2l5q6xkDu4SswLznCSfV/dtRGxR9AUVaz0yLhNsNARZkv80XJbGRB3Kp3r
	 JzIReK4axXnLQcT7sW5l/kv4R1f0YjxxWVBLmoSE0BkP3NZpImR4MtDn3yG/uIqDni
	 hNjdvx3oomU7FGjdOTYg5cgLF2ph3lUck6Y+1L75FsACSsMp+hJl4L6vDRXO05jaYK
	 vt+AnvJQsTNC6cdwzxa6/5lzj01LtZVF8+26SMW2Nixn49OcSOAQw/ZlendkQhklRH
	 4boUNQopJN4E2ayqH9E5uulDVimHY5TFByZ8lpQ+pkE0A9XQ+9d9M5Qv8p0IYGbhmu
	 pqvYphp0EOQ7A==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-scsi@vger.kernel.org,
	linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-usb@vger.kernel.org,
	Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 19/37] scsi: 3w-xxxx: use 16-bits defined sense codes
Date: Mon, 31 Aug 2026 11:04:33 +0900
Message-ID: <20260831020451.585944-20-dlemoal@kernel.org>
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

