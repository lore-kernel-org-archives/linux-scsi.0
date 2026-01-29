Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D374D25485A;
	Thu, 29 Jan 2026 16:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769705033; cv=none; b=NMQQVhA65IPrEPBsA1qfaHQrK/9M0JLhuWxnCGHJEkcDE6PIJTUi9ArnBtuPus3235eFhbS7L6kXAxJzLiXwlFia/SNC6vJGRMr5oDVZroOcXNiC/vaNJUndTNt0dACidiXDbnJtM4UHrYpKSWK8pzqiTwQfY9gD4MVSVlmRrog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769705033; c=relaxed/simple;
	bh=6x/Xt7u+48LVS5qZbRzLiF5xCmZzw8Wh44GZZ3yNY8o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Lt82cKvVpIUKtY28Aicuppn0EnhTTSrwaI4knN2uacH30PcI3v5hwPx0cFFm3yrg4DsDhHOy4cdUBqoBY54vQc4EL89jKISHfQXYpMXKYZeYo7l+MuGSqi2G9asctImf3Vuhyhaw0DJoApjjQ8n8mmYx2fEYR1dxjkMA6fFtvOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=WIyhOWua; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="WIyhOWua"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4f24j32N80zlfl8L;
	Thu, 29 Jan 2026 16:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1769705029; x=1772297030; bh=8IBfaP+jY3aUJxV9MXbFRvv9
	G6Bgc/GCKR1UkyKzt1Q=; b=WIyhOWuaqc1JdtTPSpV6hIW8f07t91vM47DQa+Km
	dZh9omHwJVWOnG3nfoZkw5j+Nzo/v7q1qubXKNjLoShGNRWCDbomyzXJAeFADPTG
	EHaX3twklwmp14U44UNuftF1wrILGfgs8kqLTqFQj4IH6D3AaVkbWk+tdk09TUSN
	0hAyBNr84dCFJximEjDxLQVadSq5t7BpaqolLzTQrs4eUtl5ylLm1+3ckZLjglI6
	YczdxLwzAxjDGJjCf/qwv980hbT7SOuRh7pkTmkZZaxpwzTjBi0r0D035x/P8ac6
	ZPbN+hTupFdLWPVeh0PAu54jKZdWei+bpYXl7heq0TuCVA==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id y6aJS1kQdb_N; Thu, 29 Jan 2026 16:43:49 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4f24hz4zQ6zlfwHM;
	Thu, 29 Jan 2026 16:43:47 +0000 (UTC)
Message-ID: <33a0c782-3ca5-4e5a-8d53-2ae0cf1376b9@acm.org>
Date: Thu, 29 Jan 2026 08:43:45 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/3] scsi: ufs: crypto: Add
 ufs_hba_variant_ops::crypto_keyslot_remap
To: "zheng.gong" <zheng.gong@samsung.com>, linux-scsi@vger.kernel.org
Cc: avri.altman@wdc.com, quic_cang@quicinc.com, alim.akhtar@samsung.com,
 martin.petersen@oracle.com, ebiggers@kernel.org, linux-kernel@vger.kernel.org
References: <20251112031035.GA2832160@google.com>
 <20260129031033.3428295-1-zheng.gong@samsung.com>
 <CGME20260129031040epcas5p1446e3f496de82836acdf78a400e6b116@epcas5p1.samsung.com>
 <20260129031033.3428295-2-zheng.gong@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260129031033.3428295-2-zheng.gong@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/28/26 7:10 PM, zheng.gong wrote:
> +static void __ufshcd_setup_cmd(struct ufs_hba *hba, struct ufshcd_lrb *lrbp,
> +				  struct scsi_cmnd *cmd, u8 lun, int tag)
>   {
>   	memset(lrbp->ucd_req_ptr, 0, sizeof(*lrbp->ucd_req_ptr));
>   
>   	lrbp->cmd = cmd;
>   	lrbp->task_tag = tag;
>   	lrbp->lun = lun;
> -	ufshcd_prepare_lrbp_crypto(cmd ? scsi_cmd_to_rq(cmd) : NULL, lrbp);
> +	ufshcd_prepare_lrbp_crypto(hba, cmd ? scsi_cmd_to_rq(cmd) : NULL, lrbp);
>   }

lrbp->cmd has been removed recently. Please use Martin's staging branch 
when preparing patches for the upstream kernel.

Bart.
