Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3CBA26FA60
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 00:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792023549; cv=none; b=pR+6WSjlBQHVXkKTLxYMe7lCaFFgF3/G2bcwYWpDpQxfPYiRZ5k2lXTOiN3FZJ7WPinkgh5pxIbwOOOEvrK04wZhYwmvJt3n8zKOubgDVoTfwBycKlC/iIUjjii4n9eCNaEQcsvlLMIZ+de/teKVXFMDWfnvAV5feTW+SKw8ZAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792023549; c=relaxed/simple;
	bh=Hr2oK8ttmlpG2D61qsDIhKKQExFfy2D0BxwiCZaK48U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GYJLpxyFx6x3g991zgEFKT9LIhoKwKYy4yE7SqmVBFZR5oK7iZxEmauaRlm23ZP8iNdJQI3ciNJS2+2SRiLyyqtu2iJf/GBzy3QhN/zAHrtPXCcgTPizUXgBfM4rphwll+L36+u0BY+QMW6yw1ScgMuFas1+4QsYmhcsSLvpfbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qjgZeHrg; arc=none smtp.client-ip=209.85.210.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qjgZeHrg"
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-88bbc27f85cso6285335b3a.0
        for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 17:19:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792023547; x=1792628347; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ekzn/WWlDOKdo6/4sJafMgrym97HW3GfYUZNRGrTpGM=;
        b=qjgZeHrg66T3D+fTLb8GvjrjD5PDWNJ4IIoqkHpi87ImJ6C8Va2hS3RhCAe+vC9V6f
         INzNOEFb5jHvIW897DwUYeFbtLtEM0ULUExBt7w6uXprygM9t5IzKDE25SHm1QfQAynk
         SMBSc3RkKKJfmwW6gt74EqmOZ3y9y5BWPsvqzDruJAruaLPSMbysVrKzq0LehcyA4PwC
         nEcCMYXD2haH9R4r86Uw+rq86jcZPnwIMkmnknRihdYAfi1Mcz1pCbEj0u88N2tGhSSB
         hLU3G0Yc7P1a4ub3twm+mTIuUiHmBymKsBHuTTs9baNDkwU9opvBG/nWIILCCUaIFpdc
         MzZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792023547; x=1792628347;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ekzn/WWlDOKdo6/4sJafMgrym97HW3GfYUZNRGrTpGM=;
        b=iZXyU8YND8iOt+oXs7nf0mOU4U6tzkqrD9q+AjNsoKfvZjoG8avQys4M8Q4QrRRyKX
         RozoJ5nexAuwWG7L9ltoyrIepQP5VPux61LFvbtirGL7z3W7FxxisTCbC2umRawlwLf1
         sT77ZZ+K9nTuX4XTPrCWgNZP+dXHAb529BJll2av8tpBqmufxy9+j2ieOBX1CRDvNPUi
         MUcyDZdCkauxMUv7oI2/kyvaS81VGyRudtFeGc6Q0ZbkStVgDyJAHbcsC+0WIGQiZefI
         GQabrHdi5WciEqISBBSVLPCluJ3dwNVDo6xz4IsqMlWJpJmI+GzmKOhNymaMQWB1wBku
         KpVw==
X-Forwarded-Encrypted: i=1; AKwUvBxlIfO238/CnWJ0rezdROGM6u3dOPMda3cT7drYnrv9Gsv2xv+kGmFIqQmii5TFqmFJqDV3FGAtPs5M@vger.kernel.org
X-Gm-Message-State: AFq9FYIBHYh34cRTVVQjt0LKW+Pl23Woma7+0hdYy1mSzKRZGzo80t2z
	R1m/YHyj8Y95/kH9Pm4mhqIKpLLORvbCk+kewyJODTMApaMO4g7smJsPnWRNqazfUdA9doC5TuV
	+TQYtH3LvH1I2WgIbBj/RWQ==
X-Received: from pfbay42.prod.google.com ([2002:a05:6a00:302a:b0:88f:3e8f:c0b])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:9083:b0:895:b10f:242d with SMTP id d2e1a72fcca58-897c83ac869mr14665480b3a.43.1792023547126;
 Wed, 14 Oct 2026 17:19:07 -0700 (PDT)
Date: Thu, 15 Oct 2026 08:18:55 +0800
In-Reply-To: <20261015001855.3450573-1-stanleyjhu@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20261015001855.3450573-1-stanleyjhu@google.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261015001855.3450573-6-stanleyjhu@google.com>
Subject: [PATCH v2 5/5] scsi: ufs: core: Clear stale UIC result byte before
 peer DME retries
From: Stanley Jhu <stanleyjhu@google.com>
To: "Martin K. Petersen" <mkp@kernel.org>, 
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, 
	Bean Huo <beanhuo@micron.com>, Peter Wang <peter.wang@mediatek.com>, 
	Brian Kao <powenkao@google.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Peer DME get and set retry a failed attempt with the same struct
uic_command. UIC completion ORs the ConfigResultCode into
argument2[7:0], and nothing clears it before the next attempt. Once an
attempt fails, every retry keeps reporting that error code, even when
the device returns success, so a transient failure becomes a hard
failure after three retries. Each such retry also triggers the
WARN_ON_ONCE() in ufshcd_dispatch_uic_cmd(). In ufshcd_dme_set_attr(),
ufshcd_uic_cmd_compl() also overwrites argument3 with the register
readback before the next attempt.

Clear the result byte and restore argument3 in ufshcd_dme_set_attr()
when an attempt fails.

Fixes: 64238fbd15ea ("scsi: ufs: add retries to dme_peer get and set attribute")
Cc: stable@vger.kernel.org
Reviewed-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
---
Changes in v2:
- Clear argument2's result byte and restore argument3 (MIBvalue_W) in
  the failure path instead of before the first attempt. Kept Bean's
  Reviewed-by; Bean, please let me know if you would like to look again.

 drivers/ufs/core/ufshcd.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index bcc2512bf34b..7532fd916bfd 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4400,9 +4400,12 @@ int ufshcd_dme_set_attr(struct ufs_hba *hba, u32 attr_sel,
 	do {
 		/* for peer attributes we retry upon failure */
 		ret = ufshcd_send_uic_cmd(hba, &uic_cmd);
-		if (ret)
+		if (ret) {
 			dev_dbg(hba->dev, "%s: attr-id 0x%x val 0x%x error code %d\n",
 				set, UIC_GET_ATTR_ID(attr_sel), mib_val, ret);
+			uic_cmd.argument2 &= ~MASK_UIC_COMMAND_RESULT;
+			uic_cmd.argument3 = mib_val;
+		}
 	} while (ret && peer && --retries);
 
 	if (ret)
@@ -4467,9 +4470,11 @@ int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
 	do {
 		/* for peer attributes we retry upon failure */
 		ret = ufshcd_send_uic_cmd(hba, &uic_cmd);
-		if (ret)
+		if (ret) {
 			dev_dbg(hba->dev, "%s: attr-id 0x%x error code %d\n",
 				get, UIC_GET_ATTR_ID(attr_sel), ret);
+			uic_cmd.argument2 &= ~MASK_UIC_COMMAND_RESULT;
+		}
 	} while (ret && peer && --retries);
 
 	if (ret)
-- 
2.56.0.385.gd3acb90ef8-goog

