Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71DC3F107D;
	Mon,  7 Sep 2026 02:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788749067; cv=none; b=C9pfKzxO21Mi956BuhfPaAKPHhMlhX4NBSIkLMg3+3Zsc61JW2A6B+01PcbFjG7u74iy3ZR2dc6E5rFXNm1xxUdDpdZ+gAEtnIZHpVD50SxsiQ65e4+YTIPwa9yF0N1oXjLA9iNKcZWNv81RRvJOYiLBC5g3ImWzPfmb0vUBzl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788749067; c=relaxed/simple;
	bh=wipOK+FAzYHW6bKnmv0SyRzt8t1T+HSr2bcv+tV2JhA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=omaabc9E58dfrk6BQgVm/jWc3B+LPYaYioS8n2hZ/3/P7E+9OvU+SW0kyS/3FnDtZZVdU9vAnFVADklGSBn3ygyneR2cY+39O+8JR4K1BFe4CnDVgJBr5pZ2CB7RGrnBw/ZLXGf4HIaFKM5AeXTTG41L70bEPBsPhjKebzR1SYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lu9yk7aR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lu9yk7aR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FE461F00A3E;
	Mon,  7 Sep 2026 02:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788749065;
	bh=qdTjkiIjZMu8cjMgsdFmDzLK3lN2zk55PxrAQFqSmUA=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=lu9yk7aR4Qxe7E10eIbkWB/xhhJ0B9f/k1po9YAcP1VGgdhClP7ASNYTqFXrRXdxM
	 RPO2l2RWZ+ibW1fqiAew/lt3GFOdcUS/YHixiQ6yvTFGm+5G+2unu8EjKVoTYhba5H
	 4LRSZbp9u2zv2wcVEfHqyRtNxbzb+XV5TMYdaBizGpv+hcDh3NXxj2QEA8gJOJSBW/
	 6IboDWBl97OwQLmECn9BxYHzHDImoCdWyOW3e3tqHDnOvEOP1EfS+4wyp/jxljF1OY
	 q3yNK50ZEH5WzS8rnNoTbaZ56I2yYt+uUgy5WPR2Fkm0lgo0sY24yMdq3vek17/C6i
	 RMgAV7+y9OtiA==
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
Subject: [PATCH v5 19/40] scsi: 3w-xxxx: use 16-bits defined sense codes
Date: Mon,  7 Sep 2026 11:43:22 +0900
Message-ID: <20260907024343.1046387-20-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260907024343.1046387-1-dlemoal@kernel.org>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
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
index 7f7bf5b5640d..11326465abb6 100644
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

