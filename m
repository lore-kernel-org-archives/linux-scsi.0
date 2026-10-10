Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D6535200C
	for <linux-scsi@vger.kernel.org>; Sat, 10 Oct 2026 18:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791655919; cv=none; b=DsE47GOD6+3pRPD6QPLEOdG1tUH0hO+T4zm6z8Lv5FZzo21knX7tfbGE8FJ+l4jQJJs/Xrf1FBqwIqewh8DMLHj8a6c4qtew1mcZBHEE6RKpPax2k7sABkOhU+lwH0Rb/VXWf4P42FQv8dGhYk/VoGhzc+SZCGM7OGMNETFgx2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791655919; c=relaxed/simple;
	bh=wkVRrTpMgE+KPh0cRYiSGUFQ7jFRVYybu/LGXoBlcn0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=texTaEjoKV+80LqIa0J2NcmDY6N+viSk22EywxQf7JgG2ZeqDZx65cW70px8QRtC54wlu4ljrgllPdO8qoDo7LY565QFmmkrLrT4J3OeeHaMxMOVGEiJZZHnS1judTXDttQ2qy+qmpF2cfDdVq2KQy2cwYQnz0zQddIgikKFfzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=nyrI8VH+; arc=none smtp.client-ip=74.125.82.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="nyrI8VH+"
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-3514b90bb89so1193901eec.1
        for <linux-scsi@vger.kernel.org>; Sat, 10 Oct 2026 11:11:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791655915; x=1792260715; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=mUtw2tzDbt+OyXccbgY+BLRCZ5+kc31wvweZfcNZPV8=;
        b=nyrI8VH+MZdarO7pe3RFEUb6+qx8Y/RwLuIAWcj8Rgan2tV74vBvX+j113WgYHm2NO
         qeN9UsPBL/feYTZjjkloR9SdxntD6zcguhBN7v5m1vw77ZP3xbLxscV3A0QunVHLBOCL
         d8eL11O6Lhe+BlGP/FmgZyN1EkS/kTqzvkxgkKylvUVl6ePl0wMYoE5hi/eQ5ChphvkY
         kD4PLVEWWp/BZ3CJb3LRLyKPQIloewnHzNz9WEkrT+8z01nPH5uSGvaEA+1NRwWleP3F
         9laieGGXdw0r7ByTVlntGpZToTXWxPrTylhNyL3yrbAwWLpEOUxwkbcoVSOSouHbc4jJ
         RKWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791655915; x=1792260715;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mUtw2tzDbt+OyXccbgY+BLRCZ5+kc31wvweZfcNZPV8=;
        b=eMD8CaFzcUx1xiLb2m9bUjGmHgYqz/a84M2JTM+cMgzAx2tdsRJEWMqYuDSd36JJig
         GB/yBt8YyvwA6b3v8cJDT1dnsHwTcv/7jJ8IAjKsq51KP7MRb7Ug1nR3v3+mE50hihvn
         jY4zFyQazwA0Qg1E61EsDs9muGT+sVZirxMiD0hu6zfVcD7390snuOTueHHG3f94hMZA
         fT/ljGCTQOCPIXwzs6+lfaf5wJoR+xtnprWEREfW+pUcA0obAghhnEyylCmy76vc4T9R
         WcAj4aXeA1sW/z/1gspE5eiyb5Wd57ohy1CLM3X3LnaX8sWSroWgewGsEFi7vus19Yl6
         fKHw==
X-Forwarded-Encrypted: i=1; AKwUvByVsmL+QbytKXIGd5Oso//fYhlBz7jrKt0hspoqnHhoKXax0qRxGL7OOD9NSWEjSflvnnuXH2LZMKE8@vger.kernel.org
X-Gm-Message-State: AFq9FYKASAQfE91Y1uGl/ej401pLiSHfRObaZhu23KZTTE2Uut5JfmIU
	/xXgY8Or8JKO3aA6M3YmyymRHrpPYAJ58gD/SIWCe0gbD39qZ/DXa5Sq93mU9t2OFwE=
