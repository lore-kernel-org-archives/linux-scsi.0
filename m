Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D160207646
	for <linux-scsi@vger.kernel.org>; Mon, 16 Dec 2024 18:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734374970; cv=none; b=rPBZu11ZcOElheTFdRcWvZ6uEnkiVkqXZi0nbyA4nkqcB5BEr1AlfFIMnmaKjfQrVOPiGvt4TJzQW1X1HRYR5Tr2nwqGCL0bpBTjdQaDzBV0A0M5fxsJvml59Xs5HHYaSp4lrK9ZNkIHuJxQPCijvoRaZQkU+ZqD6WpCAYtALW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734374970; c=relaxed/simple;
	bh=LXhwdgbjNmVzK8KlzILZalZTnJiV8CHkZ57MEUndJa8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lCCEVkqFyq3bRO71g/GpjtdeeFocnFaO7E98IGIwOvD8+LgF0kxuq0UKwOWfn28h0Z4OJmbQ/CxnsKVcyofomRyfjr3CXrbU1IES1RFjzthIM3tDkmBwm3peQ4dq+DLGj9f/jAji5QCG6v2Rog2cOBKZKsn9rRieYs2CL6zys/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=IAczrgVg; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="IAczrgVg"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4YBprf1fvhz6ClL92;
	Mon, 16 Dec 2024 18:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1734374960; x=1736966961; bh=UB8TTR4zlIXJDUOXD5whunCT5OCtpE6oGds
	CiG1qv5c=; b=IAczrgVg3XI52fMR2tTOHSUFFilFoS56IeesT9Mk0uc3mhQzfGh
	Q2fTsEeRrCrtX5EqGj61H//Q6D4ZIE/UIqqLAHx4YKXu/ym6GWo7vYEr7y8XGZzW
	dEJ6F9mYAoeqADvqcXZex7N4SiLO3QvQQ+dlYUXtA/bJxmqdvJ8zZuQ8oR/o39aw
	vy5K8SddAn0w+C0ObWEfQ+/sG2B0EDlj6YigFiHb8GWZVDKOt0lZ849I6ZOfUL4H
	EK155RUTRXEjiuUcN0EZCbUxaPYT+u0M6VRBnoChdX759V8j59QLTieW6u9BTt+e
	qsvnkV1rpyJ8SEKVoty+WG4eCY0+sCHOLyQ==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id iTPdaIYgRHPa; Mon, 16 Dec 2024 18:49:20 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4YBprZ4rB4z6ClL90;
	Mon, 16 Dec 2024 18:49:18 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] scsi: scsi_debug: Skip host/bus reset settle delay
Date: Mon, 16 Dec 2024 10:48:52 -0800
Message-ID: <20241216184852.2626339-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Skip the reset settle delay during error handling since the scsi_debug
driver doesn't need this delay.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_debug.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index af6a128be9b6..bf0ac6255137 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -8751,6 +8751,7 @@ static struct scsi_host_template sdebug_driver_temp=
late =3D {
 	.max_sectors =3D		-1U,
 	.max_segment_size =3D	-1U,
 	.module =3D		THIS_MODULE,
+	.skip_settle_delay =3D	1,
 	.track_queue_depth =3D	1,
 	.cmd_size =3D sizeof(struct sdebug_scsi_cmd),
 	.init_cmd_priv =3D sdebug_init_cmd_priv,
