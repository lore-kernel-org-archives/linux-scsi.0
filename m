Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE2891ABCD6;
	Tue, 18 Jun 2024 12:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714504; cv=none; b=iwdkWgmMETstqqGuqZzSVNlmf6AKarEy6DmcJcN7+1zE+GVgTNB/TwU2sQAmOZq8LFZzunCqmrly72z3VCqRJRlwYzRKtiOBrcShcKqgxb+V57teZ+lXnCpkm8qRJxxkmuyTNfN19MuaD2F7TTvv/f7UL30mpLBqt7wKx85+Zg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714504; c=relaxed/simple;
	bh=+2uQ5tHZtMTt2bmW/5BElXi1TPUpOsm5QPSwJ4r75p4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JJmgj5adh9/+D1fV37aOywSid5yjnyvRikC7cytKbReQoWJBeJVqH9YzMDqUwhdg8ZLoxZunOh3xbYTUzdT5B9ysyzfhUrIPAZKYF3WFbt9q4VGmJkM0KfYNnYhsIg9AexsmP4n+hCO+sYn6kpbK1zbzlpfmv+qfOFplwBGaxYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X5ARYYct; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X5ARYYct"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 648C2C4AF51;
	Tue, 18 Jun 2024 12:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718714503;
	bh=+2uQ5tHZtMTt2bmW/5BElXi1TPUpOsm5QPSwJ4r75p4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X5ARYYctH16Etw9LYwvqI0TA+pJY2GjgeBmrEbCw0sr27l5+VTlqyUBdH/IF8JJh7
	 GGP1k9HjapC+SXQ3x0DS1ihHRGH4wGMAemviCX1ubEYbhxRPZs+NXxCe8jHOuCJ4Yy
	 X4m5pkGnHLYHi4CwGAmV3yVt8gjKX+ZsEv1lnNEFR36empfH8ba1F8UfRg0xzpOdnx
	 1arwa2zxZvC9SNDdaMhlxttNuQlkDO67/Dl8fju3cWKaTl3CFd4+HNHaS1rjDezO66
	 UAlmqw0j1AUsrFI6Gz227D5I5CagGYDBraWcyRWk43ny4NL/AX798gbk0Aai7UittM
	 L4va4zhFvFtcA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Saurav Kashyap <skashyap@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	jhasan@marvell.com,
	GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 02/21] scsi: qedf: Don't process stag work during unload and recovery
Date: Tue, 18 Jun 2024 08:41:01 -0400
Message-ID: <20240618124139.3303801-2-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240618124139.3303801-1-sashal@kernel.org>
References: <20240618124139.3303801-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.15.161
Content-Transfer-Encoding: 8bit

From: Saurav Kashyap <skashyap@marvell.com>

[ Upstream commit 51071f0831ea975fc045526dd7e17efe669dc6e1 ]

Stag work can cause issues during unload and recovery, hence don't process
it.

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://lore.kernel.org/r/20240515091101.18754-2-skashyap@marvell.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedf/qedf_main.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 18380a932ab61..ab43e15fa8f36 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -4001,6 +4001,22 @@ void qedf_stag_change_work(struct work_struct *work)
 	struct qedf_ctx *qedf =
 	    container_of(work, struct qedf_ctx, stag_work.work);
 
+	if (!qedf) {
+		QEDF_ERR(&qedf->dbg_ctx, "qedf is NULL");
+		return;
+	}
+
+	if (test_bit(QEDF_IN_RECOVERY, &qedf->flags)) {
+		QEDF_ERR(&qedf->dbg_ctx,
+			 "Already is in recovery, hence not calling software context reset.\n");
+		return;
+	}
+
+	if (test_bit(QEDF_UNLOADING, &qedf->flags)) {
+		QEDF_ERR(&qedf->dbg_ctx, "Driver unloading\n");
+		return;
+	}
+
 	printk_ratelimited("[%s]:[%s:%d]:%d: Performing software context reset.",
 			dev_name(&qedf->pdev->dev), __func__, __LINE__,
 			qedf->dbg_ctx.host_no);
-- 
2.43.0

