Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A58B13A246
	for <linux-scsi@vger.kernel.org>; Fri, 29 Mar 2024 20:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711745361; cv=none; b=a6JYhyTmhLTwfL1FK7N9FSvLbcsdQwLyk+fg1Jp4UAfGDMjEi4mP9VI6vpFuDMHdYBT4AQmVSXTvyxJb5gu18XDeDp4KWs/iYj73Pqlb0g6CN6eb3oGglaGHIhNF+dSj+y0TPVJ/8ekCyt1yt63q2o/YwbgFKgo5XnYpqqxlBe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711745361; c=relaxed/simple;
	bh=MqUK4t3jMDCrMMs9Mz5+Qm33rxyXcyDKec2Tc5qngjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YkcDq7bEIWhwD9bLdUp07CmXoN5v4zSMSTM2PVpmeBu9+g3JurF0p2PAkpbYQV/3qH1CaB93Uoe+VJg7HfkTuiGBWNy11MfHMe0oYQKBIzAcJeDtZ26byZLaqOY9lp3LKt9mGPekw6Q/npaBsLI00qV3whYglbRjzRie4QI2rAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S/8BiKQs; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S/8BiKQs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711745359;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bbrTh9OZvl0SuHCPomptfMbosBAijok3aL1EimHPcPQ=;
	b=S/8BiKQsglR8lcLSbSrDsB4qkXbtv5Ff1KhH3ehRrJnzk1oWTwo46oAYVaiYAxUgCoOfK3
	q1OPCqtVu9aHgn3pPpj5+FQ9h2nap4JmS8PgCnh4i/x0qv7wYUfEn9kNOj4Ir8ZTSxKgLJ
	B5Fu4Rjyquuy2gwAjffpObTvChHy9t0=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-679-YXdEpigyNwKc-VeEVYhjHg-1; Fri, 29 Mar 2024 16:49:15 -0400
X-MC-Unique: YXdEpigyNwKc-VeEVYhjHg-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-696a35b5d38so27573046d6.3
        for <linux-scsi@vger.kernel.org>; Fri, 29 Mar 2024 13:49:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711745350; x=1712350150;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bbrTh9OZvl0SuHCPomptfMbosBAijok3aL1EimHPcPQ=;
        b=mCCURvNjNuG8Zk+jWaMgKwOuaIs8MANsU2JlYMgTnbW+55Aet4aK7fl2+ipkB21Oh/
         soOPvfBlsiOaLpC1wrTHc6cvMVgBvwFwT/Nu24Zuv/1q9ZdfXS0ps4R45MKzOYdmRXSz
         k+XK3C7+MKuHr26lUIw2ekbVyy+FOa208DLDys+0XZlGwtmebhn7aJiOcoPnGRcreUnk
         Tv+sPU+Tk03yjKXVfXZuPokWtv4y92/gnwOb3AVU5FcKFo72U2pebwbZ4BdUNrHBaUmL
         psb3NxGePCGYW1v8tJquf3jnheS/nqjVPMBYU+QLcVdjHchS8VsD38HmZwcmzg4pZAmQ
         eGMw==
X-Forwarded-Encrypted: i=1; AJvYcCWT/kFA5DoKK/YJWjEBP8rDj/InJEpQorG16DOiOuqEGCE86vpptw00PFeuHNXAxAyNjnQX7GK7xIkPb2glgfEDN+fmeLFPbHFEhw==
X-Gm-Message-State: AOJu0Yz/lJ9vuik4AS9lRiaFkiis9gB/IRZ8RpC0xQKfBbEsy5fbZIjG
	WO4gFiMLL5uFOpmOjDXV9r+BqT0fVBzYESCZuzvegLrvAP6zNIlQlEIkuqpsbRlR7SIL5u+g3zU
	bm0xYt4xsNMx9XQfe/kmd+Z+WXtKyVuu5X0rUFOGOwSAgwwaiqpZ6RUKolFw=
