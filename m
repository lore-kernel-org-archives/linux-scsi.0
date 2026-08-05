Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 100D43E51EC
	for <linux-scsi@vger.kernel.org>; Wed,  5 Aug 2026 21:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785965851; cv=none; b=DcdisJPxfxwZouxUbdFCXGYzSqYh19DoSmOmLhyHsykU8bnL0aICfqUJ5I/4PVHvyOZosER2F2+UZO12QtHHp7kzM+05yT5GZRacIbnoflHBd7B+4bTem2U/5chqwpZkM5CegA0OtqAVxLiHrMhXOH9OIxFcMg2KwihmlL3VhC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785965851; c=relaxed/simple;
	bh=wtG0GLaiiIXPsrH4SnvnNdb0NlosWUXMgng1w9pPD6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VHdUXZS/Ho+7xlvRDMMq+gheSY+njxIBVfbBv8s/9xQpBjRyMc7bB0yzICDjMnz7etPbddqpM96rqxTwQxgMxQhgtdqMwKAdtHKvphSG666TRlHJH8eSCl9+WXRZ1A+xtdZXyA7m1b4z0dfk0P4oOBDQmtYzOCqbDwVwAy+Tw9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=HW7iJ6eY; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="HW7iJ6eY"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hFkK51bpSz1XM4TB;
	Wed,  5 Aug 2026 21:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1785965842; x=1788557843; bh=hwWUy
	2F7EHIKzl+j9wMO/Ap3pSuYRjbaZik6m4oqvnU=; b=HW7iJ6eYKxokVdZyEDtDf
	EtHLQWyL4ZQi+/qkJO+Kk9qrg/i2aNsZkGgIcOEv2mFItRLDvck/SKQxGQW8U2EH
	G7ECta8AP+dSXkJET3n3ikX4lZaxWCBfFhFzS2A5gsnAPIPx77ixzWIFe8tGAV8Z
	czr/bsTuBf/nFH5t+Lz/KjVlIcNf79hEO7l5/JRv6ne5pQtynBcWY7GnqVV89OkO
	rBzOUj8aVYf4NmFfNrPTn9sSxBmr3c9I9pYWKfRlVSYuWJqiPHGzXxJXwlpcG26b
	G9e5RRAWT7nOsVxpDJ2ElBeS+zRwEqCa5CXsojVKsCBAHY/dfnCfPTCf03XUtCp4
	w==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id bEmG-Dg7aTdn; Wed,  5 Aug 2026 21:37:22 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hFkJv1jClz1XM30n;
	Wed,  5 Aug 2026 21:37:18 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: John Garry <john.g.garry@oracle.com>,
	Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Peter Wang <peter.wang@mediatek.com>,
	Sashiko <sashiko-bot@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>,
	Can Guo <can.guo@oss.qualcomm.com>,
	Stanley Jhu <chu.stanley@gmail.com>
Subject: [PATCH v5 1/6] ufs: core: Set task state before io_schedule_timeout()
Date: Wed,  5 Aug 2026 14:36:48 -0700
Message-ID: <b0271215996bd4656e644a7686be45e758032bfa.1785965531.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.55.0.629.g250fe7f194-goog
In-Reply-To: <cover.1785965531.git.bvanassche@acm.org>
References: <cover.1785965531.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Set the task state to TASK_UNINTERRUPTIBLE before calling
io_schedule_timeout() in ufshcd_wait_for_pending_cmds().
Without setting the task state, io_schedule_timeout() returns
immediately because the task state remains TASK_RUNNING. This
results in a busy loop that wastes CPU cycles.

Fixes: 2000bc309703 ("scsi: ufs: core: Reduce the clock scaling latency")
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 1a5a851d43b2..5f99aad26d57 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1317,6 +1317,7 @@ static int ufshcd_wait_for_pending_cmds(struct ufs_=
hba *hba,
 			break;
 		}
=20
+		__set_current_state(TASK_UNINTERRUPTIBLE);
 		io_schedule_timeout(msecs_to_jiffies(20));
 		if (ktime_to_us(ktime_sub(ktime_get(), start)) >
 		    wait_timeout_us) {
