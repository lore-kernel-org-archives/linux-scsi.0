Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B96128469B;
	Wed, 10 Jun 2026 16:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781109984; cv=none; b=VAHqRcnk0weVNpYlqF9cuTZ5dTeV5ueG+hQgtpE9DWswJ/xmxE2H+otRd7KcvfFYIoOwoz9Aax1N49qQ01x6G7+JPuDtGJvqh2il9DZgXAzWd5PutY+29cwqvXO6l+Vt9n+zF/kwpxIfVIGT6jFjWhc7gr1tFgm115XIFMjbZmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781109984; c=relaxed/simple;
	bh=RL2FrQeNuGPRBx5uM1U8wqBdFapMjdzKLxYJGzK00i4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eLRsoCUSXcXSvSjOjwGYvrImuNroQe79V6GHk6n90Nhq+MISyD6XH0oxuYg2pQ2lAj+UD7MaPYEVHNb3yIUfPz/pf4eRdtvzfrJkEL2FpqRQjGB8cBGQKJjhR6kPdzBZeeiQxcorKGl4BPCceXb0wkYhSuAoW1oqpYhCK86MQJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=bTWflbo/; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="bTWflbo/"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4gbBW24CkXzlffvg;
	Wed, 10 Jun 2026 16:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1781109974; x=1783701975; bh=/jB0cPZbL/j9osnIk7St90yg
	frYdaffrndO7LwkqWJU=; b=bTWflbo/sP5FTUDCc/Ak9W4pOgod3h13bq9Er/m+
	X3MnYwDgfeGWi6wJ/7Z9NVrj6kuHPopW0G1uPQhbDEzUI1EwUxNnaETzYi/XfK2F
	XdYDkOSobGKUANrEqx4R39F2pFqcIILGHMDfRgB+wJRbMacYm8/iQfDeVOIomNAg
	ovmd2pz6biGgh+Vj7H5sAEEvykonhSLJJz1or3j6l3hrGnM6EQ+cytV7xkgoe/c6
	f3DsjmFNjGy+L5931c+rVlp5j2Ccvq33Sf/E5XmykdD8kInj1ZrYfswgHfhp3+8t
	SMZ1yb4uHb9VqVSfCshZoujzduS83PDGFih1+W6F04hF2A==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id H_ZPhF46pVnA; Wed, 10 Jun 2026 16:46:14 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4gbBVp2k5bzlfgPv;
	Wed, 10 Jun 2026 16:46:10 +0000 (UTC)
Message-ID: <1af2f199-e498-46ea-b872-74bfc0d05243@acm.org>
Date: Wed, 10 Jun 2026 09:46:09 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] ufs: core: Add get_hba_nortt callback for
 vendor-specific RTT capability
To: ed.tsai@mediatek.com, alim.akhtar@samsung.com, avri.altman@wdc.com,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org, wsd_upstream@mediatek.com,
 peter.wang@mediatek.com, alice.chao@mediatek.com, naomi.chu@mediatek.com,
 chun-hung.wu@mediatek.com
References: <20260609103856.676222-1-ed.tsai@mediatek.com>
 <20260609103856.676222-2-ed.tsai@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260609103856.676222-2-ed.tsai@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/9/26 3:38 AM, ed.tsai@mediatek.com wrote:
> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
> index cfbc75d8df83..13d0d7798294 100644
> --- a/include/ufs/ufshcd.h
> +++ b/include/ufs/ufshcd.h
> @@ -370,7 +370,6 @@ struct ufshcd_tx_eq_params {
>   /**
>    * struct ufs_hba_variant_ops - variant specific callbacks
>    * @name: variant name
> - * @max_num_rtt: maximum RTT supported by the host
>    * @init: called when the driver is initialized
>    * @exit: called to cleanup everything done in init
>    * @set_dma_mask: For setting another DMA mask than indicated by the 64AS
> @@ -415,10 +414,11 @@ struct ufshcd_tx_eq_params {
>    * @get_rx_fom: called to get Figure of Merit (FOM) value.
>    * @tx_eqtr_notify: called before and after TX Equalization Training procedure
>    *	to allow platform vendor specific configs to take place.
> + * @get_hba_nortt: called to get maximum number of outstanding RTTs supported by
> + *	the controller.
>    */
>   struct ufs_hba_variant_ops {
>   	const char *name;
> -	int	max_num_rtt;
>   	int	(*init)(struct ufs_hba *);
>   	void    (*exit)(struct ufs_hba *);
>   	u32	(*get_ufs_hci_version)(struct ufs_hba *);
> @@ -477,6 +477,7 @@ struct ufs_hba_variant_ops {
>   	int	(*tx_eqtr_notify)(struct ufs_hba *hba,
>   				  enum ufs_notify_change_status status,
>   				  struct ufs_pa_layer_attr *pwr_mode);
> +	int	(*get_hba_nortt)(struct ufs_hba *hba);
>   };

A patch series should be bisectable. Removing max_num_rtt from struct
ufs_hba_variant_ops before the code is removed from the MediaTek driver
that sets that variable introduces a build break. Please keep
'max_num_rtt' in this patch and add a third patch to this series that
removes 'max_num_rtt'.

Thanks,

Bart.
