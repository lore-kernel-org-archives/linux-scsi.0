Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1AF4256D;
	Tue, 22 Oct 2024 16:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729615895; cv=none; b=PenGVA3qAteJAnVXE9lZt/Qgftb4bEsICOHJINnQfCeM2swTroO4M8hwQE5tJZP0IDpmqXD2JXSBP8IJ0cg8VNBL1qm6UIJ1VAXsD/N79SohYRB1TxJxfe34GfTNxproHtrzZFbVEUh0vvsh0Cg/uW6iOrmFxgHeQnaUrOrBwFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729615895; c=relaxed/simple;
	bh=i9FeUVlAuL54Xbxnr1rNje3DaQohcv8791Fl6+DC13Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ku1SKGCCpUbm/CM68A5ib9zbxwcSz+q7cd+MlsQ1pgP2tGYVPLvryaEwl081KeIx6CN9SWCO400RA9UwLrFVDSQ32ZNufTNn5V5lfv4LpirT3NRjU08Ygz8vw6xLLPgNwGMH/T7PSoXozxyU0jmKSjKHeetvNnLS/LDnsbLzS+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ygRywrc8; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ygRywrc8"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XXyr33fngzlgTWQ;
	Tue, 22 Oct 2024 16:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1729615889; x=1732207890; bh=sF7wyG3xG9g1bvC77ctWmfky
	A1B6Phef3AGYEAmwYis=; b=ygRywrc8PEjPFunfhdVHLTuRm7sAWDC5spKwJlMy
	CACEDKm1QlqtzXjmovfEC1NeK6AnknjpSk0mlLKHDq4v+inWTP49T7qiI6ZKnScd
	955Ck3jcbMBK+wGMPW+UuujvecGJ/AhTdJ2FygN5cqFooh7lEt2xcHyQtFEJip9W
	iLTAHEcqJxOE0tMJ8dKmWiwv+Z9/1vXe7jc+vnIlMbixGS8Igk70E9tsYEg24tnK
	95d99oPQ3zFt/+I7oiOQfrS5IzIP3euZv8cjq7uSsgAh2ttPIelVPSF9Y9zLk4i5
	fQ/aFzbXW/GbyS29KbAlrSbpzrtw50zI0oHiOtUH2yvJrQ==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id pSh_95VhZEWF; Tue, 22 Oct 2024 16:51:29 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XXyr046y6zlgTWP;
	Tue, 22 Oct 2024 16:51:28 +0000 (UTC)
Message-ID: <8e1ec6a0-38db-414e-90da-4d04ea8d6be2@acm.org>
Date: Tue, 22 Oct 2024 09:51:26 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] scsi: ufs: core: Remove redundant host_lock calls
 around UTMRLDBR.
To: Avri Altman <avri.altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20241022074319.512127-1-avri.altman@wdc.com>
 <20241022074319.512127-2-avri.altman@wdc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241022074319.512127-2-avri.altman@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/22/24 12:43 AM, Avri Altman wrote:
> @@ -6877,13 +6874,13 @@ static irqreturn_t ufshcd_check_errors(struct ufs_hba *hba, u32 intr_status)
>    */
>   static irqreturn_t ufshcd_tmc_handler(struct ufs_hba *hba)
>   {
> -	unsigned long flags, pending, issued;
> +	unsigned long flags;
> +	unsigned long pending = ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL);
> +	unsigned long issued = hba->outstanding_tasks & ~pending;
>   	irqreturn_t ret = IRQ_NONE;
>   	int tag;
>   
>   	spin_lock_irqsave(hba->host->host_lock, flags);
> -	pending = ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL);
> -	issued = hba->outstanding_tasks & ~pending;

Please keep the 'pending' and 'issued' assignments in the function body. 
Initializing variables in the declaration block is fine but adding code 
in the declaration block that has side effects is a bit controversial.

>   	for_each_set_bit(tag, &issued, hba->nutmrs) {
>   		struct request *req = hba->tmf_rqs[tag];
>   		struct completion *c = req->end_io_data;

Would it be sufficient to hold the SCSI host lock around the 
hba->outstanding_tasks read only? I don't think that the
for_each_set_bit() loop needs to be protected with the SCSI host lock.

Otherwise this patch looks good to me.

Thanks,

Bart.
