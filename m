Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71BCF45FFB7
	for <linux-scsi@vger.kernel.org>; Sun, 11 Oct 2026 14:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791730099; cv=none; b=hTSfu2RyVYp7w9FO3TsaAzTZRiN1GeunV2tXfTEw1XKKLWW/aD0LZlVeKJkz4g1eL31fFAxrXOushuBx2De4nZ0QlPmA0bptfZKWF2x7dcVTnfowQh78hWkIn+CGxSM6sQ6VZZf5fm0y8GOG/ygC0Ifdmtn4yFgPrDlUFjO2Zuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791730099; c=relaxed/simple;
	bh=HsgbRWE+5rn+/d+eGYKn73urxfqSQ9ZjitzwK59WK9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rt9YoQxMFOHxp8T5W+ynbQdokiq7jAxi2KwW+GZJ3p7rCIjD+2lnIVUutdUq3emMGds8z+Wj8HfeTCw3rM3wpLxU/Mij67koaQjr7Sb02DKVgZVnz8y5EMBUsmN/Y+Q9Y9KJXtSQ31S3sy8M8FwC+BPaBrNuPGCqkJWiOYOCzfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=R0Nn4C8C; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="R0Nn4C8C"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-39647aa9d52so648794a91.0
        for <linux-scsi@vger.kernel.org>; Sun, 11 Oct 2026 07:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791730095; x=1792334895; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/5mJq8d9plFSHVdOGt4XQU6iEJZi3mQ9E+ALBg7jwqw=;
        b=R0Nn4C8C2c+jKLK//pbi0+0bXam1RGyOvYQf7LMHkL9ASjePJY1lwq3sCy5h8dr3NW
         cIfNcWJyOGyBBkpWEaY6kff4hRvLhlvo2pfmuMwowVbvzNCS4ael8h+xOjZsEB45lMTv
         IWfUA/P3XE+yqUnZnMzPUiZ3SN/baDX0NogdXItFV030oEZdtBoJUzXjFoMU28w3T7d+
         XaTU9PUYRf710XUyevtBkX5V/rsqbvhOHn7ZHl565AsAjSpA1wArWFbqhRheaG5btFKY
         WXMDGC0WwE0m8MIWX2BUSzhRJwsy3qbeUnVw5pOK/I3pToFiy1QF4s8Pn0Ak7ljTNrxz
         BhzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791730095; x=1792334895;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/5mJq8d9plFSHVdOGt4XQU6iEJZi3mQ9E+ALBg7jwqw=;
        b=cS3sOK2v/7swZ8ADR2dszPiFx0Ic8UyErXDc2t1RWApFFKcA0t2j21yxnn+Fs3xHSf
         d+Op0NYXXJGVDNGq8r0DeWpnoNtpCaKazYrN44iuk+UelxoTmvjDlpPb1Tk74q1FQ3kb
         wgSDnQTnyvqLPbZ4jqd/BsDsPw+oe/7wh6jnT+eNpDvc4QTvoUkaxHvBUMmhX25JN0WL
         KqQs5eVIxG48amlR4X1E+GKJdT01DLvqvNKqs4X73yWZPJE36kl+lVETyhKPZ5/DvT/1
         w3kpDPIWViCx+rS01gSuwFnikjIQO3acd4FMXRAcSbseowcvXd1n9mRhCwO/epiRZBNn
         /FPA==
X-Forwarded-Encrypted: i=1; AKwUvByBaYd3bEB+TGRhnExYV+E8bc0YkymETQ25UcB5VeTp2pGjkTMD4hThJJZC/57J4l88TcO9jfytQwZV@vger.kernel.org
X-Gm-Message-State: AFq9FYJ0OAMt6n0hlXlJvtHADta5N6BMMKFr+2ZmJuhtxYMLoXtLH2lY
	TXqi11CCREtgXhbsOe1HnAErwcVR2FruGaDbeY8BbZUMi5xO5dh3zccnu8wudgQ5Usk=
