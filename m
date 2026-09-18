Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35AC245198C
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 06:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789712974; cv=none; b=dRogO1p5e0Cp7XnjrJS7cz1PmpphwGvmYG9tXBLGuqQWhP1dewCntREltd6luGfhivGB1kX1P4TWywkxwOmmCQomacP9i//PJUiR44ydb+GJVY8n0LtCVBRNGWh9VwWluJ6uGoieee+yEl0RMXI/6l/M2JoE5aByxT3gpOdTi0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789712974; c=relaxed/simple;
	bh=XBGppDs3ydwa9jmhHKvjbpmMbEP/jZxZzh4Jyy3yKQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DW25pOOrNvLKgvXMZN/bAPOIPZK+uEj1cv8MCkSuShQAJNa81C+u2wY0QIGkJspDWlV2qBe3teiqXrH9oz+l2AOHefV72DKNbVopAg+TY2cctcmm/Qz+tYbR//eZuEGGBUS1SXzyZhIHEUXwzLl0r5Qz0tDCwjFrodaDV0izxPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YQGf5gHd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YQGf5gHd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 568A41F000FF;
	Fri, 18 Sep 2026 06:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789712972;
	bh=11Lw62EwrWbMy0FnH54l5DJ8+egkHiTEh93j011BvwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YQGf5gHdXnzLpOy2VZ8Z/aarvKtqEbRKY3dq2FQoqnzuRH9oJlUT2yAm4AQeM7Uy3
	 z6Wnwm+et8ZWgPeWJiNEoHf9e6dXdqu4xtiV/cNcjLFDQNVaDCvXWXxIzwYPYybrAV
	 pO9Bs3bkNewLI5coxKmvZztc4naKXJIgjMDLIgq+OP7mGXR7Kl5aMg9vK8MF3+kCw6
	 9gBKGe5xvrbqGnR6RDHhXCPp0tnwuJ68Un5hw2Lvbo4UYEtz2wpttWDf8i9LcCdc07
	 bOJTXwi+Wq93hqloWshMWwSvztsSGFjVz06/HCUVtZu5c2E1u3+dXa/as3rSYwy571
	 APCSHqZbKVF8g==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v4 01/10] scsi: scsi_debug: Refuse a zoned device with a non-zero lowest aligned LBA
Date: Fri, 18 Sep 2026 08:29:12 +0200
Message-ID: <20260918062910.1709791-13-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260918062910.1709791-12-cassel@kernel.org>
References: <20260918062910.1709791-12-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2131; i=cassel@kernel.org; h=from:subject; bh=XBGppDs3ydwa9jmhHKvjbpmMbEP/jZxZzh4Jyy3yKQ4=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLLW3LJjsrrDvi1itVHMzkevlULa/7WyTN0he3RJoo7ry dYsB8uvHaUsDGJcDLJiiiy+P1z2F3e7TzmueMcGZg4rE8gQBi5OAZiITBbD/6S6V69r3bxft7Zx JNR4JrNIr83Oir3dpLfQ7p0jQ9L3/wx/uKPs3uSJhTNoWgq+u/W3KOLllJMzLPwfzfoZ4XhqseR yZgA=
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

The LOWEST ALIGNED LOGICAL BLOCK ADDRESS field indicates the LBA of the
first logical block that is located at the beginning of a physical
block, see SBC-6 r02 (T10/BSR INCITS 587), 5.20.2. scsi_debug reports
the lowest_aligned module parameter in that field of the READ CAPACITY
(16) parameter data, but nothing else in the driver acts on it: the data
it stores begins at LBA 0 and has no physical block structure behind it.

That does not matter for a device that is not zoned, where a write need
not end on a physical block boundary at all. It does matter for a zoned
device: ZBC requires a write to a sequential write required zone to end
on a physical block boundary, and a zone begins at a multiple of the
zone size, so a non-zero lowest aligned LBA puts the beginning of every
zone in the middle of a physical block. A host that writes in units of
the zone write granularity that it was given can then never satisfy the
requirement, and such a zone cannot be written at all.

Refuse the combination rather than emulate a device that cannot be used.

Assisted-by: LLM
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
Tested by loading the module with each combination:

  zbc=managed lowest_aligned=8    refused, -EINVAL
  zbc=aware   lowest_aligned=8    refused, -EINVAL
  zbc=managed lowest_aligned=0    loads
  lowest_aligned=8                loads, as the device is not zoned
---
 drivers/scsi/scsi_debug.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 6941809dfdb7..c664966e95cb 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -8734,6 +8734,11 @@ static int __init scsi_debug_init(void)
 			sdebug_dev_size_mb = DEF_ZBC_DEV_SIZE_MB;
 	}
 
+	if (sdeb_zbc_in_use && sdebug_lowest_aligned) {
+		pr_err("lowest_aligned is not supported by a zoned device\n");
+		return -EINVAL;
+	}
+
 	if (sdebug_dev_size_mb == DEF_DEV_SIZE_PRE_INIT)
 		sdebug_dev_size_mb = DEF_DEV_SIZE_MB;
 	if (sdebug_dev_size_mb < 1)

base-commit: c3cff7fac01638ab58e85fe7df41a04fa25c5bae
-- 
2.55.0

