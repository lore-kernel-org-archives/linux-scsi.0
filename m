Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5821D17A5BD;
	Fri, 20 Sep 2024 18:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726856922; cv=none; b=OYV9T5IFT6WyaQeLZpLx67HV7Gk8Vf0xPku2+99eNapWi9GLjIb/4sJ49R0ZB2Zag6TuWLmMyW5VuR/kARCRfKqy/+qQehU8FIO3y5OvvnViIHcfidXEs+44srg1nsnf32x1RIzPVkmfVjvaWYUP1yNJjQmhGzoV80iXw/X4GEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726856922; c=relaxed/simple;
	bh=9cPDo1wci76cbqdQ0yPHcn9i+dHlFDkKwKgjYwUZu+I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I8PYQMleI/rMB3LjMFSBlIxyqj9FSTCNp0H/75cChpoj9YfgTQD2+c9CivYIOUAQAx7QbV9zpBE/Ux5k7tVCbL9EHhGLvcht8Y/+TQOJNappqcBAyceoyO+Dgx6ZRTfGhdpjb4Xuwnz4CaQ4nYD0WJ4IH7iZOx52OjUOSRt+ytE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=qHt8nyAC; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="qHt8nyAC"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4X9LVw6MTlz6ClY9H;
	Fri, 20 Sep 2024 18:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1726856919; x=1729448920; bh=DW4vQZIJ214BTxWL9j5mMvj7
	mbFqEwVfy9t7q3aOVsg=; b=qHt8nyACCl2fbzZPre1oujQ2Oeen+IjFhoj2E3uX
	3J8JAryxcCZwMZjNbFRiUf/iac+7yzTW3p5Eoeg8Xnvuc9HXwK+ziubfJczJx3pR
	mel5DfzCRDd5+CFNkm6ltNdAoqNo1IQBZEZqHXEWSuOB09WlvC5moxAwuoso5Hkp
	d6VF/+GrgIZ59u3lJg17sLaA0qendBjPOKdgnZ3C7TwQgOCHwxQ3HaoqmDMFhttv
	xGRKFvnkir30yUfefsbqYb8SoVpEivYRbmt+3Z27UeAVpA7GpmghYLL0slzHzoaV
	viPYbcsCFfsHaMv3xCGSDaWi6TYZv9khYQNwaRY4Ivyo5w==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 06rWznrvWNH2; Fri, 20 Sep 2024 18:28:39 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4X9LVv0Ttsz6ClY9B;
	Fri, 20 Sep 2024 18:28:38 +0000 (UTC)
Message-ID: <0caf3cfa-d1ec-44b3-b2db-1d95a33567ec@acm.org>
Date: Fri, 20 Sep 2024 11:28:38 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] scsi: ufs: Zero utp_upiu_req at the beginning of each
 command
To: Avri Altman <avri.altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240919084155.17004-1-avri.altman@wdc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240919084155.17004-1-avri.altman@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/19/24 1:41 AM, Avri Altman wrote:
> +static void __ufshcd_setup_cmd(struct ufs_hba *hba, struct ufshcd_lrb *lrbp,
> +			     struct scsi_cmnd *cmd, u8 lun, int tag)
> +{
> +	memset(lrbp->ucd_req_ptr, 0, sizeof(*lrbp->ucd_req_ptr));
> +
> +	lrbp->cmd = cmd;
> +	lrbp->task_tag = tag;
> +	lrbp->lun = lun;
> +	ufshcd_prepare_lrbp_crypto(cmd ? scsi_cmd_to_rq(cmd) : NULL, lrbp);
> +}

This function does not use the 'hba' argument so please remove that
argument. Otherwise this patch looks good to me.

Thanks,

Bart.
