Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A0334BE430
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 13:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790601954; cv=none; b=gvJnifDeD3nHqgSI3xU/XICS59yAqT4j+ILJhFhxgdokCPgaoOQ7NUhbXkkaRxc7EAZyWePWsczy2Pxh6Febz61x3Sy4mgptrPESWR/brBkjctWSa7fqhNMs9G2phyc0NtGPo+DRrS0GSpeq5Qc3nw/ngvh4+oePjshkH32mY38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790601954; c=relaxed/simple;
	bh=IqIPy9n+VXdx4pRPU/H+AgCHByOR5qS826/tI/zLkrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P6rAZuSKZfLcnnMM82xG7EntFavKalR5YZkpYZKVPtrFUR0DpP4dsdgNLvJ16+1ICuvXs34ohYNvUc2QK12ywWPEc9wn3jPlrpQ7aZrEfDfDT9+l5g2fXLZ9zZhCwRXRwB2LvvxHx1fJRndh7x51IXXfC9tzGOnZeMHKp7Hvlok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JcP7FTsI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JcP7FTsI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790601952;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=toGuUqyRFhytAtRkZAx6uch68LPu7LuApHrI2f0KxwA=;
	b=JcP7FTsIR9W4CuDLYcVF0GJjXxitDEwZhL+L9htkFhyBN9K0gE7Atwm8DS02o1ZYhOoikH
	KuCGzbduFGIMj00az+qdYpUuP8tYh+woW5R4VH3hQVnq8RYyA6CTZPzmaCTle4hUQXN7au
	BEDgbeUyFbt5DzswIkDg3vpJ9Pvuxkk=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-583-tuF2rUFaNbyCXeVv7c61NQ-1; Mon,
 28 Sep 2026 09:25:51 -0400
X-MC-Unique: tuF2rUFaNbyCXeVv7c61NQ-1
X-Mimecast-MFC-AGG-ID: tuF2rUFaNbyCXeVv7c61NQ_1790601950
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AC1E019775D8;
	Mon, 28 Sep 2026 13:25:49 +0000 (UTC)
Received: from loberman-thinkpadp16gen3.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5C3D541D;
	Mon, 28 Sep 2026 13:25:48 +0000 (UTC)
From: Laurence Oberman <loberman@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Kai Makisara <Kai.Makisara@kolumbus.fi>,
	John Meneghini <jmeneghi@redhat.com>,
	emilne@redhat.com,
	bgurney@redhat.com
Subject: [PATCH v2 2/2] scsi: st: Record the tape position after a successful MTLOAD
Date: Mon, 28 Sep 2026 09:25:39 -0400
Message-ID: <20260928132539.56876-3-loberman@redhat.com>
In-Reply-To: <20260928132539.56876-1-loberman@redhat.com>
References: <20260928132539.56876-1-loberman@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

Commit 0b120edb37dc ("scsi: st: Add MTIOCGET and MTLOAD to ioctls allowed
after device reset") allows MTLOAD to clear the reset condition because
the tape location is known after MTLOAD.  But the driver does not record
it: reset_state() sets the file and block numbers to -1, and
do_load_unload() leaves them there.  check_tape() sets them to 0 only for
a new session, which requires a new-medium unit attention.  Drives that
do not report one when the medium was already loaded (seen with IBM LTO
drives) keep reporting file/block -1 in MTIOCGET and no BOT, although the
tape is at the beginning.

Set the file and block numbers to 0 after a successful load when the
current partition is 0, where LOAD positions the medium, and reset the
EOF state as MTREW does; otherwise a read after loading at EOD fails
with EIO.

Fixes: 0b120edb37dc ("scsi: st: Add MTIOCGET and MTLOAD to ioctls allowed after device reset")
Assisted-by: Claude sashiko
Signed-off-by: Laurence Oberman <loberman@redhat.com>
---
 drivers/scsi/st.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 0a4263bef9cb..f4393a8e8fb1 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -2686,6 +2686,20 @@ static int do_load_unload(struct scsi_tape *STp, struct file *filp, int load_cod
 		else {
 			STp->rew_at_close = STp->autorew_dev;
 			retval = check_tape(STp, filp);
+			/*
+			 * LOAD leaves the medium at the beginning of partition
+			 * 0.  check_tape() records that only for a new session;
+			 * without a new-medium unit attention (the medium was
+			 * already loaded) the position and the EOF state would
+			 * be left as before the load.  Set them as MTREW does.
+			 */
+			if (retval == CHKRES_READY && STp->partition == 0) {
+				STps = &(STp->ps[0]);
+				STps->drv_file = STps->drv_block = 0;
+				STps->eof = ST_NOEOF;
+				STps->at_sm = 0;
+				STps->last_block_valid = 0;
+			}
 			if (retval > 0)
 				retval = 0;
 		}
-- 
2.55.0

