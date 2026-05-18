Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4EB40DFA3
	for <linux-scsi@vger.kernel.org>; Mon, 18 May 2026 14:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779115400; cv=none; b=kcTU35sF9+5btQf8g9T4pUVwC1/oB4F2FNpW3G9Bw888xf0zls6/WtzRF1hPaQVMQfFmr2VzaDWDkwV30QTYTRyKTi2IL3UOKc0SSUZraCqbBXmevoQw4julIEIBgXur2lct7vOSthIyjT34E/Rfb3C4RwN2enfrkdFWn7/1kgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779115400; c=relaxed/simple;
	bh=pawwitQNX1nqSOXvK5cq6YVjA4OHhlKXYxE7K5N/7O8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=okoIUdb2KQJBVTpC8anoJbua63WL1F1+LTkyoQq8P3msMdlkFr1KdHSP0HBqylKBkRpTr5Iiv6mXr6hdOO4kRfpVMAmfvTe7O7bukkV5zciaW14ZhmlK2PMuqU77ZKG+0iz4v1UCWzTcabk/0hiuXP5PcxEbq/gravHv58rg7qE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jWUd1/GI; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jWUd1/GI"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-90eb7a63a30so149792585a.2
        for <linux-scsi@vger.kernel.org>; Mon, 18 May 2026 07:43:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779115398; x=1779720198; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nJ6SCZDA5+huDxSfTFbbVsLJZtzCpNLwdGVSw0TUP5o=;
        b=jWUd1/GIAUG+wNq6l2X7Is/QSUrYwPZ/po/F2bme5K8iCJA+EmNKBO2n4XqKaNRcZS
         g/ANoYzL9Ovchl4TzJQNgdmv2pgJiUBQTAhYEy2j/PNYQkMLGs3YeXtYiVncV/5EVGT5
         pdV/MdXz3i+umtEyJYC5QVIUpvU0s08thgbEuCCQgV2cLR72WtmTKDcyo+YGShvVroUQ
         3MEX/ZI0Re0vAPdljdi5/k0gKo17NnOKkeuaeFRKQUyp5vbePdhyJmpnJs+v/igwN1xB
         XcVT3uN3wbzsCPpr/dbVfCfI9wo0q+pCOMjgbqGsLManlt0nPbo8OdqrZZEu7MwIzuOF
         Y1Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779115398; x=1779720198;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nJ6SCZDA5+huDxSfTFbbVsLJZtzCpNLwdGVSw0TUP5o=;
        b=CZruM+lnS8txZYrtLMeNXDcVFHO7G1doWBz+tBvtDUcvGHc9ATzqTdlR76/eWMgCm0
         EnrtIJB3wZUD7TnLu8FCAtNjrIvOl7IWga+NJ3Qh1AxBTnwNUhI4NfLGVEp2zV7gkDzQ
         41zbsDs3eAd850+BYARgXzDFN1I7NkzBuH7R/fXbStjVWK/VmtTSYvkPPIOI3lH5Jd0v
         Qp5+ILtpO0QUfnXbQXp8sAt6fp+8xLg4Jd3FSiQvXzngCj0uL2YodGj4yjDN/aXTp8jS
         p/EMguuLdiVuRm6YFM3P7pyEAPxPSMhGkKzSIiYlPNjrzih1+CLxPrqYFVIRIZc4BCfg
         abGQ==
X-Forwarded-Encrypted: i=1; AFNElJ9LpY2TULPBOWZmRSuizbymm6b1OAhhoU0aM77Wgcc9bvY/ORrYyGup2GxKvGDVayC+1rF1UcuZ+/pP@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8vt36LxGwewd2uD/g4vEWvFjKth3c/FgsuwKT6GTTte+xMeUF
	pZLBmEl69sTHou58dx3I111HdH4kXO3kgz2zJHHuVks2XlOHfrfqmYJS2wZpYJXP
