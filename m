Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A22B382
	for <linux-scsi@vger.kernel.org>; Mon,  2 Sep 2024 05:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725254434; cv=none; b=eymIkL/0PMPRnjsatZSnz2iHj7CzxjvrgIypTLTOEFCHa3T85GTkwdlOGGNgCf+8lq5llt8FO7KXmAgqcT+8bueWK8cwTW3dVPl5Vg5Eb+oetCbqOqBcnYX7LU5QIMYvq+MaSPZRKcOh4+Nj/uXCnNLsoQvloqOJQWpfdBFNu6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725254434; c=relaxed/simple;
	bh=KvKf4g0Bbhp3lZCttFyNHndJpiFd0u4cw7Jr+H2fsGI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sFMoMSGvj6wYrKaoqjLGfmqLY5TDQbVLkoS5b/vVt7/xitywQ34jiq2WxrjJnjpH310iBufdeR+jNSRkGW9RaLSKvnsflTkoW6tWZ0kWRO7Ni14pH3EOXivXC//9gE4wlgmmWUK2UgQa0h/5N7n6iVf4SndCjlrcJyFQZfjo4gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=a1PQyklq; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="a1PQyklq"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2055a3f80a4so5780895ad.2
        for <linux-scsi@vger.kernel.org>; Sun, 01 Sep 2024 22:20:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1725254432; x=1725859232; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=svCd9cCmgi2dsrZIqz9Ry+NjpaYUU7HzIWIuLx9fASw=;
        b=a1PQyklqoevg4Z8ysVpaRSgCO3JcBBte/f1+B3LrQu4IZQZ8R7CqKscbQbSWSbKjCj
         aReR3EoF0TCsYFKhCcFSo5NhULAfJ/A2OM221KuphmdEwYsjxvuKaLhNzWnuYOinBMlU
         1F2tzYcMUaKU9Bl8C+UA79QasDc14ApzFgMtwhobbdlC+jvkvYsqjH+B090FG1xq0erF
         58XS8zxnx1wuPdJIs9K+F2JsM/pJjx6niIWIWYW9Egk/VrxVcCkYamYx/KXZZ0x0b5IZ
         dKJUguJ1dOjvh1hY546bSycLCd2gouDqePNQjZzkWgV3xdEWS7oQ5eW6yS2+lL8z37LB
         wC9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725254432; x=1725859232;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=svCd9cCmgi2dsrZIqz9Ry+NjpaYUU7HzIWIuLx9fASw=;
        b=HI93wKtA0V+Labv72Jb3lWbdvmRwRwUT3Plp28wzNeGqx9JZWIQ+lS9CSjZrybaUZI
         tducfJj3kDyxLrIe0yh6U65fU3IPS3fCw4pUCOpzxjZQPRjWBDJmRt1XSScI3rMNKvqF
         vjbb3Fvo/9Cuak5OOr8qIfCaO5/NV7usiedU7iRkzDMVTEyJMk+4oZxcbAG04zNZ/dW4
         NX9zeJLj3UTQD8mkBlvsd/MaX+A1NccNb9ftoPYht/1uwRO6dmwI3uanCG46vrX4HsRS
         uPuSW7zzUTLdaiD2Fsc5QPKsxHpQecgYmAB2u1kYyYjebaSYFgzOUFD/C5Il8Bzc5Rjz
         wRZw==
X-Forwarded-Encrypted: i=1; AJvYcCXUO4oRU9c5M3U0Yke3PM0SMbSpOftOGB5EYX0T6aFYrEAmadMjvnxkfAWti3rYK3w4MSFiUcz+nEur@vger.kernel.org
X-Gm-Message-State: AOJu0YxhU9Hrbq3vIU0c6UHthG3wL9Bd0aON2rmKietns5MISZFU5frS
	NK6Iyc/oQbC91TkIMFUVvJfNEzsyBF3Y+hnF3RXBZdXO6D0pBMQuBTuTXLp32w==
X-Google-Smtp-Source: AGHT+IENo82OP7KUAchOYeqsGnHpgO27EwWWGu6yGd/8R1i+gvRUCCf9ONzPCabM/KVK3PRQdMypwg==
X-Received: by 2002:a17:902:f688:b0:1fb:4194:5b78 with SMTP id d9443c01a7336-2054477bfbamr54625635ad.47.1725254432576;
        Sun, 01 Sep 2024 22:20:32 -0700 (PDT)
Received: from thinkpad ([120.60.58.247])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20538525f1fsm37636485ad.65.2024.09.01.22.20.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Sep 2024 22:20:31 -0700 (PDT)
Date: Mon, 2 Sep 2024 10:50:22 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: MANISH PANDEY <quic_mapa@quicinc.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	quic_nitirawa@quicinc.com, quic_bhaskarv@quicinc.com,
	quic_narepall@quicinc.com, quic_rampraka@quicinc.com,
	quic_cang@quicinc.com, quic_nguyenb@quicinc.com
Subject: Re: [PATCH V2] scsi: ufs: qcom: update MODE_MAX cfg_bw value
Message-ID: <20240902052022.ye5a5g4aaiunhnyl@thinkpad>
References: <20240828132526.25719-1-quic_mapa@quicinc.com>
 <20240828133132.zqozjegmbnwa7byb@thinkpad>
 <f0b62279-b4b6-4cb3-a808-fcd170a384eb@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f0b62279-b4b6-4cb3-a808-fcd170a384eb@quicinc.com>

On Thu, Aug 29, 2024 at 05:44:21PM +0530, MANISH PANDEY wrote:
> 
> On 8/28/2024 7:01 PM, Manivannan Sadhasivam wrote:
> > On Wed, Aug 28, 2024 at 06:55:26PM +0530, Manish Pandey wrote:
> > > The cfg_bw value for max mode was incorrect for the Qualcomm SoC.
> > 
> > What do you mean by 'incorrect'? I extracted the value from downstream DTs. So
> > it cannot be incorrect.
> > 
> > If you want to update it, please clearly provide the reason.
> 
> Hi Mani,
> 
> From the snip from commit message
> "The bandwidth values defined in ufs_qcom_bw_table struct are taken from
> Qcom downstream vendor devicetree source and are calculated as per the
> UFS3.1 Spec."
> 
> we have UFS 4.x devices, and ufs_qcom_bw_table is already updated with Gear
> 5 support (8db8f6ce556a - "scsi: ufs: qcom: Add missing interconnect
> bandwidth values for Gear 5"). So the max cfg_bw is not updated.
> 
> Also for UFS 3.x devices,
> [MODE_HS_RB][UFS_HS_G3][UFS_LANE_2] = { 1492582,        204800 },
> [MODE_HS_RB][UFS_HS_G4][UFS_LANE_2] = { 2915200,        409600 },
> [MODE_MAX][0][0]                    = { 7643136,        307200 },
> 
> Please have a look for current max mode value(307200), it is even less than
> UFS_HS_G4 (409600). So it should be updated.
> 

Okay, then you should mention that the max value is updated for UFS 4.x devices
and mention that commit 8db8f6ce556a missed adding them. Also add the fixes tag
for 8db8f6ce556a.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
