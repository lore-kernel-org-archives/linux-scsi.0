Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF224B5CD0
	for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2026 15:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790005287; cv=none; b=jDofIq1s4cHz4xdVxrkEBtQKY+7cNm4njhfpvErFHlgwa8DG7UuJU0lWbP6IFBIrQ643ekruqmTzmC+a/8F0qME8O8uZsZ+xGGCzCd0qBGCMksgQIL8524HqTYUWjuMnx/2JVSe4gzm7aFD8lOF4l3Qc//zR5feq0ccIoUePZBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790005287; c=relaxed/simple;
	bh=fcYuPGUVyjI1AgbeevCPWQGfY6dkLEKnDXjGpAChGtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aqDowShyIlGLQnLayWn9OWN2/APrAd3CmjROV3R3dQrYE7XMpRMA6Yi1GwohtrApggeluuIpVNTCeKRtVekagR4vuWWOE9JyTCQi/JwaQrXPibZYCKECiUXOUn1qgayUNY//yBpw8TJ9Q3VGF/cfYUNSMG93Alvj6D1oJLpKuG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RBCi7azd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RBCi7azd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B45131F00893;
	Mon, 21 Sep 2026 15:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790005285;
	bh=67KlLfqzIZuhM2qwlRKBHA2duhtkiON8JeLD/f3LGvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RBCi7azdKIJ40VL2f73r7RXqCXoUpTwlG1lnhfTEVU8Zo0e+J79J0QdxXaoSqiGC0
	 In5QNgU2b+kreX5IPtEEcqMURW4CNJXmjsSQue38oKvVxaJoOYTZ3qFfHjvIERrDjW
	 14AzD+V6tsi7wX1NbcNBL3Z1sf1o2wfDnS7hVNhma+8qy9kLPnYJsBiq/t/+GvE+1r
	 if4XiU2QHnOpI+GenJvd/dgp8u5bZTH3uiKAqnu+e+CM6ULnQz3+KUCX6Gponignls
	 H/a7CWJeYSga6cdYCv/ZdjkBbBsTL3Zp5O4i9w9/jDZPqGVzO2bBpQCPiFk2XTR+7v
	 V4TKfL4nsRVmA==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v5 10/10] scsi: scsi_debug: Validate the access parameters of WRITE ATOMIC (16)
Date: Mon, 21 Sep 2026 17:40:26 +0200
Message-ID: <20260921154015.2971990-22-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260921154015.2971990-12-cassel@kernel.org>
References: <20260921154015.2971990-12-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2022; i=cassel@kernel.org; h=from:subject; bh=fcYuPGUVyjI1AgbeevCPWQGfY6dkLEKnDXjGpAChGtk=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLI2+j/3dTxzcI/GhDWPVokecN0076nurNjfzKEnzu40z LnuuuXx945SFgYxLgZZMUUW3x8u+4u73accV7xjAzOHlQlkCAMXpwBMpKWWkWH/smVLbAXepjZW TxHTXvZ9zqRjmzZ65a/hFm/efz2MV8WQkWE914ZfqoI7z/Qv17OsjL7RoFg3p49pW+WE4rOlD4r VHzABAA==
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

resp_atomic_write() validates the fields that are specific to an atomic
write, the alignment and granularity of the transfer, the atomic
boundary and the maximum transfer length, but it never validates the
range that the command addresses. Every other command that writes user
data calls check_device_access_params() first, which rejects a transfer
that ends beyond the capacity of the device, one whose length exceeds
the size of the store, and any write to a write protected device.

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
index 2e1a02c383a3..4f4d8f9f19c4 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6247,6 +6247,10 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
 		}
 	}
 
+	ret = check_device_access_params(scp, lba, len, true);
+	if (ret)
+		return ret;
+
 	if (lbp)
 		sdeb_meta_write_lock(sip);
 
-- 
2.55.0

