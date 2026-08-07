Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 423672F30
	for <linux-scsi@vger.kernel.org>; Fri,  7 Aug 2026 22:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786143027; cv=none; b=K+hcgUktSUApocZK3bTurf4e3MkdFW8424R8wTli83b/GpuZ1+nHJ9pUwJldjlq5W2tjvt22HeZCMDLI3jLSdgjH7lKbEtScqs3PJnwx+TzFhNzYJ5D9klJY/YmoEkmy2jgHVGj7lHJry9/Z4XSRSJV8rGnDbFRDfp/B6Llt/94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786143027; c=relaxed/simple;
	bh=QjGJ03T/2j3pNZY8+iqLHHJNEYLwqT9cy2nmalH5ugw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=er0TbofOsNvWnfD03Ty0wtKWlT+fJXP2INjabKUBC24kuRywD4iW+cFJ6QIDagakL270fTSqMLhQxXYQXKv3cD71Wj2cVm+txOUyFLsopmPqcp6SKM3NocOyxwFOxI+DzWzqbDCS5BQoUt8ThZil6mortEY7W74+FYTGufQ8j1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=lecp9YCP; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="lecp9YCP"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hGzrK4xJQzlfvq0;
	Fri,  7 Aug 2026 22:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1786143019; x=1788735020; bh=SlB47
	i2sXpAPytPwA059VY14RHqpI5n9HrkL8Iywf1w=; b=lecp9YCPe+eF8feXznVz3
	VkSi5ys7LsQ769ExsoSEtCa9aG0+cfJgwhGIXUCpSUbv5J7Tu70o3TtDyx1z6FB9
	qLp7sDrH9Tiumr3KV8PPNSdotLsW6aIatbE5i0kO+m+TTGTWLAZPw71Zc/9SjFPn
	N8IxhcvqADRcmMp8eR3JQuKpm0lK2UJmXT8Dsc66mNxGuhZmAXtE34p5MeJS7Ddj
	YB8bTC87BQSRdZU3kegjFjvKdfZuD9V1nEM++cPrFVGyz9HUtbVoPevlYDDbQ3UT
	me5+nQZVYn/CzsJY0u2r14GeEwySdFtlY+dRpVP56S/qKCsb868NzNrduorUzQXT
	g==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id JgIPc-TOXcDu; Fri,  7 Aug 2026 22:50:19 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hGzr72QmVzlfvq8;
	Fri,  7 Aug 2026 22:50:15 +0000 (UTC)
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
Subject: [PATCH v7 1/6] ufs: core: Set task state before io_schedule_timeout()
Date: Fri,  7 Aug 2026 15:49:46 -0700
Message-ID: <8fe4526ce272811b28e99048b42358dd8f7c48af.1786142946.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.55.0.679.g6767b8d81c-goog
In-Reply-To: <cover.1786142946.git.bvanassche@acm.org>
References: <cover.1786142946.git.bvanassche@acm.org>
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
