Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C871E52CCC2
	for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 22:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791929982; cv=none; b=ZzZSTWZVXCqW/W2QIiNGo25meYUnX5xzNIih+89ZLZh1IHo24XM37q1r1OijmJladnT4exr+GVbN6Mw9szy2+1IiI1yfXnbS3F/T9knuwOmrNHkCREQW/c575Ut7EHqyhoWaLKxK8dspy41RYV52Exn1A2qxXhlh0wEZwuL5ucc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791929982; c=relaxed/simple;
	bh=A+I/86KdVa8jIDGYt6ApDmQiXDBusJSa5kMa1fb0xTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZOiKE+kwb01yrVATCLKYDxQ6T2clA9tJnAQe0XJSCSVxEA3gxHw5l7rMZLFMJVd13xPDhFHwOTgrwc54/DJ2ICRg+kJKYV8mUiRx17tUQNLvlJg4xpbMeGku2WfeoAzDtsS9YljDMstSE3OQvHewn9Co8CCrzm7tJOTghRs2pFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T9ivcEh2; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T9ivcEh2"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a0286c981dso3027125e9.2
        for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 15:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791929979; x=1792534779; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SfkApeXinHFIr0p8vXlFlLyypuKINDLCCxfSgft0shY=;
        b=T9ivcEh20L2Gnf55fpi7DhP2HKShJOGeeTBrs3mIni6QHZp0ttdbtyyKpxc/m9Vce8
         06mrG4FlYTMFm7pK4KNdp14OM3toRYmxvEltNOFm6CdqSKmJH9wYrgNhzFL0ghGbiRLK
         HZdBJz1KcH9dup7ZCLkndjoFeAnmT5BuQGBYW0ipohtIy1mhKFvifFngR45FbEB0EMYh
         jhGgdXYmyQqe1X1d+jTdxoKjFDzskAakrug5B3aBOVNYioYtDaWRVI2sDYDxWE+5E0Qe
         k2+5HsHdT7D0Mq8Nf7IYBc6Gv8Cthsb1oUwt/RCpiHkaxdqHfezmgxOixLbW4Napo6z2
         FJTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791929979; x=1792534779;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SfkApeXinHFIr0p8vXlFlLyypuKINDLCCxfSgft0shY=;
        b=CRYys0htgriFEBi9tX41WExp1dslbXi0brA0iG7bPSoUAEQq/JonO1Qn2BOUNQ3xEw
         stdGOxZectLJaVhg8ar0T58S5wxlNBAGvb0w3QhvBP5R8hzzyPvPGVS6tzbDw9q9Pa/e
         dqdBi/bTlmP9H/d/R3GdGR2I754mK1HarQalT60fpzmJvTwc6f/NIKUDKrsIMQadQOWt
         ZS8KzlZ1j9Tq9GQKMPMjd9y3bzk6VJNehYvGhXFX4wlxQKdl7VtdoYxcrxCcrPF2ih+p
         wWJLSBiHetW0UDi/7QFlMdxXYgdVk5Riab4/byqOmh031+cAASFsTD9gmx45KXu2+qrI
         b3iw==
X-Forwarded-Encrypted: i=1; AKwUvByEriS/09CPtGMKqeloirBQuMWhhajvKe3VS4K83EV4tNhwLD4JcGy9tN60NU9qChURX6DGJ7ZzQEpJ@vger.kernel.org
X-Gm-Message-State: AFq9FYKCuKUOE3CTM9/U8tCNtaizI08PQpCw119+9Exv335RSrMFR/RJ
	S7DfmY3/o1LVteX0TZ5N+o6vAgO7olztRRrKaM6xQsD5c9dLiFHxO2PhGicOqzoB
