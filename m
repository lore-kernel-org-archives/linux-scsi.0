Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 738691DDC38
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 07:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790320678; cv=none; b=cdwy4rWqsCqI3qoCmhmF6R+57Ai/inx9s890b9ygakDbaararatLhTOZOJji19zPq0VAuKPKhsXt+6jG4RBTApN2wIC1vg4qv/4syVGUAaS1CRxRAK1MJv+Oloy31bVWvr5D5a6ydgpeK0g2tzYfG3IldjrcluHr1Ak2ZcLlVZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790320678; c=relaxed/simple;
	bh=hDyKn5H668n2DAtJiID4JzeUA3BzqwW+7cjoRgDqSnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hJrAdM4/CZrJCV5XhNPFz2l8ApR17NJo1nAtNuC+zyY4k53VbmKFORfjh+Q3ktmY4UL/R3ljBRfntqle70znHrQlvnLxUZwe687XiShKj0+Eog/B7Wh3hrm5Tu61UHwJAEsKpIyarmhPimj26j7V6VRRJ6PLewGrsyBtL0ZSN8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZY/kYbXG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZY/kYbXG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9504B1F000FF;
	Fri, 25 Sep 2026 07:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790320677;
	bh=YEu3MsMHPBwd43wYfqrxHIrNOIlCMbdMTVVz25qgbhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZY/kYbXGRH7bFRo67Al0X+fLhfAggAfAo7xKx3WgmX8qvueMMIY57ypCLDhswm0sb
	 q9qcLIUvCeWbrTnt70zHLoScmv0EKwO5GONO7ZtfB8GWbQA9lx6972/9Aqw9Sq9W6Y
	 vZokNDRi4Ni2Y3j4syjBnxhA3LyU0YjmH3a/ddRXIagnAV921QmwU2ZAENBYYi2EtI
	 ZMcCXtgK1gAStrdfRm4/MsCyHWeu2SHsk8ZKhJakEXufGCD/WgrF2uibX2AeIUiXhO
	 zXBvk5ODj/3FyEjWpZw0+U+q3YtSWkgfj7+EXaDEiOSRNP1/5I5+5QU36KxX4z9xC7
	 R3X/w3elHndiw==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v7 06/11] scsi: scsi_debug: Enforce physical block alignment of zoned writes
Date: Fri, 25 Sep 2026 09:17:33 +0200
Message-ID: <20260925071726.140915-19-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260925071726.140915-13-cassel@kernel.org>
References: <20260925071726.140915-13-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2828; i=cassel@kernel.org; h=from:subject; bh=hDyKn5H668n2DAtJiID4JzeUA3BzqwW+7cjoRgDqSnU=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLK2KQj1ea9sUuNSPXns+gNNwZrF7zXkVrMufsm0/eKfY +ruDS4mHaUsDGJcDLJiiiy+P1z2F3e7TzmueMcGZg4rE8gQBi5OAZiIfh0jw9LDc+2ln0g4L/R9 ve9AXPqnnBiPb4XnLp1n5/uVMH1ObRbDP5uZ0h4JN/+yP7J33vT77s58vQUzW2W5+e/X3bLI09o VzQYA
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

ZBC-3 r06 (T10/BSR INCITS 579), 4.5.3.3.2, requires a write to a
sequential write required zone to be terminated with ILLEGAL REQUEST /
UNALIGNED WRITE COMMAND both when it does not start at the write pointer
and when it does not end on a physical block boundary. That is why
sd_zbc_read_zones() sets the zone_write_granularity queue limit to the
physical block size of a host-managed device.

check_zbc_access_params() implements the first condition but not the
second. So with zbc=managed sector_size=512 physblk_exp=3, a write of a
single logical block at the write pointer is accepted and advances the
write pointer by one logical block, leaving it off the granularity that
was advertised: nothing can write at it any more, and the zone can only
be used again after being reset.

Check the ending LBA as well, with the same sense data, as the standard
gives both conditions the same. An entire medium write same command,
which the standard excludes, needs no special case: the preceding check
already terminates it with WRITE BOUNDARY VIOLATION. Sequential write
preferred zones are left alone, as writes to them need not be
sequential, and with the default physblk_exp=0 the check is a no-op.

Assisted-by: LLM
Fixes: f0d1cf9378bd ("scsi: scsi_debug: Add ZBC zone commands")
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
Tested with:

  modprobe scsi_debug zbc=managed sector_size=512 physblk_exp=3 \
      zone_size_mb=8 dev_size_mb=128 zone_nr_conv=2

Before this patch, a one logical block WRITE(16) at the write pointer of
an empty sequential write required zone completes with GOOD status and
leaves the write pointer at LBA 0x18001, which is not a multiple of the
4096 byte zone_write_granularity reported for the device. After it, the
same command is terminated with ILLEGAL REQUEST / UNALIGNED WRITE
COMMAND and the zone is left EMPTY, while an aligned eight block write
is still accepted.
---
 drivers/scsi/scsi_debug.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 9220758bb801..3ed599a606ba 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -3980,6 +3980,16 @@ static int check_zbc_access_params(struct scsi_cmnd *scp,
 					UNALIGNED_WRITE_COMMAND);
 			return check_condition_result;
 		}
+		/*
+		 * Writes must end on a physical block boundary, that is, the
+		 * transfer length must be a multiple of the physical block
+		 * size.
+		 */
+		if (!IS_ALIGNED(lba + num, 1U << sdebug_physblk_exp)) {
+			mk_sense_buffer(scp, ILLEGAL_REQUEST,
+					UNALIGNED_WRITE_COMMAND);
+			return check_condition_result;
+		}
 	}
 
 	/* Handle implicit open of closed and empty zones */
-- 
2.55.0

