Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DDD84D7D34
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 18:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790360963; cv=none; b=sJhe/mGMwnJaD9KyRgxHJQUhhbLQoIJ9uSr48zG1vpJAltkphVOMfQ3u8WnXaV9+XaT1aqz1UiOxOQyFLGno2lGE8gA3fNdgKkFaKzXajjYD1m2rdQkTv5fnUmSHLc/Uo0pLN+/IKAbRR1LUBl1gzAye6yGLyRVHL/spsgtlgkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790360963; c=relaxed/simple;
	bh=Ym703sD+XoYc7hbyJxElaFACBnq4w+STxBdGPNR8xr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gmZq8zEVi8BFOIhxVnrNcN7j/IPecq4CFKJ5S88GrNa80RxssQk/UMsm+fqKokhJsx5L+ogaxa1H/38vd3eFMnVmkVyNbMn6B3GlQnmOsOP0CARSUGf+/crS/YxhmmaY5xQoN3mXVNsQ5sBlgVaWeiTqL9cEZEDk96LLP+ox5Ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=YU1H5ph5; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="YU1H5ph5"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hrzkT4yW3z1XM4Tl;
	Fri, 25 Sep 2026 18:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790360957; x=1792952958; bh=wXz/v
	NvtZI4fV2rd+Bl7V7Y9nJAHxkdQhssBCBdgqH0=; b=YU1H5ph58Fu8f2dwl+P8Y
	IVncnaFvR22KLTPD7AB6VkE0gLg2dgDHbWszNH+PvtLG6aqSfYlP4NkO6mj5DCe/
	0rEmslmJalaAaCl76iGKrp/zFthb2YIT//294/Abi/I+b5VolCEUxbwr0Qz5MzcY
	XwtXYFhfXBAlTO7aSNq5MqC7Fm1hKgAcDljZrZ9FzWaOC7jf+s6y5AfaixWgDcGh
	Yw/wFPuS1ksG308S/o3FVHpuvak9t2tgs2AU6p5SpoDT1B2Q7w/rgDuZbWQTTKXv
	va7uAwDUqYKvNKq2gqehBkGwi2ovOkYiICwrBmv/9uFk8ZYLp91Jt901phMUUgXV
	A==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id i5nyJlz6tYpG; Fri, 25 Sep 2026 18:29:17 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hrzkN0Rhzz1XM4Sx;
	Fri, 25 Sep 2026 18:29:15 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"Juergen E. Fischer" <fischer@norbit.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH v4 08/54] scsi: aha152x: Prepare for enabling lock context analysis
Date: Fri, 25 Sep 2026 11:25:46 -0700
Message-ID: <b7dc3add84f4224a90a095d9996b0744cb04c1cc.1790360262.git.bvanassche@acm.org>
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

Annotate aha152x_error() with __noreturn. This suppresses a lock context
analysis compiler warning if lock context analysis is enabled.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/aha152x.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index e3ccb6bb62c0..d751dc8093cc 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -636,7 +636,7 @@ static struct {
 /* setup & interrupt */
 static irqreturn_t intr(int irq, void *dev_id);
 static void reset_ports(struct Scsi_Host *shpnt);
-static void aha152x_error(struct Scsi_Host *shpnt, char *msg);
+static void __noreturn aha152x_error(struct Scsi_Host *shpnt, char *msg)=
;
 static void done(struct Scsi_Host *shpnt, unsigned char status_byte,
 		 unsigned char host_byte);
=20
@@ -2441,7 +2441,7 @@ static void is_complete(struct Scsi_Host *shpnt)
 /*
  * Dump the current driver status and panic
  */
-static void aha152x_error(struct Scsi_Host *shpnt, char *msg)
+static void __noreturn aha152x_error(struct Scsi_Host *shpnt, char *msg)
 {
 	shost_printk(KERN_EMERG, shpnt, "%s\n", msg);
 	show_queues(shpnt);
