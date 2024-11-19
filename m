Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4AB17557;
	Tue, 19 Nov 2024 00:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731976157; cv=none; b=txVzk4EcFD2Q9vn1WwKc0sKIz/uJTvwzwupH05s28x+CYAXjJDgDeAmQf+bo5HckX7+oqbQ2jwGjC8lqZYR7c1sMKyJVvmxJLDV9BloZzkkoHl47gMcjdC8OwNmxE6uOM2c4EngFO0qP82y4/c75xZmlHPTYkIVL9IJ2hlLNNnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731976157; c=relaxed/simple;
	bh=bk9zvHFPBucCSXhMT9N1+kTQJs/laUB3R64x/Vx3Okg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ctdfXqbHxw45FZO1GmAC1CA/uKqwwimr1UGxdYhqaQWe2+vEAcfCXOeurpiXNwAHrhW5ZAbHRdNyi06GVJqXOV9S6m1J90PbnrBEZjcM2aIQBmZ+vRgve0OjLcfBD6XUgydEQieORR1ydefRcg6++bUpQvmIx0sLkk4BWCgfWr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=wg+OGLnm; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="wg+OGLnm"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Xsljl44sBzlgVXv;
	Tue, 19 Nov 2024 00:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1731976152; x=1734568153; bh=sdYDv
	5rHj+PM9ZB2zWOgqt4k0jVu9cQDS7ai8yA3A5E=; b=wg+OGLnm5RqOnb4NFV0YC
	mqb36NkLq/Hc+lbFBbLjSc/auJP9JIsK0vCkKLrAdXq1ep2ColFW8GYVrJnk910W
	HUz6DEj5vtXYxwip0fU6s2+TRFW2Bz/B/c9RBtD5L9uttccEYyxpakbZgYbCkpSf
	SxHlgk++gDFQpp4M1Zo0AigZynkzpNqwYIhiZQIr9/IW4A3d1C035Sf+/xGzpILW
	Q8g4s+JG2BKo7nKXgEVw/PQuthyBWZmwZPOVR/oKSBpcPIWDml1WXzmVPmvWpx50
	0IxKaqniV0qoSOb9EijV8h7dNcgoBSC4P3KLjoVyU8dJ7Bt3cb0mdxy57y529K/K
	g==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Jx4RXGKLqb2m; Tue, 19 Nov 2024 00:29:12 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Xsljg2ZkMzlgVnN;
	Tue, 19 Nov 2024 00:29:11 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v16 25/26] scsi: scsi_debug: Skip host/bus reset settle delay
Date: Mon, 18 Nov 2024 16:28:14 -0800
Message-ID: <20241119002815.600608-26-bvanassche@acm.org>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
In-Reply-To: <20241119002815.600608-1-bvanassche@acm.org>
References: <20241119002815.600608-1-bvanassche@acm.org>
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
index 2ff3a24d791e..791c085917bc 100644
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
