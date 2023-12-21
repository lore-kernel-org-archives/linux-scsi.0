Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C60E976DDF
	for <linux-scsi@vger.kernel.org>; Thu, 21 Dec 2023 18:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F7fequ4V"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703183155;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xUUJuT608SRhCl6+0/SpXWAx7Kuk//nvBAACeA7YhJo=;
	b=F7fequ4VIRhX6t6qYOHntkIvt8CQokcEKjGn/U0tUQkQVopRnXMKqtVTxDp137WRdBtCBI
	LfvZAG45B3jGTP6jsnreth9bc/9I0y9AlT1iw02CzPJzFg8XAA6FEPEW9ir9/bInORAbbs
	mM8ET+MwoNTsi6vRDnPO5J7R/4CVMRk=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-475-bYbruVEgOsGNvrLHMR86tw-1; Thu, 21 Dec 2023 13:25:54 -0500
X-MC-Unique: bYbruVEgOsGNvrLHMR86tw-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7810802421bso131705285a.2
        for <linux-scsi@vger.kernel.org>; Thu, 21 Dec 2023 10:25:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703183150; x=1703787950;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xUUJuT608SRhCl6+0/SpXWAx7Kuk//nvBAACeA7YhJo=;
        b=P2iE1QJV3grzQKxH3Zuw1KhJE0RGKeI0uHXoyiOa4ZmL4zs2SbUNzMtFLciis/pmxG
         gXWHqy2hzSmANz63TZu0VZIepV67utCfFk771abwaZ77saIsL7GAKz3MjDI7Axw4mEcw
         VyiWtgUy2bYD7fd2JC1Qg7Yo84JHLdA/y4/cNlKgxx1kk5s6Rz2q5NyTgtM76g8pz2rs
         nx8f+8m2QbOdSlcXSRGbylJsmbdsJpdoo0Lr7Y8YOYsmR8TKhvhthNr6MpOOYss9iteT
         4L/NvwOiKlZFr4HkLPeF1YZ9H8tiHcO+9vMXQN3ChD6CMnN06FaqiTGFqJgNiDw1jkas
         MZQQ==
X-Gm-Message-State: AOJu0Yzk1y+GDVB2b+llHm0tlMQvKCwd0JiH2i+WEeyRzIrfsi5Y5hxB
	MtaftP5tt9B8WU6jqHPTT2T46gIXCmbuxHPRDNM01kHLAlSGWGM2/Fo+nVPiwWO/9Biqek9C+aJ
	u0/dHu12OzkUFEsgZhArsGSNsKp3c1g==
X-Received: by 2002:a05:6214:23cf:b0:67a:a721:f313 with SMTP id hr15-20020a05621423cf00b0067aa721f313mr119304qvb.83.1703183150067;
        Thu, 21 Dec 2023 10:25:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGJ9Kju9IqTA5EEJRzv9VHVG6omJS9ICt+kO57nwljfFPxGim4CiNb9HpK10WnlhSNr539//w==
X-Received: by 2002:a05:6214:23cf:b0:67a:a721:f313 with SMTP id hr15-20020a05621423cf00b0067aa721f313mr119290qvb.83.1703183149828;
        Thu, 21 Dec 2023 10:25:49 -0800 (PST)
Received: from [192.168.1.163] ([2600:1700:1ff0:d0e0::37])
        by smtp.gmail.com with ESMTPSA id da7-20020a05621408c700b0067f2c03d4adsm779605qvb.100.2023.12.21.10.25.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Dec 2023 10:25:46 -0800 (PST)
From: Andrew Halaney <ahalaney@redhat.com>
Date: Thu, 21 Dec 2023 12:25:24 -0600
Subject: [PATCH RFC v2 07/11] scsi: ufs: core: Perform read back after
 writing UTP_TASK_REQ_LIST_BASE_H
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231221-ufs-reset-ensure-effect-before-delay-v2-7-75af2a9bae51@redhat.com>
References: <20231221-ufs-reset-ensure-effect-before-delay-v2-0-75af2a9bae51@redhat.com>
In-Reply-To: <20231221-ufs-reset-ensure-effect-before-delay-v2-0-75af2a9bae51@redhat.com>
To: Andy Gross <agross@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konrad.dybcio@linaro.org>, 
 Manivannan Sadhasivam <mani@kernel.org>, 
 "James E.J. Bottomley" <jejb@linux.ibm.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Yaniv Gardi <ygardi@codeaurora.org>, Dov Levenglick <dovl@codeaurora.org>, 
 Hannes Reinecke <hare@suse.de>, Subhash Jadavani <subhashj@codeaurora.org>, 
 Gilad Broner <gbroner@codeaurora.org>, 
 Venkat Gopalakrishnan <venkatg@codeaurora.org>, 
 Janek Kotas <jank@cadence.com>, Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
 Anjana Hari <quic_ahari@quicinc.com>, Dolev Raviv <draviv@codeaurora.org>, 
 Can Guo <quic_cang@quicinc.com>
Cc: Will Deacon <will@kernel.org>, linux-arm-msm@vger.kernel.org, 
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Andrew Halaney <ahalaney@redhat.com>
X-Mailer: b4 0.12.3

Currently, the UTP_TASK_REQ_LIST_BASE_L/UTP_TASK_REQ_LIST_BASE_H regs
are written to and then completed with an mb().

mb() ensure that the write completes, but completion doesn't mean that
it isn't stored in a buffer somewhere. The recommendation for
ensuring these bits have taken effect on the device is to perform a read
back to force it to make it all the way to the device. This is
documented in device-io.rst and a talk by Will Deacon on this can
be seen over here:

    https://youtu.be/i6DayghhA8Q?si=MiyxB5cKJXSaoc01&t=1678

Let's do that to ensure the bits hit the device. Because the mb()'s
purpose wasn't to add extra ordering (on top of the ordering guaranteed
by writel()/readl()), it can safely be removed.

Fixes: 88441a8d355d ("scsi: ufs: core: Add hibernation callbacks")
Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
---
 drivers/ufs/core/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index d1e33328ff3f..7bfb556e5b8e 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10351,7 +10351,7 @@ int ufshcd_system_restore(struct device *dev)
 	 * are updated with the latest queue addresses. Only after
 	 * updating these addresses, we can queue the new commands.
 	 */
-	mb();
+	ufshcd_readl(hba, REG_UTP_TASK_REQ_LIST_BASE_H);
 
 	/* Resuming from hibernate, assume that link was OFF */
 	ufshcd_set_link_off(hba);

-- 
2.43.0