X-Gm-Gg: AYBFou03oRdcnjyEPXCVoy5z4zxX+qO487VC+M0DpQtDesq6XzV1+SWA06z0vIiit3L
	6MupKNQXGyUKxpU2o+HgB8yuAA2IpHV3OU00cJQEub04FEw6/lToa8cILQaGYz/8zErPPWZ79c0
	uXFeItAg9xl6H58cheCWo0BFsJk8VKsB9M7kynZySlXwZxTwyqpgbZ56vz21zm54tCLuaouTSXr
	Ewz9hetofPSytpArpI51sOYWF26fPD59xkE31BNjF2idxZoEEm1aFANiEPMcIuixkGB7RCNQUHt
	M1ffXTg4s4+AdQ5xrebdYGQNoNc34uXZG7ZqFvoJEGDr+9cWDFqYbVoBFB8pBVKwk6tGl7LItuV
	uF88qP8MJTx9Lo+KlXZ3Rg3sMO0ucC24vgrlklIoisYxMrOdT9PsT8peg10x98Ioos5QDAY+Y0g
	IdV3oo1HwE4B04saYmc3o4LmGjvh/PuIe3Egy2reap4MkQrpGuW2TJ562UK0s4trvdLhHIEFgTS
	oDgwkn0qrDDFByZYAIMsg==
X-Received: by 2002:a17:90b:2d82:b0:39e:6c68:fd91 with SMTP id 98e67ed59e1d1-3ab3acdc391mr3580312a91.38.1791730094423;
        Sun, 11 Oct 2026 07:48:14 -0700 (PDT)
Received: from localhost.localdomain ([2406:5900:1044:110c:97fe:d421:a74a:1d6e])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab38ddac6dsm11729048a91.7.2026.10.11.07.48.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2026 07:48:14 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Nilesh Javali <njavali@marvell.com>,
	Manish Rangankar <mrangankar@marvell.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <mkp@kernel.org>
Cc: Mike Christie <michael.christie@oracle.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	stable@vger.kernel.org
Subject: [PATCH v3 1/2] scsi: qla4xxx: bound the ISP83xx reset template to its buffer
Date: Sun, 11 Oct 2026 23:47:50 +0900
Message-ID: <20261011144752.2063334-2-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261011144752.2063334-1-yhlee@isslab.korea.ac.kr>
References: <20261011144752.2063334-1-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

qla4_83xx_read_reset_template() reads the reset template out of the
adapter flash into a fixed buffer:

	ha->reset_tmplt.buff = vmalloc(QLA83XX_RESTART_TEMPLATE_SIZE);

It then takes the template length from the header it just read and uses
it to size the second flash read:

	tmplt_hdr_def_size = (ha->reset_tmplt.hdr->size -
	    ha->reset_tmplt.hdr->hdr_size) / sizeof(uint32_t);
	ret_val = qla4_83xx_flash_read_u32(ha, addr, p_buff,
	                                   tmplt_hdr_def_size);

hdr->size is a 16-bit field supplied by the flash contents and nothing
bounds it: QLA83XX_RESTART_TEMPLATE_SIZE appears only at the allocation
and is never compared against anything. qla4_83xx_flash_read_u32() walks
its word count storing one dword at a time with no end check, so a
template claiming a size larger than the 8192-byte buffer stores up to
~57 KB past it with flash-chosen contents. The checksum test runs after
the copy and cannot prevent this.

  BUG: KASAN: vmalloc-out-of-bounds in qla4_83xx_flash_read_u32 [qla4xxx]
  Write of size 4 at addr ffffc90000057000 by task init/1

qla4_83xx_process_reset_template() then walks the template with
hdr->entries as the loop bound and each entry's own size as the stride,
and the per-opcode handlers read hdr->count items from an entry. These
values all come from flash and none is checked against the end of the
template, so processing a crafted template reads past the buffer:

  BUG: KASAN: vmalloc-out-of-bounds in qla4_83xx_process_reset_template [qla4xxx]
  Read of size 4 at addr ffffc90000057004 by task init/1