X-Gm-Gg: AYBFou05EfST4rsDUt6C0zDAJTMYbXqaCN9tEKwGFV/fb1njtHR/R3O4YIqDUSowgBX
	foqilY7tQiUVMFgAbfvZnrgtqZ22mRTSCAZBI9vvm52RYj148H2/4RPIqzSnhaUUnaOmiKpmM+f
	+xIc18HdZaDHiH7ZNLAW/ZgNRGO0sSH6nfCga1LZ4T9md8e8V+ZvNDLhHASfDzoamkurJkK5Mti
	NFEvcrgbzzRHkV8GrFaOzrec/R813CTavvf1kXMq/3NWTjzz88JSmYOBaDev1X1gC/0IcLQAcxX
	EP0Jn7hO+NnwBpCuL8JiG3R68wqvDAWB38CZ8bMCkiToWWqvr72v+/7N5wx3QJr0hHZ7TQt3rUp
	jOcBMJvDLXAnprt4Kh02vrm5EfRJodL1HPfKXNyBSypQL2+jSaitOF8NMKOND3SO1CAlhWMSepA
	xUqBhK1ecta1kDtoFDOqlOVfVK5XJ9KSWA6A7o1abXj7vW7gTQ0MXrvC7DKZsNNB8MgOiaPpFbO
	7k5GIHlIZOjlEk1tBKsa6M=
X-Received: by 2002:a05:693c:66db:20b0:353:8287:4fd6 with SMTP id 5a478bee46e88-35382875256mr5981121eec.9.1791655914608;
        Sat, 10 Oct 2026 11:11:54 -0700 (PDT)
Received: from localhost.localdomain ([2406:5900:1044:110c:9657:9541:a576:7d2f])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3537cacb61asm17939027eec.21.2026.10.10.11.11.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 11:11:54 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Nilesh Javali <njavali@marvell.com>,
	Manish Rangankar <mrangankar@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <mkp@kernel.org>,
	linux-scsi@vger.kernel.org
Cc: Mike Christie <michael.christie@oracle.com>,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Subject: [PATCH] scsi: qla4xxx: bound the ISP83xx reset template to its buffer
Date: Sun, 11 Oct 2026 03:11:38 +0900
Message-ID: <20261010181139.1911817-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
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
out-of-range array index.

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
 drivers/scsi/qla4xxx/ql4_83xx.c | 82 +++++++++++++++++++++++++++++----
 1 file changed, 74 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_83xx.c b/drivers/scsi/qla4xxx/ql4_83xx.c
