Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7AE438038
	for <linux-scsi@vger.kernel.org>; Tue,  4 Aug 2026 04:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816375; cv=none; b=Xx7NkjrywvWeNuY30FlcSIjAFu34LByOv2QsK645hqSgOx8U3fEeBQxRzBfoowfKkdOdT3C8g4EG5paH9mJHHM8ffX4K7DohNB3NC0TKYHhzFefO/X2uuoJIYS/ShqhwJGp1W3uHmd2JZ/DB7wtIY5Mpp2ohKMh/TgBZNfgPaFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816375; c=relaxed/simple;
	bh=Pb1m5gtR1Waz2T4Dlo1TBMbTvyQgrBK6r64ajRbo/kM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MosI31VGyQWbA6PrgAditBmddiM1jNGcBXljIH6gRjj9ajuBUMjxsH+U0qe7ZibULTpwhIO+qu92z/cBkV+R/nyvCH9rC9nnks+q31i6nVCv/e4Ubb4y4rHV0TPuMKD8ODpKYCu336XqpxEYwhgXPeXXdNpKGiB+mz8CbEnfzQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=tlVyqcbL; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="tlVyqcbL"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2cf452def93so4695705ad.1
        for <linux-scsi@vger.kernel.org>; Mon, 03 Aug 2026 21:06:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1785816374; x=1786421174; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ktrD5Au+y2fdveRAMa1uUs9Ni5kpAlV0uMWrALgQG98=;
        b=tlVyqcbLMHQUaRobLitLFDIY4nkxJXPZNCbnyjSOTE/84Oc3+tEEl8vFNTpjpUGxiv
         LsnwAUGFkCYkcXvExRRVl0PhbNI870Yj6jEO66vRKW4i1kFFzgkPbTvnoUkEqUqkWSEA
         Ubc91ino8+TpY2VC6hEVDQ0FXMrDdlPzfR58hSLGX0iLadvElO1ES42+j0XB6AMgeya5
         8pWMpm/ye4tz1KKgGu6gLSmfqHJivD0FiYHRkWjH/OWzpXrLhpZbB6Uk8dzL+buIBtoB
         Fe4DQQr0N/ftg2YHd3OFBjg6onySnCtRLSlzdrfwRhrRAQGglLYy1h1uXag0pDODoZRQ
         VeQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785816374; x=1786421174;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ktrD5Au+y2fdveRAMa1uUs9Ni5kpAlV0uMWrALgQG98=;
        b=QzTMVxgBl3U5Hjl4f0bJqmmxy1hc/kBovg2p4eAr2CjEjnBb8Wh5YMEpDZ63YZCaq0
         st2B5HBdKZUyZy2Ly82A97NDUGP/GtkZAuTcI3isgS2eYu4bF6vuLhTeW5qTu+sFUH5C
         b/T1aMU3xgZYOmWXDpdo4powl2b3yGtYYh6twhzQumm1EWOQ/+9K2AG2HHVrgWSflrAn
         pS9TAiTp8ygsDZ/v9MtVeL/AcTI63O1v0U0EdU6SAH2OcKBQV7XtEa+ckDE7OGTjVVL2
         gnibyCh24mjswLILmtLdY5DfHZuSE7iTlfZ7+fEgeJldfC44/CjW6sYGkDg7N5Em1MO2
         glkA==
X-Forwarded-Encrypted: i=1; AHgh+RrmEiMxtgPdyRRgF5TzGNVbQTWdqzeSl8ChEm7YM7zdAZD6SSWuKRYCvqtElaA/w9Kc0bW43smK6AJD@vger.kernel.org
X-Gm-Message-State: AOJu0YygaCXK3y9BbjqwSK8LWzaao/UNzCz9NAl9jlzPRn3+ia0o/mA6
	rqK3OF0q+QJjrz3+7G3TgKr0h5M7hd0oPxXM2YbGoM6gREAwehZnI+jzhEkdJ/xeKnU=
X-Gm-Gg: AR+sD13A5/1YqSnBB4W0+9htlWgDmseUShM6gpW3ZZ6yhchES9sehCv+zk8c9ltR0xs
	JSdfnYy5O8ZSv/k+LeKVm0ZImNyl/QLoVTUiF/I/jQz14H7r7YCXorhCSIHb9C9ugwks7hRRiGX
	/jhH30LyRHXN+y1dk7beTAV3qeB7+yelcy2wsxY4RvobfX3t5VaXmzvAd2OCCGrAqwx4NALgxF+
	KN3P8ErjfxPa8BYaWFUSNqHYeK2oSGEpAZgS9V7OC7UHd440xGVKIfEZ+apTRTBaO0Uds/QYHvV
	wXvc+ioAmgTYRRvAfuVWrO3a2mrmQjOIAFz2OKC+lIE0xnWsMQZ8KccdV9I3X9JpZopn7vCLokH
	ckp16AAtOyF/L2SdOLNMSWOU60o9ygmy3EYUs/1MG8MjNZsjxozpcFAzJKLtLJpA/t2eRuKgDsV
	47R9H/YXdLf4eZpZLTmyafojJiuevenj9AT/fl8lG5qepW8aFNjigA9yc1nNbZlSLQQF7l
X-Received: by 2002:a17:902:ced0:b0:2cf:41ba:96c2 with SMTP id d9443c01a7336-2d08aad82b4mr18597015ad.12.1785816373710;
        Mon, 03 Aug 2026 21:06:13 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04b11f9a9sm46075465ad.57.2026.08.03.21.06.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 21:06:13 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: lduncan@suse.com,
	cleech@redhat.com,
	michael.christie@oracle.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: open-iscsi@googlegroups.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	stable@vger.kernel.org
