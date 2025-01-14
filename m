Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [104.223.66.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3A01FA177;
	Tue, 14 Jan 2025 18:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=104.223.66.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736877961; cv=none; b=drjzWiM95FLBM3uxrSq7deKX4Mz9gx5mqtTLAnnYzSMR0Y5b+/uqeecijVjivKYXAh49AuMRnJNEq6ZfTgXwrNmG4JTH18uVMAH0y8Vhm0iQ63NijI5fRsow3lNYfuWYhsydzDD2n/PIqMMl9PflhPwE/ywNyikm4m/JSAtF74w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736877961; c=relaxed/simple;
	bh=pgI/Ke9nwWTJAG7CdqpastJE4ZXpSm2WShpI0LS1RMo=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=EkbGAsYjhQXMjBhrSldD09CAUaaEJbMpE03awKNrZlezz/+mavWV05nKq7m+D6lB4a9yfEo3LW00WJeP7wAy9WKYe3PER4iqemTZrE8yzVw4zTMwVcbHpGlpXSoEa4fQm6m5s8Gf972H+ugm6Bta81MsM40/yREVkOgfTRy3bGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=vYevi441; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=TNqIIlLG; arc=none smtp.client-ip=104.223.66.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="vYevi441";
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="TNqIIlLG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1736877959;
	bh=pgI/Ke9nwWTJAG7CdqpastJE4ZXpSm2WShpI0LS1RMo=;
	h=Message-ID:Subject:From:To:Date:From;
	b=vYevi4412UYTJnKVEXRCxzRNxn9wUukCKRcsbDu/fCBH7gNVw7yA9SYed92cU9T5I
	 CSQyztPqMQHD/co4ymPezC4acBXwQFa4V58ruxVOMkqX2h8aKDEYw/bU9JfvxWjjcX
	 sV6bCrkKRQxzsjr/T9aIG4G+Row5HZYqXe/3Dfxo=
Received: from localhost (localhost [127.0.0.1])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id 036501286D0B;
	Tue, 14 Jan 2025 13:05:59 -0500 (EST)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
 by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavis, port 10024)
 with ESMTP id 74NaP81loHZ8; Tue, 14 Jan 2025 13:05:58 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1736877958;
	bh=pgI/Ke9nwWTJAG7CdqpastJE4ZXpSm2WShpI0LS1RMo=;
	h=Message-ID:Subject:From:To:Date:From;
	b=TNqIIlLGhLevI12BVhJHh5Gm5JvQd5mTE5C6xgP/miJhE3xJlLH0xmXn/+qOCDIkG
	 3yRMh/YUli9/KS2HJ8yoEf/GxL+J+urLdZfYyZfRZXczZvb3xYt+uTgcDwst+qT0yj
	 KrWhJo1tWXYxjFx9yDAVzFvAHwJ58kIWSfW5oFDY=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4302:c21::db7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 3D25D1286CD9;
	Tue, 14 Jan 2025 13:05:58 -0500 (EST)
Message-ID: <0adab7ba6c378fc1c610e367e6e952db7b27baa6.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 6.13-rc7
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds
	 <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel
	 <linux-kernel@vger.kernel.org>
Date: Tue, 14 Jan 2025 13:05:55 -0500
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

One iscsi driver fix and one core fix.  The core fix is an important
one because a retry efficiency update is now causing some USB devices
to get the wrong size on discovery (it upset their retry logic for
READ_CAPACITY_16).

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Mike Christie (1):
      scsi: core: Fix command pass through retry regression

Xiang Zhang (1):
      scsi: iscsi: Fix redundant response for ISCSI_UEVENT_GET_HOST_STATS request

And the diffstat:

 drivers/scsi/scsi_lib.c             | 3 +++
 drivers/scsi/scsi_transport_iscsi.c | 4 +++-
 2 files changed, 6 insertions(+), 1 deletion(-)

With full diff below.

James

---

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index adee6f60c966..0cc6a0f77b09 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -210,6 +210,9 @@ static int scsi_check_passthrough(struct scsi_cmnd *scmd,
 	struct scsi_sense_hdr sshdr;
 	enum sam_status status;
 
+	if (!scmd->result)
+		return 0;
+
 	if (!failures)
 		return 0;
 
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index fde7de3b1e55..9b47f91c5b97 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -4104,7 +4104,7 @@ iscsi_if_rx(struct sk_buff *skb)
 		}
 		do {
 			/*
-			 * special case for GET_STATS:
+			 * special case for GET_STATS, GET_CHAP and GET_HOST_STATS:
 			 * on success - sending reply and stats from
 			 * inside of if_recv_msg(),
 			 * on error - fall through.
@@ -4113,6 +4113,8 @@ iscsi_if_rx(struct sk_buff *skb)
 				break;
 			if (ev->type == ISCSI_UEVENT_GET_CHAP && !err)
 				break;
+			if (ev->type == ISCSI_UEVENT_GET_HOST_STATS && !err)
+				break;
 			err = iscsi_if_send_reply(portid, nlh->nlmsg_type,
 						  ev, sizeof(*ev));
 			if (err == -EAGAIN && --retries < 0) {