index db41d90a5b6e9..7fbcc4e85b26a 100644
--- a/drivers/scsi/qla4xxx/ql4_83xx.c
+++ b/drivers/scsi/qla4xxx/ql4_83xx.c
@@ -773,7 +773,7 @@ static int qla4_83xx_reset_seq_checksum_test(struct scsi_qla_host *ha)
 void qla4_83xx_read_reset_template(struct scsi_qla_host *ha)
 {
 	uint8_t *p_buff;
-	uint32_t addr, tmplt_hdr_def_size, tmplt_hdr_size;
+	uint32_t addr, tmplt_hdr_def_size, tmplt_hdr_size, tmplt_size;
 	uint32_t ret_val;
 
 	ha->reset_tmplt.seq_error = 0;
@@ -815,6 +815,19 @@ void qla4_83xx_read_reset_template(struct scsi_qla_host *ha)
 		goto exit_read_template_error;
 	}
 
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
 	addr = QLA83XX_RESET_TEMPLATE_ADDR + ha->reset_tmplt.hdr->hdr_size;
 	p_buff = ha->reset_tmplt.buff + ha->reset_tmplt.hdr->hdr_size;
 	tmplt_hdr_def_size = (ha->reset_tmplt.hdr->size -
@@ -856,6 +869,11 @@ void qla4_83xx_read_reset_template(struct scsi_qla_host *ha)
 
 exit_read_template_error:
 	vfree(ha->reset_tmplt.buff);
+	ha->reset_tmplt.buff = NULL;
+	ha->reset_tmplt.hdr = NULL;
+	ha->reset_tmplt.init_offset = NULL;
+	ha->reset_tmplt.start_offset = NULL;
+	ha->reset_tmplt.stop_offset = NULL;
 
 exit_read_reset_template:
 	return;
@@ -894,6 +912,13 @@ static void qla4_83xx_rmw_crb_reg(struct scsi_qla_host *ha, uint32_t raddr,
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
@@ -914,12 +939,14 @@ static void qla4_83xx_write_list(struct scsi_qla_host *ha,
 				 struct qla4_83xx_reset_entry_hdr *p_hdr)
 {
 	struct qla4_83xx_entry *p_entry;
+	char *p_end = (char *)p_hdr + le16_to_cpu(p_hdr->size);
 	uint32_t i;
 
 	p_entry = (struct qla4_83xx_entry *)
 		  ((char *)p_hdr + sizeof(struct qla4_83xx_reset_entry_hdr));
 
-	for (i = 0; i < p_hdr->count; i++, p_entry++) {
+	for (i = 0; i < le16_to_cpu(p_hdr->count) &&
+	     (char *)(p_entry + 1) <= p_end; i++, p_entry++) {
 		qla4_83xx_wr_reg_indirect(ha, p_entry->arg1, p_entry->arg2);
 		if (p_hdr->delay)
 			udelay((uint32_t)(p_hdr->delay));
@@ -930,12 +957,14 @@ static void qla4_83xx_read_write_list(struct scsi_qla_host *ha,
 				      struct qla4_83xx_reset_entry_hdr *p_hdr)
 {
 	struct qla4_83xx_entry *p_entry;
+	char *p_end = (char *)p_hdr + le16_to_cpu(p_hdr->size);
 	uint32_t i;
 
 	p_entry = (struct qla4_83xx_entry *)
 		  ((char *)p_hdr + sizeof(struct qla4_83xx_reset_entry_hdr));
 
-	for (i = 0; i < p_hdr->count; i++, p_entry++) {
+	for (i = 0; i < le16_to_cpu(p_hdr->count) &&
+	     (char *)(p_entry + 1) <= p_end; i++, p_entry++) {
 		qla4_83xx_read_write_crb_reg(ha, p_entry->arg1, p_entry->arg2);
 		if (p_hdr->delay)
 			udelay((uint32_t)(p_hdr->delay));
@@ -948,6 +977,7 @@ static void qla4_83xx_poll_list(struct scsi_qla_host *ha,
 	long delay;
 	struct qla4_83xx_entry *p_entry;
 	struct qla4_83xx_poll *p_poll;
+	char *p_end = (char *)p_hdr + le16_to_cpu(p_hdr->size);
 	uint32_t i;
 	uint32_t value;
 
@@ -961,13 +991,15 @@ static void qla4_83xx_poll_list(struct scsi_qla_host *ha,
 
 	delay = (long)p_hdr->delay;
 	if (!delay) {
-		for (i = 0; i < p_hdr->count; i++, p_entry++) {
+		for (i = 0; i < le16_to_cpu(p_hdr->count) &&
+		     (char *)(p_entry + 1) <= p_end; i++, p_entry++) {
 			qla4_83xx_poll_reg(ha, p_entry->arg1, delay,
 					   p_poll->test_mask,
 					   p_poll->test_value);
 		}
 	} else {
-		for (i = 0; i < p_hdr->count; i++, p_entry++) {
+		for (i = 0; i < le16_to_cpu(p_hdr->count) &&
+		     (char *)(p_entry + 1) <= p_end; i++, p_entry++) {
 			if (qla4_83xx_poll_reg(ha, p_entry->arg1, delay,
 					       p_poll->test_mask,
 					       p_poll->test_value)) {
@@ -986,6 +1018,7 @@ static void qla4_83xx_poll_write_list(struct scsi_qla_host *ha,
 	long delay;
 	struct qla4_83xx_quad_entry *p_entry;
 	struct qla4_83xx_poll *p_poll;
+	char *p_end = (char *)p_hdr + le16_to_cpu(p_hdr->size);
 	uint32_t i;
 
 	p_poll = (struct qla4_83xx_poll *)
@@ -994,7 +1027,8 @@ static void qla4_83xx_poll_write_list(struct scsi_qla_host *ha,
 		  ((char *)p_poll + sizeof(struct qla4_83xx_poll));
 	delay = (long)p_hdr->delay;
 
-	for (i = 0; i < p_hdr->count; i++, p_entry++) {
+	for (i = 0; i < le16_to_cpu(p_hdr->count) &&
+	     (char *)(p_entry + 1) <= p_end; i++, p_entry++) {
 		qla4_83xx_wr_reg_indirect(ha, p_entry->dr_addr,
 					  p_entry->dr_value);
 		qla4_83xx_wr_reg_indirect(ha, p_entry->ar_addr,
@@ -1017,6 +1051,7 @@ static void qla4_83xx_read_modify_write(struct scsi_qla_host *ha,
 {
 	struct qla4_83xx_entry *p_entry;
 	struct qla4_83xx_rmw *p_rmw_hdr;
+	char *p_end = (char *)p_hdr + le16_to_cpu(p_hdr->size);
 	uint32_t i;
 
 	p_rmw_hdr = (struct qla4_83xx_rmw *)
@@ -1024,7 +1059,8 @@ static void qla4_83xx_read_modify_write(struct scsi_qla_host *ha,
 	p_entry = (struct qla4_83xx_entry *)
 		  ((char *)p_rmw_hdr + sizeof(struct qla4_83xx_rmw));
 
-	for (i = 0; i < p_hdr->count; i++, p_entry++) {
+	for (i = 0; i < le16_to_cpu(p_hdr->count) &&
+	     (char *)(p_entry + 1) <= p_end; i++, p_entry++) {
 		qla4_83xx_rmw_crb_reg(ha, p_entry->arg1, p_entry->arg2,
 				      p_rmw_hdr);
 		if (p_hdr->delay)
@@ -1046,6 +1082,7 @@ static void qla4_83xx_poll_read_list(struct scsi_qla_host *ha,
 	int index;
 	struct qla4_83xx_quad_entry *p_entry;
 	struct qla4_83xx_poll *p_poll;
+	char *p_end = (char *)p_hdr + le16_to_cpu(p_hdr->size);
 	uint32_t i;
 	uint32_t value;
 
@@ -1055,7 +1092,8 @@ static void qla4_83xx_poll_read_list(struct scsi_qla_host *ha,
 		  ((char *)p_poll + sizeof(struct qla4_83xx_poll));
 	delay = (long)p_hdr->delay;
 
-	for (i = 0; i < p_hdr->count; i++, p_entry++) {
+	for (i = 0; i < le16_to_cpu(p_hdr->count) &&
+	     (char *)(p_entry + 1) <= p_end; i++, p_entry++) {
 		qla4_83xx_wr_reg_indirect(ha, p_entry->ar_addr,
 					  p_entry->ar_value);
 		if (delay) {
@@ -1117,15 +1155,43 @@ static void qla4_83xx_process_reset_template(struct scsi_qla_host *ha,
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
 	entries = ha->reset_tmplt.hdr->entries;
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
+		if (le16_to_cpu(p_hdr->size) < sizeof(*p_hdr) ||
+		    p_entry + le16_to_cpu(p_hdr->size) > p_end) {
+			ql4_printk(KERN_ERR, ha, "%s: Entry %d size %u is outside the template\n",
+				   __func__, index, le16_to_cpu(p_hdr->size));
+			ha->reset_tmplt.seq_error++;
+			break;
+		}
+
 		switch (p_hdr->cmd) {
 		case OPCODE_NOP:
 			break;
-- 
2.43.0

