Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22F13BB674
	for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2026 06:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788158709; cv=none; b=B7/dYPkIKTM8nsFU0gKKVUzu1DVy3Rw1TyJA/BzdqvkmdzSfSlEqLI04FnAiN4Rg2AAXNqyy0d1m/hr5AyzkDSkdIMlvvYRqI9e8jp3tffYJxacOjUaT4GO85pVB1fFWK8rqc9yHzGqNMQbg5gr+KxIE4IO5ujBlUHmq/51BHR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788158709; c=relaxed/simple;
	bh=KiFyv5UceJgkL73+nDfsu7vN4P6cEZHeKL+28KuHZRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KswyVKIk8V0OdRzjDt4X9AGJREX5SRU9wBbLT2mPhugAkAA5qLEBg+TlrKbcWhg+xpNKd+ybzh8j5iVeprxOEC2SsRRxlpBiBqXIaVVUB4ncT8h8Hv5yhlK3FKJFpp8sP+we23novjY4MEGQleVoE40Hv5JKz7T3HZp+w4y7TJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=cPst7zGP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cPst7zGP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=fMYZyS7Y3K8BKq+etwRxKtSRvAbBW9yINBrdMroxMIk=; b=cPst7zGPgS1LUXZ4M4iWyo+FA5
	LJ9SzwX3ViaBr+9cHhje5JH++07FEy4OyOGtxldjpcMgWahLDNnLPMzoaLvpjjZFEHpcfE5kYCFd2
	yNyNyyh5+imebEhQ7kM9uO1bRlrhE5T0litS3XTf+40rmbJZG884QTx0YHFZMo7f9qGOQRlWknMwD
	yMl0u/ybcLy3G3m5obpbLkgvybWImnqWaLh3dkMSEFV4BiQezTznrss3CYIgOF4558DNvylWiH7FI
	yh7PY/vXJBvZdELFPblUU0IAkDAqJ/OSWIOixaNRVcQ7RqO5FgCLjQezRitwdDUfcUOQuE0VI9QiA
	nPAtsd4w==;
Received: from [2001:4bb8:2f9:3a59:1608:d03f:db12:ee92] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x0vlS-00000008dCb-3xWj;
	Mon, 31 Aug 2026 06:45:07 +0000
From: Christoph Hellwig <hch@lst.de>
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org
Subject: [PATCH] scsi_debug: add support to corrupt data and/or reftag
Date: Mon, 31 Aug 2026 09:44:57 +0300
Message-ID: <20260831064500.2576832-2-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831064500.2576832-1-hch@lst.de>
References: <20260831064500.2576832-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a new debugfs file to inject corruptions of the data and/or reftag.
This will be used to detect that protection information and/or file
system checksumming can detect random bit errors or misplaced writes.

To use this echo the start LBA, number of logical blocks and type of
corruption into the new "corrupt" debugfs file for each scsi_debug
device.

For example:

	echo lba=42,num=1,bit_errors=2 > /sys/kernel/debug/scsi_debug/1:0:0:0/corrupt
or
	echo lba=2,num=4,reftag_adjust=8 > /sys/kernel/debug/scsi_debug/1:0:0:0/corrupt

The injection will be used by new xfstests test cases.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_debug.c | 168 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 168 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 3346562275f8..959177adfc9a 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -44,6 +44,7 @@
 #include <linux/debugfs.h>
 #include <linux/async.h>
 #include <linux/cleanup.h>
+#include <linux/parser.h>
 
 #include <net/checksum.h>
 
@@ -1168,6 +1169,95 @@ static const struct file_operations sdebug_error_fops = {
 	.release = single_release,
 };
 
