Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D51C47043E
	for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 09:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791795732; cv=none; b=HJK/xe2CVTwdlP9XRmWvlStJnq8riIp2NYDMjykJgqt5lHyvk4ZwC7K4ieaPw44KBBXMA7IaREaiYQtpn6vkwD+EGXKlI4LFHgZtjubqXBZbtEvfrkh1oZzx/ZkeNfM2EI86IjqPokXlYb53BB2t9KvcMYkeOt+U4lx0tMMl/KI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791795732; c=relaxed/simple;
	bh=gRy0tVmY36RuFINYba/yIa9FoyM7l7UXacFnKeSKODQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XEADvXmLub23DrpSmKbkKrlaRcsMxI4FmvNAtTVFG9C97To2Qpkmn+svTfWSQA7fHUNQkxyZeQoo3MZtcABZj4xK7xpsOCK8Whm/rYRigIjFavFghonjyRiHZpmLPHH4MMVsvyyaokxXlFwVvz43yODxoppkRxCoiLGysynag58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=VZ8cyRd6; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="VZ8cyRd6"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2dd9ec41bc4so8726135ad.2
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 02:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791795729; x=1792400529; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EnNE/hWpk3lnvRShne5vDHHiWuXq0SGuBMsNI2/H+N0=;
        b=VZ8cyRd6poHvT1xgZgUydejHf43oP37Sphn61OipY0R8TL/Fxr3ZI9uDUE1KBPJYLE
         zACXI/0TcJOqR8tkZorfaZ6/8nPP8TLg9/FIq9LSflV8N7Z8MI+xtUczAYfT/6PONCFQ
         C01wilBkVFjXgdUFJoYyMXadV0z0f+3yChngE/CB9KeffnYEhC7pmpMJJuxvpeXQlYtR
         DbnRIa3RRuQk/i4XcTU7NXRL8FzCtsaWPTVlU3GSxg8faSRTxq9BrnK+xT2xPJBgHkfx
         /AAQfytDCjYvjdCynE0Sy1shgD+pSgD1fshfsTF0dukfRPLgzg1Kd0O//Ohg1I9m0JSY
         +paQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791795729; x=1792400529;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=EnNE/hWpk3lnvRShne5vDHHiWuXq0SGuBMsNI2/H+N0=;
        b=WKIPzqm94ZgG/09R3L3DZ4Z8/d+eaiMDT7wzJ5FmSXI4kYjzUH312yV0alF9N+k7Tn
         bgIccwr73jL0fbkgjGjBQktimBXQhAsCXQtZ9cMDJEKi7raH++fGpJGWAPifVW9WmkVc
         W8DFCcX/Jq96zE0p+fUuSgLKYkbin1Oh9Kr43ZOX+2Jolp/af66IsTinfR2x5f3cdGeb
         JQ3XcYdbT/O1w9Go11FiyHn8YnkqoQkov/cJblrETRFlGq5a4OxG3u/C1hd+SEaOrRB2
         MT9r666Y6Bs22026Mig+XxCBFhfV07zcaH1278WQejKDmrKoYX1V/qJ8uF2F29ZdW2nO
         VvCg==
X-Gm-Message-State: AFq9FYIQvLD3BVsGZheqnTo7M0aMm360DUBkqgaUER7ShbE8wyo0wLK2
	OqVmnsEuZS6uX5Ga7EQtdEbor3grSZnHcb0fJzCG8+Kr5A2QObd3CW0LYM1CdLBrlZ0=
X-Gm-Gg: AYBFou178nmxq0Oj2Gf3KEKFaso6lAkgFnpMVXi2kzw65YeszresV8LKtgdXineLTDp
	oHC1xPFfCanDH+jkl+NgvFGXQKog7LI7k3ZZ7HJCq3VNFUNlR31yK3jZjW5ChbrNIYMuXtrw2aI
	tGz4xZKcxr73n9VWvK9FcMwV8nW8/rpKB5XWV2MfOlx7F7ro8j81gYSnj1iBJeU0lwYayXFVvkh
	MrRTn/hzIgfrIy6exGpyH1WBSLWlQzIO2s7Jd1ZfOz6Lpt06RlZ3XFQjZj2HZJwgaetMoYeTBiK
	UmROkdd1YABv8q742NOVTFWBZQG2dg7P0wlvf3BRVAdZDm/fvigMHWl21XdeWJ1dF3MRWofJyxw
	3gxzAOPJmZu/Il9swWa9Qs0+ZIq255zKX/jeH1v0CQ0IyH9/dTnspIo/6YcgR96aCt8c/YLQlg2
	IK4ANyACWiBxHVRC3QQgaQxVnNy5/M3t8QEaQxMHYoxIIcd2r1Ka/eZ22h/QCzJIdtP9jqooapB
	/WvRg==
