Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 710693C3450
	for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2026 21:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773350245; cv=none; b=dKABSoIFISnpqUhRju1DyXq6Qpyv4IeNxjElxWyZrxEZS28Cc2ZXf+1UH/nV77HvWnxIkAW/Z0YrVXRHEu9KimA1urE0vs3UBhwC1927wPK6poDIktVQicn+VivgrW1AkPn2lsynogUfv5g1MJBWSTyzlMSfDWhKDjuib3eVojo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773350245; c=relaxed/simple;
	bh=uFX1l705y7oo9Ts7ix0PAKjwLRFE+IA1DpeBghazGnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rwcZcfsQsWqwcc0prhl1EmptMKo+KO6M5Cx0ba2D6JXq6c3Hnjxi9Hcg+2lDciIuY7byjOTrWxulacuud0TKSW4pBnX10HPvVcJF49MZfwIxy22Mg6jwNIcNRgUOm7UeE7sKaVWW/z96MxGhGtyncKYeZDB6dEJzXZYPSYqFz/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=jQ9b1fHI; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="jQ9b1fHI"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fX0nJ0DYnzlfl5h;
	Thu, 12 Mar 2026 21:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1773350241; x=1775942242; bh=s/q+0
	6VK7UrzQn0TF/2cFa/kMbUeGQJ8sYO+3Ef/Q40=; b=jQ9b1fHIkylW9NSlDg0vz
	B7mTG3RnZLTyhgSbx+8aPwWuY3aumk5kv0hRtNtmDgrBKuNkGXkXu7FqDFC0LmPU
	N7i4A6Rf9YUgxj+BoPM9GoAaWA7qQKe8ai66BXa3NwCrHaXt6jo3QgmmBykF5mG0
	b+SXYW7goYjsVs/ENWQYTOrREmfixPo98Pu6Z3x2gQ9TUjUV4lHdqx3Kb+2U8qGI
	kPRRaRuAUkIlfheQJZsknApU6zPiFRLlLPw+G3rb1PjQ/5g3WkqvLo1MbTTFpcES
	Ng4PaJyjPPr/dPMLnpalf5djmkTn2nA3yb/CIhkt9oBydvF5bnHMFbCo7FTBs9+v
	Q==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id QcGh2Ccb9E0n; Thu, 12 Mar 2026 21:17:21 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fX0nD0W4yzlfl5V;
	Thu, 12 Mar 2026 21:17:19 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 08/36] scsi: aacraid: Prepare for enabling lock context analysis
Date: Thu, 12 Mar 2026 14:15:19 -0700
Message-ID: <20260312211636.3245119-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
In-Reply-To: <20260312211636.3245119-1-bvanassche@acm.org>
References: <20260312211636.3245119-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Document the aac_send_reset_adapter() locking requirements with
__must_hold(). Annotate functions that perform conditional locking with
__no_context_analysis.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/aacraid/commctrl.c | 1 +
 drivers/scsi/aacraid/commsup.c  | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commc=
trl.c
index bd82aeb679ae..77238e610db4 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -1043,6 +1043,7 @@ struct aac_reset_iop {
 };
=20
 static int aac_send_reset_adapter(struct aac_dev *dev, void __user *arg)
+	__must_hold(dev->ioctl_mutex)
 {
 	struct aac_reset_iop reset;
 	int retval;
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsu=
p.c
index c4485629f792..b85961b62213 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -475,6 +475,7 @@ int aac_queue_get(struct aac_dev * dev, u32 * index, =
u32 qid, struct hw_fib * hw
 int aac_fib_send(u16 command, struct fib *fibptr, unsigned long size,
 		int priority, int wait, int reply, fib_callback callback,
 		void *callback_data)
+	__no_context_analysis /* conditional locking */
 {
 	struct aac_dev * dev =3D fibptr->dev;
 	struct hw_fib * hw_fib =3D fibptr->hw_fib_va;
@@ -698,6 +699,7 @@ int aac_fib_send(u16 command, struct fib *fibptr, uns=
igned long size,
=20
 int aac_hba_send(u8 command, struct fib *fibptr, fib_callback callback,
 		void *callback_data)
+	__no_context_analysis /* conditional locking */
 {
 	struct aac_dev *dev =3D fibptr->dev;
 	int wait;
@@ -1466,6 +1468,7 @@ static void aac_schedule_bus_scan(struct aac_dev *a=
ac)
 }
=20
 static int _aac_reset_adapter(struct aac_dev *aac, int forced, u8 reset_=
type)
+	__no_context_analysis /* conditional locking */
 {
 	int index, quirks;
 	int retval;
