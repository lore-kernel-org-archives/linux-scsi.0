Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F6A944238A
	for <linux-scsi@vger.kernel.org>; Thu, 24 Sep 2026 11:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790248921; cv=none; b=VZVp4DoUYCzNbCA45ZUdkv3QANQyf4Ug6tvDjQiee9vfUzbiRlypWcT7u5EvUwOWLOpdSaEQvYS1Xl1SSv7tnLRuxw1T0IqHJK6PoRzsw2L2n73khaQ9z/1JQsyU8tbv4Dzdgno9ovppwD9LxNkeA5doO9Y6/lUKBzLsFFUbhjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790248921; c=relaxed/simple;
	bh=DTINgXj5wB7sllZYiHCh6ie6yA6mbt59qH5CuR+eshA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hIb0VYHN0wUlhUCJYRoUozBa7cvmSV8is6Nj+UMjoTtrKh5SXDtObm2/dVTpj9Oq9khgZGuIBZxlvQW9/m+Sz+xfEoqD8/PzKJOJ3872XgIwJu8hEtsflNi6DCvxnMVwd550HzlwuP0P12x9GRr11BdEMMd84ZqkBVkJoQ7cMyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JoYsfHNC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JoYsfHNC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2D161F000FF;
	Thu, 24 Sep 2026 11:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790248920;
	bh=MzFjN0KYc875+7nQg+OxNBzUdyBEPqPNCw/CWVJcFhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JoYsfHNCwFHeHH9lOCsNojTldMxGIt3zhN+wZ8YZVSoiz8fmiVLe/VqFLVf16HNsb
	 uX0aCdepE12m19c+jN442xyAu3YDdtTMwkaAfH+fCPD3f2YaTeUgL87Cpbt30rENHH
	 i9npJB1XsgvSJb9ALF3hamb1asSPnTm6rq2jbhEApWJJM7FEKvbHfJo6mZrDboGXUw
	 0BaNxr8OcKyzUmlfTZ92ADB+lxyQc/HVGcbxtMo8leNy29we+ebEXPvZZc5hxbxRJP
	 lDSjcdcJbzH1LaiWY8P/OEZ8qk9P26CFxOzGE/PA9WFWJ9puK+NUPXwkvUy3A89BQ9
	 CTLtaBaodV4ug==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v6 11/11] scsi: scsi_debug: Validate the access parameters of WRITE ATOMIC (16)
Date: Thu, 24 Sep 2026 13:21:39 +0200
Message-ID: <20260924112127.3815255-24-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260924112127.3815255-13-cassel@kernel.org>
References: <20260924112127.3815255-13-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2012; i=cassel@kernel.org; h=from:subject; bh=DTINgXj5wB7sllZYiHCh6ie6yA6mbt59qH5CuR+eshA=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLK2su859mf595Bp+jzuHy3rX+Z3bbRQaneSOfAoJ6wv8 9eRniztjlIWBjEuBlkxRRbfHy77i7vdpxxXvGMDM4eVCWQIAxenAExkdQIjQ1e4poDq7Neupky7 Pl0QC/jP2f/7zwLmrpbOzIte8/aqiTP8U9+wKYc1Vq+qt+6seh23id3Zn0tmLOa4z5Vv8twgM30 fDwA=
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
index cbe21ac06044..c2c1a5318b79 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6243,6 +6243,10 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
 		}
 	}
 
+	ret = check_device_access_params(scp, lba, len, true);
+	if (ret)
+		return ret;
+
 	/* A failed atomic write must not have written any of its data */
 	if (scsi_bufflen(scp) < len * sdebug_sector_size)
 		return DID_ERROR << 16;
-- 
2.55.0

