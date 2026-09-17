Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A314D596D
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 11:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789643037; cv=none; b=GVjEIG/h929CZkKLHUOhs6iBb0DRAmJ9yQjCw3u1Kbw/rad/ZUOkw76ClWE+Mir8addqro9kJX4sJokFnYUDEhJkweNxJkajKUsE7h2ZG3u+xJoDPX4AAX+fPi/ITg/U3xHOn6P0hXpGETe5qIGUF0HKWVEDZkxf3jESOTnAft8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789643037; c=relaxed/simple;
	bh=5IaUV2lWnKrviNUvjPsP666+dNsvjpNeBaPusln/JaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MayTjaFyIatJ1/t1lVT/222WUEbQjaH6t+MNdfPOBfvTotR6CJPgngu6GHHrLFRBtqXShLgJ/Oj91lYtR2WfygW6FuEwG46tzdjkffAFBkDdhGUrOE+B8D10mQ3fRkHaZDT64V47J7Qo5+SzFyJEiHIbkfPhwa40XZKYwQ7eask=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l9b1zxEn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l9b1zxEn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5CFF1F000FF;
	Thu, 17 Sep 2026 11:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789643026;
	bh=MCNHqpWrDRF4tlfdGHKk0Wa3/EwAv4y7SKbFYEA7LMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l9b1zxEnbqnVNb/KyA/XRGE9PkCGP/1GHNJWGdAyzVgsVrguOxE/p5J1Zlh8rIBLN
	 ZX7exdzXITEAXEju3Ub9JEzklll+YpR4AZV0Yx0y1urtIYVQ6mSn4yFelaxnDBXh5J
	 BFV/ToUx/zanRHNNTRPviW2FrPCslzVNcvU6DdKuPlnD8yhZMoMTBmlIfRYXjkHt98
	 Du1NaNdJgjbzcP3TPJr240AVDgCqUCDptdiE3EdS9iyj9jZ1isj7geSQEJH4QCIe9N
	 N87McNOyddlIv6nBbB+B7Lva5qyoBPh+jgvmuPBMON/309WGmJAihyDygfXxQN5fmY
	 zk4uds35zJiQQ==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v2 3/4] scsi: scsi_debug: Map the region written by WRITE ATOMIC (16)
Date: Thu, 17 Sep 2026 13:03:20 +0200
Message-ID: <20260917110316.1104863-9-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917110316.1104863-6-cassel@kernel.org>
References: <20260917110316.1104863-6-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1687; i=cassel@kernel.org; h=from:subject; bh=5IaUV2lWnKrviNUvjPsP666+dNsvjpNeBaPusln/JaY=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLJWn/gx86yece+qUNaM16b+d8TvPp8TsdTKR7NQoO2DJ tPash0rOkpZGMS4GGTFFFl8f7jsL+52n3Jc8Y4NzBxWJpAhDFycAjCRMFOGf4a5+1kFTPmXSXqe +Ljt/tdLZ7kF482ENX6t37rz20EnCVaGv6INTUXbtfRi521QFH144dusnskPE9xn5vzffu9MTmb kQU4A
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

When logical block provisioning is enabled, a command that writes user
data marks the region that it wrote in the provisioning map, so that
GET LBA STATUS reports the region as mapped. resp_write_dt0(),
resp_write_scat() and resp_write_same() all call map_region() for that.

resp_atomic_write() does not, so a WRITE ATOMIC (16) leaves the
provisioning map untouched, and GET LBA STATUS keeps reporting the
region as deallocated after it has been written. map_state(), which
GET LBA STATUS uses, is the only reader of the map, so that is the whole
of the effect.

Call map_region() the way resp_write_dt0() does.

Assisted-by: LLM
Fixes: 84f3a3c01d70 ("scsi: scsi_debug: Atomic write support")
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
Tested with lbpu=1 added to the configuration used for the rest of the
series. GET LBA STATUS reports a region that has never been written as
deallocated, and reports eight blocks as mapped after either an ordinary
WRITE(16) or a WRITE ATOMIC(16) of eight blocks at the same LBA. Only
the WRITE(16) case did so before this patch.
---
 drivers/scsi/scsi_debug.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index ddcc7a920089..5a08f02130ef 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6213,6 +6213,9 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
 	}
 
 	ret = do_device_access(sip, scp, 0, lba, len, 0, true, true);
+	if (unlikely(scsi_debug_lbp()))
+		map_region(sip, lba, len);
+
 	if (unlikely(ret == -1))
 		return DID_ERROR << 16;
 	if (unlikely(ret != len * sdebug_sector_size))
-- 
2.55.0