Subject: [PATCH v2 2/3] scsi: libiscsi: validate the ITT reflected in a Reject PDU
Date: Tue,  4 Aug 2026 13:05:45 +0900
Message-ID: <20260804040546.2264137-3-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260804040546.2264137-1-yhlee@isslab.korea.ac.kr>
References: <20260804040546.2264137-1-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A Reject PDU carries a copy of the header it rejects, and
iscsi_handle_reject() takes the ITT out of that copy to find the task to
clean up:

      memcpy(&rejected_pdu, data, sizeof(struct iscsi_hdr));
      ...
      task = iscsi_itt_to_task(conn, rejected_pdu.itt);

That value is whatever the target put there. iscsi_itt_to_task() bounds
the index against cmds_max and checks nothing else, so any task in the
pool can be named, and iscsi_nop_out_rsp() then completes it.

An index that has never been used gives a NULL task->conn: the pool is
zeroed at session setup and conn is assigned only when a task is
allocated. If the task was used and returned, iscsi_complete_task()
hits its WARN_ON_ONCE(task->state == ISCSI_TASK_FREE) and the refcount
underflows. An in-flight SCSI command is completed as successful - a
1 MiB read returned 1048576 with none of its buffer written and no
warning.

Validate the reflected ITT the way iscsi_itt_to_ctask() validates a
command ITT, and require the task to be in flight and not a SCSI
command.

[    6.248477] Oops: general protection fault, probably for non-canonical address 0xdffffc000000000c: 0000 [#1] SMP KASAN NOPTI
[    6.249357] KASAN: null-ptr-deref in range [0x0000000000000060-0x0000000000000067]
[    6.249951] CPU: 1 UID: 0 PID: 0 Comm: swapper/1 Not tainted 7.2.0-rc5-ISCSI1-gf5098b6bae76 #1 PREEMPT(lazy)
[    6.250718] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[    6.251616] RIP: 0010:iscsi_nop_out_rsp.constprop.0+0x46/0x160
[    6.252043] Code: c1 ea 03 48 83 ec 08 80 3c 02 00 0f 85 f5 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 8b 6b 58 48 8d 7d 60 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 c0 00 00 00 48 8b 45 60 48 39 c3 74 50 48 b8 00
[    6.252813] RSP: 0018:ffff88806c907b80 EFLAGS: 00010206
[    6.253042] RAX: dffffc0000000000 RBX: ffff88800607e000 RCX: ffffffff8d571a25
[    6.253345] RDX: 000000000000000c RSI: ffff88806c907c38 RDI: 0000000000000060
[    6.253642] RBP: 0000000000000000 R08: 0000000000000000 R09: fffffbfff235a504
[    6.253947] R10: 0000000000000003 R11: 7463656e6e6f6320 R12: 0000000000000000
[    6.254251] R13: 0000000000000000 R14: ffff88806c907c38 R15: 0000000000000000
[    6.254549] FS:  0000000000000000(0000) GS:ffff8880d95bc000(0000) knlGS:0000000000000000
[    6.254887] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    6.255140] CR2: 00007fc393e8ffc0 CR3: 0000000005252006 CR4: 0000000000770ef0
[    6.255439] PKRU: 55555554
[    6.255564] Call Trace:
[    6.255674]  <IRQ>
[    6.255768]  __iscsi_complete_pdu+0x18bf/0x22a0
[    6.256733]  iscsi_complete_pdu+0x54/0xa0
[    6.256905]  iscsi_tcp_data_recv_done+0xf4/0x250
[    6.257103]  iscsi_tcp_recv_skb+0x31e/0xec0
[    6.257680]  iscsi_sw_tcp_recv+0x12f/0x390
[    6.258061]  __tcp_read_sock+0x1ab/0x810
[    6.258853]  iscsi_sw_tcp_data_ready+0x18b/0x510
[    6.259808]  tcp_data_queue+0x1f13/0x4cd0
[    6.260567]  tcp_rcv_established+0x8a5/0x3a00
[    6.261931]  tcp_v4_do_rcv+0x449/0x960
[    6.262269]  tcp_v4_rcv+0x2245/0x3bc0

Fixes: 8afa1439fcff ("[SCSI] libiscsi: handle immediate command rejections")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
Measured on 7.2-rc5 with KASAN over a proxy that injects one Reject PDU.
Unpatched: the unused index oopses, the returned index warns and
underflows the refcount, and the in-flight read returns 1048576 with 0
bytes filled. With the patch the reject is refused in all three cases
and the connection is failed the way an unknown ITT already is. A
NOP-Out ping reflected in a Reject - the case this branch exists for -
completes normally on both kernels.
 drivers/scsi/libiscsi.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 7a74bc697d23..774ed4739891 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1147,8 +1147,11 @@ static int iscsi_handle_reject(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 			 * Our nop as ping got dropped. We know the target
 			 * and transport are ok so just clean up
 			 */
-			task = iscsi_itt_to_task(conn, rejected_pdu.itt);
-			if (!task) {
+			task = NULL;
+			if (!iscsi_verify_itt(conn, rejected_pdu.itt))
+				task = iscsi_itt_to_task(conn, rejected_pdu.itt);
+			if (!task || task->state == ISCSI_TASK_FREE ||
+			    task->sc) {
 				iscsi_conn_printk(KERN_ERR, conn,
 						 "Invalid pdu reject. Could "
 						 "not lookup rejected task.\n");
-- 
2.43.0

