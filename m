Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A2A3B0AD0
	for <linux-scsi@vger.kernel.org>; Fri,  7 Aug 2026 22:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786142710; cv=none; b=TurM5Q5GbRVJgQgxfj8leXJW7D8nHcqC3CRHfjqeRDWekiUuAyRMbbptbs0BzMkEgs082orzSjg7d93Dj9o9gIP9u8CpCjp2yOC2HAbDQXBUPZe2dOmmahZxvh47KkvH0CIkCkWNRgjjWtTcuJHID35UcUJgimNLjGFiLdM2IyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786142710; c=relaxed/simple;
	bh=QjGJ03T/2j3pNZY8+iqLHHJNEYLwqT9cy2nmalH5ugw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LSMKkC2sUElCOf7PIqABn42VQuJX5lGSCxR54hS7BYHJ3gER6jIxVj0oPQ0tq9cn0M0SIRp6yrvCc+AV76ZWJgQkY7278shhUYft4WHu5D0D5r9loUbUFhCgb4KMvPPOHV7VAs1kz3xy/Gg+2EG/dmnS5kMXUVf4UYupeUy+py8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=MknQMV5o; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="MknQMV5o"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hGzkD3qmlz1XM4Tn;
	Fri,  7 Aug 2026 22:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1786142701; x=1788734702; bh=SlB47
	i2sXpAPytPwA059VY14RHqpI5n9HrkL8Iywf1w=; b=MknQMV5o1L8ryO1K1HckX
	IBhciEeJ71crRmtGaTUHyCexVKa/RcPX5R/JPJW1cThcl75wW6vk8lMPj0mVdkVq
	9QSTnQWVleeEHdL6XQrX1muDbGor0jxR4lXuEJ8/poC+D7j+OEmf1IzS9ltAXEJu
	bARLzG8WhQf9995s3QhqSbQB5sD8kW+Muit+fEujRGcu8B/EIafG0Ove6r4xNZMn
	xqiN9ObQBxAjqLKbSeIRkS2Ce5ZsjCG7NFxTXkM6iNAtoj0jQpINKHUW4iJT9SRk
	bRHiEsCyYy8qRuxq8kvLlcBcGYxe4qGOReijpS8S6nGHK/FRd7tud5x1y+MZFiDj
	g==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id p12az7hMYi5W; Fri,  7 Aug 2026 22:45:01 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hGzk16fy9z1XM6JP;
	Fri,  7 Aug 2026 22:44:57 +0000 (UTC)
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
	Bean Huo <beanhuo@micron.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Can Guo <can.guo@oss.qualcomm.com>,
	Hyeoncheol Jeong <hyenc.jeong@samsung.com>,
	Stanley Jhu <chu.stanley@gmail.com>
Subject: [PATCH v6 1/6] ufs: core: Set task state before io_schedule_timeout()
Date: Fri,  7 Aug 2026 15:44:18 -0700
Message-ID: <8fe4526ce272811b28e99048b42358dd8f7c48af.1786142607.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.55.0.679.g6767b8d81c-goog
In-Reply-To: <cover.1786140825.git.bvanassche@acm.org>
References: <cover.1786140825.git.bvanassche@acm.org>
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
index a51e071916cf..2c5d8e0e696e 100644
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
