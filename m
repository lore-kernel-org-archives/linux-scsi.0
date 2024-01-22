Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC1460EC8
	for <linux-scsi@vger.kernel.org>; Mon, 22 Jan 2024 17:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705944119; cv=none; b=nLpD/VrBSYgTqYWIKmzXfkrPYbn3ABQoU142dRuTCNbDrNl/mlPwxGHNDx9GPrfH9bhB0umi2iy6yR+KjnqwGJ5lSS0Xbk+m0vhjtDMiucpcjfNYHDYTpT8rIjslVBGgtRliWe4e2azvfwVPFBhMIr4dTu05im1C8xL66/t8vjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705944119; c=relaxed/simple;
	bh=OxrzxxUWihz3B2zxHQ6fTBKU+t//zIV2dCIEuKHpOM0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=MhYL9VY03e21mACoEKjNsB5bbP8DFjL5NTPIHQChSSk99ZH5ID3x173dcVaHQvYdJJIlMi+5tw1bz7sROURvDUTvi+BKkKYML0D8aXgR1AxtJQBrBAriJyTrunVhk3uIHaS5EjGXg5YG32OJzl1mfSdSj3eXOvhzoLdTvmSYcqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eoO8G6uz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eoO8G6uz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705944114;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7rD2RVNfwDn0BbFWtf0meNmC+cZt+1EvBJ+MzhncMZA=;
	b=eoO8G6uzb3M74FpxBJBjqanYSinUSE5SvmzuEkYwneC2PCnQ/ebzp/BW6Jtnx1XgJJ3cVd
	p4xcfjf0ZhZkBirSz6lPuLK2H/93INR+UHVIPZH7xFhVBxu0MgSb6wOEX7cO/hw/iz9Y+R
	qJkPuHno17eKxgvIZrWrOMzWwVfN+yQ=
Received: from mail-vk1-f199.google.com (mail-vk1-f199.google.com
 [209.85.221.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-212-8zIz4nCPN-GFqkWA9F6Vyw-1; Mon, 22 Jan 2024 12:21:53 -0500
X-MC-Unique: 8zIz4nCPN-GFqkWA9F6Vyw-1
Received: by mail-vk1-f199.google.com with SMTP id 71dfb90a1353d-4b73b65c0dbso770404e0c.1
        for <linux-scsi@vger.kernel.org>; Mon, 22 Jan 2024 09:21:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705944111; x=1706548911;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7rD2RVNfwDn0BbFWtf0meNmC+cZt+1EvBJ+MzhncMZA=;
        b=bEPPEUxz6A94SakHcmapDvhfOcF8hwdViFF85jWzm/yEmngsOAvEfiS34Hrsqg7q74
         j/Scm01l6z31oKpInHk3Esq1fIWoMf2hIWIGVYMJPbJOQPMLwY8ORRO/YratfFYhgYtz
         T/v9c5WsEU259cBfiqZEyRjKsZo5YCPc+cEDy41+7QqMZGHoONX+KfYNgrbxoBJncqfB
         14dtdsCY1ZryJVcbVLRvYt/jqtGmjA2zpFH+L1d1dYjpIhJ1PkDdYTeXD/eACwpFnIu5
         OJVghXyJw/y/0fUf8TQx88MlwAxildAA0LwONz5CFJSaYIHJIPLJerON3lCypMY5YUVi
         +rSA==
X-Gm-Message-State: AOJu0YwlsPoGDIK4xVxVrrAEkcH9d7kshULlGTiU25Ry+wZZDqtA9nD5
	feU5TH/fj9FTuKSRsxNiVpVVZ4TM3ULauteRatZ6P6zpoLYi23Uzf8sQfcWJptR5sPzBlhKekCd
	XK2riJ3kN9KYTOYrgnNDWjHutBkc8GHFPJW4Rw/nZlg/3LBENJdwPBs2yrY4=
X-Received: by 2002:a05:6122:179c:b0:4b7:422b:d7c3 with SMTP id o28-20020a056122179c00b004b7422bd7c3mr1787495vkf.20.1705944111715;
        Mon, 22 Jan 2024 09:21:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF22UHtqop2p9ldWS0FUSCe44a8uIXyYTv6zwTkEm4KTH9So+jKN01poJ3m4ghRt3Y9yA0QGA==
X-Received: by 2002:a05:6122:179c:b0:4b7:422b:d7c3 with SMTP id o28-20020a056122179c00b004b7422bd7c3mr1787474vkf.20.1705944111456;
        Mon, 22 Jan 2024 09:21:51 -0800 (PST)
Received: from [192.168.1.163] ([2600:1700:1ff0:d0e0::37])
        by smtp.gmail.com with ESMTPSA id lf3-20020a0562142cc300b00680c25f5f06sm2567738qvb.86.2024.01.22.09.21.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jan 2024 09:21:47 -0800 (PST)
From: Andrew Halaney <ahalaney@redhat.com>
Date: Mon, 22 Jan 2024 11:21:30 -0600
Subject: [PATCH RFC v4 05/11] scsi: ufs: qcom: Perform read back after
 writing CGC enable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240122-ufs-reset-ensure-effect-before-delay-v4-5-6c48432151cc@redhat.com>
References: <20240122-ufs-reset-ensure-effect-before-delay-v4-0-6c48432151cc@redhat.com>
In-Reply-To: <20240122-ufs-reset-ensure-effect-before-delay-v4-0-6c48432151cc@redhat.com>
To: Andy Gross <agross@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konrad.dybcio@linaro.org>, 
 Manivannan Sadhasivam <mani@kernel.org>, 
 "James E.J. Bottomley" <jejb@linux.ibm.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Hannes Reinecke <hare@suse.de>, Janek Kotas <jank@cadence.com>, 
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, 
 Bart Van Assche <bvanassche@acm.org>, Can Guo <quic_cang@quicinc.com>
Cc: Will Deacon <will@kernel.org>, linux-arm-msm@vger.kernel.org, 
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Andrew Halaney <ahalaney@redhat.com>, 
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
X-Mailer: b4 0.12.3

Currently, the CGC enable bit is written and then an mb() is used to
ensure that completes before continuing.

mb() ensure that the write completes, but completion doesn't mean that
it isn't stored in a buffer somewhere. The recommendation for
ensuring this bit has taken effect on the device is to perform a read
back to force it to make it all the way to the device. This is
documented in device-io.rst and a talk by Will Deacon on this can
be seen over here:

    https://youtu.be/i6DayghhA8Q?si=MiyxB5cKJXSaoc01&t=1678

Let's do that to ensure the bit hits the device. Because the mb()'s
purpose wasn't to add extra ordering (on top of the ordering guaranteed
by writel()/readl()), it can safely be removed.

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Can Guo <quic_cang@quicinc.com>
Fixes: 81c0fc51b7a7 ("ufs-qcom: add support for Qualcomm Technologies Inc platforms")
Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
---
 drivers/ufs/host/ufs-qcom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index decad95bd444..881074fc2329 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -406,7 +406,7 @@ static void ufs_qcom_enable_hw_clk_gating(struct ufs_hba *hba)
 		    REG_UFS_CFG2);
 
 	/* Ensure that HW clock gating is enabled before next operations */
-	mb();
+	ufshcd_readl(hba, REG_UFS_CFG2);
 }
 
 static int ufs_qcom_hce_enable_notify(struct ufs_hba *hba,

-- 
2.43.0