X-Gm-Gg: AYBFou2KFbDx2oMWlM7xQGuSSIzOKydooXcKCUdRwmlOfneMBuVpFyFal6qRZoxGlGO
	r6eXTYtv33hv/P+tIjmzsHKiiAQfqr+nAt0/Zc1G4MWOBRHcMAXH0QJ1t4cPXOSEq/cn0NtQz79
	//+Buia2gXDU+e+sEkEPKsSXlVEH8EeT9PwT31SzQ3jKGpmha3j2CcWVxtxokXQGQEY6K4C6QjD
	VEL4DWMtEFpCFB7Yeziptl5CjRgruhMU4FlXQMCprGyNEsNB3epsQTzPIh20fI9MKXgQtuKc1gQ
	q/xjbZyZ0iY+54xS5gPn0MB2SPZWEIJyc/eLrmCo8KJ7eQnxL9fnjo2Ock90Z67EKfUqokf/5o5
	lPeqWBFj0NMm23bmjM9rwqifwhT4jDBUl7HbNB68XWh7E6Dgtxq76EysZBJI74yrKdbQaHQ2LjW
	4uKfX5EopNx1Hi29doMRYl09Zo25/6hORI6sj8v7FbIVxx0VAkVzL19KjcdAkiJsieDTptyVoJA
	NXw98nw6jEu50sYXXMqHfW/39C1CyzEmmFncXa40ulWXriLSE7bGm/e7MkwhM0yAha1H2cHxkD/
	9ObM3u5pPkMyw1zGg/C8axgwo9uWqKil9gAm5B/udOYb7pXwZ4kyyz4i48cqk55/rMLrEXi6yMs
	AkYDwQOzVRJRily0WqFmBGL68mdp4GupL69h6GfnOJ4zutDSD/UNti41Lpat9W4bL5PvxW9rMx7
	3pfyGeP65GEbLq32g=
X-Received: by 2002:a05:600c:8b06:b0:4a1:7ce1:2eaf with SMTP id 5b1f17b1804b1-4a18e4e0963mr279668475e9.34.1791929978906;
        Tue, 13 Oct 2026 15:19:38 -0700 (PDT)
Received: from localhost.localdomain ([2a0d:e487:412d:e9fb:680d:a947:4b50:d9e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18beacd2csm428992205e9.14.2026.10.13.15.19.38
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 13 Oct 2026 15:19:38 -0700 (PDT)
From: Olivier Kaloudoff <olivier.kaloudoff@gmail.com>
To: linux-usb@vger.kernel.org
Cc: oneukum@suse.com,
	stern@rowland.harvard.edu,
	gregkh@linuxfoundation.org,
	linux-scsi@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net,
	Olivier Kaloudoff <olivier.kaloudoff@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] usb: uas: validate status URB length before parsing the IU
Date: Wed, 14 Oct 2026 00:19:37 +0200
Message-ID: <20261013221937.41490-1-olivier.kaloudoff@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

uas_stat_cmplt() dereferences iu->tag without verifying that the
status URB actually carried a full IU header.  The transfer buffer is
a freshly-zeroed sense_iu, so a status URB that completes
successfully but with a short or empty actual_length — observed in
the wild during link-level upsets (Thunderbolt-chain xhci blips) and
on a wedging bridge — reads back as iu_id=0/tag=0 and produces the
misleading

  stat urb: no pending cmd for uas-tag 0

log spam seen e.g. on an ASMT135x enclosure and a Samsung T7, right
before the affected commands time out into the error handler.

Beyond the noise, a short packet that happens to carry a
plausible-looking header could be matched to an inflight command and
drive the state machine off garbage.  Bail out on anything shorter
than a full struct iu.

Cc: stable@vger.kernel.org
Signed-off-by: Olivier Kaloudoff <olivier.kaloudoff@gmail.com>
---
 drivers/usb/storage/uas.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 265162981269..88fed50c262b 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -315,6 +315,13 @@ static void uas_stat_cmplt(struct urb *urb)
 		goto bail;
 	}
 
+	if (urb->actual_length < sizeof(struct iu)) {
+		dev_err(&urb->dev->dev,
+			"stat urb: short transfer (%u bytes)\n",
+			urb->actual_length);
+		goto bail;
+	}
+
 	idx = be16_to_cpup(&iu->tag) - 1;
 
 	spin_lock_irqsave(&devinfo->lock, flags);
-- 
2.47.3

