Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5377A53C3D7
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 17:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790702313; cv=none; b=hVSJogaSsN5RGNOZ7ljuOMGyrD5+Kd0LE4+YQPaSQxX37jhAZLtNqLjqzRFtcH+cvBaz+3pLFiVOoDnp0pAhsCYbBX0e1QFhj77dDn90l292gZDqKcS9cMpkPwsbn0qFfPEz/8nXMTbA+mCMXL1Bn7W09mlwtzaW4nb4KZqZKuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790702313; c=relaxed/simple;
	bh=LkY/cDROxYb54yWwJyGF2csSpDyQt8ZL2xq7DnCeXCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ICFBcOUkA4kssFJia83ndA8glnFhy2A7Z4cQsaRamPMTCx6kQwXpHwK1x4A4fHs5zbNRp2oE41SxU9v0zFESNmTTWzXxE62U7W62vIHlilHATcDTeuZYVISE5Mn1p8MIKR1ll7LjLNvUTJSx+zi0zkPChqnEB1vwyotZ39V2wVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ib/08ukm; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ib/08ukm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790702309;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gdon/V/Bd+ipJYWfV46BBiv32l2Yz4ceMphOTXGcSbw=;
	b=ib/08ukmHSvVdAfMVWmSyR558EUzzv5D3I5UrsxYv4zKeFxmkYRZvlw9T8LjL2cwqQoxGU
	qF0HbkKyFLQwx7LbmWrAJ6P9QUzfawsT76O5MfVetfWE//9rrr7loqedP32b1FJpmdT1+o
	Yegc4y922hnlP/DKFkWazfS2Z6cM9zc=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-13-y3L1wXicNsWcwSLnZmQxow-1; Tue,
 29 Sep 2026 13:18:24 -0400
X-MC-Unique: y3L1wXicNsWcwSLnZmQxow-1
X-Mimecast-MFC-AGG-ID: y3L1wXicNsWcwSLnZmQxow_1790702303
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9C6731828B0E;
	Tue, 29 Sep 2026 17:18:23 +0000 (UTC)
Received: from loberman-thinkpadp16gen3.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 55D7C1800473;
	Tue, 29 Sep 2026 17:18:22 +0000 (UTC)
From: Laurence Oberman <loberman@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Kai Makisara <Kai.Makisara@kolumbus.fi>,
	John Meneghini <jmeneghi@redhat.com>,
	emilne@redhat.com,
	bgurney@redhat.com
Subject: [PATCH v3 2/4] scsi: st: Record the tape position after a successful MTLOAD
Date: Tue, 29 Sep 2026 13:18:11 -0400
Message-ID: <20260929171813.844733-3-loberman@redhat.com>
In-Reply-To: <20260929171813.844733-1-loberman@redhat.com>
References: <20260929171813.844733-1-loberman@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Commit 0b120edb37dc ("scsi: st: Add MTIOCGET and MTLOAD to ioctls allowed
after device reset") allows MTLOAD to clear the reset condition because
the tape location is known after MTLOAD.  But the driver does not record
it: reset_state() sets the file and block numbers to -1, and
do_load_unload() leaves them there.  check_tape() sets them to 0 only for
a new session, which requires a new-medium unit attention.  Drives that
do not report one when the medium was already loaded (seen with IBM LTO
drives) keep reporting file/block -1 in MTIOCGET and no BOT, although the
tape is at the beginning.

After a successful load, set the partition to 0, the position to BOT and
reset the EOF state, as the new-session path in check_tape() and MTREW
do.  Otherwise the driver may still record the previous partition, so
that a later MTSETPART to that partition is not performed, and a read
after loading at EOD fails with EIO.

Fixes: 0b120edb37dc ("scsi: st: Add MTIOCGET and MTLOAD to ioctls allowed after device reset")
Suggested-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
Assisted-by: Claude sashiko
Signed-off-by: Laurence Oberman <loberman@redhat.com>
---
v3: set the partition to 0 for all partitions, not only when the current
partition is 0 (Kai Mäkisara).
v2: also reset the EOF state after the load, as MTREW does (Sashiko).

 drivers/scsi/st.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 0a4263bef9cb..e5b2e2d4872d 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -2686,6 +2686,22 @@ static int do_load_unload(struct scsi_tape *STp, struct file *filp, int load_cod
 		else {
 			STp->rew_at_close = STp->autorew_dev;
 			retval = check_tape(STp, filp);
+			/*
+			 * LOAD leaves the medium at the beginning of partition
+			 * 0.  check_tape() records that only for a new session;
+			 * without a new-medium unit attention (the medium was
+			 * already loaded) the partition, position and EOF state
+			 * would be left as before the load.  Set them as a new
+			 * session and MTREW do.
+			 */
+			if (retval == CHKRES_READY) {
+				STp->partition = STp->new_partition = 0;
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