A read-modify-write entry adds one more: its 8-bit index_a flash value
subscripts reset_tmplt.array[], which holds QLA83XX_MAX_RESET_SEQ_ENTRIES
(16) entries inside struct scsi_qla_host. Only 404 bytes follow the
array in that structure, so an index of 101 or more reads past the
allocation:

  BUG: KASAN: slab-out-of-bounds in qla4_83xx_rmw_crb_reg [qla4xxx]
  Read of size 4 at addr ffff88810644aa28 by task init/1

Bound the template size to the buffer before the copy, keep the entry
walk and each handler's item loop inside the template, and reject an
out-of-range array index. These sizes and counts are little-endian
16-bit flash fields; read them through le16_to_cpu() where the bounds
are computed, so that on a big-endian host the check does not run on a
byte-swapped size while the copy and the walk use the raw one.

While here, fix the state the error path leaves behind. It frees the
buffer without clearing the pointer, so qla4xxx_free_adapter() frees it
a second time on remove, and hdr is assigned before the header is
validated, so it keeps pointing into the freed buffer and a later
adapter reset dereferences it in qla4_83xx_process_reset_template().
Clear the template state on the error path and refuse to walk a
template that is not there.

Fixes: 6e7b429259fc0 ("[SCSI] qla4xxx: Added support for ISP83XX")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/scsi/qla4xxx/ql4_83xx.c | 200 +++++++++++++++++++++++---------
 1 file changed, 142 insertions(+), 58 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_83xx.c b/drivers/scsi/qla4xxx/ql4_83xx.c