X-Received: by 2002:a0c:d64d:0:b0:696:3a75:2964 with SMTP id e13-20020a0cd64d000000b006963a752964mr3120760qvj.18.1711745350516;
        Fri, 29 Mar 2024 13:49:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHJ88QIcMuVCz52/RQwc9/KpZS2Pszl/Xy5I/f0VraMqB6QDoXwQ9/e4R2qP+NldNZut7x/7w==
X-Received: by 2002:a0c:d64d:0:b0:696:3a75:2964 with SMTP id e13-20020a0cd64d000000b006963a752964mr3120749qvj.18.1711745350105;
        Fri, 29 Mar 2024 13:49:10 -0700 (PDT)
Received: from x1gen2nano.redhat.com ([2600:1700:1ff0:d0e0::33])
        by smtp.gmail.com with ESMTPSA id jz10-20020a0562140e6a00b00698f27c6460sm794271qvb.110.2024.03.29.13.49.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Mar 2024 13:49:09 -0700 (PDT)
From: Andrew Halaney <ahalaney@redhat.com>
To: Andy Gross <agross@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Hannes Reinecke <hare@suse.de>,
	Janek Kotas <jank@cadence.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Can Guo <quic_cang@quicinc.com>,
	Anjana Hari <quic_ahari@quicinc.com>
Cc: Andrew Halaney <ahalaney@redhat.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-msm@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH v5 06/11] scsi: ufs: cdns-pltfrm: Perform read back after
 writing HCLKDIV
Date: Fri, 29 Mar 2024 15:46:48 -0500
Message-ID: <20240329-ufs-reset-ensure-effect-before-delay-v5-6-181252004586@redhat.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240329-ufs-reset-ensure-effect-before-delay-v5-0-181252004586@redhat.com>
References: <20240329-ufs-reset-ensure-effect-before-delay-v5-0-181252004586@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.13.0
Content-Transfer-Encoding: quoted-printable

Currently, HCLKDIV is written to and then completed with an mb().=0D
=0D
mb() ensure that the write completes, but completion doesn't mean that=0D
it isn't stored in a buffer somewhere. The recommendation for=0D
ensuring this bit has taken effect on the device is to perform a read=0D
back to force it to make it all the way to the device. This is=0D
documented in device-io.rst and a talk by Will Deacon on this can=0D
be seen over here:=0D
=0D
    https://youtu.be/i6DayghhA8Q?si=3DMiyxB5cKJXSaoc01&t=3D1678=0D
=0D
Let's do that to ensure the bit hits the device. Because the mb()'s=0D
purpose wasn't to add extra ordering (on top of the ordering guaranteed=0D
by writel()/readl()), it can safely be removed.=0D
=0D
Fixes: d90996dae8e4 ("scsi: ufs: Add UFS platform driver for Cadence UFS")=
=0D
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>=0D
Signed-off-by: Andrew Halaney <ahalaney@redhat.com>=0D
---=0D
 drivers/ufs/host/cdns-pltfrm.c | 2 +-=0D
 1 file changed, 1 insertion(+), 1 deletion(-)=0D
=0D
diff --git a/drivers/ufs/host/cdns-pltfrm.c b/drivers/ufs/host/cdns-pltfrm.=
c=0D
index bb30267da471..66811d8d1929 100644=0D
--- a/drivers/ufs/host/cdns-pltfrm.c=0D
+++ b/drivers/ufs/host/cdns-pltfrm.c=0D
@@ -136,7 +136,7 @@ static int cdns_ufs_set_hclkdiv(struct ufs_hba *hba)=0D
 	 * Make sure the register was updated,=0D
 	 * UniPro layer will not work with an incorrect value.=0D
 	 */=0D
-	mb();=0D
+	ufshcd_readl(hba, CDNS_UFS_REG_HCLKDIV);=0D
 =0D
 	return 0;=0D
 }=0D
=0D
-- =0D
2.44.0=0D
=0D

