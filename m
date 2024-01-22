Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 675EA6280A
	for <linux-scsi@vger.kernel.org>; Mon, 22 Jan 2024 17:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705944331; cv=none; b=m/Gb0dNJlgREDOZ1hhhUZz1bB15U8h4EUH3U5gLF2sAsbXmAFZMocbTx5n8mlyGLa0zntJl/fufNBdjSIl7UqP+vn3029rKhmCm6xi17hX7jftF2cNvQ6npNOwu3JxxGpmJ5V1NhlfEqxot3qkpz2o9FalzlYnvt0t1SlQTZPZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705944331; c=relaxed/simple;
	bh=eqU9bnJJL8L6334KQv0i2/sTryAarZX2XDro3a1bVTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ttWeroKZFlq7eI1gFgogSDAPsYcpDzqWT/+9IjQff5AjdnIupjC2MlqAMhXSjgt/GsMJzJYBkGB9+IaHbfAJufVx3/XflbXggL4Tczss+V8HXNCWYjMjU/ViT/iUx7JH759lENDEzJQrXJSqVUpR0YgNksecSWeOcptVwk8T8EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dIOWq8xk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dIOWq8xk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705944325;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v9E8LP/sXchUxMDynkpMldI5w3cNLtCQjxmXDj4qu+Y=;
	b=dIOWq8xkxjsVlzEfUN7tHOFrCD6zts4YUeRRA00Bam7eZlB2tdU5Dgs9TrqmKYLIplgX8c
	TrorVX8PtfsKCSyT3P7gWfD9ZPakW9hDn8KRWf/xkmclkIC5ykymgkWdUAMMeyF/YobpXh
	EfaeLkBM5ObzFhJ2TkG5L3wYG52OQfc=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-387-0tPhQiI0OjmGcEufnsmvMA-1; Mon, 22 Jan 2024 12:25:24 -0500
X-MC-Unique: 0tPhQiI0OjmGcEufnsmvMA-1
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-42a02969f69so55894671cf.3
        for <linux-scsi@vger.kernel.org>; Mon, 22 Jan 2024 09:25:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705944320; x=1706549120;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v9E8LP/sXchUxMDynkpMldI5w3cNLtCQjxmXDj4qu+Y=;
        b=X2jB0YTOKY+tFjKPUzi81aWAZll/A9fkcAzLHWEDD5LCnfNGa2ERMZBiBR1m1T/WIv
         ZEGrcTCbtKH2YDmbvk5tefZZlsygsgxPq+R2cMBLdIHVG357SPEe6wB9zrIZIj+2GOFO
         shauJLE6FVW/XSGCgfld77EYmmTdNu0FvfvrXuwJlQAp0P+/mATSgEgdfu5skGeXgMQV
         viKW01Y5Cya/OHi8jTFOKuXbrJoSL4xXqDth0uwwwGcRrRNV2BsSSJHbdHTAkWJLuUpt
         1ysZK3dgiOWh36ANcsuW02Ib9DwLMuZFW8Rsvzv4J9hqUXm56b6QkW1zJg8RGnitBavw
         w6zQ==
X-Gm-Message-State: AOJu0YyT712CFHPFjuIoHCFCCl5k4NAqwpCJq5iIsJbxcHKQb5cNMAlg
	XEIM1ye1j+RURUZPbmr8YKmv7aXLlCSQoe21Xo30fevPvsEN0S8zL1AsbHIJ0zOsqfunsSrS53u
	PN9d4mAazHKHNSC8cPTkwN1hMFToxR+yU65SMjCRyo5lt0kK982rWbHQKXB0=
X-Received: by 2002:ac8:5c06:0:b0:42a:2be8:37f8 with SMTP id i6-20020ac85c06000000b0042a2be837f8mr7667928qti.46.1705944319780;
        Mon, 22 Jan 2024 09:25:19 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEw9tYpVM1Vb6nwYLykf7yZWc23Mfc1dOE48wD53sQO6xtnskKBD0ZYOxmi4yAMEBoT5Y13vg==
X-Received: by 2002:ac8:5c06:0:b0:42a:2be8:37f8 with SMTP id i6-20020ac85c06000000b0042a2be837f8mr7667911qti.46.1705944319483;
        Mon, 22 Jan 2024 09:25:19 -0800 (PST)
Received: from fedora.redhat.com ([2600:1700:1ff0:d0e0::37])
        by smtp.gmail.com with ESMTPSA id c7-20020a05620a200700b00781ae860c31sm2280992qka.70.2024.01.22.09.25.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jan 2024 09:25:17 -0800 (PST)
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
Subject: [PATCH RFC v4 09/11] scsi: ufs: core: Perform read back after
 disabling UIC_COMMAND_COMPL
Date: Mon, 22 Jan 2024 11:24:05 -0600
Message-ID: <20240122-ufs-reset-ensure-effect-before-delay-v4-9-90a54c832508@redhat.com>
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
index 9b6355555897..9bf490bb8eed 100644=0D
--- a/drivers/ufs/core/ufshcd.c=0D
+++ b/drivers/ufs/core/ufshcd.c=0D
@@ -4240,7 +4240,7 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, s=
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
2.43.0=0D
=0D

