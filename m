Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C0E9439909
	for <linux-scsi@vger.kernel.org>; Sat, 10 Oct 2026 09:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791623696; cv=none; b=ieC7kZrdePD+OLZOj8w+um2k3r57HIJtroMBhNrS36r9DtgN0tCNTfRvBYd/Z6M3IJxOGMkt0xaCpKQY9lKq/9VWXlteIssDJU/ixNX/e7IfhRoBGso3a241j41cGi0ZG3kzfgsFb6h12C2hjsXjCp8mtwC/1UZzuFNFSiFj2ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791623696; c=relaxed/simple;
	bh=lAM5b6+OIjaOvHNXh0hpCmmkd4xeYGS8UjTaFjairtI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eMBPxTVICgm161HkOdSwrY2W2VKSAxOZ/MJGA+19KYHnFrxtGG8GHHD9Nb3oGObBFoxO+lWbFYqrQVuViG8u9ynZXv0L+rFod4nTU8toGf+ZY5Z1DQFlwXUJRZ87E73RDrFtJbwiA8BUwcs1McD3vXGFQh7Q3rUkcuyORQ/O56M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=ucwiudbi; arc=none smtp.client-ip=74.125.82.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="ucwiudbi"
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-35834f72d94so685457eec.0
        for <linux-scsi@vger.kernel.org>; Sat, 10 Oct 2026 02:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791623691; x=1792228491; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=2EcMVNGvoUCyg4a+/GXdBm3s3zoBcyX1bcILDBo8ZBg=;
        b=ucwiudbiuFPxoRgwOxXDuOEodDaDRSx0nyKbvf8B1qyGkgprdWK+hLbdTf3ZBKZTbm
         cYrMjHYIZnKEFk0gRt8cIpzI42i7hpxDEn8fky8NCfuQYaVIS6/CWyvn60uRXZ+kkbx/
         U5hteBAdhzeUt8bZrDfRZCi190f2PYWeAJhLI+IAEyxfCZVv8TUH0tGVGplVCA/KIrz8
         of/lGMGM0cziFRJ5Ah+ZgDOtr9V3xkOmXlWa8Y4isn3VoXg/RRpPivbHAta4hcUV0YYO
         jol9yIF7cepBduV2u6WtzxXeNOfjIGZVInXYB1xbU4jgWlXYkwIZwISOIrH8B8VbUJHE
         YU8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791623691; x=1792228491;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2EcMVNGvoUCyg4a+/GXdBm3s3zoBcyX1bcILDBo8ZBg=;
        b=2yFf09vX8QnaTOMynoENl6ZvBjVpdWD9lDG8GFuzyEknuPWoj7wM+Q66kdnQvtmOA7
         wlEQvxtQrDO4lGudmg5iK94W2k206VnzOEuPZOU6YziTzKbgkuS2bDlPGA19Jc75aFDU
         OZtPyfQ7Kvti+MTiBbooimrl2ZTNNhuE4luMFYtIqrO0ysqgqdB1lkASxo6xZFo49PcO
         9zBcgTw4ehm6QWkfDdWWAdN4yI7tHUGWE1dQxPOKUwAr+lI2cL0ykgt9pY6Jq3QC0cHe
         H9Fm2g8T2xKbNt48Uh7B67/bWIAtK7DwbSOECxjE5sCTn9F24Zmw7mjrIYtWIXHrMyTX
         LMfA==
X-Forwarded-Encrypted: i=1; AKwUvByL+D/wN0BzRvcsAK+wZ1JkYTcLXluH+yeGnB0yp5d9uvX8bMUMpdlXCrLuBTp8TNABonzp4R3fxjoK@vger.kernel.org
X-Gm-Message-State: AFq9FYIEa7gO8qUtHcqX6x1zKMkPcptVpzXiTdKh001o2RMvvT9g5GYg
	nYKC33EYcZtkE0BX+qqFBKYBpInTE+mAOMk/EnBle/2e5Ys4GJvoYpcJWEXVuBlCHgk=
X-Gm-Gg: AYBFou1HSI9iFnOpj2pz99S6HMCOC5ZmpR14sGTDfn3cIbcw1rszYSvX9IGrnUZVD4B
	V8JOoSER6V3ur/NMlnhdo4G+H5WBjnePmuebVN6J2xOUH1xb70Jbaxx+0V/zlB2AV9ujlQJcuiN
	iRsnx4rzmkwcgTYf280HuN3J7BPysCzrQChsowX7RuQOThdpqzHmq1lfibjbZs98Nlujm07yvnf
	JtilzRTkUgrp1HD/kdGVB0IcGIoxkJBRDoHGFss/ASrwtGQX4XZ/+WzZcNKPgVezr4HvtTHdVN1
	Olna50tUmHJcLuRFJW9Rt8hkyuCtpyzS1L0CKdfoNsH1U+Sz3G7+HVnofMr0mCUcP9jMNwXoQKp
	cTtbLJY4c8ZKklyfEaBTSuk0WO0sFcSPz3ZKKrkPH5GwecQX+PGQ2MwPvQsbiRlN/QdZYUZkYhf
	H5PMLPu4YO+w46FKagkVK++uCTiuCQNM63vRn2TF+YuovQYR2sM4ewFRg99eN1gW5cogYSAfmUk
	aNdaflNSGI7/FounLK1zQ==
