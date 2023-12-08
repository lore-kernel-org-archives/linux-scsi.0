Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G/V1uyK5"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C922110C4
	for <linux-scsi@vger.kernel.org>; Fri,  8 Dec 2023 12:20:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702066804;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Dmhz6YelCeMUGlAbZoc9SE3nXBabjlnAcn1GMpcxzgg=;
	b=G/V1uyK5/Hj9/JhB+I7d0FV0G4DlPuKasUzfOP0KiWaoDeZlQBHS2+gk71sMJOCc80QnyC
	pXP6FWjegWj4fiOFg80Fp2k9sX3k/ykNlZsFfkkUq0A9laQLmXyDJsBvb6S9/CnajPdJmM
	9TvQwEs/PMZ6bRaLGBU1XZpsxBucBFU=
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com
 [209.85.160.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-151-TwLS-YV6O_m2taDyjdxxcA-1; Fri, 08 Dec 2023 15:20:02 -0500
X-MC-Unique: TwLS-YV6O_m2taDyjdxxcA-1
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-1fb3db72d92so4199392fac.0
        for <linux-scsi@vger.kernel.org>; Fri, 08 Dec 2023 12:20:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702066797; x=1702671597;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Dmhz6YelCeMUGlAbZoc9SE3nXBabjlnAcn1GMpcxzgg=;
        b=PmXo8qd/5+4gKEE6YrT8iDaXXSNpmw/x7BDaXBWD8Cr2PRGyQ8KN3Q8mRyqtipoHB+
         YDAgyyo5WkJdp2M/yorxZkb9RqVmExdsLd1yLBJFgMBNJhoTAHLY+J+DaYxrKxnRCKFj
         9IT/V9bNkLHS9bIyY/EghaBEVdBdkNjUWccO0p6AeYsKoDEzdAubpcWV7XUuF69JJM9r
         cJkUlvSkog4VL07WSD1xa6W1t7Ohbl4eibIpav548uFgmr2HFoFVyZ/t2XGt0zq4dUT3
         sgbakAiYu9Zte/fFzq/q1JG9XC7otH1z+oZNBb85SkHO5u1p4V5ReehMslZFBG1kW7tg
         R5HA==
X-Gm-Message-State: AOJu0YzitbpkIf2ZEo89XDltGLCn6Xmq7NFPrrGaNyGvayjUWjdk69tI
	JVfK3M1o6dRQ10gMicrAmwYibCueNtHhsPabUnyo7SL2S6nuQ16iOMogoV3cgidS6kqWHf8OfVF
	lsRN3coKCsYOnM7qEkEUbgFrj5ECkC9G8KAqnatz9KdzrzTK6nIw9cbzwr8Tw6Ui2BA7wZdONgx
	4aeqEKDg==
X-Received: by 2002:a05:6870:70a4:b0:1fb:75a:de6d with SMTP id v36-20020a05687070a400b001fb075ade6dmr796072oae.91.1702066796835;
        Fri, 08 Dec 2023 12:19:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGt/wDbYfJpmyXdtxehEwlxdvCK3ovj8X10LRECzRE+Gbq8Lqd47/8LIfx9oZolHJvvXhpEYg==
X-Received: by 2002:a05:6870:70a4:b0:1fb:75a:de6d with SMTP id v36-20020a05687070a400b001fb075ade6dmr796054oae.91.1702066796483;
        Fri, 08 Dec 2023 12:19:56 -0800 (PST)
Received: from [192.168.1.164] ([2600:1700:1ff0:d0e0::47])
        by smtp.gmail.com with ESMTPSA id f16-20020a0cc310000000b0067cd016819esm1055342qvi.131.2023.12.08.12.19.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Dec 2023 12:19:56 -0800 (PST)
From: Andrew Halaney <ahalaney@redhat.com>
Date: Fri, 08 Dec 2023 14:19:44 -0600
Subject: [PATCH] scsi: ufs: qcom: Perform read back after writing reset bit
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231208-ufs-reset-ensure-effect-before-delay-v1-1-8a0f82d7a09e@redhat.com>
X-B4-Tracking: v=1; b=H4sIAF96c2UC/x3NQQ6CMBBG4auQWTtJW5RQr2JYIP2rk5hiZsBIC
 He3cflt3tvJoAKja7OT4iMmc6nwp4am51geYEnVFFxofXA9r9lYYVgYxVYFI2dMC9+R56qE17h
 xB9f1MabL2Ueqqbciy/e/uQ3H8QMeH83ydgAAAA==
To: Andy Gross <agross@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konrad.dybcio@linaro.org>, 
 Manivannan Sadhasivam <mani@kernel.org>, 
 "James E.J. Bottomley" <jejb@linux.ibm.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Yaniv Gardi <ygardi@codeaurora.org>, Dov Levenglick <dovl@codeaurora.org>
Cc: Will Deacon <will@kernel.org>, linux-arm-msm@vger.kernel.org, 
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Andrew Halaney <ahalaney@redhat.com>
X-Mailer: b4 0.12.3

Currently, the reset bit for the UFS provided reset controller (used by
its phy) is written to, and then a mb() happens to try and ensure that
hit the device. Immediately afterwards a usleep_range() occurs.

mb() ensure that the write completes, but completion doesn't mean that
it isn't stored in a buffer somewhere. The recommendation for
ensuring this bit has taken effect on the device is to perform a read
back to force it to make it all the way to the device. This is
documented in device-io.rst and a talk by Will Deacon on this can
be seen over here:

    https://youtu.be/i6DayghhA8Q?si=MiyxB5cKJXSaoc01&t=1678

Let's do that to ensure the bit hits the device. By doing so and
guaranteeing the ordering against the immediately following
usleep_range(), the mb() can safely be removed.

Fixes: 81c0fc51b7a7 ("ufs-qcom: add support for Qualcomm Technologies Inc platforms")
Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
---
This is based on top of:

    https://lore.kernel.org/linux-arm-msm/20231208065902.11006-1-manivannan.sadhasivam@linaro.org/T/#ma6bf749cc3d08ab8ce05be98401ebce099fa92ba

Since it mucks with the reset as well, and looks like it will go in
soon.

I'm unsure if this is totally correct. The goal of this
seems to be "ensure the device reset bit has taken effect before
delaying afterwards". As I describe in the commit message, mb()
doesn't guarantee that, the read back does... if it's against a udelay().
I can't quite totally 100% convince myself that applies to usleep_range(),
but I think it should be.

In either case, I think the read back makes sense, the question is "is
it safe to remove the mb()?".

Sorry, Will's talk over has inspired me to poke the bear whenever I see
a memory barrier in a driver I play with :)

    https://youtu.be/i6DayghhA8Q?si=12B0wCqImx1lz8QX&t=1677
