Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D85740C03;
	Thu,  7 Mar 2024 20:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709843432; cv=none; b=EyhekvQAH6YE9alJEA0ARLZ3YmJPW++5PxzmRcXHqCXknBcngwi2Wpo09CsGzZTYZ04Hl9O9Ni8m2nY1J3SLUNj9Fj5jcsmCUg//A5dMHg69vMltf/wqAsmKjkRso38AU0y4IEs4m3aNWzrKYhgFqLX+K7mqUjdi+ifM25oloqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709843432; c=relaxed/simple;
	bh=3MSS6t14wKZ7Oox3rcUR9L2Af6xTqNIfQh30fiv7mHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MXM1RgUfok6jhwGWiH0NNb34xyOwdfHUaHLwFMKSvi558KlFdySinIoKkbjae/J9GM2a8xmsW1pdB6Hfkz/mQWLtmudNrvhuzuay5djv0EH+jg0gHc/3b/E/tFu3G49SQaL04OL+w+xB4YSd3uprqts+f9Oin/EAUv1TCEL2O5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=1calvFou; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="1calvFou"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4TrLXP01xzz6Cl2L4;
	Thu,  7 Mar 2024 20:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1709843425; x=1712435426; bh=WxEPv
	XCwyK085AT4hDEgztr7omx3ZmiCZJO9NL2Ynh4=; b=1calvFouXHLynl/gOO/qT
	BoI1P+1ZQZuaagWWYjlbOoQ9eAubGc0cIGw8utNiVbS3yJesPMGLj8rEiaMFJwt1
	xSmcv49n+vh/tiPig8BRwJ2kaBUdkgn+q0psajHU3Kbzw1X7gNUYnXOw6uc+YoLr
	+ddkQOflTcy7oFN7RfnDZl4kmlbFtqyVlGpeUt/FUnk5xmFSCynZ9dD5eCVpVA7M
	oyT+dLMeKm7NtAgXyCnBaAcZhLLCx0xOP7q48k7iuwFioyqd1z5Ti4usv09Z53+v
	a1BMsWBsnZXJBmvNjq8OmUFQBWvGAhGVJzE6XbtGKjZ6IyTe/CgyaxjOUDJjOPET
	A==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id jC66wSScB6VI; Thu,  7 Mar 2024 20:30:25 +0000 (UTC)
Received: from bvanassche-linux.mtv.corp.google.com (unknown [104.132.1.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4TrLXH6wdtz6Cl452;
	Thu,  7 Mar 2024 20:30:23 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Douglas Gilbert <dgilbert@interlog.com>,
	John Garry <john.g.garry@oracle.com>,
	stable@vger.kernel.org,
	"James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 2/4] scsi: scsi_debug: Do not sleep in atomic sections
Date: Thu,  7 Mar 2024 12:30:05 -0800
Message-ID: <20240307203015.870254-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
In-Reply-To: <20240307203015.870254-1-bvanassche@acm.org>
References: <20240307203015.870254-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

stop_qc_helper() is called while a spinlock is held. cancel_work_sync()
may sleep. Sleeping in atomic sections is not allowed. Hence change the
cancel_work_sync() call into a cancel_work() call.

Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: John Garry <john.g.garry@oracle.com>
Fixes: 1107c7b24ee3 ("scsi: scsi_debug: Dynamically allocate sdebug_queue=
d_cmd")
Cc: stable@vger.kernel.org
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_debug.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 36368c71221b..7a0b7402b715 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5648,7 +5648,7 @@ static void scsi_debug_slave_destroy(struct scsi_de=
vice *sdp)
 	sdp->hostdata =3D NULL;
 }
=20
-/* Returns true if we require the queued memory to be freed by the calle=
r. */
+/* Returns true if the queued command memory should be freed by the call=
er. */
 static bool stop_qc_helper(struct sdebug_defer *sd_dp,
 			   enum sdeb_defer_type defer_t)
 {
@@ -5664,11 +5664,8 @@ static bool stop_qc_helper(struct sdebug_defer *sd=
_dp,
 			return true;
 		}
 	} else if (defer_t =3D=3D SDEB_DEFER_WQ) {
-		/* Cancel if pending */
-		if (cancel_work_sync(&sd_dp->ew.work))
-			return true;
-		/* Was not pending, so it must have run */
-		return false;
+		/* The caller must free qcmd if cancellation succeeds. */
+		return cancel_work(&sd_dp->ew.work);
 	} else if (defer_t =3D=3D SDEB_DEFER_POLL) {
 		return true;
 	}
