Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2260C1DDC38
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 07:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790320688; cv=none; b=lSxTLZtxooPohhRmmIAdj0pzT45IOMleKWFh2w3zMwEFkTzIy96kD2LCFv1CFw40eyYJ+WU1+sag2Nj46DH9d2QbIUHj8/t5Zucqi95roNz0wmpiGDKNwdp+syNmCT5Oel3PUSRhtCBV71HmfF/B00F+iktFPKz5zZl+YGVMmwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790320688; c=relaxed/simple;
	bh=MEEhwHbq3+Jd5g4BBgXtG9sTnwASn55RVEBTlVyDef8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DndTk6FLbDMB5FMC0YVBLavnhiOswodqzmjux9W8dND2vUun8d2xtC0Mfh35jdjr3btTi1I0mKQxIGUxXqae8N1rG183kXv88HjgaDFlHpLzlT2agiL7PtFkuOiOsDme52DErqATtj54kMgjYOsa5jXy3gugolxIoPAm2h0zShw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jxv4Jq8t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jxv4Jq8t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 589FC1F00893;
	Fri, 25 Sep 2026 07:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790320686;
	bh=KMK/xNkmdGTGYi2Y9NUshnTQFNsFcGJXRrWMoqoJYM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jxv4Jq8tOenWxKCXTDHJDohEEkQ8SDgwzt8/iRbA6a5smK/BgmNzgfI1tlqi4qTix
	 I0mjijvAUvgIUg1uv2x0jXpdgjEj7ckhwfhntQmSt6gUtycmV6P5oP6aj3ojFXleHP
	 PDreXZi0Y9WATJVyrCiPpC0V810DApyAcxd5u4aRJFwbVs6BHkvoyB5R4KuJ2TMSSn
	 dTk97cgnSzpfSkqA36+BfC55bE8h78QIblHG9u9Z/Ab0gNKxfk0xUSd3QlLb2UzBVf
	 YRce61bKCSe93IIWR/W51xuRsH/LaM+R81SYYesMEnFghNds6Pt8SjcKhVUP/a9u8e
	 TYOARkZewTC8Q==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v7 11/11] scsi: scsi_debug: Validate the access parameters of WRITE ATOMIC (16)
Date: Fri, 25 Sep 2026 09:17:38 +0200
Message-ID: <20260925071726.140915-24-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260925071726.140915-13-cassel@kernel.org>
References: <20260925071726.140915-13-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1989; i=cassel@kernel.org; h=from:subject; bh=MEEhwHbq3+Jd5g4BBgXtG9sTnwASn55RVEBTlVyDef8=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLK2KQjX/d1pd1r2U5aR68MVllNtym0/B+1UVSz5waObp N1rt25aRykLgxgXg6yYIovvD5f9xd3uU44r3rGBmcPKBDKEgYtTACZyaTojw1nXC7cFD+sZvb84 s0zdL024+cWuKSVLmt826H89teSd0U9Ghkm3e90OMnxdNW/F/a2CXczR+V+bb65TXHohZrUH48Y rfuwA
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

resp_atomic_write() validates the fields that are specific to an atomic
write, but never the range that the command addresses. Every other
command that writes user data calls check_device_access_params() first,
which rejects a transfer that ends beyond the capacity of the device,
one whose length exceeds the size of the store, and any write to a write
protected device.

Call check_device_access_params(). The zone checks that it ends with are
unreachable, as atomic writes and ZBC emulation are mutually exclusive.

Assisted-by: LLM
Fixes: 84f3a3c01d70 ("scsi: scsi_debug: Atomic write support")
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: John Garry <john.garry@linux.dev>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
Tested with:

  modprobe scsi_debug sector_size=512 physblk_exp=3 dev_size_mb=128 \
      atomic_wr=1

The device has a capacity of 262144 logical blocks. A WRITE ATOMIC (16)
of eight blocks at LBA 262140 is now terminated with ILLEGAL REQUEST /
LOGICAL BLOCK ADDRESS OUT OF RANGE; before this patch it completed with
GOOD status, having written eight blocks at LBA 0 instead.

With the wp module parameter set to 1, a WRITE ATOMIC (16) is now
terminated with DATA PROTECT / LOGICAL UNIT SOFTWARE WRITE PROTECTED,
which is what an ordinary WRITE(16) has always returned; before this
patch it completed with GOOD status and wrote the data.
---
 drivers/scsi/scsi_debug.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index c407f4c5ac47..c4ed9ebb930c 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6248,6 +6248,10 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
 		}
 	}
 
+	ret = check_device_access_params(scp, lba, len, true);
+	if (ret)
+		return ret;
+
 	/* Short atomic writes are not allowed. */
 	if (scsi_bufflen(scp) < len * sdebug_sector_size)
 		return DID_ERROR << 16;
-- 
2.55.0

