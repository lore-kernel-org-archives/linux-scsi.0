Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1728837DEBA;
	Sat,  5 Sep 2026 03:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788578593; cv=none; b=kvb2OBWY9LQksv8F95+QbdqT9/caB2xfQOxB3z+KjDvA5d0tlcDHfeBbIeK09gIndiZaupPH+u+JFMtWdf4X+mFjHBNnnLr5vhdARnx/DR7r9RAcEY6nEf8YK1WjqXs8Uofu/ccUBFH8qoxugULddJMqrcuBw087gMX67Y0lqqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788578593; c=relaxed/simple;
	bh=wipOK+FAzYHW6bKnmv0SyRzt8t1T+HSr2bcv+tV2JhA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dHh34Fyj1V1oGElTpe/aAM3ivI2Z0NetRVQtG8n7pJK1idtOrk1Pyk0v5UQNSgBRZvSbrkwaZuKpIIrmqY7BlbgW8zhC1rPd1+7YupYmdhGe3H8jUlJShgJ3lHNOP6ejLDQGc0bRBEvCGMHmRMEUzbEXgEvEyPMXofi6kkRPs2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aExcDQD0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aExcDQD0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 651261F00A3D;
	Sat,  5 Sep 2026 03:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788578591;
	bh=qdTjkiIjZMu8cjMgsdFmDzLK3lN2zk55PxrAQFqSmUA=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=aExcDQD08w1hGLOM3S2xfjjaeiGk7cxgsnnLVW72Q+rhKHsfAUflRd0DvpGmLA6jB
	 abEEaoDmAFys9x40lWqzT6m+1HkiF2tDRq5pu53f2tS7E7U7CCmRNGlC1pW46Kt3Od
	 RiB7PxTEVnBE5eQv3JdSU1tIk1io4t5IVs68TXSVA0XcklBhOky7Yq94OzNn9qf7qx
	 zRLPiJskn//eKsW0teyd/5Q70BydkUSEk894/UmUBj0J/EviSSaAHUJanqLss6eD9H
	 rRXppU0EUFGCCEVrjI538xGwJHPBedWKIxL7FyXklViL1jD4+yPUwKin/trnf8P29q
	 xJI7aTjOZ3Vxw==
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
Subject: [PATCH v4 19/40] scsi: 3w-xxxx: use 16-bits defined sense codes
Date: Sat,  5 Sep 2026 12:22:03 +0900
Message-ID: <20260905032224.509860-20-dlemoal@kernel.org>
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