X-Gm-Gg: Acq92OEP+f/HuI8TaT4O8D26unCnEDVYE9kgdek0TvvkDH46y/rgTBVXxRzU3BEh3uG
	PEmDhT3poEGRaHlKPAJZBXqYjlOUShPYtGKlZaibetnWLpT+DlL48d1bGUFwVJMwy6+yNHc5GBP
	IYngd1QHLymJbuHavmimxHBszYMwIHHPR41ySFx534puAXHljHdltov8Cq9jHdvwUbG1d6Ak7g8
	bx7CJaKnFI0Jn8ee+uLAMNO6nCqxHWQNX66CLYzzJmYadIxHYMp9a0DqgpdRwyO6kGqh1lIETrT
	QtKEqovY5ewMwNWBZ8Y27ZIDjN1zkHX2gIfr/ln5A+eG+N7ld6Ap1puaIPDPOAqdT3XR1CguugC
	G1E6DCLZydHuEZsqz8AqxOhAboBTSr7re9QR9bzJWf+NqcYa0nIAT4Xf+Om4DbUvBIVG5Kvoi8K
	g4ug4S3h/IFiKsNQ+qRhmGUEmN/8sk/TfBEretTmGFTgO3dtl64ZtgYaTECIBzzdaup9KaduEQy
	mN4Y5uXz7XLXZO9xtwwQRkwjhXoL6bi08l4W5mdOGus/h18yQIj+w==
X-Received: by 2002:a05:620a:3714:b0:8ef:ca26:dcf8 with SMTP id af79cd13be357-911ca3452b6mr2408313185a.0.1779115397525;
        Mon, 18 May 2026 07:43:17 -0700 (PDT)
Received: from server0.tail6e7dd.ts.net (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ca36095608sm58044196d6.12.2026.05.18.07.43.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2026 07:43:17 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: Hannes Reinecke <hare@suse.de>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Robert Love <robert.w.love@intel.com>,
	Vasu Dev <vasu.dev@intel.com>,
	Joe Eykholt <jeykholt@cisco.com>,
	Saurav Kashyap <skashyap@marvell.com>,
	Javed Hasan <jhasan@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Karan Tilak Kumar <kartilak@cisco.com>,
	Sesidhar Baddela <sebaddel@cisco.com>,
	Arun Easi <aeasi@cisco.com>,
	Kees Cook <kees@kernel.org>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] scsi: fcoe: reject FIP descriptors with zero fip_dlen in CVL walker
Date: Mon, 18 May 2026 10:43:07 -0400
Message-ID: <20260518144307.2820961-1-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260518141150.2755252-1-michael.bommarito@gmail.com>
References: <20260518141150.2755252-1-michael.bommarito@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

drivers/scsi/fcoe/fcoe_ctlr.c::fcoe_ctlr_recv_clr_vlink() advanced
the descriptor cursor by an attacker-supplied fip_dlen without
ever requiring dlen >= sizeof(struct fip_desc) in the default
branch.  The named descriptor cases (FIP_DT_MAC, FIP_DT_NAME,
FIP_DT_VN_ID) checked their per-type minimum lengths, but a
FIP_DT_NON_CRITICAL descriptor (fip_dtype >= 128, which the
standard requires receivers to silently ignore) skipped that
check entirely.

An unauthenticated L2 peer on the FCoE control VLAN could hang
fcoe_ctlr_recv_work on an fcoe, qedf, or bnx2fc initiator
indefinitely by emitting one FIP CVL frame whose single
descriptor had fip_dtype == FIP_DT_NON_CRITICAL and fip_dlen
== 0: the cursor advanced zero bytes per iteration and the
loop condition rlen >= sizeof(*desc) stayed true forever,
blocking every subsequent FIP frame on that controller.

Tighten the outer dlen guard to also reject dlen <
sizeof(struct fip_desc), so a malformed descriptor whose
length cannot even cover the descriptor header is rejected
before the switch.  This is the same lower-bound the named
cases already apply and is the minimum scope that closes the
loop.

Fixes: 97c8389d54b9 ("[SCSI] fcoe, libfcoe: Add support for FIP. FCoE discovery and keep-alive.")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
---
v2: drop the redundant cover letter shipped with v1.  A
    single-patch send should not carry a cover; the lead
    belongs in the commit message, which the patch below
    already has.  The v1 cover also carried stale drafting-
    time envelope markers that should have been stripped
    before send.  Apologies for the noise; please ignore the
    v1 cover at
    https://lore.kernel.org/linux-scsi/20260518141150.2755252-1-michael.bommarito@gmail.com/
    The patch hunk below is byte-identical to v1's 0001.

 drivers/scsi/fcoe/fcoe_ctlr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index 02cd4410efca7..496ddd45f74da 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -1385,7 +1385,7 @@ static void fcoe_ctlr_recv_clr_vlink(struct fcoe_ctlr *fip,
 
 	while (rlen >= sizeof(*desc)) {
 		dlen = desc->fip_dlen * FIP_BPW;
-		if (dlen > rlen)
+		if (dlen < sizeof(*desc) || dlen > rlen)
 			goto err;
 		/* Drop CVL if there are duplicate critical descriptors */
 		if ((desc->fip_dtype < 32) &&
-- 
2.53.0

