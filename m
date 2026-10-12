Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E5194499AA
	for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 11:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791805286; cv=none; b=u6jXKeVRe7tPc7HMq8LzUuzqgAn61skgE20p4bIxaGVjG6mtXZ8REttqoV/ai0NuzBrXDec3EZQmgTZolXqUZQHrjuNfROf6vFrzLu1UogkQgGBCRFxD3GRBot6l0ua4ouTlhaRHCHlqXbUYEHGqeeK5HAWKh8bk3j7ir7mI/dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791805286; c=relaxed/simple;
	bh=gRy0tVmY36RuFINYba/yIa9FoyM7l7UXacFnKeSKODQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hCS4g8Gxu6BP9Y+naVlAKi8AW86TP+2eomNPDNOq9+2s9wwtUGexEkJ0NFXUpZyZQ+BQdjbOrSTfi7OsTRM6Ew3jFM+W61wtajmcaTPfWE2OoeSM6B6yEI+oM5ifVSX1gZAvINStG0LDGjjYo1Xn+4mP13urimR0Xthing/gAmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=qNIFCLFe; arc=none smtp.client-ip=74.125.82.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="qNIFCLFe"
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-141395927feso3016847c88.0
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 04:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791805283; x=1792410083; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EnNE/hWpk3lnvRShne5vDHHiWuXq0SGuBMsNI2/H+N0=;
        b=qNIFCLFeTs3ibfztcz7qKVXeUc7kBuqgIjKlD70ukkY3FCM2zjtJpXoAdtgAjgYB0Z
         6ioM2JuNBODEnewAix+tEK33T9iQh6o34BP1B0Iihc9i+80WJXr2omMlU2v+BiXMRVLL
         nN+xTjeMga/bpDtduIm4FSpw+HnkQpWvjBJzsplH2LY27gMOk6KBdEy1iDFer8hVLamR
         LVIVWiQ+vY5mmmVbbI8iyY2NyS8kFvZH1EgNXL/a3H/pXQmFBkAbwWepbPZn1Fu2bouZ
         QK06uWGyeCOMqcttCeQ6X5Da5LJFZwZ2YATDeb1Qr0vfO2AkamA68Gqufiq14faGtKnU
         TfJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791805283; x=1792410083;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=EnNE/hWpk3lnvRShne5vDHHiWuXq0SGuBMsNI2/H+N0=;
        b=PscnIPas8ac6Bp/mKJkWYKYF5IxVYgLnliUf6kTnmUKIF2cH7LuOz0BZvykvNYrh9A
         5/+iJOeO5CUfutjeHg/Khggve9XVQwGgZyU/DM4GG2L4xlNPxOIAADpuekIrY+5CQ8FA
         DGcCUwoOwsTl+Sf899vdkce58JM/hAw4/i/BEKj3UUQ1bRNUoTBbTTKSAKcSxO4BUPUP
         GAnqzPk46CxljlEOiauAz0It8aeR0+k+T6pdxG+Q22+RXaYP7ZpnW4CxucN4Pxm5zOAi
         XaEFzd2Q3uP+04HMpqkAUU0yqoiEUQ7qE1K31Q5xRZYCJczKLHi7It8Lx4Nin19HaF4A
         NO+w==
X-Gm-Message-State: AFq9FYIQ66+8mW8jofoemyPdkriVLhIBv84MLGYldVHSWbBppYaKFFzF
	zBHimh5Y4x2Doo3WhitJhiFMK89dGad1MxrZfPsc82qKigwXh7kS62126u4vZ9ZUiKuWan/zxdz
	g/of5t3M=
X-Gm-Gg: AYBFou1uk228inoMlViTNniB6XRR7xKyoIWNnKWPDpXeQZDOpp9flkJfQ1Bj5UrOB4s
	U8wg9dawGfA//XJVZeS7AOjqgRCxg5XLB/ab/PaPBD8UzpLCvMLyIh4GB/cvWHTU6Zc35Aclv4n
	w2qNj4VnnD8FgDldI25FGg/PleJTyI4OI3XlFSTRXd42F0AzaHL5S+JNEjlcexW1PAKEnSLm1CF
	usr0MGryjgIxzgaP/YelNEoSXIwxOdh83zletfwJM6MBbo2kFqhdwG2/kG6R48rK0bY/I1xA+BD
	GojvsLVCwYiBGuMUQyzOwPDJ1MDBt/yVo4ZMbmxfO5PpxgUokjb5vZs3mrQ0RbKAbENF9bbr2HZ
	dcJPOrb0YcDG9Ipb90UnrbEW+J687L+D3iRl/r3tAWrmKg++jkB4CO6i5LOTuQZmYhVE+T4K9xQ
	iAm5+uyz8nTwTKBxMur5osjr1UNUBC3Pwe8TIqPs/cPtRBSmBGd9jsPehiewy/+oLzi8xnSCh9D
	dXKsNJF/NAvXs57Xc4cViw=
X-Received: by 2002:a05:701b:205b:10b0:148:722b:7cbc with SMTP id a92af1059eb24-16a5dbfe430mr12897663c88.14.1791805282613;
        Mon, 12 Oct 2026 04:41:22 -0700 (PDT)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:7bd2:1202:246d:44ce])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1746482c978sm8725533c88.13.2026.10.12.04.41.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 04:41:22 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: ching2048@areca.com.tw,
	mkp@kernel.org,
	James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	thenzl@redhat.com,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Subject: [PATCH v3 1/3] scsi: arcmsr: bound the firmware-supplied message length
Date: Mon, 12 Oct 2026 20:41:01 +0900
Message-ID: <adc1e1512a87ff16e99d066c2e96e18a1d28e610.1791803953.git.yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1791803953.git.yhlee@isslab.korea.ac.kr>
References: <cover.1791803953.git.yhlee@isslab.korea.ac.kr>
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