index db41d90a5b6e9..c68500280168b 100644
--- a/drivers/scsi/qla4xxx/ql4_83xx.c
+++ b/drivers/scsi/qla4xxx/ql4_83xx.c
@@ -745,7 +745,8 @@ static int qla4_83xx_reset_seq_checksum_test(struct scsi_qla_host *ha)
 {
 	uint32_t sum =  0;
 	uint16_t *buff = (uint16_t *)ha->reset_tmplt.buff;
-	int u16_count =  ha->reset_tmplt.hdr->size / sizeof(uint16_t);
+	int u16_count =  le16_to_cpu(ha->reset_tmplt.hdr->size) /
+			 sizeof(uint16_t);
 	int ret_val;
 
 	while (u16_count-- > 0)
@@ -773,11 +774,11 @@ static int qla4_83xx_reset_seq_checksum_test(struct scsi_qla_host *ha)
 void qla4_83xx_read_reset_template(struct scsi_qla_host *ha)
 {
 	uint8_t *p_buff;
-	uint32_t addr, tmplt_hdr_def_size, tmplt_hdr_size;
+	uint32_t addr, tmplt_hdr_def_size, tmplt_hdr_size, tmplt_size;
 	uint32_t ret_val;
 
 	ha->reset_tmplt.seq_error = 0;
-	ha->reset_tmplt.buff = vmalloc(QLA83XX_RESTART_TEMPLATE_SIZE);
+	ha->reset_tmplt.buff = vzalloc(QLA83XX_RESTART_TEMPLATE_SIZE);
 	if (ha->reset_tmplt.buff == NULL) {
 		ql4_printk(KERN_ERR, ha, "%s: Failed to allocate reset template resources\n",
 			   __func__);
@@ -807,18 +808,36 @@ void qla4_83xx_read_reset_template(struct scsi_qla_host *ha)
 		(struct qla4_83xx_reset_template_hdr *)ha->reset_tmplt.buff;
 
 	/* Validate the template header size and signature */
-	tmplt_hdr_size = ha->reset_tmplt.hdr->hdr_size/sizeof(uint32_t);
+	tmplt_hdr_size = le16_to_cpu(ha->reset_tmplt.hdr->hdr_size) /
+			 sizeof(uint32_t);
 	if ((tmplt_hdr_size != tmplt_hdr_def_size) ||
-	    (ha->reset_tmplt.hdr->signature != RESET_TMPLT_HDR_SIGNATURE)) {
+	    (le16_to_cpu(ha->reset_tmplt.hdr->signature) !=
+	     RESET_TMPLT_HDR_SIGNATURE)) {
 		ql4_printk(KERN_ERR, ha, "%s: Template Header size %d is invalid, tmplt_hdr_def_size %d\n",
 			   __func__, tmplt_hdr_size, tmplt_hdr_def_size);
 		goto exit_read_template_error;
 	}
 
-	addr = QLA83XX_RESET_TEMPLATE_ADDR + ha->reset_tmplt.hdr->hdr_size;
-	p_buff = ha->reset_tmplt.buff + ha->reset_tmplt.hdr->hdr_size;
-	tmplt_hdr_def_size = (ha->reset_tmplt.hdr->size -
-			      ha->reset_tmplt.hdr->hdr_size) / sizeof(uint32_t);
+	/* The template size is chosen by the flash contents and nothing has
+	 * bounded it yet, so a template claiming to be larger than the buffer
+	 * would make the read below store past the end of it.  The integrity
+	 * check runs after the copy and cannot prevent that.
+	 */
+	tmplt_size = le16_to_cpu(ha->reset_tmplt.hdr->size);
+	if (tmplt_size > QLA83XX_RESTART_TEMPLATE_SIZE ||
+	    tmplt_size < le16_to_cpu(ha->reset_tmplt.hdr->hdr_size)) {
+		ql4_printk(KERN_ERR, ha, "%s: Template size %u is invalid\n",
+			   __func__, tmplt_size);
+		goto exit_read_template_error;
+	}
+
+	addr = QLA83XX_RESET_TEMPLATE_ADDR +
+	       le16_to_cpu(ha->reset_tmplt.hdr->hdr_size);
+	p_buff = ha->reset_tmplt.buff +
+		 le16_to_cpu(ha->reset_tmplt.hdr->hdr_size);
+	tmplt_hdr_def_size = (tmplt_size -
+			      le16_to_cpu(ha->reset_tmplt.hdr->hdr_size)) /
+			     sizeof(uint32_t);
 
 	DEBUG2(ql4_printk(KERN_INFO, ha,
 			  "%s: Read rest of the template size %d\n",
@@ -845,17 +864,22 @@ void qla4_83xx_read_reset_template(struct scsi_qla_host *ha)
 
 	/* Get STOP, START, INIT sequence offsets */
 	ha->reset_tmplt.init_offset = ha->reset_tmplt.buff +
-				      ha->reset_tmplt.hdr->init_seq_offset;
+		le16_to_cpu(ha->reset_tmplt.hdr->init_seq_offset);
 	ha->reset_tmplt.start_offset = ha->reset_tmplt.buff +
-				       ha->reset_tmplt.hdr->start_seq_offset;
+		le16_to_cpu(ha->reset_tmplt.hdr->start_seq_offset);
 	ha->reset_tmplt.stop_offset = ha->reset_tmplt.buff +
-				      ha->reset_tmplt.hdr->hdr_size;
+		le16_to_cpu(ha->reset_tmplt.hdr->hdr_size);
 	qla4_83xx_dump_reset_seq_hdr(ha);
 
 	goto exit_read_reset_template;
 
 exit_read_template_error:
 	vfree(ha->reset_tmplt.buff);
+	ha->reset_tmplt.buff = NULL;
+	ha->reset_tmplt.hdr = NULL;
+	ha->reset_tmplt.init_offset = NULL;
+	ha->reset_tmplt.start_offset = NULL;
+	ha->reset_tmplt.stop_offset = NULL;
 
 exit_read_reset_template:
 	return;
@@ -894,16 +918,23 @@ static void qla4_83xx_rmw_crb_reg(struct scsi_qla_host *ha, uint32_t raddr,
 {
 	uint32_t value;
 
+	if (p_rmw_hdr->index_a >= QLA83XX_MAX_RESET_SEQ_ENTRIES) {
+		ql4_printk(KERN_ERR, ha, "%s: Invalid array index %u\n",
+			   __func__, p_rmw_hdr->index_a);
+		ha->reset_tmplt.seq_error++;
+		return;
+	}
+
 	if (p_rmw_hdr->index_a)
 		value = ha->reset_tmplt.array[p_rmw_hdr->index_a];
 	else
 		qla4_83xx_rd_reg_indirect(ha, raddr, &value);
 
-	value &= p_rmw_hdr->test_mask;
+	value &= le32_to_cpu(p_rmw_hdr->test_mask);
 	value <<= p_rmw_hdr->shl;
 	value >>= p_rmw_hdr->shr;
-	value |= p_rmw_hdr->or_value;
-	value ^= p_rmw_hdr->xor_value;
+	value |= le32_to_cpu(p_rmw_hdr->or_value);
+	value ^= le32_to_cpu(p_rmw_hdr->xor_value);
 
 	qla4_83xx_wr_reg_indirect(ha, waddr, value);
 
@@ -914,15 +945,18 @@ static void qla4_83xx_write_list(struct scsi_qla_host *ha,
 				 struct qla4_83xx_reset_entry_hdr *p_hdr)
 {
 	struct qla4_83xx_entry *p_entry;
+	char *p_end = (char *)p_hdr + le16_to_cpu(p_hdr->size);
 	uint32_t i;
 
 	p_entry = (struct qla4_83xx_entry *)
 		  ((char *)p_hdr + sizeof(struct qla4_83xx_reset_entry_hdr));
 
-	for (i = 0; i < p_hdr->count; i++, p_entry++) {
-		qla4_83xx_wr_reg_indirect(ha, p_entry->arg1, p_entry->arg2);
+	for (i = 0; i < le16_to_cpu(p_hdr->count) &&
+	     (char *)(p_entry + 1) <= p_end; i++, p_entry++) {
+		qla4_83xx_wr_reg_indirect(ha, le32_to_cpu(p_entry->arg1),
+					  le32_to_cpu(p_entry->arg2));
 		if (p_hdr->delay)
-			udelay((uint32_t)(p_hdr->delay));
+			udelay((uint32_t)le16_to_cpu(p_hdr->delay));
 	}
 }
 
@@ -930,15 +964,18 @@ static void qla4_83xx_read_write_list(struct scsi_qla_host *ha,
 				      struct qla4_83xx_reset_entry_hdr *p_hdr)
 {
 	struct qla4_83xx_entry *p_entry;
+	char *p_end = (char *)p_hdr + le16_to_cpu(p_hdr->size);
 	uint32_t i;
 
 	p_entry = (struct qla4_83xx_entry *)
 		  ((char *)p_hdr + sizeof(struct qla4_83xx_reset_entry_hdr));
 
-	for (i = 0; i < p_hdr->count; i++, p_entry++) {
-		qla4_83xx_read_write_crb_reg(ha, p_entry->arg1, p_entry->arg2);
+	for (i = 0; i < le16_to_cpu(p_hdr->count) &&
+	     (char *)(p_entry + 1) <= p_end; i++, p_entry++) {
+		qla4_83xx_read_write_crb_reg(ha, le32_to_cpu(p_entry->arg1),
+					     le32_to_cpu(p_entry->arg2));
 		if (p_hdr->delay)
-			udelay((uint32_t)(p_hdr->delay));
+			udelay((uint32_t)le16_to_cpu(p_hdr->delay));
 	}
 }
 
@@ -948,6 +985,7 @@ static void qla4_83xx_poll_list(struct scsi_qla_host *ha,
 	long delay;
 	struct qla4_83xx_entry *p_entry;
 	struct qla4_83xx_poll *p_poll;
+	char *p_end = (char *)p_hdr + le16_to_cpu(p_hdr->size);
 	uint32_t i;
 	uint32_t value;
 
@@ -959,21 +997,28 @@ static void qla4_83xx_poll_list(struct scsi_qla_host *ha,
 	p_entry = (struct qla4_83xx_entry *)((char *)p_poll +
 					     sizeof(struct qla4_83xx_poll));
 
-	delay = (long)p_hdr->delay;
+	delay = (long)le16_to_cpu(p_hdr->delay);
 	if (!delay) {
-		for (i = 0; i < p_hdr->count; i++, p_entry++) {
-			qla4_83xx_poll_reg(ha, p_entry->arg1, delay,
-					   p_poll->test_mask,
-					   p_poll->test_value);
+		for (i = 0; i < le16_to_cpu(p_hdr->count) &&
+		     (char *)(p_entry + 1) <= p_end; i++, p_entry++) {
+			qla4_83xx_poll_reg(ha, le32_to_cpu(p_entry->arg1),
+					   delay,
+					   le32_to_cpu(p_poll->test_mask),
+					   le32_to_cpu(p_poll->test_value));
 		}
 	} else {
-		for (i = 0; i < p_hdr->count; i++, p_entry++) {
-			if (qla4_83xx_poll_reg(ha, p_entry->arg1, delay,
-					       p_poll->test_mask,
-					       p_poll->test_value)) {
-				qla4_83xx_rd_reg_indirect(ha, p_entry->arg1,
+		for (i = 0; i < le16_to_cpu(p_hdr->count) &&
+		     (char *)(p_entry + 1) <= p_end; i++, p_entry++) {
+			if (qla4_83xx_poll_reg(ha,
+					       le32_to_cpu(p_entry->arg1),
+					       delay,
+					       le32_to_cpu(p_poll->test_mask),
+					       le32_to_cpu(p_poll->test_value))) {
+				qla4_83xx_rd_reg_indirect(ha,
+							  le32_to_cpu(p_entry->arg1),
 							  &value);
-				qla4_83xx_rd_reg_indirect(ha, p_entry->arg2,
+				qla4_83xx_rd_reg_indirect(ha,
+							  le32_to_cpu(p_entry->arg2),
 							  &value);
 			}
 		}
@@ -986,23 +1031,27 @@ static void qla4_83xx_poll_write_list(struct scsi_qla_host *ha,
 	long delay;
 	struct qla4_83xx_quad_entry *p_entry;
 	struct qla4_83xx_poll *p_poll;
+	char *p_end = (char *)p_hdr + le16_to_cpu(p_hdr->size);
 	uint32_t i;
 
 	p_poll = (struct qla4_83xx_poll *)
 		 ((char *)p_hdr + sizeof(struct qla4_83xx_reset_entry_hdr));
 	p_entry = (struct qla4_83xx_quad_entry *)
 		  ((char *)p_poll + sizeof(struct qla4_83xx_poll));
-	delay = (long)p_hdr->delay;
-
-	for (i = 0; i < p_hdr->count; i++, p_entry++) {
-		qla4_83xx_wr_reg_indirect(ha, p_entry->dr_addr,
-					  p_entry->dr_value);
-		qla4_83xx_wr_reg_indirect(ha, p_entry->ar_addr,
-					  p_entry->ar_value);
+	delay = (long)le16_to_cpu(p_hdr->delay);
+
+	for (i = 0; i < le16_to_cpu(p_hdr->count) &&
+	     (char *)(p_entry + 1) <= p_end; i++, p_entry++) {
+		qla4_83xx_wr_reg_indirect(ha, le32_to_cpu(p_entry->dr_addr),
+					  le32_to_cpu(p_entry->dr_value));
+		qla4_83xx_wr_reg_indirect(ha, le32_to_cpu(p_entry->ar_addr),
+					  le32_to_cpu(p_entry->ar_value));
 		if (delay) {
-			if (qla4_83xx_poll_reg(ha, p_entry->ar_addr, delay,
-					       p_poll->test_mask,
-					       p_poll->test_value)) {
+			if (qla4_83xx_poll_reg(ha,
+					       le32_to_cpu(p_entry->ar_addr),
+					       delay,
+					       le32_to_cpu(p_poll->test_mask),
+					       le32_to_cpu(p_poll->test_value))) {
 				DEBUG2(ql4_printk(KERN_INFO, ha,
 						  "%s: Timeout Error: poll list, item_num %d, entry_num %d\n",
 						  __func__, i,
@@ -1017,6 +1066,7 @@ static void qla4_83xx_read_modify_write(struct scsi_qla_host *ha,
 {
 	struct qla4_83xx_entry *p_entry;
 	struct qla4_83xx_rmw *p_rmw_hdr;
+	char *p_end = (char *)p_hdr + le16_to_cpu(p_hdr->size);
 	uint32_t i;
 
 	p_rmw_hdr = (struct qla4_83xx_rmw *)
@@ -1024,11 +1074,12 @@ static void qla4_83xx_read_modify_write(struct scsi_qla_host *ha,
 	p_entry = (struct qla4_83xx_entry *)
 		  ((char *)p_rmw_hdr + sizeof(struct qla4_83xx_rmw));
 
-	for (i = 0; i < p_hdr->count; i++, p_entry++) {
-		qla4_83xx_rmw_crb_reg(ha, p_entry->arg1, p_entry->arg2,
-				      p_rmw_hdr);
+	for (i = 0; i < le16_to_cpu(p_hdr->count) &&
+	     (char *)(p_entry + 1) <= p_end; i++, p_entry++) {
+		qla4_83xx_rmw_crb_reg(ha, le32_to_cpu(p_entry->arg1),
+				      le32_to_cpu(p_entry->arg2), p_rmw_hdr);
 		if (p_hdr->delay)
-			udelay((uint32_t)(p_hdr->delay));
+			udelay((uint32_t)le16_to_cpu(p_hdr->delay));
 	}
 }
 
@@ -1036,7 +1087,7 @@ static void qla4_83xx_pause(struct scsi_qla_host *ha,
 			    struct qla4_83xx_reset_entry_hdr *p_hdr)
 {
 	if (p_hdr->delay)
-		mdelay((uint32_t)((long)p_hdr->delay));
+		mdelay((uint32_t)((long)le16_to_cpu(p_hdr->delay)));
 }
 
 static void qla4_83xx_poll_read_list(struct scsi_qla_host *ha,
@@ -1046,6 +1097,7 @@ static void qla4_83xx_poll_read_list(struct scsi_qla_host *ha,
 	int index;
 	struct qla4_83xx_quad_entry *p_entry;
 	struct qla4_83xx_poll *p_poll;
+	char *p_end = (char *)p_hdr + le16_to_cpu(p_hdr->size);
 	uint32_t i;
 	uint32_t value;
 
@@ -1053,22 +1105,26 @@ static void qla4_83xx_poll_read_list(struct scsi_qla_host *ha,
 		 ((char *)p_hdr + sizeof(struct qla4_83xx_reset_entry_hdr));
 	p_entry = (struct qla4_83xx_quad_entry *)
 		  ((char *)p_poll + sizeof(struct qla4_83xx_poll));
-	delay = (long)p_hdr->delay;
+	delay = (long)le16_to_cpu(p_hdr->delay);
 
-	for (i = 0; i < p_hdr->count; i++, p_entry++) {
-		qla4_83xx_wr_reg_indirect(ha, p_entry->ar_addr,
-					  p_entry->ar_value);
+	for (i = 0; i < le16_to_cpu(p_hdr->count) &&
+	     (char *)(p_entry + 1) <= p_end; i++, p_entry++) {
+		qla4_83xx_wr_reg_indirect(ha, le32_to_cpu(p_entry->ar_addr),
+					  le32_to_cpu(p_entry->ar_value));
 		if (delay) {
-			if (qla4_83xx_poll_reg(ha, p_entry->ar_addr, delay,
-					       p_poll->test_mask,
-					       p_poll->test_value)) {
+			if (qla4_83xx_poll_reg(ha,
+					       le32_to_cpu(p_entry->ar_addr),
+					       delay,
+					       le32_to_cpu(p_poll->test_mask),
+					       le32_to_cpu(p_poll->test_value))) {
 				DEBUG2(ql4_printk(KERN_INFO, ha,
 						  "%s: Timeout Error: poll list, Item_num %d, entry_num %d\n",
 						  __func__, i,
 						  ha->reset_tmplt.seq_index));
 			} else {
 				index = ha->reset_tmplt.array_index;
-				qla4_83xx_rd_reg_indirect(ha, p_entry->dr_addr,
+				qla4_83xx_rd_reg_indirect(ha,
+							  le32_to_cpu(p_entry->dr_addr),
 							  &value);
 				ha->reset_tmplt.array[index++] = value;
 
@@ -1117,16 +1173,44 @@ static void qla4_83xx_process_reset_template(struct scsi_qla_host *ha,
 	int index, entries;
 	struct qla4_83xx_reset_entry_hdr *p_hdr;
 	char *p_entry = p_buff;
+	char *p_end;
+
+	if (!ha->reset_tmplt.buff || !ha->reset_tmplt.hdr || !p_buff) {
+		ql4_printk(KERN_ERR, ha, "%s: No valid reset template\n",
+			   __func__);
+		return;
+	}
 
 	ha->reset_tmplt.seq_end = 0;
 	ha->reset_tmplt.template_end = 0;
-	entries = ha->reset_tmplt.hdr->entries;
+	entries = le16_to_cpu(ha->reset_tmplt.hdr->entries);
 	index = ha->reset_tmplt.seq_index;
+	p_end = (char *)ha->reset_tmplt.buff +
+		le16_to_cpu(ha->reset_tmplt.hdr->size);
 
 	for (; (!ha->reset_tmplt.seq_end) && (index  < entries); index++) {
 
+		/* Both the entry count and each entry size come from flash,
+		 * so stop rather than walk past the end of the template.
+		 */
+		if (p_entry < (char *)ha->reset_tmplt.buff ||
+		    p_entry + sizeof(*p_hdr) > p_end) {
+			ql4_printk(KERN_ERR, ha, "%s: Entry %d is outside the template\n",
+				   __func__, index);
+			ha->reset_tmplt.seq_error++;
+			break;
+		}
+
 		p_hdr = (struct qla4_83xx_reset_entry_hdr *)p_entry;
-		switch (p_hdr->cmd) {
+		if (le16_to_cpu(p_hdr->size) < sizeof(*p_hdr) ||
+		    p_entry + le16_to_cpu(p_hdr->size) > p_end) {
+			ql4_printk(KERN_ERR, ha, "%s: Entry %d size %u is outside the template\n",
+				   __func__, index, le16_to_cpu(p_hdr->size));
+			ha->reset_tmplt.seq_error++;
+			break;
+		}
+
+		switch (le16_to_cpu(p_hdr->cmd)) {
 		case OPCODE_NOP:
 			break;
 		case OPCODE_WRITE_LIST:
@@ -1163,7 +1247,7 @@ static void qla4_83xx_process_reset_template(struct scsi_qla_host *ha,
 		}
 
 		/* Set pointer to next entry in the sequence. */
-		p_entry += p_hdr->size;
+		p_entry += le16_to_cpu(p_hdr->size);
 	}
 
 	ha->reset_tmplt.seq_index = index;
-- 
2.43.0

