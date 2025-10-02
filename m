Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC9CD22A7E5;
	Thu,  2 Oct 2025 16:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759422231; cv=none; b=g4forTmegRhoiYBHAl/+/ZyRG00B3dj12cAiR4sWqdWYOnzJv5b0f7Rp6G71uWiXf1DrbvVtSxJaBkPWw4a7aEdUy+ox9aVwE8B4DBO5MP0QmNdNeHcvvTc6hzSIDYqk1/QHt8eNl9WUBeYTMEwfgquQ9L3vPzWuRWlkFuQRi0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759422231; c=relaxed/simple;
	bh=G+wLTnJ+myYctT51VGgkeJfMpoEE40420rc1e8ZCNFA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=sW8MFdE644nJhXiIW4GbmBTAm/bBXPX2brRSxe8wYLgxVtSb58JJ8XgWHDY3iIi1fKcoDrLIqmRathAWDV2Yo+RchSkOtUvHz32wRDPqYeRaX0VJpVt7J//pC6q9/dixwKG3tT6XXtb776fUhZaNCBU81qQidTPuECLT8Rdfqfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=EH/0Mmvs; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="EH/0Mmvs"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4ccxtr66Fszm0yVd;
	Thu,  2 Oct 2025 16:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1759422227; x=1762014228; bh=YVLfLcMkV1zFweVIY/VVF0zf
	Yz3fFMeqLQkFuvW1zXw=; b=EH/0MmvsCABhtzwLBHA3sYlNGTZtxSg7OA2SdoHv
	ZbpsnQWSt697BnTa+5ePvEFvdr03VUm2g6Z4dypy4mEJAoedeNTN4K0PMgJn38yN
	oJBQF2V1eZ7KayrrMfHVZqfvJjKLB9r9SApG3dP2mBta+kWtEsCRTrzy/8VPiazw
	nn8woQyS5zjKSeNLJua26xi/12ACd3+RGfMoTsJ/ydULs2V0wsoWG9rYo9+USaMo
	wkZiRGADFZRm2fPs+62Bp2fl9cqDZ6kpWv5xLHAkXWGBFh0Qy2V6E9qEXWADQH6c
	cIJBFIs7jRnkaftGusURgaiq4rMueCYAi3EWxTXSDAPQ+w==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id axTIzJPF84cc; Thu,  2 Oct 2025 16:23:47 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4ccxtl3J27zm16lR;
	Thu,  2 Oct 2025 16:23:42 +0000 (UTC)
Message-ID: <4c894d68-7d0e-49a0-b582-477bcc7f351d@acm.org>
Date: Thu, 2 Oct 2025 09:23:41 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ufs: core: Initialize a variable mode for PA_PWRMODE
To: Wonkon Kim <wkon.kim@samsung.com>, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com, peter.wang@mediatek.com,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CGME20251002070057epcas1p49ac487359f24f6813ba8f9f44bcf0924@epcas1p4.samsung.com>
 <20251002070027.228638-1-wkon.kim@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251002070027.228638-1-wkon.kim@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/2/25 12:00 AM, Wonkon Kim wrote:
>   static bool ufshcd_is_pwr_mode_restore_needed(struct ufs_hba *hba)
>   {
>   	struct ufs_pa_layer_attr *pwr_info = &hba->pwr_info;
> -	u32 mode;
> +	u32 mode = 0;
>   
>   	ufshcd_dme_get(hba, UIC_ARG_MIB(PA_PWRMODE), &mode);

Since there is more code that passes a pointer to an uninitialized
variable to ufshcd_dme_get(), the untested patch below may be a better
solution:

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 127b691402f9..5226fbca29ec 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4277,8 +4277,8 @@ int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 
attr_sel,
  			get, UIC_GET_ATTR_ID(attr_sel),
  			UFS_UIC_COMMAND_RETRIES - retries);

-	if (mib_val && !ret)
-		*mib_val = uic_cmd.argument3;
+	if (mib_val)
+		*mib_val = ret == 0 ? uic_cmd.argument3 : 0;

  	if (peer && (hba->quirks & UFSHCD_QUIRK_DME_PEER_ACCESS_AUTO_MODE)
  	    && pwr_mode_change)



