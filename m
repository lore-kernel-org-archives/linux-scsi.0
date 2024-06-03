Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B62F78283
	for <linux-scsi@vger.kernel.org>; Mon,  3 Jun 2024 17:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717435424; cv=none; b=iJOTfnCr9QfcGgxk4m/1BXAhYb5jRIyljLkd60I6MGB54WRyvtIchj6OoO1uB3aW3MGOB53ve0deym+wU17TIt88kl0XAPO7szEwbMfdUcjAqTSqst198et9MuvTce/1CP6Lr3ufXc8h5+Ni9NkcCZXBq7w9TvzKFDZmWPu9AkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717435424; c=relaxed/simple;
	bh=FCuboNp7SLYuRkD2JTwwKqSat1Nwi5uODdGh6Pey72Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=T4KlVqSZu1lcJBK6YMgCXxEF3oaZYc9GI1whQ94uupX6bmSr+ZarLEN3L2aDC7S5N/onuiLv9wg7/zKXxP7JQ9vS8eOfJWp0KcKY4gcMlvGMd1Y52inLOWE7Ec0jjZrHCUa4/HW6s5SZ5EQ69bhjm8UNsmcFy7+YqYgaRSps1O8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=rk6xSAf7; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="rk6xSAf7"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4VtLDG03wQzlgMVq;
	Mon,  3 Jun 2024 17:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1717435420; x=1720027421; bh=EvzVmWhTWmz1ry3pKkQ6lpcgwE3GskfGxKN
	yNZJSCgk=; b=rk6xSAf7iTH7DEV9WUtNY+hRfhVt5kfcNYd2CNJXim+974l0c/L
	wRDJW2g9wz29pe/qYMxzFKsm4/DDBHDBdtUMvMXJsefddgbKlOGYG66ZRwjZkVEH
	hKhvsD0t6zp4J9rOm1M2zg9dfXi7abrleP5xz1uA9N3L/HUBdmYBH+Mq1wTXNTU1
	bAXEXxwZWRQB9hdK7s7H4Kj3ziLL4+ptYpfiQBagaZ7seDaVuUC+tMhALG+14naX
	aOLhxr//T4vsx96qGTCFmXldBm0mmOVXJ83z2fl3kX8QAo6BcYyzxvSquSn//H2p
	xaW9Tnvc6sOJi28W1ThLzTmb3Np5CLFajjw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id he7OWARnB0ga; Mon,  3 Jun 2024 17:23:40 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4VtLDD3RMtzlgMVY;
	Mon,  3 Jun 2024 17:23:40 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/4] Declare local functions static
Date: Mon,  3 Jun 2024 10:23:07 -0700
Message-ID: <20240603172311.1587589-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Martin,

There are several 32-bit ARM SCSI drivers that trigger compiler warnings =
about
missing function declarations. This patch series fixes these compiler war=
nings
by declaring local functions static. Please consider this patch series fo=
r the
next merge window.

Thanks,

Bart.

Bart Van Assche (4):
  scsi: acornscsi: Declare local functions static
  scsi: cumana: Declare local functions static
  scsi: eesox: Declare local functions static
  scsi: powertec: Declare local functions static

 drivers/scsi/arm/acornscsi.c | 9 ++++-----
 drivers/scsi/arm/cumana_2.c  | 2 +-
 drivers/scsi/arm/eesox.c     | 2 +-
 drivers/scsi/arm/powertec.c  | 2 +-
 4 files changed, 7 insertions(+), 8 deletions(-)

