Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1283812DA
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 12:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789649751; cv=none; b=iTqHgRKtzUO75+lkW40t/9mC7L/Wf8Se3S3M/zdiY2sinyG0rSLMDWl8AmINcvLbMuRIcPsO1Jo4KPDGFjiQwQ3eseT6sgVGjzrk5XoZh18rAIcASCZ4uO+ZBSioAV7gSK17GmZhNOhdMMjxEbu6/gPQMsjwnXYyib0Ivy4zIaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789649751; c=relaxed/simple;
	bh=JcZTqBRVPB1NnDNIXXZOjcHyGtcbVJMaCOWIisS1u3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cze2ytqo8OUs4nOz9X5y1steHmkOb3dCQ685GLfa/jYrTkCbhDp8M7TUiHvTW2MQ6t0gabULR4R0b/Aw/545SaH0xkmXgT+ZqpJCl7XkPwZ4qI01cJ3sAd2BQWSwsOW7yzltXlxzuN1RuuIOz7lclC85IOqT0W5UK0ErIxC2hMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZXvKfcfO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZXvKfcfO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C373E1F000FF;
	Thu, 17 Sep 2026 12:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789649745;
	bh=asulv6oCOvr7XYF3aUr2C4fMui2THAxgYDAeUIKJvZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZXvKfcfOkzI5cIeVJ4fg3JqPbwnvLuapBeZbt3ossCpVO+PggUn2o0gA/iQEjFUug
	 KqgbjaIAQ48uQ5cj9vzDcC7fTQ+oRcXQSrz65DmauPJmU4UAspg3qPPVcMtW3itqx3
	 eRVFI7iXdPEnfmHAu6n6hbKzLq3sAKsm3Pdtr+JPe0hGeYfH4WH4cDAKkr6nokBoJa
	 fJ7YKAuPaQCSxLfXfnmGiLoPyHtXqGBSw906hjsHQvYCN+Ole5JIix2ZEIXFvNZjOs
	 DHpK6mTj7tQgj71n/ukcxFDYTkzBvFNwClsIpVSUbEZLprFcvBhzYP+mGIQ9P20NoK
	 tdnA5syfvk+9Q==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v3 1/6] scsi: scsi_debug: Report the residual of a write
Date: Thu, 17 Sep 2026 14:54:47 +0200
Message-ID: <20260917125445.1376493-9-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917125445.1376493-8-cassel@kernel.org>
References: <20260917125445.1376493-8-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2441; i=cassel@kernel.org; h=from:subject; bh=JcZTqBRVPB1NnDNIXXZOjcHyGtcbVJMaCOWIisS1u3g=; b=kA0DAAoWyWQxo5nGTXIByyZiAGqr4xqgztJ4OAnlqzU3bfwuRVYFusvoXk2kXNDZz7aY8SAXx oh1BAAWCgAdFiEETfhEv3OLR5THIdw8yWQxo5nGTXIFAmqr4xoACgkQyWQxo5nGTXKUXgD+P9ht joXE0+MgmX7jj4lG0zgZhg+pVS4kbKjvaXsGA3EBAOi1OPhcpybmfeFg4bSs34WY8qRU25AxSad afjZPT8MM
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

A command transfers the number of logical blocks that it asks for,
bounded by the data buffer that the initiator provided. When the buffer
is larger than that, the bytes beyond are not transferred, and the
difference is a residual that the initiator is entitled to be told
about.

resp_read_dt0() reports it, as does resp_write_tape(), but the write
paths for a disk do not: scsi_get_resid() keeps the zero that
scsi_debug_queuecommand() initialised it with, so a write with an
oversized buffer completes with GOOD status and a residual of zero, as
though the whole buffer had been consumed. A READ of the same length
into the same buffer reports the residual correctly, so the two
directions disagree.

Report it in resp_write_dt0(), resp_write_scat() and
resp_atomic_write().

resp_write_scat() needs a different expression from the other two. Its
data-out buffer holds the parameter list header and the LBA range
descriptors as well as the data, and sg_off walks over all of it, from
the offset at which the data begins to the end of the last range that
was written, so what the command consumed is sg_off and not the number
of bytes that the last range transferred.

Assisted-by: LLM
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
 drivers/scsi/scsi_debug.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 6941809dfdb7..641dd6f93791 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5164,6 +5164,8 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 			    "%s: write: cdb indicated=%u, IO sent=%d bytes\n",
 			    my_name, num * sdebug_sector_size, ret);
 
+	scsi_set_resid(scp, scsi_bufflen(scp) - ret);
+
 	if (unlikely((sdebug_opts & SDEBUG_OPT_RECOV_DIF_DIX) &&
 		     atomic_read(&sdeb_inject_pending))) {
 		if (sdebug_opts & SDEBUG_OPT_RECOVERED_ERR) {
@@ -5352,6 +5354,7 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 		sg_off += num_by;
 		cum_lb += num;
 	}
+	scsi_set_resid(scp, scsi_bufflen(scp) - sg_off);
 	ret = 0;
 err_out_unlock:
 	sdeb_meta_write_unlock(sip);
@@ -6207,6 +6210,8 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
 		return DID_ERROR << 16;
 	if (unlikely(ret != len * sdebug_sector_size))
 		return DID_ERROR << 16;
+
+	scsi_set_resid(scp, scsi_bufflen(scp) - ret);
 	return 0;
 }
 
-- 
2.55.0

