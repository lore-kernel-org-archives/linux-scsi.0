Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 577FB13210D
	for <linux-scsi@vger.kernel.org>; Sun, 18 Aug 2024 23:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724023550; cv=none; b=OCeML5Se1FBEpXtkwdqzOOSIV01rNQvPXg6MlMMYj0qNukCcVS0IWrR0MPoV3NSKIZQScrCBuaGVDXjMxIfaO1vYmgkNOypVtE96zb5+dcEwVhrtu631DAYR6oxouUzi/tFmSkGu3DXz1i/KKLkB/t4bD0df7X2T38aTRtID+X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724023550; c=relaxed/simple;
	bh=nyDB1mceKW62inTC/WLDhY+YBWxJHPpjOnHEVNneizs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Hx0KYnk16r4c+nupIn1+QrzNx1zeKeaVAGJYzQ8/HRjM6in3XiBpEDi0juaOnR3uAHYQ/6RiuW+FJXzNWfs2xILszzvM1/I/N6JQk4GIGDHFOLrtYx54ywq7Ozq8rVKhq3uecdVqSbaN9/2ciq8wbNQot5CuK6LitgeogI8LtF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ilwhU+a/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ilwhU+a/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30316C32786;
	Sun, 18 Aug 2024 23:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724023549;
	bh=nyDB1mceKW62inTC/WLDhY+YBWxJHPpjOnHEVNneizs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ilwhU+a/n3yjINgc+siNeGESQ03EoYdSUqG2QNovRxliofyXT7GXk+sO9ONFKDhwJ
	 y7loaLPqzxavCDoK8dz4+JpPAnvEmqRJ8alW56VU9HGVw/ED1UijGE/EYIaUST3gfT
	 iBN5HZGbFb3RJbBE2GRaBfgA9p6XxdpkteSEJDz/3LGUTeZq9qMLw8PoQ90CRnXZWS
	 OhnMF+PoIhqF/dxtjQSPDERG1hfcJuAayoz9SzOmoiav7s3tzJFtITYNJ1YNSJZFJt
	 uDPxQmp1kQjAOYiLJ7QjFRSN4Adr+LXMg3r6YVbAQgw4lf/Y5qbFr0SDLCMWMhmE2V
	 5CNAMFt9d6Myw==
Message-ID: <686d0650-f5c9-4c86-9900-ba980baecb00@kernel.org>
Date: Mon, 19 Aug 2024 08:25:42 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/18] scsi: Expand all create*_workqueue() invocations
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
 Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Saurav Kashyap <skashyap@marvell.com>, Javed Hasan <jhasan@marvell.com>,
 GR-QLogic-Storage-Upstream@marvell.com,
 James Smart <james.smart@broadcom.com>,
 Ram Vegesna <ram.vegesna@broadcom.com>,
 Bradley Grove <linuxdrivers@attotech.com>, Hannes Reinecke <hare@suse.de>,
 Satish Kharat <satishkh@cisco.com>, Sesidhar Baddela <sebaddel@cisco.com>,
 Karan Tilak Kumar <kartilak@cisco.com>,
 Xiang Chen <chenxiang66@hisilicon.com>, Tyrel Datwyler
 <tyreld@linux.ibm.com>, Kashyap Desai <kashyap.desai@broadcom.com>,
 Sumit Saxena <sumit.saxena@broadcom.com>,
 Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
 Chandrakanth patil <chandrakanth.patil@broadcom.com>,
 Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
 Nilesh Javali <njavali@marvell.com>,
 Manish Rangankar <mrangankar@marvell.com>,
 Vishal Bhakta <vishal.bhakta@broadcom.com>,
 Nathan Chancellor <nathan@kernel.org>,
 Mike Christie <michael.christie@oracle.com>, Martin Wilck <mwilck@suse.com>,
 John Garry <john.g.garry@oracle.com>,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 Peter Wang <peter.wang@mediatek.com>,
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 Avri Altman <avri.altman@wdc.com>, Bean Huo <beanhuo@micron.com>
References: <20240816215605.36240-1-bvanassche@acm.org>
 <20240816215605.36240-2-bvanassche@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240816215605.36240-2-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/17/24 06:55, Bart Van Assche wrote:
> diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> index 1078c20c5ef6..f49783b89d04 100644
> --- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> +++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> @@ -2363,8 +2363,8 @@ static int _bnx2fc_create(struct net_device *netdev,
>  	interface->vlan_id = vlan_id;
>  	interface->tm_timeout = BNX2FC_TM_TIMEOUT;
>  
> -	interface->timer_work_queue =
> -			create_singlethread_workqueue("bnx2fc_timer_wq");
> +	interface->timer_work_queue = alloc_ordered_workqueue(
> +		"%s", WQ_MEM_RECLAIM, "bnx2fc_timer_wq");

Very odd line split. And there are a few more like this one. Maybe your patch
needs some manual tuning after running the script ?

The patch overall looks good to me, but it would be nice to have consistency in
the line splitting. Personnally, I prefer the pattern such as:

-	kmpath_rdacd = create_singlethread_workqueue("kmpath_rdacd");
+	kmpath_rdacd =
+		alloc_ordered_workqueue("%s", WQ_MEM_RECLAIM, "kmpath_rdacd");

instead of:

-	lio_wq = create_singlethread_workqueue("efct_lio_worker");
+	lio_wq = alloc_ordered_workqueue("%s", WQ_MEM_RECLAIM,
+					 "efct_lio_worker");

Though I guess that is a matter of taste :)

-- 
Damien Le Moal
Western Digital Research

