Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C6483B4E83
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 14:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784816523; cv=none; b=g0rWmyiWQw+7HfBFzOmX8h34S10n5fqL0DiABEvU0rtkowRZ7iwsbm2zKjgAVAeeTWSvXTMM5ku2/qcPKXOAR8CJ2NJvvHe6YLdh4jlXAdJqRMukXNeF6bVfHr4RgjgltLfQTquOkSyozTZSPSJ3fKlC9j9VYSHTwkDlh/jbAGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784816523; c=relaxed/simple;
	bh=TrjHRoWCSkHk5g90FL7L/FYaHZnrpYz59UL/ER5jNrU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OQDiFfOP3xOK9p9DshcHpvArsm26TyZhhh0/uDhJo5kV90FHsBAEJE6oOzS3LMNeWIwW4ZgI/gzzyEA6qpoxP12qFnjLqUQTwlxAwXaP9VijulWY2qR1GF1uVrBqLlgiZJ1+Jj18iPF9sJGF9e+NFq9Aqp67bhOnC58s8M95h6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tovgl8eA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tovgl8eA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=uyt5UdeAPcFl6weXbyfklmeTkiNvqKVQ4JPzknvKAKY=; b=tovgl8eAhKB2Wv9fb6A2XqeFs5
	kNkp/U9B2YJxLP/gb+GzjPB434je0wuPpwzxPE/hwbv20BD6kLn9EHnBYavTQWn7sYv8BEnixSUiE
	2v5/XFdi/BExk+bHc7hw/falMzFhOyXW1Y80OSVyqUpwwPH/CHY5VhriKcCrIOCWX9QDLoU7MBWfU
	8LcynWb0cbAwAUg5Uq3XcPA6plzp8NbkYJD2Y02K+1nDNwq5Y/4mz42hKNhLNCfwwF34ELHGXmBt+
	KJ7woxg5BbOe+N7e1GlKUmzZfiwLuC0/6VZ4QQ9W6fPDti/81tNKjK+mTEL6NOHSQQxO4OSqXSELS
	s4r3L8Nw==;
Received: from [2001:4bb8:2e9:b20c:3d3c:bb0:5e13:19af] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wmuJB-0000000EUMC-1zak;
	Thu, 23 Jul 2026 14:21:57 +0000
From: Christoph Hellwig <hch@lst.de>
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org
Subject: [PATCH] scsi_debug: add support to corrupt data and/or reftag
Date: Thu, 23 Jul 2026 16:21:54 +0200
Message-ID: <20260723142154.107268-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
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
 drivers/scsi/scsi_debug.c | 153 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 153 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 9d1c9c41d0f9..aa51eccb7061 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -44,6 +44,7 @@
 #include <linux/debugfs.h>
 #include <linux/async.h>
 #include <linux/cleanup.h>
+#include <linux/parser.h>
 
 #include <net/checksum.h>
 
@@ -1214,6 +1215,94 @@ static const struct file_operations sdebug_error_fops = {
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
+			error = match_uint(args, &reftag_adjust);
+			break;
+		default:
+			pr_warn("unknown parameter or missing value '%s'\n", p);
+			error = -EINVAL;
+		}
+		if (error)
+			return error;
+	}
+
+	if (num == 0) {
+		pr_warn("invalid number of logical blocks: %u\n", num);
+		error = -EINVAL;
+		goto out_free_buf;
+	}
+
+	if (reftag_adjust &&
+	    (sdebug_dif != T10_PI_TYPE1_PROTECTION &&
+	     sdebug_dif != T10_PI_TYPE2_PROTECTION)) {
+		pr_warn("reftag adjust requires type 1 or type 2 PI\n");
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
@@ -4908,6 +4997,68 @@ static int resp_write_tape(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	return 0;
 }
 
+static int corrupt_lbas(struct sdebug_dev_info *devip, u64 lba, u32 num,
+		u32 nr_bit_errors, s32 reftag_adjust)
+{
+	struct sdeb_store_info *sip = devip2sip(devip, true);
+	bool meta_data_locked = false;
+	u8 *fsp = sip->storep;
+	u32 block, b, i;
+	int error = 0;
+
+	if (sdebug_dev_is_zoned(devip) ||
+	    sdebug_dix ||
+	    scsi_debug_lbp())  {
+		sdeb_meta_write_lock(sip);
+		meta_data_locked = true;
+	}
+
+	if (num >= sdebug_capacity || lba > sdebug_capacity - num) {
+		pr_err("logical blocks out of bounds: %llu:%u", lba, num);
+		error = -EINVAL;
+		goto out_unlock;
+	}
+
+	if (scsi_debug_lbp() && !map_state(sip, lba, &num)) {
+		pr_err("can't modify unmapped logical blocks: %llu:%u",
+			lba, num);
+		error = -EINVAL;
+		goto out_unlock;
+	}
+
+	for (b = 0; b < nr_bit_errors; b++) {
+		unsigned int bit;
+
+		bit = get_random_u32_below(sdebug_sector_size * BITS_PER_BYTE);
+
+		div_u64_rem(lba, sdebug_store_sectors, &block);
+		for (i = 0; i < num; i++) {
+			u8 *p = fsp + (block * sdebug_sector_size);
+
+			p[bit / BITS_PER_BYTE] ^= (1 << (bit % BITS_PER_BYTE));
+			pr_info("flipping bit %u in LBA %llu\n", bit, lba + i);
+
+			if (++block >= sdebug_store_sectors)
+				block = 0;
+		}
+	}
+
+	if (reftag_adjust) {
+		for (i = 0; i < num; i++) {
+			struct t10_pi_tuple *sdt = dif_store(sip, lba + i);
+
+			be32_add_cpu(&sdt->ref_tag, reftag_adjust);
+			pr_info("adjusting reftag by %d sectors for LBA %llu\n",
+				reftag_adjust, lba + i);
+		}
+	}
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
@@ -6670,6 +6821,8 @@ static int scsi_debug_sdev_configure(struct scsi_device *sdp,
 	if (IS_ERR_OR_NULL(dentry))
 		pr_info("failed to create error file for device %s\n",
 			dev_name(&sdp->sdev_gendev));
+	debugfs_create_file("corrupt", 0600, devip->debugfs_entry, sdp,
+				&sdebug_corrupt_fops);
 
 	return 0;
 }
-- 
2.53.0

