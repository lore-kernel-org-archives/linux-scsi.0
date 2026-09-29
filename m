Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 474D13CBE8F
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 08:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790670383; cv=none; b=XPuuZowJro7jK0KIc14tObvr8+VDmQ6zChVs1zRzln3DEZhQAm6JLzA0oAXWbezVF1UWHag6PcmJdXROMMQED3Oy+DtQRx6gAMtfLE/wGaLEwIbyJ3ansX9hNpVNeU+XvMUJ0YRUlv8lumDnVA1zoWJo+JDx68zq8/tu5MP7wvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790670383; c=relaxed/simple;
	bh=bpJ0zrsgbZLRJ7Y9VnR+2NAvhh2czUaT2EfxfTiqRrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y6c4UK9jRmBlCFskd+czrRQ4mff26F29LpcLlVcDEZU6vVfglra75FdPQkoFwEe4azAiZVDGTGb+E6R+I3Y4odr4y8zwfetaCB3rAevFr8hrnZtM+rMeoUhQ9AK1WuV453LLmdKX7fvxyEh4BpWrqQRbm768x07eSwV/pimKgIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iPuJlADU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iPuJlADU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C33541F00893;
	Tue, 29 Sep 2026 08:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790670382;
	bh=E+5FBr9++1Wn5W7mlVQ7Fx4pom+zXeXCPIQ5cqZbC94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iPuJlADUb4yQnAKcpUhajFfJ11QMH9uqUl7TNqz+OUcXHuvig+7+0Gm5j4bNSF0Eh
	 OCIgOwTRMAvasSspqyU/6T9d4pvscDmjIK2c002EkXKrqsUGUYyyeRdHD4IvB5AxRU
	 hsmK83W4Fo5k4JzPE3q5ewRtL3jv4vaWt8Ndptth5q/I/Me+773yCSAuuLzykkGtXi
	 39mrzHPopbzlo6KHMJanlxakEVNd2RtSafjYwMydg3RyUjMS0bhzUNkF7csdhSyVqz
	 5aSlZWWlVKvNQiSICpVOmoqeO0Z4jjWDZjVUy9YMPD5HRwIeFCBQO/sMB8YfnkO1hZ
	 y7yR1e29V9Tng==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v11 12/13] scsi: scsi_debug: Map the region written by WRITE ATOMIC (16)
Date: Tue, 29 Sep 2026 10:25:09 +0200
Message-ID: <20260929082456.857423-27-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260929082456.857423-15-cassel@kernel.org>
References: <20260929082456.857423-15-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2501; i=cassel@kernel.org; h=from:subject; bh=bpJ0zrsgbZLRJ7Y9VnR+2NAvhh2czUaT2EfxfTiqRrk=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLJ2l75tnJXfr7zt+8YHu7uDkj1erg5T4L2x5e4rlxVvC sum/InL7ShlYRDjYpAVU2Tx/eGyv7jbfcpxxTs2MHNYmUCGMHBxCsBEvhcyMkxhDyvcfNDt++xr 4TeF2aQYtQS+79fYWmgzw1CReeE6ZmOGPzxPAr9Ks2+dn7Zb6nW+gXRx4uuOlUe6Hze2XH1ryyk ZwQ8A
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

When logical block provisioning is enabled, every command that writes
user data calls map_region() so that GET LBA STATUS reports the region
as mapped. resp_atomic_write() does not, so GET LBA STATUS keeps
reporting a region as deallocated after a WRITE ATOMIC (16) has written
it.

Call map_region() the way resp_write_dt0() does, holding the zone
metadata write lock across the access. That lock is what serialises the
map against resp_unmap(), which does nothing unless logical block
provisioning is enabled.

Assisted-by: LLM
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: John Garry <john.garry@linux.dev>
Fixes: 84f3a3c01d70 ("scsi: scsi_debug: Atomic write support")
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
Tested with:

  modprobe scsi_debug sector_size=512 physblk_exp=3 dev_size_mb=128 \
      atomic_wr=1 lbpu=1

GET LBA STATUS reports a region that has never been written as
deallocated, and reports it as mapped after a WRITE ATOMIC (16) of eight
blocks. Only an ordinary WRITE did so before this patch.
---
 drivers/scsi/scsi_debug.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 41239ca364b3..87ef71f18f2a 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4876,6 +4876,11 @@ static unsigned int map_state(struct sdeb_store_info *sip, sector_t lba,
 	return mapped;
 }
 
+/*
+ * Callers may map the whole range of a write without checking how much of
+ * it was written. SBC-6 4.7.4.6.2 allows a deallocated LBA to become mapped
+ * at any time, and only requires an LBA that was written to be mapped.
+ */
 static void map_region(struct sdeb_store_info *sip, sector_t lba,
 		       unsigned int len)
 {
@@ -6206,6 +6211,7 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
 	u8 *cmd = scp->cmnd;
 	u16 boundary, len;
 	u64 lba, lba_tmp;
+	bool lbp = scsi_debug_lbp();
 	int ret;
 
 	if (!scsi_debug_atomic_write()) {
@@ -6258,7 +6264,15 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
 	if (scsi_bufflen(scp) < len * sdebug_sector_size)
 		return DID_ERROR << 16;
 
+	if (lbp)
+		sdeb_meta_write_lock(sip);
+
 	ret = do_device_access(sip, scp, 0, lba, len, 0, true, true);
+	if (lbp) {
+		map_region(sip, lba, len);
+		sdeb_meta_write_unlock(sip);
+	}
+
 	if (unlikely(ret == -1))
 		return DID_ERROR << 16;
 	if (unlikely(ret != len * sdebug_sector_size))
-- 
2.55.0

