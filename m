Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E8213BC3E
	for <linux-scsi@vger.kernel.org>; Fri, 29 Mar 2024 20:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711745443; cv=none; b=iKlX/6qk1EwgyyxV9A14DSJXjrHIZrQy8SicPIayLLGGHaNO1wT7u747NL34EbAPTFM9JwAw/KX8HTQS1Q0Fmp800t4hv8bdJBPYyrMVy/6v+VhY6Ua/XoDlBGGoCEY6M3Co5vVn07Naoy0lqFAI1ciTqAywAyvI2SAAVuZX388=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711745443; c=relaxed/simple;
	bh=PqxfmcZUl71aJ83+FVaDE3fBXAA/MF4FXGrWqbmE6/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MpqThj3kA3bD6KSy0zhCUpV5/WWXYY4V0WHmiq1UReZFuOAbsRjviG5ZP2g6+Hvl0aZVFowGG1Ml/Ot93olR7qHlhG28HJx8Z29Qa8SpqX/ryAKu6yJXNeuiccq3t+xc5B9E2UmXjrMUP3Pg5DtVJYzFTuCGyLq5EU1Lxh8PWZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TPTjhLSv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TPTjhLSv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711745441;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6QjyaSVMjBwePVdedDMMBn4vO294tfAzIl87qC/KNtw=;
	b=TPTjhLSvN75ogmMa1GWYwNuVnquMKUW5nipcCVLsEZGwG7PdVic0CXYaSlwKRHt0FLCW7w
	urDZZ381YfWwSV+z5p6T4qkHOZLRZrVCFLfsH8eeXnRSdrY4VQyoZi5ABBAHbXR2FpGRSc
	wB/eP0w+NM4aoTv10vkQlcnCy/TJLcA=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-645-nTFV6siVMvmUrWm7Cwg4HQ-1; Fri, 29 Mar 2024 16:50:39 -0400
X-MC-Unique: nTFV6siVMvmUrWm7Cwg4HQ-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-69649f1894dso28366926d6.0
        for <linux-scsi@vger.kernel.org>; Fri, 29 Mar 2024 13:50:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711745438; x=1712350238;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6QjyaSVMjBwePVdedDMMBn4vO294tfAzIl87qC/KNtw=;
        b=I+K4zN4mTP1px6TytgxV7v9SBuDjVlcgaeqomz1T1uTaVsvqeWMjuD4at71zrPjQOP
         ystY1Wop3WxY/vosrTxcJH2mdjPYuKyZoDGJ3sa8l0GBF3SWqfoOfvqj2BrlTlMjeZXF
         eKXn8DJS87sjTKdMAHCRg8uLBgCk2mmoifMvsqlCWwEZpqp6QP0JjoLqC7GvMdMpY9b3
         NICchPzvSmuXLW9SEF95P8AAJbC5h2/r6zkU6KyUEZInuerdUGSN5AtqHwoTPrxyEIq+
         SOofAEf1m52IIpgz5jpAQM0aAADWo0WN8vYoAIrPUbJigLX8Viy+Crc+ftI2NuzbFdJt
         Q/ZA==
X-Forwarded-Encrypted: i=1; AJvYcCVKX4BRDqr4JAm88WJGd85Qn6QtVf0GwIw6ooOlBOm3t2uWhXO+g9S8nJKFR1A0njLgw1f2llTfM5NAvMiQPlQA61QUNYUQwTk6jA==
X-Gm-Message-State: AOJu0YwWagr5KeJAtDnJPkIrdAd+TsCakQnDh+6mHs0hWIw9i3ydkWJW
	jVP9ZMn7GjbJSqUM1sGODByXloISxaYGdvLiyHtAC/Tx35GQOCPH2OevqLN/FMIQKKBW59qR170
	4qAal+Nw3Vm1XHEjcpmOuR1+kaG4sjBg9j0AkV9NcjdKh2WLglzQJ0gwmg/U=
X-Received: by 2002:a0c:f98b:0:b0:696:b03b:95c9 with SMTP id t11-20020a0cf98b000000b00696b03b95c9mr3554500qvn.45.1711745438107;
        Fri, 29 Mar 2024 13:50:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHeopnUxHF7SURKgs64+ifYV1WqjEh+CLYVI3V7yZtqeLq0zE8KjS5O671BagYz47YJT4NKBQ==
X-Received: by 2002:a0c:f98b:0:b0:696:b03b:95c9 with SMTP id t11-20020a0cf98b000000b00696b03b95c9mr3554487qvn.45.1711745437715;
        Fri, 29 Mar 2024 13:50:37 -0700 (PDT)
Received: from x1gen2nano.redhat.com ([2600:1700:1ff0:d0e0::33])
        by smtp.gmail.com with ESMTPSA id jz10-20020a0562140e6a00b00698f27c6460sm794271qvb.110.2024.03.29.13.50.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Mar 2024 13:50:34 -0700 (PDT)
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
Subject: [PATCH v5 09/11] scsi: ufs: core: Perform read back after
 disabling UIC_COMMAND_COMPL
Date: Fri, 29 Mar 2024 15:46:51 -0500
Message-ID: <20240329-ufs-reset-ensure-effect-before-delay-v5-9-181252004586@redhat.com>
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

Currently, the UIC_COMMAND_COMPL interrupt is disabled and a wmb() is=0D
used to complete the register write before any following writes.=0D
=0D
wmb() ensures the writes complete in that order, but completion doesn't=0D
mean that it isn't stored in a buffer somewhere. The recommendation for=0D
ensuring this bit has taken effect on the device is to perform a read=0D
back to force it to make it all the way to the device. This is=0D
documented in device-io.rst and a talk by Will Deacon on this can=0D
be seen over here:=0D
=0D
    https://youtu.be/i6DayghhA8Q?si=3DMiyxB5cKJXSaoc01&t=3D1678=0D
=0D
Let's do that to ensure the bit hits the device. Because the wmb()'s=0D
purpose wasn't to add extra ordering (on top of the ordering guaranteed=0D
by writel()/readl()), it can safely be removed.=0D
=0D
Fixes: d75f7fe495cf ("scsi: ufs: reduce the interrupts for power mode chang=
e requests")=0D
Reviewed-by: Bart Van Assche <bvanassche@acm.org>=0D
Reviewed-by: Can Guo <quic_cang@quicinc.com>=0D
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>=0D
Signed-off-by: Andrew Halaney <ahalaney@redhat.com>=0D
---=0D
 drivers/ufs/core/ufshcd.c | 2 +-=0D
 1 file changed, 1 insertion(+), 1 deletion(-)=0D
=0D
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c=0D
index 268fcfebd7bd..dfa4f827766a 100644=0D
--- a/drivers/ufs/core/ufshcd.c=0D
+++ b/drivers/ufs/core/ufshcd.c=0D
@@ -4287,7 +4287,7 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, s=
truct uic_command *cmd)=0D
 		 * Make sure UIC command completion interrupt is disabled before=0D
 		 * issuing UIC command.=0D
 		 */=0D
-		wmb();=0D
+		ufshcd_readl(hba, REG_INTERRUPT_ENABLE);=0D
 		reenable_intr =3D true;=0D
 	}=0D
 	spin_unlock_irqrestore(hba->host->host_lock, flags);=0D
=0D
-- =0D
2.44.0=0D
=0D

