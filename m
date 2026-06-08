Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 945303D3CEE;
	Mon,  8 Jun 2026 09:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780912560; cv=none; b=e9psGWzYUh1TBJ3tmOCT0UHUuhKEWftE9OkfBu1VEgEMJ7ieZqen4kVihY2aUOwEFQt7RaGh8uq0BO4Dzsy9nbYayQwjFEtvh0vZff4GYt4xRl4mt5DWhMPgEtnIT6cRtcUeWi6vN3aXNNIPE5EUQfSyha/T4Ob1kGiwnCfI0pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780912560; c=relaxed/simple;
	bh=qEmHCbXS5whw2ROkO97wgg6AOjtnocJh52kBO8s8oQ8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=kbNRQOOKpk9My+LS8ZXS2V+2q+YL6aROUuH9vRcba/NdJZnsNYLrZ+VS/HRgqBlb5HryvmxIltfo7LgzJA4mYbWKNScOltxs+eSzbXcUCLvnC/oFbX/LR7pUMlmqxFsHnylhSUz89+LNKCUzPAGTIfSZDOdlVX8U/AVzLGG/3Ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=runbox.com; dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b=mvwuLTIs; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=runbox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b="mvwuLTIs"
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <david.laight.linux_spam@runbox.com>)
	id 1wWWi4-00BrHo-Rl; Mon, 08 Jun 2026 11:55:56 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
	 s=selector1; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:
	Subject:Cc:To:From; bh=LcjyQx8Q4MzDqCmavYOYkBcOkFtvQFgyHJ3gfEG4lIg=; b=mvwuLT
	IsAcxiU69aDWlN0NkOaXoVeVyKG2f+rAqvqXqW3r1zoeDVKRgTfbruZs98Jrq4bOj/ZuukX3l/aCv
	7pqMP1atlhiDqmJoys5HtSpC+e9iQc/SNICQTukVMilrG08eduumRSHNy/GFF4WG+Gk3QVEgfq36J
	h1ydLZ16zKPP+t/4fbTmt+1HSCZ0Pd4+jcVdbuIQ/icOSdoaJ7swvc+cGMS7nKbnDhU+QiolXp2Cs
	0SjcGKC2IBK8J7RQE41aoj85BcnVK8pH88FROkU7G1tebQsq63GdLJiFG+bHQvhSLgG+eQj7BfUXk
	YsoJSmnQxA7PA4vT4varR9c1Gq7w==;
Received: from [10.9.9.73] (helo=submission02.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <david.laight.linux_spam@runbox.com>)
	id 1wWWi4-0000L8-GI; Mon, 08 Jun 2026 11:55:56 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (1493616)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.95)
	id 1wWWhn-00Ag6G-5P;
	Mon, 08 Jun 2026 11:55:39 +0200
From: david.laight.linux@gmail.com
To: Kees Cook <kees@kernel.org>,
	linux-hardening@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org
Cc: Arnd Bergmann <arnd@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Khalid Aziz <khalid@gonehiking.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	David Laight <david.laight.linux@gmail.com>
Subject: [PATCH next] drivers/scsi/BusLogic: Avoid overrunning static message buffer
Date: Mon,  8 Jun 2026 10:55:18 +0100
Message-Id: <20260608095523.2606-34-david.laight.linux@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Laight <david.laight.linux@gmail.com>

blogic_msg() seems to save output in a static buffer (presumably for
diagnostic reasons).
Discard copies that would overrun the buffer end.
Since the length is calculated used memcpy() not strcpy() for the copy.

Signed-off-by: David Laight <david.laight.linux@gmail.com>
---
This is one of a group of patches that remove potentially unbounded
strcpy() calls.

They are mostly replaced by strscpy() or, when strlen() has just been
called, with memcpy() (usually including the '\0').

Calls with copy string literals into arrays are left unchanged.
They are safe and easily detected as such.

The changes were made by getting the compiler to detect the calls and
then fixing the code by hand.

Note that all the changes are only compile tested.

Some Makefiles were changed to allow files to contain strcpy().
As well as 'difficult to fix' files, this included 'show' functions
as they really need to use sysfs_emit() or seq_printf().

All the patches are being sent individually to avoid very long cc lists.
Apologies for the terse commit messages and likely unexpected tags.
(There are about 100 patches in total.)

 drivers/scsi/BusLogic.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index 5304d2febd63..7e481dbfc521 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -3451,13 +3451,17 @@ static void blogic_msg(enum blogic_msglevel msglevel, char *fmt,
 	va_end(args);
 	if (msglevel == BLOGIC_ANNOUNCE_LEVEL) {
 		static int msglines = 0;
-		strcpy(&adapter->msgbuf[adapter->msgbuflen], buf);
-		adapter->msgbuflen += len;
+		if (adapter->msgbuflen + len < sizeof (adapter->msgbuf)) {
+			memcpy(&adapter->msgbuf[adapter->msgbuflen], buf, len + 1);
+			adapter->msgbuflen += len;
+		}
 		if (++msglines <= 2)
 			printk("%sscsi: %s", blogic_msglevelmap[msglevel], buf);
 	} else if (msglevel == BLOGIC_INFO_LEVEL) {
-		strcpy(&adapter->msgbuf[adapter->msgbuflen], buf);
-		adapter->msgbuflen += len;
+		if (adapter->msgbuflen + len < sizeof (adapter->msgbuf)) {
+			memcpy(&adapter->msgbuf[adapter->msgbuflen], buf, len + 1);
+			adapter->msgbuflen += len;
+		}
 		if (begin) {
 			if (buf[0] != '\n' || len > 1)
 				printk("%sscsi%d: %s", blogic_msglevelmap[msglevel], adapter->host_no, buf);
-- 
2.39.5

