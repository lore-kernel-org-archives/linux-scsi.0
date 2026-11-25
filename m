Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795645230;
	b=Y0HmdGoA7LZbAkObbEJqdrOJ9yFMcBq9/hbjbm2SrZm3Da6Bpruq0YRhZ0mDP9T0byxJ
	 i++XNsj4s+JCfVa6s6Ow+50r82FxsUG7Wu8Nz6U13HaW79oV08Nvdk1oBm6CrmFvouJ17
	 Hw9qrFC3sbTpV6YNR7XLAWT+Ry6DKj+L6MDg5fPiMSPtMRx6V/vTIFI8jSttFy2DeB7+O
	 whnldvI5pCt2rtxLn8bXlFd6osXwnr06hlKb6MSV74Awi70FwUFH5qVtFTGFU5C7p437y
	 23sI0BfXFgWnoR9TDUVVkec9w6VqD5gP7QA4Xa0fpKma8v240SYID6QprVb9PFLxW5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795645230;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:Mime-Version:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=K4o0fdb77C2dnHpzdq2HhvHCDm+wfEBJJb+Gee5/SLc=;
	b=4vfT1cDgnTaYl2cGpa2ihw5H5hYY7Ro095Ip5RHiiPHHiAPnXIFvELFfhVcEmiduPSD3
	 PXODEdxULDLxRVsUM2kAFtm40lppUz2IDGNp9f3DUTUN9E5FmmcXyIKAo3/g3EcLvXUjB
	 vx4IC9xWNux52ivqVNgBkRShcAN98d5+QP9h1OQJNLJTRa7xMP7Wr8jUKwsFOTTqJMwSA
	 tHa44iUB32ACvI0bAyHQeJqo5V1foLIzIKvonximIxtaxwDGibIvb+EAadznEefGgrvbA
	 wgPzRYrnUksVsg1PohMcXF3UkNZfiY7zZBSg7o0289gHwrvlgRPCTAKNP3F8+0kwloA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--elkin.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=mmBDrb9G;
	arc=none smtp.remote-ip=74.125.82.69
