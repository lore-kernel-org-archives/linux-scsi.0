Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B2C22D792;
	Thu, 30 Apr 2026 17:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777570264; cv=none; b=p9lJ/Lm3A8x/SpV01LOYSGhpmy7mtSGUSlB8BRaYEhHMQl6gEgJuW+mBRPfoxxaTxzVNQ3jVbM4Lg0SPyGD/Im1Zv7zpRCz5Gq4iULhDTdXGqwFdMlVsGq8l2G6Xtf8EVzfyIh8X4BdiEbDjJSXNd46ZbZvfdQTu6aMpP+mA9q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777570264; c=relaxed/simple;
	bh=5IFpiK7tOskNMlUq8bIY5MP8pnOLH1QFfDZD0FczDzI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qqp45ltX1S9fHBqJva1Wyue1cNpVQLjhPQ8rWhpbAWMSKsH1QFfqY8qzh6Hu46FGnupbKrRr+ZXVzGMeBsaLeEPQk9PpsR1H4l933kPK4IZMRvqIEluvucPvkUIgBd7/yAYUoDRF4FSiuDHFSDXzXlxfmX47mkIOInIlWUiXltQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=EZK/Vvbo; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="EZK/Vvbo"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4g61RV5Gm6zm1QG3;
	Thu, 30 Apr 2026 17:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1777570258; x=1780162259; bh=Bb3Ag702cyCt5wayokIKHwf4
	/btWdEWlvD8JptFoB2U=; b=EZK/Vvboir1556nqEkyPLGGJ8dyh9iDl5ZgVKEwR
	gbSd1bunqvyDt2nP/FOatS9s+M08q9v9Gbe6LPyeUAP1dvleSLdwgTlnO20UNGIR
	coXtXPocZjLyxITsJ0PbsyXF4zgeFwuzzEosqYsagTjwASBlakQKxsyDy4WqrSqT
	pp8Rrf7C6T9uXHALSsgaZTTiskkSgFpvkTIc0bfUPfbrqxdvym2LtFRaRi8DGjon
	GfLyR+yPCfajqRsHKDmpsXWxALv/PdNQLxWUKN5GHTdcGmtSoz7ibteSxyvBfzFj
	n50r7g5mmTUxYWmIYvSrW8gh1QfRXkFhS7AU3BuIOhcY8g==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id P8DDtwr5DrSu; Thu, 30 Apr 2026 17:30:58 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4g61RN6L1Czm10Bn;
	Thu, 30 Apr 2026 17:30:56 +0000 (UTC)
Message-ID: <26d908a7-8f95-4f73-b2bf-78923e55b3e8@acm.org>
Date: Thu, 30 Apr 2026 10:30:55 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] scsi: ufs: core: call hibern8 notify when hibern8 cmd
 failed
To: Hongjie Fang <hongjiefang@asrmicro.com>, alim.akhtar@samsung.com,
 avri.altman@wdc.com, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260430042212.3712251-1-hongjiefang@asrmicro.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260430042212.3712251-1-hongjiefang@asrmicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/29/26 9:22 PM, Hongjie Fang wrote:
> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
> index 8563b6648976..4f7c619db324 100644
> --- a/include/ufs/ufshcd.h
> +++ b/include/ufs/ufshcd.h
> @@ -270,6 +270,7 @@ struct ufs_clk_info {
>   enum ufs_notify_change_status {
>   	PRE_CHANGE,
>   	POST_CHANGE,
> +	ROLLBACK_CHANGE,
>   };
>   
>   struct ufs_pa_layer_attr {

This looks better to me but triggers compiler warnings:

drivers/ufs/host/ufs-exynos.c:1614:10: error: enumeration value 
'ROLLBACK_CHANGE' not handled in switch [-Werror,-Wswitch]
  1614 |         switch (status) {
       |                 ^~~~~~
drivers/ufs/host/ufs-exynos.c:1654:10: error: enumeration value 
'ROLLBACK_CHANGE' not handled in switch [-Werror,-Wswitch]
  1654 |         switch (status) {
       |                 ^~~~~~
drivers/ufs/host/ufs-exynos.c:1687:10: error: enumeration value 
'ROLLBACK_CHANGE' not handled in switch [-Werror,-Wswitch]
  1687 |         switch (status) {
       |                 ^~~~~~

These warnings can be reproduced on any Linux development system by
installing Clang and by running the following command:

build-scsi-drivers -c

See also https://github.com/bvanassche/build-scsi-drivers

Thanks,

Bart.
