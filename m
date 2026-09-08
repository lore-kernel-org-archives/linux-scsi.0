Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9ACF5013D8;
	Tue,  8 Sep 2026 09:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788858238; cv=none; b=PpOxJz2DKZOAG/quty0zWJLf/UgEgfjTW01nM4oL9yqUJct1vr6CgY9XBEFcyJTax0TfKUbLHPVw9nhomPWl8eOU0e7QXwaY09dEwr7iGJEfsE8esJa23Hl4Tr3tHoWEkG1OFPDY2QupWEbfhAr6ObnpkBOc0037KH5trXIk1+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788858238; c=relaxed/simple;
	bh=G05VKPYfQU+cOgILIKAMFfagWAj1vzN50l+I9FzuKSM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=klZeBgy/YzNmurszynKMme55K9Hkbc16Ir/3Yu/A6psMdIybW8+vIp3zGS0xxZcb8WQ7jbO7divrjRJDOnZS7AeyLOPj5StjtBUU9Opb8cCbJ0K5jBpx9GVCmj4PD1ZP0Yyz6MdctSW0r3+/eJFWctwuKZGkfAMIAdqZp8sfV+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CuliFC+g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CuliFC+g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9BC31F00A3A;
	Tue,  8 Sep 2026 09:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788858234;
	bh=M8Rhwe7rwcSU6ZpO6YL9XyG68Q/NO3f6sEyLMdmas54=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=CuliFC+gNQTEWOV4v6YcVLzsamoDQaDY6kaqZdJ9banu8EPc96jLSMdsSh6h2xZfP
	 Ut9e4JO8s3C09UTdgwT2CmCVWCTDuPND4WjlpCLNyVHajN+FXbQbV1IdUhoivTfEzH
	 b70I6Sk1YdaFutFDpURS+v9zVOmVSq2a9pQHrZk8RfJt96nYOseaZAp6PUrI1kHJt2
	 lH/ymfN1JhfQtreLeStrahPXBfwKV8OFDJs+h7fiYnvwLYNufFY57MCpd3vP9wD3H5
	 3A3uWVRvZuxSv6mKnMvjI5Aaw2yzEqU+kD4RoshS9oAl/g4AjY/6UPctOug3NXedzP
	 8ATJ/sgzl2rsA==
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
Subject: [PATCH v6 19/40] scsi: 3w-xxxx: use 16-bits defined sense codes
Date: Tue,  8 Sep 2026 18:02:47 +0900
Message-ID: <20260908090308.1085097-20-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260908090308.1085097-1-dlemoal@kernel.org>
References: <20260908090308.1085097-1-dlemoal@kernel.org>
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
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
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

