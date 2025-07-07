Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEEE71AB52D
	for <linux-scsi@vger.kernel.org>; Mon,  7 Jul 2025 19:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751918230; cv=none; b=jcIXJ+9kFVpwtw00O38VuTsowhpuzE7RqoADdIuo+UPF+QsAk0YmGFeM4ANZu/9gniomvO2gHfxEyQ09eXb5NKxFEbk4GDiYZnG9mIvGxs3meJWp43HSTV43mvM8PB12j61wGcaC7SoZOTLdodGQGcZyxOlATFBzVJ2xhQss5Gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751918230; c=relaxed/simple;
	bh=V8ukvypL1ytuVrhz92CV5yi9WnxGVOvGn5sfBtZbiLQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hMX2pn2sBeCd4XAU+NpYdDsnIwk8Wq3omYu1w598gQNh3vUyxCVPtP4s8/JLdWvIbaVSKpi+detDLesFdtG4pGX3ShFrjJBO4mBEOJKoGjzceLltGduDQ+Vpfou180bofT7U/tw7J9/5fbY4aok8Vz5yeqJxTGtrjRE+STw3O+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=y/1wtXK5; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="y/1wtXK5"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bbZl76pxBzm0ySM;
	Mon,  7 Jul 2025 19:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1751918226; x=1754510227; bh=HKJICqa3qRiYVALjurYSLDvx
	C9mt0VUq6BrI+MoaMtk=; b=y/1wtXK5UDV0ijSs6W2gA0hLEYgANyZX+KS1DGxr
	0SD2/E3k8LW9Bz8SQephbJyNR3/2rVICsS4+4sKumB8x5Yt9WkbJJB+XnwLNLK9j
	Dve6whb+vA5s4jjq3UIaJz2wgSGLdoYcpUseS7RbARfqsPx4y1pdDTj2IsJ0ZGvz
	PRgi/z5WKEXfrJY3QidlrPZX6ck5jnTxuc5gtFwMqYSJHGgiX5oVqamYY0dPwUsh
	avY07FInEzsMY9It2mw2kn6ELe/Zmk1E+yniKBDGz7tGlkGiOhFAktXEGF95iU5x
	xmxRlIwpfmVzA0DwhBwELms3bC9Bkz9kbJBpWemoDYa+0g==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id VdaCRfPYPD1R; Mon,  7 Jul 2025 19:57:06 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bbZl3072kzm0ySS;
	Mon,  7 Jul 2025 19:57:02 +0000 (UTC)
Message-ID: <83eb436e-a76e-472b-9d50-c6db52b399d2@acm.org>
Date: Mon, 7 Jul 2025 12:57:01 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] scsi: ufs: ufs-pci: Fix default runtime and system PM
 levels
To: Adrian Hunter <adrian.hunter@intel.com>,
 Martin K Petersen <martin.petersen@oracle.com>
Cc: James EJ Bottomley <James.Bottomley@HansenPartnership.com>,
 Avri Altman <avri.altman@sandisk.com>,
 Archana Patni <archana.patni@intel.com>, linux-scsi@vger.kernel.org
References: <20250703064322.46679-1-adrian.hunter@intel.com>
 <20250703064322.46679-3-adrian.hunter@intel.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250703064322.46679-3-adrian.hunter@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/2/25 11:43 PM, Adrian Hunter wrote:
>   static int ufs_intel_mtl_init(struct ufs_hba *hba)
>   {
> +	struct ufs_host *ufs_host;
> +	int err;
> +
>   	hba->caps |= UFSHCD_CAP_CRYPTO | UFSHCD_CAP_WB_EN;
> -	return ufs_intel_common_init(hba);
> +	err = ufs_intel_common_init(hba);
> +	ufs_host = ufshcd_get_variant(hba);
> +	ufs_host->late_init = ufs_intel_mtl_late_init;
> +	return err;
>   }

Shouldn't the ufs_host declaration and assignment be combined as
follows?

struct ufs_host *ufs_host = ufshcd_get_variant(hba);

Otherwise this patch looks good to me.

Thanks,

Bart.