X-Received: by 2002:a05:7300:8803:b0:351:735e:2ef8 with SMTP id 5a478bee46e88-3537df50e9dmr6407629eec.7.1791623691332;
        Sat, 10 Oct 2026 02:14:51 -0700 (PDT)
Received: from localhost.localdomain ([2406:5900:1044:110c:c95f:28ac:324a:cdc3])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3537ca1b53dsm12287561eec.6.2026.10.10.02.14.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 02:14:50 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Subject: [PATCH] scsi: mptfusion: reject events with a MsgLength outside the reply frame
Date: Sat, 10 Oct 2026 18:14:32 +0900
Message-ID: <20261010091432.1788497-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mptsas_event_process() sizes the event payload from the reply header:

      event_data_sz = ((reply->MsgLength * 4) -
          offsetof(EventNotificationReply_t, Data));

MsgLength is an 8-bit field chosen by the controller firmware and is not
validated on the way in; ProcessEventNotification() only looks at
EventDataLength. event_data_sz is a signed int but is then used as a
size_t in both the kzalloc() and the memcpy() that follow:

      fw_event = kzalloc(sizeof(*fw_event) + event_data_sz, GFP_ATOMIC);
      ...
      memcpy(fw_event->event_data, reply->Data, event_data_sz);

A MsgLength too small to cover the 28-byte reply header (MsgLength <= 6)
makes event_data_sz negative; it sign-extends to a huge size_t, so the
kzalloc() under-allocates and the memcpy() runs for ~2^64 bytes. A
MsgLength larger than the reply frame makes the memcpy() read past the
frame and leak up to ~940 bytes of the adjacent reply.

Reproduced under KASAN with a crafted EventNotificationReply (reply_sz
0x50); MsgLength 255 over-reads the frame, MsgLength 4 wraps the length:

  BUG: KASAN: slab-out-of-bounds in mptsas_event_process [mptsas]
  Read of size 992
   which belongs to the cache kmalloc-96 of size 96

  BUG: KASAN: out-of-bounds in mptsas_event_process [mptsas]
  Read of size 18446744073709551604

reply points at a fixed MPT_REPLY_FRAME_SIZE frame, so a valid event has
7 <= MsgLength <= ioc->reply_sz / 4. Compute event_data_sz before the
switch and drop the event when MsgLength is outside that range, as
mptsas_mgmt_done() and mptctl_reply() already bound it to ioc->reply_sz.
Doing it before the switch also keeps a dropped BROADCAST_PRIMITIVE from
leaving ioc->broadcast_aen_busy set.

Fixes: 3eb0822c6740 ("[SCSI] mpt fusion: Firmware event implementation using seperate WorkQueue")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/message/fusion/mptsas.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index c362f09a8c555..1812b871c47ef 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -5009,6 +5009,18 @@ mptsas_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *reply)
 		return 0;
 
 	delay = msecs_to_jiffies(1);
+
+	/* Bound the firmware-chosen MsgLength to the reply frame: too small
+	 * underflows event_data_sz, too large over-reads the copy.
+	 */
+	event_data_sz = ((reply->MsgLength * 4) -
+	    offsetof(EventNotificationReply_t, Data));
+	if (event_data_sz < 0 || reply->MsgLength * 4 > ioc->reply_sz) {
+		printk(MYIOC_s_WARN_FMT "%s: bad MsgLength %u\n",
+		       ioc->name, __func__, reply->MsgLength);
+		return 0;
+	}
+
 	switch (event) {
 	case MPI_EVENT_SAS_BROADCAST_PRIMITIVE:
 	{
@@ -5105,8 +5117,6 @@ mptsas_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *reply)
 		return 0;
 	}
 
-	event_data_sz = ((reply->MsgLength * 4) -
-	    offsetof(EventNotificationReply_t, Data));
 	fw_event = kzalloc(sizeof(*fw_event) + event_data_sz, GFP_ATOMIC);
 	if (!fw_event) {
 		printk(MYIOC_s_WARN_FMT "%s: failed at (line=%d)\n", ioc->name,
-- 
2.43.0

