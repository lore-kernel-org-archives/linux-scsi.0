Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F27556BA8
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 15:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791991186; cv=none; b=qdxh5BI/6jnPKT2kCJoT2cqY0GB09y/KhoqNTrZe0HZkpqY0lHrclFjP+46qZKW1FaPXgKDDz1u40kMevPm+C+r+W0xFlPLyznNw0q5JnVbt3agpv7Avbw1xHaRjCjVvWeUHr2Uk2Jt5OLoUMLtptPsdtHyNw344ylKhQwjo0zE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791991186; c=relaxed/simple;
	bh=1qtcQGTTfLfJhXZQIz7jgPeEmlUMJNph+9KnWiMafH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dKs6kvLsa2MOfv1wWQSDKuqZ+B6DmF+GxQuaO8EMW1tYv3l26YVGwhAOERkvG9flq4qkNKGavsQudWujCrOtinA4zAqMFh0hKOwlHm+GCGCkDQqcoINtMEXa3McNz2GQniOXAH/VBgbeG7RHpW+i1WOM+L5Oy7kUTRj1MnxWMho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=Iz5/YJ2i; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="Iz5/YJ2i"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3a4b9732d5aso3264295a91.3
        for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 08:19:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791991184; x=1792595984; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tdW1raeqaDmKMeOAWjGpiHBZvfxWS70bbozlu+Hi+Fc=;
        b=Iz5/YJ2iIEgliWU8QHH0OaV2ZNJdYqYVl+m9GBYMdtFn0DfNX7GZuSbPANCEGjrcfz
         werUfuQ3SrJ+pdDh7YftEh8zVXun+Kb1jCosGefsOJ/O9az/P2PVivt0jPtGm4vnhmhY
         0Nbqttq5W2guWLD7CkRXdc5/MxeJW0yyP6948LycmDkX96kr12+jAiHR6YoO6kCX0Qz2
         Qso93KUOKoF+HZkX+WlwdbxKz4hcMb7VVs5jP+zAF8c0PTMFlzi1qeDIzCTMFEf2crt1
         GP5l7iDYcKCm3FiJqzp1le5dnmCbwfUe3sHzMJzblyaICQ8fGdAV2UCLmVHFNgVCYt7M
         wEDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791991184; x=1792595984;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tdW1raeqaDmKMeOAWjGpiHBZvfxWS70bbozlu+Hi+Fc=;
        b=0uMByEZ8/vg0BVB2uGm8U/lwxdEFJlcZxZDKZt8LTkxcePiSnErsQ16KEvhwAq7nWi
         1Jf7AVObdMR++2owmz1wS/MhVhYDUbWsL9To9pBPtLhHC54wUgo+EWGjjbuiE7dtVcCF
         xU56C2G2DFTslo/QASWcsXG20Ux94syIc6tg+dpArZRrOYru0opGEC0SaDXWNegr/dUn
         8wr79/v5qLTl4+gBeJmjcISmNZ2awmlgpqhZ+M6P1+MH1mjOqk8Hv9ijQ5l7MsnHxZcu
         yMHUm8ip+Fss4tkTX93dqsavO5sLGG6ifCHDm7MQIHrAwfCJ3Y+cwaNZ87Pq2ytvdKNO
         EAnw==
X-Gm-Message-State: AFq9FYLxJar8AsLgRuX3ICwg9q6UlxX74bczK7n4L6y9Vfn8ffm/W9DG
	ZmFwy+FeM0U91mu5OsXhRqwCYwwaYSzyQY3avBRJEh/3gD9eF7TU2UT25QvW15eT2rI=
X-Gm-Gg: AYBFou2HXCdWuOnyW1lVU9HifMOxTZZ95XwLwuxSVhYTm41d+ZDpOKqm1K8KXTHlQ2Q
	Ak4qMnhLTfQhRXx62ZO9wmW4AyU2kZXFIvP9ItCoBHspXpdpT8tdre3gAh/RxUydxFWNmBfhUh4
	iq1D8zwWX24ZhqDQ9ogg+T3xNGB7SpsDvnEplhN3uYNL56MF3O+x1SvpLNriaPX9mjGZmMn18VG
	ve7nsMcSMXlXo9UrodHHJaK0KfuDv/6SF3pODbK7UFYcNUwBsI2VwW3CnTyEo9sJcRegnT1sypi
	KHbndvfiAHwfAExKSqNIGqdnSECbR3lRopYOyK5Gv2wvSZnwyHGRGIb9l3Cc7Br+i8/WXQENjPA
	GXRyTVLW1dqoAcGKuFZGnAev5Uzy696S+ExfvHgzVBntJS7O0nq4wJqHhaJx0obc3MGle+oPScW
	1eQ11zW4XXvdWEhUbeJQu/4izshM7MOqIvyBoO+RJp2lLxGE2qB1sxDWnlzBtmr92PscjiucOJp
	BGtNFvnX6z/I9B3WSDo
X-Received: by 2002:a17:90a:e7cb:b0:3aa:f2c4:12f4 with SMTP id 98e67ed59e1d1-3ab3a95369emr15805387a91.31.1791991183542;
        Wed, 14 Oct 2026 08:19:43 -0700 (PDT)
Received: from localhost.localdomain ([2406:5900:1044:110c:1c49:61ee:8c8:3f4c])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac8d40e7f3sm622450a91.5.2026.10.14.08.19.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 08:19:43 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v5 5/6] scsi: mvumi: validate the response frame tag before using it
Date: Thu, 15 Oct 2026 00:19:13 +0900
Message-ID: <20261014151914.3632701-6-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261014151914.3632701-1-yhlee@isslab.korea.ac.kr>
References: <20261014151914.3632701-1-yhlee@isslab.korea.ac.kr>
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
anything about this one.  Make the two existing bounds checks >= so a tag
equal to the entry count is rejected there too, and read the tag into a
local in mvumi_receive_ob_list_entry() as well, so the check there and the
accesses beside it see one value instead of three fetches.

Fixes: f0c568a478f0 ("[SCSI] mvumi: Add Marvell UMI driver")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/scsi/mvumi.c | 34 ++++++++++++++++++++++++++--------
 1 file changed, 26 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index e63b3ba7eaabd..07cfac9276e7b 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -468,7 +468,7 @@ static char mvumi_check_ob_frame(struct mvumi_hba *mhba,
 	p_outb_frame = mhba->ob_list + cur_obf * mhba->ob_max_size;
 	request_id = p_outb_frame->request_id;
 	tag = p_outb_frame->tag;
-	if (tag > mhba->tag_pool.size) {
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
+		tag = p_outb_frame->tag;
+		if (unlikely(tag >= mhba->tag_pool.size ||
+			     !mhba->tag_cmd[tag] ||
+			     mhba->tag_cmd[tag]->request_id !=
+			     p_outb_frame->request_id))
 			if (mvumi_check_ob_frame(mhba, cur_obf, p_outb_frame))
 				continue;
 
@@ -1848,6 +1850,7 @@ static void mvumi_handle_clob(struct mvumi_hba *mhba)
 	struct mvumi_rsp_frame *ob_frame;
 	struct mvumi_cmd *cmd;
 	struct mvumi_ob_data *pool;
+	unsigned short tag;
 
 	while (!list_empty(&mhba->free_ob_list)) {
 		pool = list_first_entry(&mhba->free_ob_list,
@@ -1856,11 +1859,26 @@ static void mvumi_handle_clob(struct mvumi_hba *mhba)
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

