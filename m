Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168DF5464C
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 22:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785451684; cv=none; b=HYLSHHx8/H883vAj2DNpM48gDrtmYamiTlkagO10Tq0rUO9GaC9E0ALFPitWXKddqFb9fxx14EJxopNKSJfG5zfAmUsTnwVB9TONRjmRWHdfocs80f5evgSoaG0rGOvCcnVQ+ZdrKbdxBzuF5ZeQCIJW+f7Kwu+GK4ZzxHxKbSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785451684; c=relaxed/simple;
	bh=JGPuIyysDyaqVHQqhXHi0htNmLW6ILwWM7dGBH7g3y4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kuQjzZ+cl8OnsjKXfymGuj20/eOd7aug0vg6A1SXxQFhIcxdJnjQs+FMhWupgjyuZ4IKF27RMlXq6a8LparLNQfC+zfQG5PBcpI0sJqrEuVgA+A/8ZQW6b8e+4lWy2jOJ9CGzUdkhc3W0TQMJO1OfZ/Um9lLSu4YayRozAHFMWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=gapqKdfd; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="gapqKdfd"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hB49G44QKz1XM6Jm;
	Thu, 30 Jul 2026 22:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:mime-version
	:references:in-reply-to:x-mailer:message-id:date:date:subject
	:subject:from:from:received:received; s=mr01; t=1785451679; x=
	1788043680; bh=JGPuIyysDyaqVHQqhXHi0htNmLW6ILwWM7dGBH7g3y4=; b=g
	apqKdfdEV8Gh+IFkukfsF96UnvxRWe6zgdj+1oe/wHJAGdN05FHfOuVufLFf017K
	TA/V5iNY3JRJJgrqqazdDJjEeH74cdOExmvc5q8Kh9qRYYqQDFRmulYmAIDhUL6J
	Dhnp1M8mUzE5VhK0n1qoIb0WM6QK2HTA8u624fjXhsWZvJ7vShyiSNicvNvG8xyg
	F85bX8bubROMotk5QXr/DWeA3XK0n4gS35AL/IFGCy0pfhFhxntQRMgPuctKCv9p
	3FC+p4DLJInu3GubxOy+euGAsScgs9onKlSRA4ML/3zxPr9NRyGmJwgFHhY0e8Za
	DuDS6Ne0/q4WE6wb/fFvw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id W1M6ImzyXJ4w; Thu, 30 Jul 2026 22:47:59 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hB49B31tWz1XM30k;
	Thu, 30 Jul 2026 22:47:58 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Ram Vegesna <ram.vegesna@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 23/57] scsi: elx: Enable lock context analysis
Date: Thu, 30 Jul 2026 15:45:06 -0700
Message-ID: <b815cc95e76b308add4dba34f7a81d02e925a681.1785451174.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
In-Reply-To: <cover.1785451174.git.bvanassche@acm.org>
References: <cover.1785451174.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/elx/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/elx/Makefile b/drivers/scsi/elx/Makefile
index a8537d7a2a6e..0ed508e379fb 100644
--- a/drivers/scsi/elx/Makefile
+++ b/drivers/scsi/elx/Makefile
@@ -4,6 +4,7 @@
 # * =E2=80=9CBroadcom=E2=80=9D refers to Broadcom Inc. and/or its subsid=
iaries.
 # */
=20
+CONTEXT_ANALYSIS :=3D y
=20
 obj-$(CONFIG_SCSI_EFCT) :=3D efct.o
=20
