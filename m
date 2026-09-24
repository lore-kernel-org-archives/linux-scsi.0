Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D6940A936
	for <linux-scsi@vger.kernel.org>; Thu, 24 Sep 2026 11:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790248918; cv=none; b=D4aE7zB9wHF9iDB3e0mZQ2dEomWCp20502yHzjv2I54n6qflvvVGV/Il7stpVIF6T0554NMXTksxhokvt+DPDMIRCSdLOXxn/RfATaiF743KoXiTWvdwmgAQby6/0U+aGq3CnR1IvWF+WGT4lQ1rUBSJlT8NUVm7UodCFWsd1sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790248918; c=relaxed/simple;
	bh=Lw/lnT3UffRNJqnKPnXIJjq3ezl9TcMYqjsJZexWcIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b/dZ8db0maJTd9thdSmAX2dkGfFN0qciHM0gSf2079NLfUACLQsCBwZQOdFIAQ+gjjLJBikERZbAmwLgh+rSADFM5N5fb8yZw75TVHlhI8Vj6wuMoj2DX9aDdqeQ9jFgt6oNLvRxUqnprqOAyjmYgocUhhLuo8u6ahWmdJq8d5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iQLCmyZB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iQLCmyZB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C6DB1F000FF;
	Thu, 24 Sep 2026 11:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790248914;
	bh=gaeoKS0ZtfrR4lvyhZ8IkKYcUCTiFU3v8s4tRMNYduM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iQLCmyZBtl1Ohz9r+hOE7mMNGW9c0uiFgKoNRmlCPupDSq27uqe18YeAKUx8gnCG2
	 ft69sA6fqebHUKLNLOBqTOyiU14DMU8OXcM6QlXg/J5vIUfNxJXY8xAqsXF9LmMIf7
	 0JqLW17q3Ezf8Ax4G61bk3ySoyZjXmUfCEUCp47bNaw+WFj9D7sLuz5thZkWHcc4VF
	 KL7pfu1kcS9BPsNsPe8pJZ9m/mCljJdOyGeCrHTsLuXNQC5BvEg2Bavwktidi57zKW
	 AwPNowmImQhDHHzXyhqgVkBUxtGAST9IhtVCCuXypIPf/zHXOr6w6QFJ0uSZyE49P4
	 0608MD1ULsbfw==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v6 08/11] scsi: scsi_debug: Advance the write pointer over the data written
Date: Thu, 24 Sep 2026 13:21:36 +0200
Message-ID: <20260924112127.3815255-21-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260924112127.3815255-13-cassel@kernel.org>
References: <20260924112127.3815255-13-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3223; i=cassel@kernel.org; h=from:subject; bh=Lw/lnT3UffRNJqnKPnXIJjq3ezl9TcMYqjsJZexWcIw=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLK2su+ZManO0KTgcPrt7BOq8Wy7T/m/XqE4qeC+q3Tcv DipWLuzHaUsDGJcDLJiiiy+P1z2F3e7TzmueMcGZg4rE8gQBi5OAZhIxWSG/y4vfGZI+yxq+x7L YzaXa/3/i9xSy551tKvm/Nh3c9MtQ05Ghl1PzF13HfubxpnRxFWfeni3jExsTqdo1kLh/B9rT8Z vYAEA
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

resp_write_dt0() and resp_write_scat() advance the write pointer of a
sequential write required zone by the transfer length of the command
without looking at what do_device_access() returned, which is -1 when
the data direction of the command does not match the operation, and a
short byte count when the data-out buffer is smaller than the transfer
length. An initiator can produce both with SG_IO.

The zone then describes more data than is on the medium, and a write at
the position where the data really ends is terminated with UNALIGNED
WRITE COMMAND, so the zone has to be reset before it can be written to
again.

Advance the write pointer over the data that was written instead. As
do_device_access() does not write a partial physical block to such a
zone, that leaves the write pointer where a write can end.

Assisted-by: LLM
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Fixes: f0d1cf9378bd ("scsi: scsi_debug: Add ZBC zone commands")
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
Tested with:

  modprobe scsi_debug zbc=managed sector_size=512 physblk_exp=3 \
      zone_size_mb=8 dev_size_mb=128 zone_nr_conv=2

issuing WRITE(16) through SG_IO with a data-out buffer shorter than the
transfer length of the command. A sixteen block write with a buffer of
twelve blocks leaves the write pointer of an empty sequential write
required zone eight blocks on, which is where the data it wrote ends,
and a following eight block write continues from there. An eight block
write with a buffer of one block writes nothing and leaves the write
pointer where it was.

Before this patch both advanced the write pointer by the full transfer
length, and a write at the end of the data that had actually been
written was then terminated with UNALIGNED WRITE COMMAND.
---
 drivers/scsi/scsi_debug.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 0171dab59865..af1b27b48867 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5179,9 +5179,9 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	if (unlikely(lbp))
 		map_region(sip, lba, num);
 
-	/* If ZBC zone then bump its write pointer */
-	if (sdebug_dev_is_zoned(devip))
-		zbc_inc_wp(devip, lba, num);
+	/* If ZBC zone then bump its write pointer over the data written */
+	if (sdebug_dev_is_zoned(devip) && ret > 0)
+		zbc_inc_wp(devip, lba, ret >> ilog2(sdebug_sector_size));
 	if (meta_data_locked)
 		sdeb_meta_write_unlock(sip);
 
@@ -5345,9 +5345,10 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 		 * writes behaviour as possible.
 		 */
 		ret = do_device_access(sip, scp, sg_off, lba, num, group, true, true);
-		/* If ZBC zone then bump its write pointer */
-		if (sdebug_dev_is_zoned(devip))
-			zbc_inc_wp(devip, lba, num);
+		/* If ZBC zone then bump its write pointer over the data written */
+		if (sdebug_dev_is_zoned(devip) && ret > 0)
+			zbc_inc_wp(devip, lba,
+				   ret >> ilog2(sdebug_sector_size));
 		if (unlikely(scsi_debug_lbp()))
 			map_region(sip, lba, num);
 		if (unlikely(-1 == ret)) {
-- 
2.55.0

