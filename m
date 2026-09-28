Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2ACF298CC4
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 07:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790580088; cv=none; b=HqqMhMd1fhqQHNABW2ujLEjU/CPRc9BRuDqQiyO28FrAFmAkS2xYyThcYVFOmtdZ07XZmreXMSA3Crx/NkiKUjpIVIYRph4PYic1US1oNKbhM2SpTY9LOOV5hb02NyAKIE8+ik4WpaIfMkZH4V+77c0oKi81rImXS5JwI9nherw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790580088; c=relaxed/simple;
	bh=L169EokxEqMMGOC8GPzefXfJRV9NkayCiQtJx2lacz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EtK7FxhmBG4A8JYUkYrxEWWuX5AXpxq1NJFnlN3hndse/RQhTCdHXOyn44K4K98sgTdVB/lmrc8WRpz5gWqvEldBfXfSEedq6n65UvsdNVD6A/qUReQFMTQPwUPCcRcrK8dkiAsjYIxLo5KI0yHPnmNVwLx3Fu1HkeCYYJ5x1fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hcjNqzeQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hcjNqzeQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2927E1F00893;
	Mon, 28 Sep 2026 07:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790580086;
	bh=MWQBnxQ4xEuMDrEDhRRPbx7+fYWVSVweUNwl35W36OQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hcjNqzeQE/hEzttJBf9F8BwdNPOinFucpOVCq6GBz1aA1Wo0RX0xs58eIH6YEeaaQ
	 yW1X/n6OzawIMkO4Tk50RWVH6eZNhsy6ppw0MsqqbHBomFhCd3Gut0ImQQYvegbwtU
	 GCwiHOHJkovoCaFju1F98AxPlmBf4KNHskkSDBb7IwdHYvhyOXsCsoiHvJqVFWjEnd
	 4i2INEK3EbyBOFeGZLHaypDyZIBT7gvOpuwEdjZplX2UkjEtzaPuzmGPP+NeLX6wlx
	 Fw3or+879pCsqCgnfTaXwNmc08gzSm66XkVHFnMT4l6+WR1jAk0QmC/eaaa3t1n9tL
	 2zZQDwtftaLnA==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v10 05/12] scsi: scsi_debug: Avoid 32-bit overflow in WRITE SCATTERED offsets
Date: Mon, 28 Sep 2026 09:21:08 +0200
Message-ID: <20260928072102.725566-19-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260928072102.725566-14-cassel@kernel.org>
References: <20260928072102.725566-14-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3475; i=cassel@kernel.org; h=from:subject; bh=L169EokxEqMMGOC8GPzefXfJRV9NkayCiQtJx2lacz4=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLJ2iaaf7fou1iOVcu/z4aXvgz6v+Ht/uZ2h2u2fEa55k 68W7tyr2lHKwiDGxSArpsji+8Nlf3G3+5TjindsYOawMoEMYeDiFICJnNZkZPh9/syLnEmzXSYq L9qeu6ZD9Nsh5se/5VwOdf507Up2St7MyNBW17drb2foY81vdUmHTz1ILdv49MBnBuFVR57xHXP KEGcHAA==
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

resp_write_scat() computes the length of an LBA range in bytes as a
32-bit product, num_by = num * lb_size, and adds it to sg_off, the
32-bit offset of the next range in the data-out buffer.
check_device_access_params() limits num to the number of sectors in the
store, so the product wraps once the store is 4 GiB or larger, and
sg_off wraps with it. The ranges that follow are then written from the
wrong offset in the buffer.

Make num_by and sg_off 64-bit. do_device_access() takes a 32-bit
offset, so pass it sg_off capped at U32_MAX: a data-out buffer is at
most U32_MAX bytes, so a capped offset is still at or past its end and
nothing is copied.

Assisted-by: LLM
Fixes: 481b5e5c7949 ("scsi: scsi_debug: add resp_write_scat function")
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
Tested with:

  modprobe scsi_debug sector_size=512 dev_size_mb=4097

in a guest with 8 GiB of memory, issuing a WRITE SCATTERED (16) through
SG_IO with two LBA range descriptors: 8388608 blocks at LBA 0, which is
exactly 4 GiB, and 8 blocks at LBA 8388608. The 8704 byte buffer holds
the parameter list and 16 blocks, so the first range consumes all of it.
Before this patch the offset wrapped, and the second range was written
with the data of the first; after it the second range is left as it
was.
---
 drivers/scsi/scsi_debug.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index b64ae3ad300d..8f9d54269dce 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5197,7 +5197,8 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 	struct sdeb_store_info *sip = devip2sip(devip, true);
 	u8 wrprotect;
 	u16 lbdof, num_lrd, k;
-	u32 num, num_by, bt_len, lbdof_blen, sg_off, cum_lb;
+	u32 num, bt_len, lbdof_blen, cum_lb;
+	u64 num_by, sg_off;
 	u32 lb_size = sdebug_sector_size;
 	u32 ei_lba;
 	u64 lba;
@@ -5273,14 +5274,14 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 		num = get_unaligned_be32(up + 8);
 		if (sdebug_verbose)
 			sdev_printk(KERN_INFO, scp->device,
-				"%s: k=%d  LBA=0x%llx num=%u  sg_off=%u\n",
+				"%s: k=%d  LBA=0x%llx num=%u  sg_off=%llu\n",
 				my_name, k, lba, num, sg_off);
 		if (num == 0)
 			continue;
 		ret = check_device_access_params(scp, lba, num, true);
 		if (ret)
 			goto err_out_unlock;
-		num_by = num * lb_size;
+		num_by = (u64)num * lb_size;
 		ei_lba = is_16 ? 0 : get_unaligned_be32(up + 12);
 
 		if ((cum_lb + num) > bt_len) {
@@ -5311,7 +5312,8 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 		 * Write ranges atomically to keep as close to pre-atomic
 		 * writes behaviour as possible.
 		 */
-		ret = do_device_access(sip, scp, sg_off, lba, num, group, true, true);
+		ret = do_device_access(sip, scp, min_t(u64, sg_off, U32_MAX), lba,
+				       num, group, true, true);
 		/* If ZBC zone then bump its write pointer */
 		if (sdebug_dev_is_zoned(devip))
 			zbc_inc_wp(devip, lba, num);
@@ -5322,7 +5324,7 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 			goto err_out_unlock;
 		} else if (unlikely(sdebug_verbose && (ret < num_by)))
 			sdev_printk(KERN_INFO, scp->device,
-			    "%s: write: cdb indicated=%u, IO sent=%d bytes\n",
+			    "%s: write: cdb indicated=%llu, IO sent=%d bytes\n",
 			    my_name, num_by, ret);
 
 		if (unlikely((sdebug_opts & SDEBUG_OPT_RECOV_DIF_DIX) &&
-- 
2.55.0

