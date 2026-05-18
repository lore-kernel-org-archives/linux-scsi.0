Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AB1A481667
	for <linux-scsi@vger.kernel.org>; Mon, 18 May 2026 14:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779113526; cv=none; b=NBr/x8yLypG6TMH6ArLUtLRT3u0HVI2S4JYEqaZM3O9fDa2Q4K+Fft6z4fGi3BV3CTZKEKPP/dFtGFr3nxuRoK27ymww+b2yHQEC75xt1hp7nC/jtO2/blGTOLfQCsAbfODKGlss9HNDL82YmE8hA/0AtipgOk3mJX5XiblLeYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779113526; c=relaxed/simple;
	bh=l9ZNwR9fd21ubMirXhvgBcTPShRXtd/vfNweHUFlK9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IzqY0N0GY/AIZ0oA4wMj/2lbSP5lBmtNcnCXzhQdl/rH+lrdhzcam98D4mwn5YHKwxS1tTu41ZLbmvx78mQgQuFp4Be13d54bS96ZEZU0C3PRL8oqAPPWb2+eU8YBnWJg332VfgS+usP0wFLsMrG3JSqsBStm8wiAHQClketPbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oNCfON7Q; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oNCfON7Q"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-50e5b55062fso22397301cf.2
        for <linux-scsi@vger.kernel.org>; Mon, 18 May 2026 07:12:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779113524; x=1779718324; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2bFAXmewb45iCgStxAKNd1eKekO8h8rumHyO3Nn0r1s=;
        b=oNCfON7Q3/Y2/bTcqVWfLTfe40JlqMR1zIk8oc6VCuuKbfEOvUwRFmDGRHCvhxcFbJ
         moM9ZEpxMIrkVljdLnK0jrpKPH1pydf85ioS4gdMpyeGtC7DWFwloU3l66EhQpRunH+x
         pZm6pRqj7VGF8jIIYHuHqcvp1+EEWy1nFS2Q0JWbeQcXrdDAbKK5WXv0/xwrQfOnGpIb
         cROIrQ+2s0gQnF90qO107dNWWZUM7l+axpZJAQj+nYJdPcOQ53yxiED6MIkJEQvVVXd4
         LzQt1nvttVfi5IYShw4bIbiouXktf98ujRlsEdFsMVyT3Misnw1qoh51EYaS0A159DHv
         yjvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779113524; x=1779718324;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2bFAXmewb45iCgStxAKNd1eKekO8h8rumHyO3Nn0r1s=;
        b=o6N/3TANhkt7NgNMzaQn9FQ5z5pjKQYN2Qa0xD1NgoEbsaGzuPnCJxWGGceQX/M3vr
         /2BzsKDCzyEib2RGSEHFYKuMFYq3rxts3lzVm1lWeuGGJ8QP7fGHAG3EQdeFOhW1XbV3
         BdrM1RGzPk2rMfeuu/31pHKVJhJr/D5U70CouHogVQwRn3R5Rm6kUj4A4YQv80kxlTVK
         2ETABCghxExTul4Su2ulpQBU/nrkOiBK9w8p/T5P4wMtDOrL7hKkWDcycpYThnmNfR62
         BKFZbk+UR2M9s1B1tVsXJTxsYd43Tkjeh0N3SOT5uRw96AhI0x5RK5Q3Gw4yxLRkkj1r
         TdGw==
X-Forwarded-Encrypted: i=1; AFNElJ8YWYHTjXCOCJdspiPELq/Sw4iucDlMULABvZ2IczY02fppTj9OEBA2Pp8Gm1hGccrv8yBK/NEePzIb@vger.kernel.org
X-Gm-Message-State: AOJu0YyrK06pNInM4yBSa7A53ldzsII8/i79wLbnXFjKtwrVruinqan6
	YljcS/AGLXgjJRbvxQhOWvDcLH2UL99Oe0SbiwqcANfTloMJw+60F9XX
X-Gm-Gg: Acq92OFyhDcXhNeKV7Ceane7T1WyHPRQEY1+zcrO1xVq/hU8miwenYXp0+uoQ36dmBz
	rvCnIXl/W+15rWLKk9XsTJVJV7Lb1vhGYHvmCqdGJnIPz2sYsh84IWm9Om9n9C/e38Gx7wbWVpz
	r08JUG14IKKZJ/fqH8l3wcftXV6HLLYyEpGbOfsEwxH70BkFagDScINRbc46JsLKz4RK7gW4Cag
	gDnGUWgBVxuDCiNfQ9g6xXqgv8Nl8BNKjZfihOeSFVpXPD+FzUUDc3Ltb+5rsw/ctWFztcwNgJ5
	aLJitrAPmM4/lD5MTYd6oQi2IwhfmIPo2kUZZ8i1HPKh3XLKJ9hDFsmlGKFzQVADFqHyNMLyWk/
	YNa2T0921Fcb6Fmhy0LqnYyS0/x3oycYusg+AVRn/phk+17VF9W7uGIhcooUcHG02G0o/C0mo/z
	1E2znSeHvrrRwe3DpLeAuce80XD/e0yBoA6bTGoajwC1EvYMmZW/n2Ci6rZWgZTdZ8ZtZctGf20
	SCZ8fjw/wh9D4R1K5Tvti2zQOEVE3TFOvzARQaLWy8=
X-Received: by 2002:a05:622a:1181:b0:50f:c36a:3821 with SMTP id d75a77b69052e-5165a1e7b22mr216863421cf.34.1779113524155;
        Mon, 18 May 2026 07:12:04 -0700 (PDT)
Received: from server0.tail6e7dd.ts.net (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51645688c13sm132490731cf.1.2026.05.18.07.12.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2026 07:12:03 -0700 (PDT)
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
Subject: [PATCH] scsi: fcoe: reject FIP descriptors with zero fip_dlen in CVL walker
Date: Mon, 18 May 2026 10:11:50 -0400
Message-ID: <20260518141150.2755252-2-michael.bommarito@gmail.com>
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

