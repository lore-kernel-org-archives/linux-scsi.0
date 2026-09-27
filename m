Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E355E3F1061
	for <linux-scsi@vger.kernel.org>; Sun, 27 Sep 2026 13:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790514641; cv=none; b=KOE1K2TR8EIgQuMYPO2p+bGlJcX4sFSxChV6Q6B1WpV3HNXuIhh/JBzNPzqJNFvqWB1k5eMC8+40qF64C/hmDb3hDcBznNKol+SkKsiFbQfBRknZd7KBXyveeyJKt7QLL2H4Gij9oAD6IWXHY+Dhyx9GGj1dfOuaf6rOxNKxaNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790514641; c=relaxed/simple;
	bh=ybKVqa4+CcxcLsd6jknLNzXG7G6TYKHK/tj+rYmCEpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cFI2umjsqsD3boIdYrntDR/RonR6cI66aK6IkO71Nm2HLyGmTB2DeZP7hKDFW2ZJT4tJp3friBlwOTdJSPRzubwXQXMmwPc38/9nCfv52imIPgjxbkDbo4hiuIPMQ5cF0bfU4q2OO7mdPzViClfn9/WusG8bTzOL8IDJF3SOQi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bjSrBoLm; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bjSrBoLm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790514637;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EEDgtPTpDI9etm8E+qaHPGittlV88UGz9yrkZhG0VcY=;
	b=bjSrBoLmJqTDvALCtDmOMDkMdSRCO+zKi8wYG9RTLZjciD7Q1mhUJHLcey6TH2a5SXbmd8
	Zpw8WM7vuH3KBvfyBldfNqY/MPnJNqqNvQDrybtFJ1ExVzfXMHY3fvmg7oHmhQ80GnHV8A
	Rh35Kc9vXB+P7MTMf9OcbWl1DZLSoEk=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-43-Fi4b1u33OQ2_KAkCrueRvg-1; Sun,
 27 Sep 2026 09:10:36 -0400
X-MC-Unique: Fi4b1u33OQ2_KAkCrueRvg-1
X-Mimecast-MFC-AGG-ID: Fi4b1u33OQ2_KAkCrueRvg_1790514635
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4C4891954238
	for <linux-scsi@vger.kernel.org>; Sun, 27 Sep 2026 13:10:35 +0000 (UTC)
Received: from loberman-thinkpadp16gen3.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7DC9B1800348;
	Sun, 27 Sep 2026 13:10:34 +0000 (UTC)
From: Laurence Oberman <loberman@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: jmeneghi@redhat.com,
	emilne@redhat.com,
	bgurney@redhat.com
Subject: [PATCH 2/2] scsi: st: Record the tape position after a successful MTLOAD
Date: Sun, 27 Sep 2026 09:10:19 -0400
Message-ID: <20260927131019.4188777-3-loberman@redhat.com>
In-Reply-To: <20260927131019.4188777-1-loberman@redhat.com>
References: <20260927131019.4188777-1-loberman@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
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

Set the file and block numbers to 0 after a successful load when the
current partition is 0, where LOAD positions the medium.

Fixes: 0b120edb37dc ("scsi: st: Add MTIOCGET and MTLOAD to ioctls allowed after device reset")
Assisted-by: Claude sashiko
Signed-off-by: Laurence Oberman <loberman@redhat.com>
---
 drivers/scsi/st.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 0a4263bef9cb..8889714122c7 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -2686,6 +2686,14 @@ static int do_load_unload(struct scsi_tape *STp, struct file *filp, int load_cod
 		else {
 			STp->rew_at_close = STp->autorew_dev;
 			retval = check_tape(STp, filp);
+			/*
+			 * LOAD leaves the medium at the beginning of partition
+			 * 0.  check_tape() records that only for a new session;
+			 * without a new-medium unit attention (the medium was
+			 * already loaded) the position would stay unknown.
+			 */
+			if (retval == CHKRES_READY && STp->partition == 0)
+				STp->ps[0].drv_file = STp->ps[0].drv_block = 0;
 			if (retval > 0)
 				retval = 0;
 		}
-- 
2.55.0

