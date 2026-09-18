Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30DD8489FC9
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 06:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789712978; cv=none; b=gwuwYdcnxD8DQ1k6OvyeMhYN1M30yk+cbC9ATG9/Qystx89UIzV73ocM494UxeqbGBZtTaUS4UotMHvNMUzrqTw76wdl8YGx25L9dKjPW41O98q7lhNwYmyyQ0uRURFHTrK90K4hnZ69wv0u1VbrNwh7EjSB1DvRXK7AXxBWRZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789712978; c=relaxed/simple;
	bh=Cy4VVr43w9tUJMCCsSofUP0EKffH8lisFpy81tlFfdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HuVTw0EkhQLfPWNe0XEFyy5/SkQR2WTBNS8+HsWiB9Zab7DqqhnIGDn08IEI1V8WGLIV7UO/TrApCoJHbtSRRIbwwLFnqqOvE3o9LdyeQBV2xUjbzHvA/JBVBvits6thWnQbotwlCEItzFy0sJvgS9Nl7TytOxO/nr9d9RxCxb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FdMXoOsQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FdMXoOsQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E7081F000FF;
	Fri, 18 Sep 2026 06:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789712976;
	bh=+ibOEh3fRuY/Hb0PKlmEJlPzLwk7PnoJWDX7RuFpaXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FdMXoOsQVHA9buLx5Y7P/ggfekfIvUoeEJMRJyw12+4uhcPV765FL/YfAzk+eRBdj
	 H7Ke34NMqSqmJ+RCarDKOav01TL2TGOf/6mx9P8vsHfuhQP8r2VcAHEmCWO2jjqoAh
	 3KI01J+2DyCMXciM+rBkeonQmQKpCOs/W9R0qH/kvoywfM70QULXDr6j4V4eU4c1ZE
	 e3nzaqr+nUz1ajntRKZGE6czRmSdGZHNOCSKBTNqDE/g/UHn/l53r5gYcfu+9Tdsp7
	 pWbTCwd4nk0Dq2WkcyheqF9he914Tk93ty1QzIvrQ1OIjhTY0hTPaynoem8r9NkAJn
	 ikArHKGgHZW+A==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v4 03/10] scsi: scsi_debug: Take the zone metadata lock before the data lock
Date: Fri, 18 Sep 2026 08:29:14 +0200
Message-ID: <20260918062910.1709791-15-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260918062910.1709791-12-cassel@kernel.org>
References: <20260918062910.1709791-12-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2564; i=cassel@kernel.org; h=from:subject; bh=Cy4VVr43w9tUJMCCsSofUP0EKffH8lisFpy81tlFfdA=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLLW3LILqWE9dC/zwNtDJw+aP9yw0W6h4tQLJctDpy4/9 JXV7p7jrI5SFgYxLgZZMUUW3x8u+4u73accV7xjAzOHlQlkCAMXpwBMJFKMkeFl5Tc2hsvXXt2e Ob/P5rXwVe2zU3f+WfxS/HXxrrTF5qn3Gf6Ki9y5ddD8aduk5eu0dDdkpYsFTT/wj99GZ/m5Ta/ SxPPZAQ==
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

resp_comp_write() takes the data lock and then the zone metadata lock.
Every other command that takes both takes them the other way round:
resp_write_dt0(), resp_write_scat(), resp_write_same() and
resp_write_tape() take the metadata lock and then call
do_device_access(), which takes the data lock.

Two commands that take the same two locks in opposite orders can
deadlock against each other, so a COMPARE AND WRITE and any other write
to the same store can hang one another.

Take the locks in the same order as everywhere else, and release them in
the reverse of that order.

Correct the comment above map_region() while here. The provisioning map
is covered by the metadata lock rather than by the data lock, which is
why resp_unmap() takes only the metadata lock while unmap_region()
clears map bits.

Assisted-by: LLM
Fixes: 84f3a3c01d70 ("scsi: scsi_debug: Atomic write support")
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
Tested with:

  modprobe scsi_debug sector_size=512 dev_size_mb=128 lbpu=1 lbpws=1

COMPARE AND WRITE completes, and a READ(16) of the block that it wrote
returns, so the reordered locks are still taken and released correctly.

The deadlock itself was not reproduced. This kernel is built without
lockdep, and the window needs a COMPARE AND WRITE and another write to
the same store to interleave between the two acquisitions. Found by
review.
---
 drivers/scsi/scsi_debug.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 8e45a57ae406..18aefe83b7b6 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5575,8 +5575,8 @@ static int resp_comp_write(struct scsi_cmnd *scp,
 			    "indicated=%u, IO sent=%d bytes\n", my_name,
 			    dnum * lb_size, ret);
 
-	sdeb_data_write_lock(sip);
 	sdeb_meta_write_lock(sip);
+	sdeb_data_write_lock(sip);
 	if (!comp_write_worker(sip, lba, num, arr, false)) {
 		mk_sense_buffer(scp, MISCOMPARE,
 				MISCOMPARE_DURING_VERIFY_OPERATION);
@@ -5584,12 +5584,12 @@ static int resp_comp_write(struct scsi_cmnd *scp,
 		goto cleanup_unlock;
 	}
 
-	/* Cover sip->map_storep (which map_region()) sets with data lock */
+	/* Cover sip->map_storep (which map_region() sets) with the meta lock */
 	if (scsi_debug_lbp())
 		map_region(sip, lba, num);
 cleanup_unlock:
-	sdeb_meta_write_unlock(sip);
 	sdeb_data_write_unlock(sip);
+	sdeb_meta_write_unlock(sip);
 cleanup_free:
 	kfree(arr);
 	return retval;
-- 
2.55.0

