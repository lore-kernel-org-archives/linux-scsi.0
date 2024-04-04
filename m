Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 412171C6BC;
	Thu,  4 Apr 2024 16:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712249732; cv=none; b=JdQBHrTgP9U6QjnfhOc/HSYvxl5lamXRIYo6BiBCnNdQqGLqHqnNE0LQvn5K1e1CzPJkPiM84cO6hAogrqgGWVUPhDJcQviJXkOwhPKG1lUsmi+IXVpxi6Jel7ZkFzDg0Gb85b9KA3cPrmL60WYXOKQBXMSfA1pkl65JEMHbIrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712249732; c=relaxed/simple;
	bh=8lQtW1kp7macBz9tX7shCodlhTYazmDMYCkB9n1ZCuU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HiZk3Isb+u0DZprJkAH+4VYNabv3OddIBnN42HWFVgeVDS7bT4V/kJBh6+vEufrC/0YTydKpMur6ps6KmM0G3xhP4juLjw6g5vbm9kMIasXhf7o5Ft0uQA60UvoSaVH/TgG+X0UL5DWguhOw9dzvONR0HTXDv4fi3zgMcizS2F8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Ez4neXk7; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Ez4neXk7"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4V9SRQ368yzlgTGW;
	Thu,  4 Apr 2024 16:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:references:content-language:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1712249719; x=1714841720; bh=ZPij4v4Q1/Tj4lhxhuIsLToh
	gUfceO3NthUEwaR+ETY=; b=Ez4neXk7Nh2qjov4cYKcL6CSs7f5UCE1l27BZHaO
	THv2b6Bu0s4/N8wpETOOfkbGU/9GO/KM3+prcjHyP/ZhiwstRtql/bg+gf5epCY5
	r4cC37Bns1I30xjLNNgVW3XS3MqVBsaLidTU6eMi4mWzlM30bo2M5N+SnGs3QVnU
	q4vws7Hkvvo90QhMxD6KEy+mcrJn3Rfyg2VdF+sezt42jePr52mlayRvNF20tEXA
	EspmPffypngn6UticUMaoOspe+wYz4ToG96L7Rh4AwxGiQ84hdRqZRLBXPCBT7vK
	5OXyHE7T6v+JMX49m6sJjmTaU53giAPJ8uj86vII+sHIFA==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id mOUqj_SbWF1Q; Thu,  4 Apr 2024 16:55:19 +0000 (UTC)
Received: from [100.96.154.173] (unknown [104.132.1.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4V9SR63jR1zlgTHp;
	Thu,  4 Apr 2024 16:55:14 +0000 (UTC)
Message-ID: <8011f224-04f2-40b6-84ad-fc0fb3d10b16@acm.org>
Date: Thu, 4 Apr 2024 09:55:13 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/23] mpi3mr: pass queue_limits to bsg_setup_queue
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
 Takashi Sakamoto <o-takashi@sakamocchi.jp>,
 Sathya Prakash <sathya.prakash@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
 "Juergen E. Fischer" <fischer@norbit.de>,
 Xiang Chen <chenxiang66@hisilicon.com>,
 HighPoint Linux Team <linux@highpoint-tech.com>,
 Tyrel Datwyler <tyreld@linux.ibm.com>, Brian King <brking@us.ibm.com>,
 Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
 Mike Christie <michael.christie@oracle.com>,
 John Garry <john.g.garry@oracle.com>, Jason Yan <yanaijie@huawei.com>,
 Kashyap Desai <kashyap.desai@broadcom.com>,
 Sumit Saxena <sumit.saxena@broadcom.com>,
 Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
 Chandrakanth patil <chandrakanth.patil@broadcom.com>,
 Jack Wang <jinpu.wang@cloud.ionos.com>, Nilesh Javali <njavali@marvell.com>,
 GR-QLogic-Storage-Upstream@marvell.com,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
 Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
 Alan Stern <stern@rowland.harvard.edu>, linux-block@vger.kernel.org,
 linux-ide@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
 MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
 megaraidlinux.pdl@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com,
 linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
 usb-storage@lists.one-eyed-alien.net
References: <20240402130645.653507-1-hch@lst.de>
 <20240402130645.653507-4-hch@lst.de>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240402130645.653507-4-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/2/24 06:06, Christoph Hellwig wrote:
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
> index ce5445eb9d0e4e..05e061fc6d3a06 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_app.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
> @@ -1838,6 +1838,10 @@ void mpi3mr_bsg_init(struct mpi3mr_ioc *mrioc)
>   {
>   	struct device *bsg_dev = &mrioc->bsg_dev;
>   	struct device *parent = &mrioc->shost->shost_gendev;
> +	struct queue_limits lim = {
> +		.max_hw_sectors		= MPI3MR_MAX_APP_XFER_SECTORS,
> +		.max_segments		= MPI3MR_MAX_APP_XFER_SEGMENTS,
> +	};

Can 'lim' be declared 'static const'?

Thanks,

Bart.
