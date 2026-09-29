Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C047A3E5EF8
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 08:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790670372; cv=none; b=BDKp3WO9c3KoEXONEQUah00IbkFkmSZjL5s5vBoVL+642j87bTyfqQbvfCYoQY/+RxoBo3/UpZ4DwjjLvdqGj5whecRMaRLmE9vvvNAQ5c5Eo32Osuqp9+Tx6hyb8bX2JYbLUSZ8vMt2q6M+B/bTa9L7LyzRSiPEP7a6RYfe7tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790670372; c=relaxed/simple;
	bh=ayBoz8bsdZUu6ThdqA/vL2AXSaVCmXAM8SuNnWJZKeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bn8Dd3T43NVQbFhX1ntb7h7sqxopp9Gw4v5ZA+rkg7mGtAHRTH3aKMzvSRnjctc9z7Av5GTZvLLEjWKoeTlCU4bm6YHhv/7kJeFre/DS76V+wftKJYvA6+JQW3w/9wA6z/KrF7KoKjbhAWcVoriqj4pQn4uohsaoZHDEW0T+h3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iSu8eXCB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iSu8eXCB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 431601F00898;
	Tue, 29 Sep 2026 08:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790670371;
	bh=B7mEXBSrXYAr4kAI+u3P+FU/tQOwSTCjfx7OJ0JVe3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iSu8eXCB9wh7BQGWzyxwjvYd/dTLghZ+I8wzgZnw5e7F8jiw7N/QA77JKbrBdRKJs
	 c1EdC+pSxLXz9r1u5pihS9grB5J2BvEzPb6zs0IL/KhhYFbuMEAkIB7irRxLPNy2rz
	 HVpPeZD1ZFhi0ZG1pnpCJki+x5tE1qjMicBDNoNQUXJn7oF6WmNAy63wrHtG9LtxOO
	 zRY8j0Y41iuE6EAi59Xo1zfdRpGEJnmpuThyh6R2TF3OgQ3v57DvLN1I3KV1SDZ/82
	 9rGLnO+74zOjfwNQ371yaG0vppqaHuvyANhav6fENXx9ukKpWVoAA184J7hqYVndku
	 Erlqf5wYMBfnA==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v11 06/13] scsi: scsi_debug: Avoid 32-bit overflow in WRITE SCATTERED offsets
Date: Tue, 29 Sep 2026 10:25:03 +0200
Message-ID: <20260929082456.857423-21-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260929082456.857423-15-cassel@kernel.org>
References: <20260929082456.857423-15-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3790; i=cassel@kernel.org; h=from:subject; bh=ayBoz8bsdZUu6ThdqA/vL2AXSaVCmXAM8SuNnWJZKeQ=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLJ2l769Gdju1/hModR4e/myAxuqWfsCm3dYeD6auoNT9 M3Gu+LvOkpZGMS4GGTFFFl8f7jsL+52n3Jc8Y4NzBxWJpAhDFycAjCRXXaMDM8Zqt4JrbIUPbf3 i+kmu6NPOKdVt6/7eeYrp9KnEKHQjdoM/7PNfKqFL0iJ+y80Wjkn2atpF6PvrMrL/J/S/jy7Irf OhRkA
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

resp_write_scat() computes the length of an LBA range in bytes as a
32-bit product, num_by = num * lb_size, and adds it to sg_off, the
32-bit offset of the next range in the data-out buffer. The product
wraps for a range of 4 GiB or more, which check_device_access_params()
allows once the store is that large, and sg_off wraps once the ranges
add up to 4 GiB, which neither their number nor their overlap prevents.
The ranges that follow are then written from the wrong offset in the
buffer.

Make num_by and sg_off 64-bit, and pass do_device_access() sg_off
capped at the length of the buffer. An offset at the end of the buffer
copies nothing, and sg_copy_buffer(), which takes it as an off_t, is
never given one larger than the buffer that it copies.

Assisted-by: LLM
Fixes: 481b5e5c7949 ("scsi: scsi_debug: add resp_write_scat function")
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
Tested with:

  modprobe scsi_debug sector_size=512 dev_size_mb=128

issuing a WRITE SCATTERED (16) through SG_IO with 33 LBA range
descriptors: 32 of 262144 blocks at LBA 0, which add up to 4 GiB, and
one of 8 blocks at LBA 200000. The 9728 byte buffer holds the parameter
list and 16 blocks, so the first range consumes all of it. Before this
patch the offset wrapped, and the last range was written with the data
of the first; after it the last range is left as it was.

Changes since v10: sg_off is capped at the length of the buffer rather
than at U32_MAX, which becomes -1 as an off_t on 32-bit architectures,
and the commit message no longer claims that the store has to be 4 GiB.
---
 drivers/scsi/scsi_debug.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 92458bf1568b..879746c2ed7d 100644
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
@@ -5311,7 +5312,9 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 		 * Write ranges atomically to keep as close to pre-atomic
 		 * writes behaviour as possible.
 		 */
-		ret = do_device_access(sip, scp, sg_off, lba, num, group, true, true);
+		ret = do_device_access(sip, scp,
+				       min_t(u64, sg_off, scsi_bufflen(scp)),
+				       lba, num, group, true, true);
 		/* If ZBC zone then bump its write pointer */
 		if (sdebug_dev_is_zoned(devip))
 			zbc_inc_wp(devip, lba, num);
@@ -5322,7 +5325,7 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 			goto err_out_unlock;
 		} else if (unlikely(sdebug_verbose && (ret < num_by)))
 			sdev_printk(KERN_INFO, scp->device,
-			    "%s: write: cdb indicated=%u, IO sent=%d bytes\n",
+			    "%s: write: cdb indicated=%llu, IO sent=%d bytes\n",
 			    my_name, num_by, ret);
 
 		if (unlikely((sdebug_opts & SDEBUG_OPT_RECOV_DIF_DIX) &&
-- 
2.55.0

