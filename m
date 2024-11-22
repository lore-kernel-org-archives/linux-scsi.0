Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B702315CD60;
	Fri, 22 Nov 2024 18:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732299847; cv=none; b=J9wcQUH3SfOzBBfaxlISPhDq0z/jpd2ongmkVGVZ3GVe/oD6Sw7PyaHZtbs+qjpaiNcxReiWJLKZ873LAO2Z44vRcT3myErsX0uue1ws3/5I1BRc24SJLJvxmIOiXHZkvIspPT/gOYYDnAHuh/s1kxVamk7cFlesb7mOt2+96Yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732299847; c=relaxed/simple;
	bh=bvKIarzOZXfwNTqZWJJJpFaJGdAF5fLTSYDSdYOjZ/I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GdFBVE+yPbqwQBxdgG/RQwKyePYWS89CUaC7R1VLL5a3NwXd303wOmB6dlSjR3mfHSgTXYEv79OaKKImZpZ+W070Oa71hUba4iVyHcPl2lRTmnIBxI2t3c84gvcsxBtMre0d/knLpp9LQTM2LGCC0FJ6qhNKGgYuAuwAOt2P2bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=pFPG4xlZ; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="pFPG4xlZ"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Xw3QQ6HPXz6CmLxR;
	Fri, 22 Nov 2024 18:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1732299826; x=1734891827; bh=5sivaA00Cl8xZHKaBlXfRVzT
	IB6kUyIYmQdHF8o7aS0=; b=pFPG4xlZgErAaaIY6f1VcQG1Snzs+EOQKm46SOkP
	dgwdcZ7l+HnTQGFnLQVgNcvIQWpWQSEBwH7hPdhpf/1BkCLqU/TRe5E4cnmZGanU
	SbGFNSOQIRucpdvHED4eJRe3971SLdZHW2loXejQouysQhcBVeQ3OULW+FP6R7/F
	VRLSrSlGOzUwqaEVltpm/jwKpDUBC0xxTbjPweFUiWfVVAIUVRylIM8Pkf6HwiIR
	k2rp9cgi7YVtpyovZEpVUbsQAfNlaUXvj6o1ACptxMwHRLRBwPOzkh89+f8BVVW8
	dCRAtswlzNe/q3SsudTCxrHGy7L2tKlSahrpimeRbX4jAw==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id KfgKYxiF_i_m; Fri, 22 Nov 2024 18:23:46 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Xw3Q54Dy5z6CmM6d;
	Fri, 22 Nov 2024 18:23:40 +0000 (UTC)
Message-ID: <f0cc674e-18f7-47c6-a39e-596b2cb161a4@acm.org>
Date: Fri, 22 Nov 2024 10:23:40 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ufs: core: add missing post notify for power mode
 change
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, avri.altman@wdc.com, alim.akhtar@samsung.com,
 jejb@linux.ibm.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com,
 yi-fan.peng@mediatek.com, qilin.tan@mediatek.com, lin.gui@mediatek.com,
 tun-yu.yu@mediatek.com, eddie.huang@mediatek.com, naomi.chu@mediatek.com,
 ed.tsai@mediatek.com, draviv@codeaurora.org, stable@vger.kernel.org
References: <20241122024943.30589-1-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241122024943.30589-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/21/24 6:49 PM, peter.wang@mediatek.com wrote:
> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
> index 3f68ae3e4330..1db754b4a4d6 100644
> --- a/include/ufs/ufshcd.h
> +++ b/include/ufs/ufshcd.h
> @@ -308,7 +308,9 @@ struct ufs_pwr_mode_info {
>    *                       to allow variant specific Uni-Pro initialization.
>    * @pwr_change_notify: called before and after a power mode change
>    *			is carried out to allow vendor spesific capabilities
> - *			to be set.
> + *			to be set. PRE_CHANGE can modify final_params based
> + *			on desired_pwr_mode, but POST_CHANGE must not alter
> + *			the final_params parameter
>    * @setup_xfer_req: called before any transfer request is issued
>    *                  to set some things
>    * @setup_task_mgmt: called before any task management request is issued
> @@ -350,9 +352,9 @@ struct ufs_hba_variant_ops {
>   	int	(*link_startup_notify)(struct ufs_hba *,
>   				       enum ufs_notify_change_status);
>   	int	(*pwr_change_notify)(struct ufs_hba *,
> -					enum ufs_notify_change_status status,
> -					struct ufs_pa_layer_attr *,
> -					struct ufs_pa_layer_attr *);
> +				enum ufs_notify_change_status status,
> +				struct ufs_pa_layer_attr *desired_pwr_mode,
> +				struct ufs_pa_layer_attr *final_params);
>   	void	(*setup_xfer_req)(struct ufs_hba *hba, int tag,
>   				  bool is_scsi_cmd);
>   	void	(*setup_task_mgmt)(struct ufs_hba *, int, u8);

'pwr_change_notify' probably should be split into two callback pointers
(one for PRE_CHANGE, one for POST_CHANGE) since the third and fourth
arguments have different roles for pre and post changes. Additionally,
this would allow to constify the fourth argument for the post callback.

Anyway, since this patch looks good to me:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
