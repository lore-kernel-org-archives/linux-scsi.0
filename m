Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED4361487C3
	for <linux-scsi@vger.kernel.org>; Tue, 29 Jul 2025 16:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753807324; cv=none; b=uuEhNJS/S46O3/szHcFF60l3T/6fzLxFyS8gl6k6wNA7V9Tl6cevfEeoDES2hv/wGaxPm1nZTMn23XJVedNuQNo3hUF6ttDPnW/63Wnnkc9VfPk9bTXCgATkuFL+pUK+xMd4vQHKUcbtv9hoMmud3uoNmIAkjNMRCQlox0/upoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753807324; c=relaxed/simple;
	bh=bFVzWFZKnzgsjxS7nC5YVy9JF+/TeHcbsgVMEaIKqXI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=RKwWC3F8xQsGf3w+coQGNihQLfZ7DOerDAdjqqE8BkXMCmRNjSw7DRWXyHdbeRZHjldThehQGRG0TC0U/y5z0RYJoY9ys9p1gkbsO6s9vXPiKA0gxHtM2KCh4HbZYc2ktW5hYP/8tODtvgrw4fR7mD9iCK8QFeUjzWPcEkFLMf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=k9md2uIs; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="k9md2uIs"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bs1Ms5pyyzm174t;
	Tue, 29 Jul 2025 16:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:mime-version
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1753807319; x=1756399320; bh=XAhfO
	1kGiNjJ3NtyM7rLw1PFZGuS2+E1s7g8CaweaJk=; b=k9md2uIsFAcDhLkB9dtv6
	iHzgRXrwdyJR6raCbTFo46R3GoPLtFwpPQgpQlGISbvp3/le8elkU9MjKa4lc/Ae
	QRRzoTdUSy9mNkFSHsPuAVb9ebp58VOBObEPZLtmX+oddeREoi3TXzp22POf2KRn
	HN5hQN2yoJFO83vPIf5E6pg+QKfKeJVv09NP/FleDsux/w35kRFSSVvkysU+isd7
	pfvnQO+R70qxYQx2eBrlFmHakO+RjqErUCLkfccdCcLjaOaEodf+VVBNdRx/zsaE
	fEwLrqZ0yYvVI8HQj8ltJ8DDoN3/+kV6cZkUQrzSGWGeUbjwu/eEmSWeUpElNa5J
	A==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id jRe_uUCSrbxM; Tue, 29 Jul 2025 16:41:59 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bs1Mf0BQwzm174l;
	Tue, 29 Jul 2025 16:41:48 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Palash Kambar <quic_pkambar@quicinc.com>,
	Nitin Rawat <quic_nitirawa@quicinc.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v2] ufs: core: Fix interrupt handling
Date: Tue, 29 Jul 2025 09:41:27 -0700
Message-ID: <20250729164135.1731025-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Commit 3c7ac40d7322 ("scsi: ufs: core: Delegate the interrupt service
routine to a threaded IRQ handler") introduced a regression in the
interrupt handler. The UFS interrupt status register (IS) is read but not
cleared. This leads to later events not being handled because UFS host
controllers only trigger an interrupt if a bit in the interrupt status
register changes from 0 into 1. Fix this by clearing the bits in the
interrupt status register for events that will be processed by the
interrupt handler.

This fixes continuous auto hibern8 enter errors and a boot failure for
systems with a Qualcomm UFS host controller:

ufshcd_check_errors: Auto Hibern8 Enter failed - status: 0x00000040, upmc=
rs: 0x00000001

This fixes the following issues that have been observed on a Pixel
development board:
* An "irq ...: nobody cared" complaint during boot.
* Not handling a SCSI command in time, resulting in the following
  complaint:

[   41.700204][   T13] google-ufshcd 3c2d0000.ufs: ufshcd_abort: Device a=
bort task at tag 23
[   41.700945][   T13] sd 0:0:0:0: [sda] tag#23 CDB: opcode=3D0x2a 2a 00 =
00 02 61 e5 00 00 01 00

Cc: Neil Armstrong <neil.armstrong@linaro.org>
Cc: Andr=C3=A9 Draszik <andre.draszik@linaro.org>
Cc: Palash Kambar <quic_pkambar@quicinc.com>
Cc: Nitin Rawat <quic_nitirawa@quicinc.com>
Cc: Manivannan Sadhasivam <mani@kernel.org>
Fixes: 3c7ac40d7322 ("scsi: ufs: core: Delegate the interrupt service rou=
tine to a threaded IRQ handler")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---

Changes compared to v1: elaborated the patch description.

 drivers/ufs/core/ufshcd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 77768bf722fa..7f4651b570be 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -7137,8 +7137,7 @@ static irqreturn_t ufshcd_intr(int irq, void *__hba=
)
 		return IRQ_WAKE_THREAD;
=20
 	/* Directly handle interrupts since MCQ ESI handlers does the hard job =
*/
-	return ufshcd_sl_intr(hba, ufshcd_readl(hba, REG_INTERRUPT_STATUS) &
-				   ufshcd_readl(hba, REG_INTERRUPT_ENABLE));
+	return ufshcd_threaded_intr(irq, hba);
 }
=20
 static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag)
