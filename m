Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A7E3D525F
	for <linux-scsi@vger.kernel.org>; Wed,  7 Oct 2026 05:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791349683; cv=none; b=ttdhXEuf92yZWE0tmgzD878iw37lBUqgoQugSGonYs+jKtw6huB4rgT/qw/yqg2iaklgZiGi73e7GHRY75b41KZ3jQJWZj0VU8qXDeCOXuzSvfn/SuDvN0dqWwVDE0WqHMe5C+uc+zAyN8wDY+ps8WmInH/+2lNPU5wFFGZV2T8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791349683; c=relaxed/simple;
	bh=Cq23+Rd1DJki0yFwhUtm6g06kNKmMXJvQNMIPsm6tMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cXxYsN8YNC1VVAgn/UTWuwhNw+6vrcbHCbzTDlD+LG+/n0nuTBrXnYeprn7snOe3S0uH4CB/lcKS+iDQh3Gn6UYsMmQ8RHV7UtnODEUU94bvOZw+0cO4GDGJisuwGnwB5APecqM/p53eAf1mkXbcy37RX9WVKpTRn6UfYldUhkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=YBmv4PTm; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="YBmv4PTm"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4j01NK5ncRzlfh8S;
	Wed,  7 Oct 2026 05:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1791349679; x=1793941680; bh=+iykk
	2EtL9MDbsE13cQw1c8kWV5IFbzUzxeQx+RdLOw=; b=YBmv4PTml4viMGY5sJIb2
	4muee2de/op8QJlsNpfsxVeUGz94kVPYaDtG7EB2qQyeuyn9pw/eC3LcHCXIr5zS
	v8mQ8qmi2XamKP2nG7Sl5DMU691rd8iAb0ZklM+iUQFCB1DCkSreVnp89wbC77n9
	Kx1N+xpoOsInYqhO2BCO8wynoBXd4bLqblhvZUC1jk2B1X0CP3+qQFmmtDts3YQ6
	Xju5efIr0Wia5OVDgs8Rn2ADOzpJhW3TgsbRN4WbGw5AHqcW8oiZtYVJ4SpZx2K9
	qhejPTwsifcXNzAZB/JYAcS1bT7MRvn26NahOhvi+TYVx64DqTMcdNzYAQN9eHl8
	A==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id G1hJnkd1vuNa; Wed,  7 Oct 2026 05:07:59 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (245.199.118.34.bc.googleusercontent.com [34.118.199.245])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4j01NF44JrzlfvpH;
	Wed,  7 Oct 2026 05:07:57 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v4 6/8] scsi: scsi_debug: Split resp_atomic_write()
Date: Tue,  6 Oct 2026 22:07:28 -0700
Message-ID: <a1827bbfa6caefebd3c50ed171a869536f1bdb44.1791349129.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
In-Reply-To: <cover.1791349129.git.bvanassche@acm.org>
References: <cover.1791349129.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Prepare for enabling lock context analysis by eliminating conditional
locking.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_debug.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 685949aedf9a..244250ba460b 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6352,13 +6352,13 @@ static int resp_atomic_write(struct scsi_cmnd *sc=
p,
 	if (scsi_bufflen(scp) < len * sdebug_sector_size)
 		return DID_ERROR << 16;
=20
-	if (lbp)
-		sdeb_meta_write_lock(sip);
-
-	ret =3D do_device_access(sip, scp, 0, lba, len, 0, true, true);
 	if (lbp) {
+		sdeb_meta_write_lock(sip);
+		ret =3D do_device_access(sip, scp, 0, lba, len, 0, true, true);
 		map_region(sip, lba, len);
 		sdeb_meta_write_unlock(sip);
+	} else {
+		ret =3D do_device_access(sip, scp, 0, lba, len, 0, true, true);
 	}
=20
 	if (unlikely(ret =3D=3D -1))
