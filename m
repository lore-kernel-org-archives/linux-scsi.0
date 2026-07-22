Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA5274399E6;
	Wed, 22 Jul 2026 18:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784743690; cv=none; b=TDh6OHz2hTKEV+mFKf0dBeT0qDZ2LFkkgJpjjCIQcKN214UL2Fxn3ZGxoD2Ab6UTuWhChxBEqUZunDZaDX5y2O1qgoAmTALYEFrsH2A5DFot8D5MvuUnV/I9BlwzBZQuVi7vSCP11RJp3ysXkdAyaeuLdGsUNVnUkzxWXdIvP0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784743690; c=relaxed/simple;
	bh=1dk9kTfcP9fX8S9kaq6vPcwrCEX2Y6DBqMRVT4dYQ9A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cEKG6Lwlm68ecCpG5/R6q6AxESgiZzRPbCHyQ/eTzc9fji0aunhm7u/an3BzZgsQG234NMk7KRQJBPU68nv2gMczmwJzRg5SnqU3AYrjtogNpmuGJc53Z52suIDv5i36TNsJyNzM/ahFJpZzFjBkF71/VzYem7MUGUj/J2SS2uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ACrDNVJB; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ACrDNVJB"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4h52Ky62kyzlfwgD;
	Wed, 22 Jul 2026 18:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1784743681; x=1787335682; bh=8e+5aYQ0x0Q2WlWJVLINockC
	3RozGQG6FbrpnpwiqJE=; b=ACrDNVJBkBr2407bSCma/4ynPHSglTQuIRAsFNSt
	FngJZ1rrZz8hxsI4gRp0JKDEKs94zhwXqZtZbEvIVP7NZqfdqWeRpUe0PwKOu5U9
	VmEI1Q5zS7qUoWwBGkDbmDGVPhZddWtg6mKMMPzuWT+BhPi5gDgOhCSPiJxB7wcP
	IuY1RbzvfC34Zr2cezKggww3ziI5NnkfC1ksOMXXJPqGnOkRCzU21yENOYIjVjbf
	BrrhK2vMeqaqXf9J/7sN68WtSIlvqV82zBvwv9w7zUIZlyPS1Nc250SJqFkFzvX1
	RZZCm3dyel7Ch1sX83BRRXMsAJ6gECv2ZtJJ87Tvte0/Tw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 0g_NsSbR84ni; Wed, 22 Jul 2026 18:08:01 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4h52Km6w1hzlfwgC;
	Wed, 22 Jul 2026 18:07:56 +0000 (UTC)
Message-ID: <bdaec5f9-7a58-494f-bad7-c65e481207f8@acm.org>
Date: Wed, 22 Jul 2026 11:07:55 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/6] scsi: ufs: Avoid NULL CQE dereference when
 reporting invalid tags
To: Li Qiang <liqiang01@kylinos.cn>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, alim.akhtar@samsung.com,
 avri.altman@wdc.com, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com, peter.wang@mediatek.com, beanhuo@micron.com,
 can.guo@oss.qualcomm.com, adrian.hunter@intel.com, tomas.winkler@intel.com
References: <cover.1784182493.git.liqiang01@kylinos.cn>
 <20260717153914.26321-1-liqiang01@kylinos.cn>
 <20260717153914.26321-3-liqiang01@kylinos.cn>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260717153914.26321-3-liqiang01@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/17/26 8:39 AM, Li Qiang wrote:
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 3541da5b6f4d..d1b989abc9e2 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -5860,8 +5860,8 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba, int task_tag,
>   	struct ufshcd_lrb *lrbp = scsi_cmd_priv(cmd);
>   	enum utp_ocs ocs;
>   
> -	if (WARN_ONCE(!cmd, "cqe->command_desc_base_addr = %#llx\n",
> -		      le64_to_cpu(cqe->command_desc_base_addr)))
> +	if (WARN_ONCE(!cmd, "invalid completion tag %d, cqe->command_desc_base_addr = %#llx\n",
> +		      task_tag, cqe ? le64_to_cpu(cqe->command_desc_base_addr) : 0ULL))
>   		return;

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
