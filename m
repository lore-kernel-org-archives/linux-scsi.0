Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0FB253E2A
	for <linux-scsi@vger.kernel.org>; Mon, 22 Jan 2024 17:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705944280; cv=none; b=kzCx9wUhsgId79ty2NJ3BS6X2PcjiVi9yw/tdyKJ+9XTIZL+o9dO9p7fG9dnYCIMNZIFJ8VULE3QdGyFr6NK7Jl2jjh4sCBsENHJSuEulbmHwMLezQCLi96ZLVhljdUfYoen66QRzaZFS400Wa/d9A35reCQe4eVyIBPnmQmGw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705944280; c=relaxed/simple;
	bh=s5zG+L/VGA4r6opNYDq/X6r4u7Dz3JHhUiw1v8rHzzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cjlyOykdi1jGabwxvSPlPlZ/Jtw/aMsP6lKngkSdzo2PhH2PpTCaXbAu4pStyrzpI0C5NXzrrqo1yZGWsBcPfc5vKPubapJfuZL6cwRfes7LZgfNMvZ3mIoADK1xcUxP3S2/KVcdiez02rTNE1PoxzZ4mh+uzWq59Jw4dGIfzwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Cfk6YGvM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Cfk6YGvM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705944277;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Nbn1T5pI3z/UbfuUYU7cHvzOeNQR0JNnB8PBypvklZ8=;
	b=Cfk6YGvMkWj9b6kanaySbzdsc1U8YQ3Shsh/THWdv3gl6s6Y4O7PMSswhTLDYDujx6jtA1
	xiF3WXweVpuWHVk07U3ApxFvNop1SitkigoW68VI1HNvWvRJ589bSTE0V+x0F+moHF7mcw
	7xYaGgd7qBFWcLZgYX4vc+0M3+4iNok=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-495-CXoUw4erO3KvqOksbAFoSg-1; Mon, 22 Jan 2024 12:24:36 -0500
X-MC-Unique: CXoUw4erO3KvqOksbAFoSg-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-783874e9123so515592785a.0
        for <linux-scsi@vger.kernel.org>; Mon, 22 Jan 2024 09:24:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705944271; x=1706549071;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Nbn1T5pI3z/UbfuUYU7cHvzOeNQR0JNnB8PBypvklZ8=;
        b=nn83wZ7CEtg27ai+WVjOuaATvJYYCgq5Xg5ao7a+RDbaPrvYUE9MPIekjzjQ2UVmCl
         NLIhZBCe1TjczCNWAfW6e8UyEpb9/jBjT92MuE5H699F0UQroi3sWj3u3QDm+9iH6Z3V
         vtnNhQzhBbkLIp6lQ8y/QbzZz8suQr5HVfW9OZjkW13RFqLEM1qIYmi9IhWm8kMpVwzb
         ssbxTk2sYp5DDpaazUpmj1P67E5MlsTjj83gu2xcPIdBIW8s4nk9Q62zs445FRXUULNP
         Iq14xtS8D5EO1UogLVqusKVAMbJzjv7iYK1VcRi6Rm+7YmLsKpM9cV1PlH9Qa2i+xf/Q
         PvJg==
X-Gm-Message-State: AOJu0Yz6Aa7xTnVx5coSmfhGeiHtmx8mwLn2Z4+dSu7bqUGTOwhA9qyf
	1/cxXqBI3xamLJIh+wKefbhB17w+bzEJyZdPuXYBEGZ6KEaOesdWbj/eXSXsBTClXAN86/QA1x9
	YLdgDU/GMJehnkAmdC12qyojHE0KqfvIVRcCT8SWcuZyYcECKkTU8gAnPCSc=
X-Received: by 2002:a05:620a:4092:b0:783:a2ba:eebc with SMTP id f18-20020a05620a409200b00783a2baeebcmr1181217qko.24.1705944271372;
        Mon, 22 Jan 2024 09:24:31 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH+cIRyR7E/BPa15GlhIFB+sJnWKn/RhvzQjmmC1gCPckHcfoCIOnQhcFc6TJFKCb9MtxlDLw==
X-Received: by 2002:a05:620a:4092:b0:783:a2ba:eebc with SMTP id f18-20020a05620a409200b00783a2baeebcmr1181193qko.24.1705944270958;
        Mon, 22 Jan 2024 09:24:30 -0800 (PST)
Received: from fedora.redhat.com ([2600:1700:1ff0:d0e0::37])
        by smtp.gmail.com with ESMTPSA id c7-20020a05620a200700b00781ae860c31sm2280992qka.70.2024.01.22.09.24.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jan 2024 09:24:30 -0800 (PST)
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
	linux-kernel@vger.kernel.org,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH RFC v4 06/11] scsi: ufs: cdns-pltfrm: Perform read back
 after writing HCLKDIV
Date: Mon, 22 Jan 2024 11:24:02 -0600
Message-ID: <20240122-ufs-reset-ensure-effect-before-delay-v4-6-90a54c832508@redhat.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122-ufs-reset-ensure-effect-before-delay-v4-0-90a54c832508@redhat.com>
References: <20240122-ufs-reset-ensure-effect-before-delay-v4-0-90a54c832508@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.12.3
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
2.43.0=0D
=0D