+enum corrupt_options {
+	Opt_lba			= (1u << 0),
+	Opt_num			= (1u << 1),
+	Opt_bit_errors		= (1u << 2),
+	Opt_reftag_adjust	= (1u << 3),
+
+	Opt_invalid,
+};
+
+static const match_table_t corrupt_tokens = {
+	{ Opt_lba,			"lba=%u"		},
+	{ Opt_num,			"num=%u"		},
+	{ Opt_bit_errors,		"bit_errors=%u"		},
+	{ Opt_reftag_adjust,		"reftag_adjust=%d"	},
+	{ Opt_invalid,			NULL,			},
+};
+
+static int corrupt_lbas(struct sdebug_dev_info *devip, u64 lba, u32 num,
+		u32 nr_bit_errors, s32 reftag_adjust);
+static ssize_t sdebug_corrupt_write(struct file *file, const char __user *ubuf,
+		size_t count, loff_t *ppos)
+{
+	struct scsi_device *sdev = file->f_inode->i_private;
+	struct sdebug_dev_info *devip = sdev->hostdata;
+	substring_t args[MAX_OPT_ARGS];
+	char *buf, *options, *p;
+	int error = 0;
+	u64 lba = 0;
+	u32 num = 1;
+	u32 nr_bit_errors = 0;
+	s32 reftag_adjust = 0;
+
+	buf = memdup_user_nul(ubuf, count);
+	if (IS_ERR(buf))
+		return PTR_ERR(buf);
+
+	options = buf;
+	while ((p = strsep(&options, ",\n")) != NULL) {
+		if (!*p)
+			continue;
+		switch (match_token(p, corrupt_tokens, args)) {
+		case Opt_lba:
+			error = match_u64(args, &lba);
+			break;
+		case Opt_num:
+			error = match_uint(args, &num);
+			break;
+		case Opt_bit_errors:
+			error = match_uint(args, &nr_bit_errors);
+			break;
+		case Opt_reftag_adjust:
+			error = match_int(args, &reftag_adjust);
+			break;
+		default:
+			pr_warn("unknown parameter or missing value '%s'\n", p);
+			error = -EINVAL;
+		}
+		if (error)
+			goto out_free_buf;
+	}
+
+	if (num == 0) {
+		pr_warn("invalid number of logical blocks: %u\n", num);
+		error = -EINVAL;
+		goto out_free_buf;
+	}
+
+	if (reftag_adjust &&
+	    (!sdebug_dix ||
+	     (sdebug_dif != T10_PI_TYPE1_PROTECTION &&
+	      sdebug_dif != T10_PI_TYPE2_PROTECTION))) {
+		pr_warn("reftag adjust requires type 1 or type 2 PI with DIX\n");
+		error = -EINVAL;
+		goto out_free_buf;
+	}
+
+	error = corrupt_lbas(devip, lba, num, nr_bit_errors, reftag_adjust);
+
+out_free_buf:
+	kfree(buf);
+	if (error)
+		return error;
+	return count;
+}
+
+static const struct file_operations sdebug_corrupt_fops = {
+	.write		= sdebug_corrupt_write,
+};
+
 static int sdebug_target_reset_fail_show(struct seq_file *m, void *p)
 {
 	struct scsi_target *starget = (struct scsi_target *)m->private;
@@ -4862,6 +4952,82 @@ static int resp_write_tape(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	return 0;
 }
 
+static int corrupt_lbas(struct sdebug_dev_info *devip, u64 lba, u32 num,
+		u32 nr_bit_errors, s32 reftag_adjust)
+{
+	struct sdeb_store_info *sip = devip2sip(devip, false);
+	bool meta_data_locked = false;
+	u32 block, num_mapped, b, i;
+	int error = 0;
+
+	if (sdebug_dev_is_zoned(devip) ||
+	    sdebug_dix ||
+	    scsi_debug_lbp())  {
+		sdeb_meta_write_lock(sip);
+		meta_data_locked = true;
+	}
+
+	if (!sip) {
+		pr_err("can't corrupt with fake_rw\n");
+		error = -EINVAL;
+		goto out_unlock;
+	}
+
+	if (num > sdebug_capacity || lba > sdebug_capacity - num) {
+		pr_err("logical blocks out of bounds: %llu:%u", lba, num);
+		error = -EINVAL;
+		goto out_unlock;
+	}
+
+	if (scsi_debug_lbp() &&
+	    (!map_state(sip, lba, &num_mapped) || num > num_mapped)) {
+		pr_err("can't modify unmapped logical blocks: %llu:%u",
+			lba, num);
+		error = -EINVAL;
+		goto out_unlock;
+	}
+
+	/*
+	 * For each possible bit error, flip the same bit in each corrupted
+	 * block to simulate repeated patterns like errors in cables.
+	 */
+	sdeb_data_lock(sip, false);
+	for (b = 0; b < nr_bit_errors; b++) {
+		unsigned int bit;
+
+		bit = get_random_u32_below(sdebug_sector_size * BITS_PER_BYTE);
+		pr_info("flipping bit %u in LBAs %llu:%llu\n",
+				bit, lba, lba + num - 1);
+
+		div_u64_rem(lba, sdebug_store_sectors, &block);
+		for (i = 0; i < num; i++) {
+			u8 *p = sip->storep + (block * sdebug_sector_size);
+
+			sdeb_data_sector_lock(sip, true);
+			p[bit / BITS_PER_BYTE] ^= (1 << (bit % BITS_PER_BYTE));
+			sdeb_data_sector_unlock(sip, true);
+			if (++block >= sdebug_store_sectors)
+				block = 0;
+		}
+	}
+
+	if (reftag_adjust) {
+		pr_info("adjusting reftag by %d sectors for LBAs %llu:%llu\n",
+			reftag_adjust, lba, lba + num - 1);
+		for (i = 0; i < num; i++) {
+			struct t10_pi_tuple *sdt = dif_store(sip, lba + i);
+
+			be32_add_cpu(&sdt->ref_tag, reftag_adjust);
+		}
+	}
+	sdeb_data_unlock(sip, false);
+
+out_unlock:
+	if (meta_data_locked)
+		sdeb_meta_write_unlock(sip);
+	return error;
+}
+
 static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 {
 	bool check_prot;
@@ -6628,6 +6794,8 @@ static int scsi_debug_sdev_configure(struct scsi_device *sdp,
 	if (IS_ERR_OR_NULL(dentry))
 		pr_info("failed to create error file for device %s\n",
 			dev_name(&sdp->sdev_gendev));
+	debugfs_create_file("corrupt", 0600, devip->debugfs_entry, sdp,
+				&sdebug_corrupt_fops);
 
 	return 0;
 }
-- 
2.53.0

