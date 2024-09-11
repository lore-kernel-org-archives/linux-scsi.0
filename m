Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53CDA1B5808;
	Wed, 11 Sep 2024 19:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726083453; cv=none; b=SkiXXrDK+JnNeESUzQhoFbyM26I+pQfMgi4lXZEp18ltaDXl5jdfMudj/TXggN0tpJbZvW/1D6baR7v1/rjw5XcCjgypGGqE3rpFXlnig0KuEipaUHVw2e+wEXdghKO20kNv6DuczQJuYasAVqjXGHNAIfLzkhHCuB+XY10WEng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726083453; c=relaxed/simple;
	bh=2NfBEYDCWrxZJix+riPhqbBtX2jk2r3u3L3ecSH1w6o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n9TdkES6b3/uOm8Xu2e0vLnBEG8aCq5lyUKmaUbhReKmb49d5Zk7XOvezv8Al0SD9xsRWkAw5fQ9/8uk++OiRZJQWCZYyxFoMN84UUsyXt6WD5HrewezEMB0TcUj8W5Uk4VYNbCpcuaWBCwODg4gue9MNuhSTUp/Jz/pd84y4HY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ou/b4dqV; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ou/b4dqV"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4X3rSW51hBz6CmLxY;
	Wed, 11 Sep 2024 19:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1726083439; x=1728675440; bh=E9EpBtYvSc90pvHVRZDTNXzN
	jSD4J58qXNz69nDxiwM=; b=ou/b4dqVvrr7QJllkAoBXmooxYhnAXyPsxwCdkHr
	csHy2NeWZxuto+RY08gHYjnjYTRqvN5MDdUv7bPIO5dLYNjLhGH55zJTWMxviBaY
	Lk13EpzQOsCYl02Ejxl6fqaZYX+W+eB3HTQ3K2jGH31TaKmc2DmCpNNuFNchx8uA
	aLg+oEUwKNOLh8SccEujFtqjQpGRqVLrhAZ85Z3nPOc2elh/+Bnmy7UzojAPJg6J
	0KKY3uWdFec8a96Lv8A8QRMBKKWZaHECUhpPNDb9knw7AWXALdMvGspgBic4/8Xk
	qWr6t9LKX1eQzPU97UbwfMnHZrwWveax0nQo9aUeKYheAw==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id jSx--RPVCpcz; Wed, 11 Sep 2024 19:37:19 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4X3rSB1xyxz6ClY9P;
	Wed, 11 Sep 2024 19:37:13 +0000 (UTC)
Message-ID: <55d2cca5-0e30-4734-aa25-d5f5cdfbfd93@acm.org>
Date: Wed, 11 Sep 2024 12:37:12 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/2] ufs: core: requeue aborted request
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, avri.altman@wdc.com, alim.akhtar@samsung.com,
 jejb@linux.ibm.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com, powen.kao@mediatek.com,
 qilin.tan@mediatek.com, lin.gui@mediatek.com, tun-yu.yu@mediatek.com,
 eddie.huang@mediatek.com, naomi.chu@mediatek.com, ed.tsai@mediatek.com,
 quic_nguyenb@quicinc.com, stable@vger.kernel.org
References: <20240911095622.19225-1-peter.wang@mediatek.com>
 <20240911095622.19225-3-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240911095622.19225-3-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/11/24 2:56 AM, peter.wang@mediatek.com wrote:
> ufshcd_abort_all forcibly aborts all on-going commands and the host
> controller will automatically fill in the OCS field of the corresponding
> response with OCS_ABORTED based on different working modes.
> 
> MCQ mode: aborts a command using SQ cleanup, The host controller
> will post a Completion Queue entry with OCS = ABORTED.
> 
> SDB mode: aborts a command using UTRLCLR. Task Management response
> which means a Transfer Request was aborted.

I think this is incorrect. The UFSHCI specification does not require a
host controller to set the OCS field if a SCSI command is aborted by the
ABORT TMF nor if its resources are freed by writing into the UTRLCLR
register.

> @@ -5404,7 +5405,10 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp,
>   		}
>   		break;
>   	case OCS_ABORTED:
> -		result |= DID_ABORT << 16;
> +		if (lrbp->abort_initiated_by_eh)
> +			result |= DID_REQUEUE << 16;
> +		else
> +			result |= DID_ABORT << 16;
>   		break;

Is the above change necessary? ufshcd_abort_one() aborts commands by
submitting an ABORT TMF. Hence, ufshcd_transfer_rsp_status() won't be
called if aborting the command succeeds.

> @@ -7561,6 +7551,21 @@ int ufshcd_try_to_abort_task(struct ufs_hba *hba, int tag)
>   		goto out;
>   	}
>   
> +	/*
> +	 * When the host software receives a "FUNCTION COMPLETE", set flag
> +	 * to requeue command after receive response with OCS_ABORTED
> +	 * SDB mode: UTRLCLR Task Management response which means a Transfer
> +	 *           Request was aborted.
> +	 * MCQ mode: Host will post to CQ with OCS_ABORTED after SQ cleanup
> +	 *
> +	 * This flag is set because error handler ufshcd_abort_all forcibly
> +	 * aborts all commands, and the host controller will automatically
> +	 * fill in the OCS field of the corresponding response with OCS_ABORTED.
> +	 * Therefore, upon receiving this response, it needs to be requeued.
> +	 */
> +	if (!err && ufshcd_eh_in_progress(hba))
> +		lrbp->abort_initiated_by_eh = true;
> +
>   	err = ufshcd_clear_cmd(hba, tag);
>   	if (err)
>   		dev_err(hba->dev, "%s: Failed clearing cmd at tag %d, err %d\n",

The above change will cause lrbp->abort_initiated_by_eh to be set not
only if the UFS error handler decides to abort a command but also if the
SCSI core decides to abort a command. I think this is wrong.

Is this patch 2/2 necessary or is patch 1/2 perhaps sufficient?

Thanks,

Bart.