X-Received: by 2002:a17:903:2ad0:b0:2e8:34f9:735f with SMTP id d9443c01a7336-2e8429a9f94mr67535575ad.16.1791795728658;
        Mon, 12 Oct 2026 02:02:08 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e8422e4ebfsm41638795ad.78.2026.10.12.02.02.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 02:02:07 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: ching2048@areca.com.tw,
	mkp@kernel.org,
	James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	thenzl@redhat.com,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Subject: [PATCH v2 1/3] scsi: arcmsr: bound the firmware-supplied message length
Date: Mon, 12 Oct 2026 18:01:46 +0900
Message-ID: <adc1e1512a87ff16e99d066c2e96e18a1d28e610.1791792888.git.yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1791792888.git.yhlee@isslab.korea.ac.kr>
References: <cover.1791792888.git.yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The adapter hands the driver an inbound message through a fixed
128-byte window:

	struct QBUFFER {
		uint32_t	data_len;
		uint8_t		data[124];
	};

arcmsr_Read_iop_rqbuffer_in_DWORD() takes data_len from that window and
uses it as the copy length without comparing it against the window:

	iop_len = readl(&prbuffer->data_len);
	if (iop_len > 0) {
		buf1 = kmalloc(128, GFP_ATOMIC);
		...
		data_len = iop_len;
		while (data_len >= 4) {
			*buf2++ = readl(iop_data);
			iop_data++;
			data_len -= 4;
		}

A data_len above 128 therefore walks the 128-byte allocation, writing
firmware-supplied data past its end, and the loop that follows reads the
same overrun back out of buf1.  arcmsr_Read_iop_rqbuffer_data() has the
same unchecked loop for adapter types A and B; there the destination is
wrapped to ARCMSR_MAX_QBUFFER so nothing is written out of bounds, but
the loop still spins up to 2^32 times with rqbuffer_lock held.

Two of the three callers place no bound on the value at all:
arcmsr_iop_message_xfer() for ARCMSR_MESSAGE_READ_RQBUFFER and
arcmsr_sysfs_iop_message_read() both call straight into the reader on
ACB_F_IOPDATA_OVERFLOW.  The third, arcmsr_iop2drv_data_wrote_handle(),
compares data_len against the free space in acb->rqbuffer, which is up
to ARCMSR_MAX_QBUFFER - 1 and so still far larger than the 128-byte
staging buffer; it also reads data_len separately from the reader, so
the adapter can change it between the two reads.

Clamp the length to the size of the window in both readers.  A
conforming adapter never reports more than sizeof(prbuffer->data), so
this does not drop any data it sends.

With a KASAN build and a crafted window, data_len = 4096 produces 992
out-of-bounds 4-byte writes (1024 dwords less the 32 that fit) in
arcmsr_Read_iop_rqbuffer_in_DWORD():

  BUG: KASAN: slab-out-of-bounds in arcmsr_Read_iop_rqbuffer_in_DWORD+0x240/0x2a0 [arcmsr]
  Write of size 4 at addr ffff88800b5baf80 by task init/1
  Call Trace:
   <TASK>
   dump_stack_lvl+0x66/0xa0
   print_report+0xd0/0x630
   kasan_report+0xe4/0x120
   arcmsr_Read_iop_rqbuffer_in_DWORD+0x240/0x2a0 [arcmsr]
   </TASK>
  Allocated by task 1:
   __kasan_kmalloc+0x8f/0xa0
   __kmalloc_cache_noprof+0x22c/0x570
   arcmsr_Read_iop_rqbuffer_in_DWORD+0x7b/0x2a0 [arcmsr]
  The buggy address belongs to the object at ffff88800b5baf00
   which belongs to the cache kmalloc-128 of size 128
  The buggy address is located 0 bytes to the right of

The first value that overruns is data_len = 129; 128 and below are
reported clean, and 124 (the window) and 120 copy byte-for-byte
identically with and without the clamp.

Fixes: bb263c4ecbb1 ("arcmsr: fix ioctl data read/write error for adapter type C")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/scsi/arcmsr/arcmsr_hba.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 8aa948f06cacf..255f1d898079f 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -2277,6 +2277,8 @@ arcmsr_Read_iop_rqbuffer_in_DWORD(struct AdapterControlBlock *acb,
 
 	iop_data = (uint32_t __iomem *)prbuffer->data;
 	iop_len = readl(&prbuffer->data_len);
+	if (iop_len > sizeof(prbuffer->data))
+		iop_len = sizeof(prbuffer->data);
 	if (iop_len > 0) {
 		buf1 = kmalloc(128, GFP_ATOMIC);
 		buf2 = (uint32_t *)buf1;
@@ -2319,6 +2321,8 @@ arcmsr_Read_iop_rqbuffer_data(struct AdapterControlBlock *acb,
 		return arcmsr_Read_iop_rqbuffer_in_DWORD(acb, prbuffer);
 	iop_data = (uint8_t __iomem *)prbuffer->data;
 	iop_len = readl(&prbuffer->data_len);
+	if (iop_len > sizeof(prbuffer->data))
+		iop_len = sizeof(prbuffer->data);
 	while (iop_len > 0) {
 		pQbuffer = &acb->rqbuffer[acb->rqbuf_putIndex];
 		*pQbuffer = readb(iop_data);
-- 
2.43.0

