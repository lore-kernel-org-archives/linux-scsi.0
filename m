Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B11F2F3C37
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 18:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790361195; cv=none; b=Fm9ofFEbu24bmxZjfX0bBScXDAvhjtjNhJL8gW4KhvQ7hRIyn+9Nc/8lgLmyGtRe8b8jqzXAF3vM8eucNrZCYLNDF4eC4rXjaKhr1xWqeIzli9cqXAZgi7t0asiOE1xwj4P8ypEfH8BMV/gmtGEGaD8cgmqMLzfMHPLJkFTZgBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790361195; c=relaxed/simple;
	bh=PZryYS6oabDZtYzYOm+Zw+phqvE4rpAMwCPqX7oBcaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g0lmnJFZ55ZmwhLSfS8ic07s066OsahrTrwesy2oaSS4K/hy3Cc+JWgdWov4N5fPjxmNU2cQb8VfalA6mjFr/Ul6P33SW3TC5z5L/5U2YiACYqPtcjCFBnD3mVtkbHmmL+1iEGzClNxfnHWD4r32jeIcH8kJr1I4QhTO5cFgq4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=MjwM/Dn5; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="MjwM/Dn5"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hrzpy0Xmlz1XM5kt;
	Fri, 25 Sep 2026 18:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790361189; x=1792953190; bh=PZryY
	S6oabDZtYzYOm+Zw+phqvE4rpAMwCPqX7oBcaE=; b=MjwM/Dn5n40p1vlHPrGa3
	WU+DCsla9dreZTzllXOiTdT54nYAcLyL1XKFREEvEekejsssv2jP6pP/6/bkwF4i
	wkHqmP8y6DIXxche11ON5gcKgwqW/yLlIAdHap1+IM1qk+ol5vP7sfMD2atRhJwK
	mIIuuEBNAJYCkh19CANi86Bp+RVLBZfX8RFTpyC5IZoXswBHw2jZOikpt//RAuNW
	Uc8ui8p7RUnSWMAoTdQKFNs9EYcu7tTbaOSOk4LC84icQDkY5DLK1iUWYnJAVmaP
	HP9I6eHdNCDyq4MjMv7OF/kP3I2P5K188zYw4ojGzfC62yllIfqNgyxmey8BLEN3
	g==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id qLveCIhKvSMU; Fri, 25 Sep 2026 18:33:09 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hrzpp2sWfz1XM4Sx;
	Fri, 25 Sep 2026 18:33:06 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Narsimhulu Musini <nmusini@cisco.com>,
	Karan Tilak Kumar <kartilak@cisco.com>,
	Sesidhar Baddela <sebaddel@cisco.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH v4 52/54] scsi: snic: Enable lock context analysis
Date: Fri, 25 Sep 2026 11:26:30 -0700
Message-ID: <23db7563bf154f505bdda5f05f7cfd574abc8b87.1790360262.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
In-Reply-To: <cover.1790360262.git.bvanassche@acm.org>
References: <cover.1790360262.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Set the CONTEXT_ANALYSIS variable in the Makefile.

Acked-by: Narsimhulu Musini <nmusini@cisco.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/snic/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/snic/Makefile b/drivers/scsi/snic/Makefile
index 41546e3cb701..b12563cb174d 100644
--- a/drivers/scsi/snic/Makefile
+++ b/drivers/scsi/snic/Makefile
@@ -1,4 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
+
+CONTEXT_ANALYSIS :=3D y
+
 obj-$(CONFIG_SCSI_SNIC) +=3D snic.o
=20
 snic-y :=3D \
