Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D71276DD3
	for <linux-scsi@vger.kernel.org>; Thu, 21 Dec 2023 19:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DsAn/8l5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703185866;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xUUJuT608SRhCl6+0/SpXWAx7Kuk//nvBAACeA7YhJo=;
	b=DsAn/8l52t3BMaF/dCEVxgi6sP+NAKM7H3vT/b8z9zZMsGumc/Jx2Fh+x+xi4higT7bQ4f
	E6XiPWFp6Gzo+sPRqKj9WXE7aONpiSipKOTABzpQ0sJqlstY2bOAOrudkbAgDq6gOeD75T
	8P2jO/20HBTGYqkDWlkbHsLTZSy1z78=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-625-QsPhizhbPeWmBBubi49yEA-1; Thu, 21 Dec 2023 14:11:04 -0500
X-MC-Unique: QsPhizhbPeWmBBubi49yEA-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-781293a471fso24551585a.3
        for <linux-scsi@vger.kernel.org>; Thu, 21 Dec 2023 11:11:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703185860; x=1703790660;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xUUJuT608SRhCl6+0/SpXWAx7Kuk//nvBAACeA7YhJo=;
        b=gI0QXDp5sLgCY4lsvfM76HxyAAy5ndfT6UiIkVdXdqObvjIY4lJ6ghRYBttEcvOya2
         HGq62Qw+grzcKtHtUOWyvNRiAA0kE0KBsq29HjHNrc92DOhtWOZUMbCizu9XZEVvRn5a
         nSSNtDfyEDdjMiVLsU1I5fzkREJvQCLmAzBAmKssu4HRKU7H/gh6c27M3Ng1mB2dkZyL
         ti451fW/0EfKJNsFffIxstximJXKDyOOUmQ2ZlQtq9e81aQEjjpSNOuBdBbbVbbW2LEL
         rwHQFdgdfTSECiDMtrswK9DmUku/3AmJS7g5dzDBp7BVHJRipBdherxgBQgeZI/sPZLQ
         BiMg==
X-Gm-Message-State: AOJu0YydVJNOqkUJlGQPPDfUzxLJVYmQNk+jS/TovLwevfhAUDC2d4yH
	sgPir4mUUPKXXnJnMgByL4/Voe3/ghx1/ngaa/M+d0aDYlMJsHak8SLG0/EU8jTlQ2mba6nkxTD
	9A/CFAdJSHxkbB4Q4uq8i3Q9zNj0eYw==
X-Received: by 2002:ae9:e00e:0:b0:781:1a4a:584f with SMTP id m14-20020ae9e00e000000b007811a4a584fmr318118qkk.120.1703185859665;
        Thu, 21 Dec 2023 11:10:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHiXPBhS4kKMnaigM0VOu3Xfp4mKtcc2Em3gQUXqUh7Nc2UYXmSf9LOeMTOGyICyCpbM5rz5g==
X-Received: by 2002:ae9:e00e:0:b0:781:1a4a:584f with SMTP id m14-20020ae9e00e000000b007811a4a584fmr318097qkk.120.1703185859419;
        Thu, 21 Dec 2023 11:10:59 -0800 (PST)
Received: from fedora.redhat.com ([2600:1700:1ff0:d0e0::37])
        by smtp.gmail.com with ESMTPSA id 25-20020a05620a04d900b0077f0a4bd3c6sm846370qks.77.2023.12.21.11.10.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Dec 2023 11:10:56 -0800 (PST)
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
	Can Guo <quic_cang@quicinc.com>
Cc: Andrew Halaney <ahalaney@redhat.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-msm@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH RFC v3 07/11] scsi: ufs: core: Perform read back after writing UTP_TASK_REQ_LIST_BASE_H
Date: Thu, 21 Dec 2023 13:09:53 -0600
Message-ID: <20231221-ufs-reset-ensure-effect-before-delay-v3-7-2195a1b66d2e@redhat.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231221-ufs-reset-ensure-effect-before-delay-v3-0-2195a1b66d2e@redhat.com>
References: <20231221-ufs-reset-ensure-effect-before-delay-v3-0-2195a1b66d2e@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.12.3
Content-Transfer-Encoding: 8bit

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

