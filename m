Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF79F3DA5C1
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 02:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792031280; cv=none; b=OPs4OBwFVQURpVtSl8Za1mFhY9g0zxfk3V/uD/sLRNph4+6IXoWIWela7sj4ujQlkYnwIW34JY3dmhNRni5nQFR7ztrSo7amVT+p5+70rp5JH5V7jB6Jg4UK2TxIqty4nR2HOuVMrc0uZwQu3uj6th8DC+hwBVFv4/iep/zRNx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792031280; c=relaxed/simple;
	bh=MDMjvCG2TCUAEeteskqIDIApECR9YheEmBxAhgDy9Lg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lgSw57GseVxlQ6XDGNgwaCC3dP/MtnufXTjCKD6u8q1xc6BWik270xV+RePkLuaCXa08GbLRefpT+XfGar8MmeErOz44YDLILOYnPWQEVRj/rs3BoAZNijOpiQpRJV4Kymga05ayBqJLitasOhuuzKSM3XvKnMLB9yPe/D7z6zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=mBZn91Cd; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="mBZn91Cd"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cd623dfe420so1271101a12.0
        for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 19:27:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792031276; x=1792636076; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aEUqd/0o0iSnmGjCyVkzuHqVdm5ujeHCGbGGtInTt5o=;
        b=mBZn91CdNB4osK+8+OhZYabu0Q8jrHcWLZTXe8s6F0bBlx4g3dE3JQq6JDWTqwaVHy
         B1XPRINCfLsAbNml13kgEWDNA6mhEN1GHxc8aEqfm8me1s8gSguRUhV6ICoQzFUT0a/e
         hFMI9RkCtuESyboooIFuso6WGoIqGDP84m24yljLD2qU4/Af0N+NzgnEB82/9cUmqDdg
         ik6+oLuoAFI1tDYxWc//O56CQwG2OHR0F+C5Mk79gjDQLzPbLIaCknouGueSVvkVK/qJ
         9QcdQMuDEgJvyJLEcojOqp8WxZV614EGknY/fv09EUCU0z1abFeX8XaQnSnikS2DKWaI
         xtOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792031276; x=1792636076;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=aEUqd/0o0iSnmGjCyVkzuHqVdm5ujeHCGbGGtInTt5o=;
        b=egZyEidbHO/XxsPyp/puQCbqCslCHKEnJEoUEjy9nWUL9+iBhDNmU3o+ooanY6IBMp
         zqq7P4hjWv0yMeOPqxcZIOQj9OyNxS1NnArHFCkFhCRDNxDg2yu9EMCaexau1glgLGXz
         GWyzALpreZzg/NNL3eRLiL5N1DlzTDNGDz8GJSpVbYvYtOk59+MMwic0y2swo4OxPoir
         H2HfoHvbHuSqz5CPtvqDhuOYBRZ+KuMBbaXcD0iKk1i71yTrS6AaAFY+z9nbXv/CdddE
         j4viBmBtwpEZW3Dj7ZO4Crmn138wf2n+brPM+QAcJVSrkTd/x5Wpxg2aRBrV/9QY9kYV
         pg0Q==
X-Gm-Message-State: AFq9FYJXN5jBCwvlnNNIe72Hv29XSWQWp/gSZj60Ht+56zOEnF44F9+B
	lIJ2lU2l484mN2wBURYIAiyoHOtacrRI73PvItCN5c1WyE3eCb2aTTZGabFi56P+xtA=
X-Gm-Gg: AYBFou0gjav9nKM1Yu+woR5I7HeckoSnpbLz+0Z+ImFP/WMWx7pEq2VT5gcdlMYtPoU
	hFypz1yQpQ/gnuJI5YUh0sn25adsoc9YegAqMn5TfggnCxKtJ70jonyamjkRM2pNss8FvlWVqji
	+ZQiXShyFupTZybjGALQhZQn+Wn8XCFfhIcEtZzJkulIBTIHnDQWKazyv6B84NFUdc1n+xMM5da
	Ahm17Xj4Og3MvsSLAxsP1hUJQ/rCgovZlkbTl3NRlpNgEaWTuKNbCG8uf7Pcd+VR5qLjO4cr4lM
	RWwEQWFp5qVUWCo1X+9sa1vrr/4xUJP5N0OWYA+q4yTiKugB42Uw/AdEwBifvg+nPswDgCh696b
	7neS2MvblNve8A45UASRHXzspsiLLNAW/WshhzxtcVkoXWJD7+XoQQma8yOhk3F2bkpA0GEk7dg
	FuBOSllX9K2TlUDJNXWGp1V/9tTjqBlxDjFdq/H0K8HxYBXF8zClbe46h4TXqW6rDRJ2G+X7IgR
	aw4RQ==
X-Received: by 2002:a17:90b:3145:b0:3a4:b0b9:6b3e with SMTP id 98e67ed59e1d1-3ab3ab40fa2mr14795649a91.36.1792031276325;
        Wed, 14 Oct 2026 19:27:56 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac94375f3fsm1997383a91.4.2026.10.14.19.27.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 19:27:56 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v8 6/8] scsi: mvumi: validate the response frame tag before using it
Date: Thu, 15 Oct 2026 11:27:26 +0900
Message-ID: <20261015022728.3936714-7-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261015022728.3936714-1-yhlee@isslab.korea.ac.kr>
References: <20261015022728.3936714-1-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mvumi_handle_clob() indexes mhba->tag_cmd[] with the tag of a response
frame the firmware DMAs into the outbound list.  The array holds
tag_pool.size entries, and the only check on that tag runs earlier, in
mvumi_receive_ob_list_entry() and mvumi_check_ob_frame(), against the frame
still sitting in the outbound list.  mvumi_receive_ob_list_entry() then
copies the frame into an ob_data buffer and mvumi_handle_clob() reads the
tag out of that copy, so the value that is checked and the value that is
used are two separate fetches of firmware-writable memory.  A firmware that
changes the tag after the check reaches tag_cmd[] with any u16, reads a
pointer past the array and dereferences it, writes NULL past the array and
pushes the tag onto the free stack for a later command to pick up.  The
check is also off by one: tag_cmd[] and tag_pool.stack[] both hold
tag_pool.size entries, so a tag equal to tag_pool.size passes a > test and
lands one entry past both.