Received: from mail-dl1-f69.google.com (mail-dl1-f69.google.com [74.125.82.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 607FB606A326
	for <linux-scsi@vger.kernel.org>; Wed, 25 Nov 2026 22:20:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 607FB606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--elkin.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=mmBDrb9G
Received: by mail-dl1-f69.google.com with SMTP id a92af1059eb24-14373747468so6064306c88.1
        for <linux-scsi@vger.kernel.org>; Wed, 25 Nov 2026 14:20:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795645229; x=1796250029; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=K4o0fdb77C2dnHpzdq2HhvHCDm+wfEBJJb+Gee5/SLc=;
        b=mmBDrb9G6Om8y09GECATQFGMZMfVNLOF677I1LHzy3toWm38jnlSK11n63pIOKwSj7
         oGtEH/xNoTRVPWS2MMwvUKXvjJ+0TBq/eRvWYbowa1X+UyQL+NCcRdb4rbuGz0v2ju7r
         FWlANaUZpXLgdSTjq2J/bqtgBsnZu8HerwPr/9dFqjJ2JgXie1Qba0I+5mRASqruEvYL
         0JfTSS5Wrt2dprFVLBg/Goe7aozroWCLqyXehEUs+KVpmXRmYI+c3onPOqTxrXppzyes
         6L/DYEtfGov0eWcvUYHhjiivJCSZOB6xV93vp+Odv/FWX58w3SMM03PL2xsVmDk2kjBG
         4lhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795645229; x=1796250029;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=K4o0fdb77C2dnHpzdq2HhvHCDm+wfEBJJb+Gee5/SLc=;
        b=mzU2jaLS0lytaYAYeFcmD3lEYLlZxxFIDdrdp2WG8UCdLGBkPnJksxJAMChZrJiQWe
         pTf7nPKYaN0rHdZjb0KZtOqkkzEeUPXcLouavMC9bBQ/MEUK25e5a4OxM1WqcQ399JW1
         PjaL2SOPEy33whIyk7zIEPPOYg6VZkNmSfq2+6pxMXIyVR7aajClsNsBrk8ZVXsYxF+w
         xWjQ5cl127NecG4s/R43Hrwv1aZ/b7sOfj9g+MW67CoscnJMlQ8THJ/gm5GYnqFi889d
         20dLyYlKd0xMs0QSxlF2SRIgPylUAxyhR+5P8u/1QbnO4RAxwhQTuOSgHMF5wswe+Dt4
         t4Rg==
X-Gm-Message-State: APuU4Z9NnFY/Pu+3yebjVHDpI1D1i1ieEIq5keDH9j80GvmEtB/xf++q
	Mr3t+zSI8ra1aCbsbY7KCOKOkLcTO8mJazLE1fwqTmRmyEvd3tqxE98alNKWkMH/CDVtJ7UdM9K
	1fw==
X-Received: from dlbts11-n2.prod.google.com ([2002:a05:7022:b04b:20b0:1b5:2d3d:de79])
 (user=elkin job=prod-delivery.src-stubby-dispatcher) by 2002:a05:701b:4193:10b0:144:eaa7:2763
 with SMTP id a92af1059eb24-1b55689a0fcmr20424343c88.16.1795645229068; Wed, 25
 Nov 2026 14:20:29 -0800 (PST)
Date: Wed, 25 Nov 2026 22:19:45 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.1.839.g22a8290db9-goog
Message-ID: <20261125221945.1426279-1-elkin@google.com>
Subject: [PATCH] scsi: esas2r: Enforce minimum header length bound in esas2r_write_fw()
From: Elkin Cruz <elkin@google.com>
To: Bradley Grove <linuxdrivers@attotech.com>, 
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org, Christian Brauner <brauner@kernel.org>, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, irogers@google.com, 
	Elkin Cruz <elkin@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

esas2r_write_fw() is reachable via EXPRESS_IOCTL_RW_FIRMWARE on
/proc/scsi/esas2r/ATTONode (created with mode 0444 and no capability
check).

In esas2r_write_fw(), the driver validates that the input buffer count is
at least min_size and caps header->length at 1 MiB, but does not ensure
that header->length is at least sizeof(struct esas2r_flash_img) on
FI_ACT_DOWN and FI_ACT_UP transfers, nor does it bound the header cache
memcpy() to min_size for FI_VERSION_0 headers.

If a caller supplies a non-zero header->length smaller than
sizeof(struct esas2r_flash_img) for FI_ACT_DOWN or FI_ACT_UP,
allocate_fw_buffers() allocates a DMA buffer smaller than
a->firmware.header, causing subsequent memcpy() and do_fm_api() calls in
esas2r_write_fw() and esas2r_read_fw() to read and write past the end of
a->firmware.data. Meanwhile, FI_ACT_UPSZ queries upload sizes directly on
a->firmware.header without allocating a->firmware.data, so header->length
may legitimately be zero for FI_ACT_UPSZ.

Require header->length >= sizeof(*header) for non-FI_ACT_UPSZ commands
and zero-pad a->firmware.header when copying min_size bytes from buf.

Fixes: 26780d9e12ed ("[SCSI] esas2r: ATTO Technology ExpressSAS 6G SAS/SATA RAID Adapter Driver")
Cc: stable@vger.kernel.org
Signed-off-by: Elkin Cruz <elkin@google.com>
---

I am trying out new Clang static analysis checks for kernel bug
classes, and they flagged this code as possibly buggy. The findings
were triaged/fixed and commit descriptions were drafted with help of AI,
then checked against linux-next (not runtime-tested on hardware).

Thanks,
Elkin

 drivers/scsi/esas2r/esas2r_ioctl.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/esas2r/esas2r_ioctl.c b/drivers/scsi/esas2r/esas2r_ioctl.c
index 901c5d40cda8..4a4489a2485b 100644
--- a/drivers/scsi/esas2r/esas2r_ioctl.c
+++ b/drivers/scsi/esas2r/esas2r_ioctl.c
@@ -1708,7 +1708,9 @@ int esas2r_write_fw(struct esas2r_adapter *a, const char *buf, long off,
 		/* Make sure the size is reasonable. */
 		length = header->length;
 
-		if (length > 1024 * 1024) {
+		if (length > 1024 * 1024 ||
+		    (header->action != FI_ACT_UPSZ &&
+		     length < sizeof(*header))) {
 			esas2r_debug(
 				"esas2r_write_fw: hosed, length %d  fi_version %d",
 				length, header->fi_version);
@@ -1729,15 +1731,15 @@ int esas2r_write_fw(struct esas2r_adapter *a, const char *buf, long off,
 			 * Store the command, so there is context on subsequent
 			 * calls.
 			 */
-			memcpy(&a->firmware.header,
-			       buf,
-			       sizeof(*header));
+			memset(&a->firmware.header, 0,
+			       sizeof(a->firmware.header));
+			memcpy(&a->firmware.header, buf, min_size);
 		} else if (header->action == FI_ACT_UP
 			   ||  header->action == FI_ACT_UPSZ) {
 			/* Save the command, result will be picked up on read */
-			memcpy(&a->firmware.header,
-			       buf,
-			       sizeof(*header));
+			memset(&a->firmware.header, 0,
+			       sizeof(a->firmware.header));
+			memcpy(&a->firmware.header, buf, min_size);
 
 			a->firmware.state = FW_COMMAND_ST;
 
-- 
2.56.1.839.g22a8290db9-goog

