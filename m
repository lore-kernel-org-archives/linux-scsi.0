Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E1C3C13EA
	for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2026 21:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773350256; cv=none; b=L7g+2qu/EaQLjMc5Cb9cgYOYWhI/GTPApKOXQDlBkmFwncic6/QI139oHR1wqRwe3o6S9w5ZsNV8I6meOR1GgIaBR0FrAvkGUR9olJOHP6w83lGBXgfPsnUvpsYgKu9YbKm24s4PHE77QfkNM3yqdgf/wviJTMKWRrPmCHZto7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773350256; c=relaxed/simple;
	bh=KeZTp2O1AsE8PDcJN04ve8v4bzfeg5o1XKJfOdK2kjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mQEJlbGDnUkcux2n8ZoeA41CIwog0udPeTUEGm5u5hjFQAZ4KB/WXeeEMiq2JF0PkGIu3+3TLLMcIfBnl6ZWjRpBtTYRSQ69hgj9zQIJVlqdHBo3weBv3CfBttPVLCo2m/fv7+a5mjCJYUcMaEQ9nzk1oT0n3YfWD8Mpr09T9cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=4Hdg8yUW; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="4Hdg8yUW"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fX0nV4znDzlfl8L;
	Thu, 12 Mar 2026 21:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1773350250; x=1775942251; bh=K33jv
	ZuiGhmssFpBQ2JG3o3pDqkv1UifTF0bCYPES0A=; b=4Hdg8yUWFPInGoyYYe+pt
	W35mbbo5twXHy2GZ2j7xNjsHx9pggSCHn0Jf9ACIRUz/pYInvS+lMk8QRxZPLg6a
	lxSQk1bm6zXPBTu6LrxdBLtR2jSeVOtAG6E9JFNr5wcjLVTnGLjDO+mB3w/cMh0G
	pcRg2zzFQDVJNH/3k9hmwF9beXiWfpsHoHbwb8q+5xybS4GTB5gJncrt9rZl0rFt
	Oq0zuIULlpmIW3BtgPt1rL9RehLu+d4254f2UQACDH53UrfJTwtMXMq2HkAkXHLc
	ulWDDS1KXCybO49EXqm7RqRDiHrFyG/O9rNeGupAgV3ZlQyem423HZFRckNyEkV1
	g==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id v8KtWxO9WZ3r; Thu, 12 Mar 2026 21:17:30 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fX0nP0nZGzlfl5V;
	Thu, 12 Mar 2026 21:17:28 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Nilesh Javali <njavali@marvell.com>,
	Manish Rangankar <mrangankar@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 13/36] scsi: bnx2i: Introduce a local variable
Date: Thu, 12 Mar 2026 14:15:24 -0700
Message-ID: <20260312211636.3245119-14-bvanassche@acm.org>
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

Prepare for adding a new statement that will use the new local variable
'conn'. No functionality has been changed.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/bnx2i/bnx2i_hwi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hw=
i.c
index d24cc2c795d6..4fb68ec8e9b0 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -1741,6 +1741,7 @@ static void bnx2i_process_async_mesg(struct iscsi_s=
ession *session,
 				     struct bnx2i_conn *bnx2i_conn,
 				     struct cqe *cqe)
 {
+	struct iscsi_conn *conn =3D bnx2i_conn->cls_conn->dd_data;
 	struct bnx2i_async_msg *async_cqe;
 	struct iscsi_async *resp_hdr;
 	u8 async_event;
@@ -1751,7 +1752,7 @@ static void bnx2i_process_async_mesg(struct iscsi_s=
ession *session,
 	async_event =3D async_cqe->async_event;
=20
 	if (async_event =3D=3D ISCSI_ASYNC_MSG_SCSI_EVENT) {
-		iscsi_conn_printk(KERN_ALERT, bnx2i_conn->cls_conn->dd_data,
+		iscsi_conn_printk(KERN_ALERT, conn,
 				  "async: scsi events not supported\n");
 		return;
 	}
@@ -1773,8 +1774,7 @@ static void bnx2i_process_async_mesg(struct iscsi_s=
ession *session,
 	resp_hdr->param2 =3D cpu_to_be16(async_cqe->param2);
 	resp_hdr->param3 =3D cpu_to_be16(async_cqe->param3);
=20
-	__iscsi_complete_pdu(bnx2i_conn->cls_conn->dd_data,
-			     (struct iscsi_hdr *)resp_hdr, NULL, 0);
+	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr, NULL, 0);
 	spin_unlock(&session->back_lock);
 }
=20