---
 drivers/ufs/host/ufs-qcom.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/ufs/host/ufs-qcom.h b/drivers/ufs/host/ufs-qcom.h
index cdceeb795e70..c8cd59b1b8a8 100644
--- a/drivers/ufs/host/ufs-qcom.h
+++ b/drivers/ufs/host/ufs-qcom.h
@@ -147,10 +147,10 @@ static inline void ufs_qcom_assert_reset(struct ufs_hba *hba)
 	ufshcd_rmwl(hba, UFS_PHY_SOFT_RESET, UFS_PHY_SOFT_RESET, REG_UFS_CFG1);
 
 	/*
-	 * Make sure assertion of ufs phy reset is written to
-	 * register before returning
+	 * Dummy read to ensure the write takes effect before doing any sort
+	 * of delay
 	 */
-	mb();
+	ufshcd_readl(hba, REG_UFS_CFG1);
 }
 
 static inline void ufs_qcom_deassert_reset(struct ufs_hba *hba)
@@ -158,10 +158,10 @@ static inline void ufs_qcom_deassert_reset(struct ufs_hba *hba)
 	ufshcd_rmwl(hba, UFS_PHY_SOFT_RESET, 0, REG_UFS_CFG1);
 
 	/*
-	 * Make sure de-assertion of ufs phy reset is written to
-	 * register before returning
+	 * Dummy read to ensure the write takes effect before doing any sort
+	 * of delay
 	 */
-	mb();
+	ufshcd_readl(hba, REG_UFS_CFG1);
 }
 
 /* Host controller hardware version: major.minor.step */

---
base-commit: 8fdfb333a099b142b49510f2e55778d654a5b224
change-id: 20231208-ufs-reset-ensure-effect-before-delay-6e06899d5419

Best regards,
-- 
Andrew Halaney <ahalaney@redhat.com>