Check the tag that mvumi_handle_clob() actually uses, against the size of
the array it indexes, and check the command it finds for NULL before
dereferencing it: with two fetches the earlier NULL check no longer says
anything about this one.  Re-check request_id against that command too,
where the controller provides one, for the same reason the earlier check
does: a tag changed between the check and the copy can land on a different
command that is also live, and then only request_id tells the two apart.
Make the two existing bounds checks >= so a tag equal to the entry count is
rejected there too, and read the tag into a local in
mvumi_receive_ob_list_entry() as well, so the check there and the accesses
beside it see one value instead of three fetches.  Use READ_ONCE() for the
tag and request_id both functions take out of the outbound list, so the
single fetch is guaranteed rather than left to the compiler.

Fixes: f0c568a478f0 ("[SCSI] mvumi: Add Marvell UMI driver")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/scsi/mvumi.c | 45 ++++++++++++++++++++++++++++++++++----------
 1 file changed, 35 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 8b8e5545747e8..2410d2aa147d9 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -466,9 +466,9 @@ static char mvumi_check_ob_frame(struct mvumi_hba *mhba,
 
 	udelay(1);
 	p_outb_frame = mhba->ob_list + cur_obf * mhba->ob_max_size;
-	request_id = p_outb_frame->request_id;
-	tag = p_outb_frame->tag;
-	if (tag > mhba->tag_pool.size) {
+	request_id = READ_ONCE(p_outb_frame->request_id);
+	tag = READ_ONCE(p_outb_frame->tag);
+	if (tag >= mhba->tag_pool.size) {
 		dev_err(&mhba->pdev->dev, "ob frame data error\n");
 		return -1;
 	}
@@ -530,6 +530,7 @@ static void mvumi_receive_ob_list_entry(struct mvumi_hba *mhba)
 	struct mvumi_ob_data *ob_data;
 	struct mvumi_rsp_frame *p_outb_frame;
 	struct mvumi_hw_regs *regs = mhba->regs;
+	unsigned short tag;
 
 	if (mhba->instancet->check_ob_list(mhba, &cur_obf, &assign_obf_end))
 		return;
@@ -546,10 +547,11 @@ static void mvumi_receive_ob_list_entry(struct mvumi_hba *mhba)
 		/* Copy pointer may point to entry in outbound list
 		*  before entry has valid data
 		*/
-		if (unlikely(p_outb_frame->tag > mhba->tag_pool.size ||
-			mhba->tag_cmd[p_outb_frame->tag] == NULL ||
-			p_outb_frame->request_id !=
-				mhba->tag_cmd[p_outb_frame->tag]->request_id))
+		tag = READ_ONCE(p_outb_frame->tag);
+		if (unlikely(tag >= mhba->tag_pool.size ||
+			     !mhba->tag_cmd[tag] ||
+			     mhba->tag_cmd[tag]->request_id !=
+			     READ_ONCE(p_outb_frame->request_id)))
 			if (mvumi_check_ob_frame(mhba, cur_obf, p_outb_frame))
 				continue;
 
@@ -1878,6 +1880,7 @@ static void mvumi_handle_clob(struct mvumi_hba *mhba)
 	struct mvumi_rsp_frame *ob_frame;
 	struct mvumi_cmd *cmd;
 	struct mvumi_ob_data *pool;
+	unsigned short tag;
 
 	while (!list_empty(&mhba->free_ob_list)) {
 		pool = list_first_entry(&mhba->free_ob_list,
@@ -1886,11 +1889,33 @@ static void mvumi_handle_clob(struct mvumi_hba *mhba)
 		list_add_tail(&pool->list, &mhba->ob_data_list);
 
 		ob_frame = (struct mvumi_rsp_frame *) &pool->data[0];
-		cmd = mhba->tag_cmd[ob_frame->tag];
+		/*
+		 * The tag was checked against the frame in the outbound list.
+		 * This is the copy, so check the value that is used.
+		 */
+		tag = ob_frame->tag;
+		if (tag >= mhba->tag_pool.size) {
+			dev_err(&mhba->pdev->dev,
+				"ob frame tag[0x%x] out of range\n", tag);
+			continue;
+		}
+		cmd = mhba->tag_cmd[tag];
+		if (!cmd) {
+			dev_err(&mhba->pdev->dev,
+				"ob frame tag[0x%x] with no command\n", tag);
+			continue;
+		}
+		if (mhba->request_id_enabled &&
+		    ob_frame->request_id != cmd->request_id) {
+			dev_err(&mhba->pdev->dev,
+				"ob frame tag[0x%x] request ID 0x%x != 0x%x\n",
+				tag, ob_frame->request_id, cmd->request_id);
+			continue;
+		}
 
 		atomic_dec(&mhba->fw_outstanding);
-		mhba->tag_cmd[ob_frame->tag] = NULL;
-		tag_release_one(mhba, &mhba->tag_pool, ob_frame->tag);
+		mhba->tag_cmd[tag] = NULL;
+		tag_release_one(mhba, &mhba->tag_pool, tag);
 		if (cmd->scmd)
 			mvumi_complete_cmd(mhba, cmd, ob_frame);
 		else
-- 
2.43.0

