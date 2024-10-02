Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E6BB84A52
	for <linux-scsi@vger.kernel.org>; Wed,  2 Oct 2024 09:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727859786; cv=none; b=JcgzjiFu3hnoXbR1P5chgwLU4WeoWDUglyxbM0f2Vmlvrvav/bs7jF0ZDRNKOpdGRU9B11ZMIHXxm/xq1QEVCvCTPHKx0c2pvFyTcZid2Gn/3iztT8t4s1dSefHcaeQmS7llwGx2zLL21pB/Dxyzqni3gTp+SuLcpQJYRQimxzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727859786; c=relaxed/simple;
	bh=5TXT2AlSibkhz8Y8NGkCMb13x7PIroZHUMZR+1Q0YmY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pEd5Bf4FW8Df1EXr+446Itt4jumLTtHx4Ek213NUTqwCl7Zn22JdYMG3FuKL1uZxHGDmlYZlLQsgJ4vEQTC4snWq6y1mP/vtpsfpu07MK/5CIECXb+f/2YxWwqVELgV8CXUFaW4YseGaWvcA0QvQivIEJFNa1yOO49gArp8u4so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=TVvseAk7; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TVvseAk7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
	:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=UFsiqbZqt4hMH60qrpdNc6V8QZaNivxjGuI6axEsKxI=; b=TVvseAk7nX3BISkRE4TSChD1Rt
	3nhcgbt3p+LVMa7IGF4MP7hR4oaGH7OOkxLqJWep3MrYvAm2FZGvsiOUQGWJmU5NK2Mn41btUMYik
	TRNNkvVazKBAUDDEdBjimxodXixtDhOOewB7b98jgsaChIHBcSczjCXmaWQ86lWRGKOQZCqaIgEmG
	k0SpTZTQWpm0DYM72xk8IbhVc6eyrVc1l1oh/o5hpb5Ee5JoWSPkpe6SnBvpGSFu+iZSZ+1Iq7wOf
	qSVGJzhk2bzBaB214WSBTlWThtW57qHxbkhu/8VR+BjBeXSPE+JAla7ht2Vn5gMbXjYcnzVYDHvKB
	F+Amic7g==;
Received: from fpd2fa7e2a.ap.nuro.jp ([210.250.126.42] helo=[192.168.1.8])
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1svvG0-00000003S4z-02Xk;
	Wed, 02 Oct 2024 09:02:52 +0000
Message-ID: <5359d743-d0fe-4217-a612-b0f36bee5cd3@infradead.org>
Date: Wed, 2 Oct 2024 18:02:31 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] scsi: Convert SCSI drivers to .device_configure()
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Sathya Prakash <sathya.prakash@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Chen-Yu Tsai <wens@csie.org>, Jernej Skrabec <jernej.skrabec@gmail.com>,
 Samuel Holland <samuel@sholland.org>, Steffen Maier <maier@linux.ibm.com>,
 Benjamin Block <bblock@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Adam Radford <aradford@gmail.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Khalid Aziz <khalid@gonehiking.org>,
 Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
 Matthew Wilcox <willy@infradead.org>, Hannes Reinecke <hare@suse.com>,
 Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
 Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
 Saurav Kashyap <skashyap@marvell.com>, Javed Hasan <jhasan@marvell.com>,
 GR-QLogic-Storage-Upstream@marvell.com, Don Brace <don.brace@microchip.com>,
 Tyrel Datwyler <tyreld@linux.ibm.com>, Michael Ellerman
 <mpe@ellerman.id.au>, James Smart <james.smart@broadcom.com>,
 Dick Kennedy <dick.kennedy@broadcom.com>, Nilesh Javali
 <njavali@marvell.com>, Karan Tilak Kumar <kartilak@cisco.com>,
 Sesidhar Baddela <sebaddel@cisco.com>, "K. Y. Srinivasan"
 <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>,
 Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
 Juergen Gross <jgross@suse.com>, Stefano Stabellini
 <sstabellini@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 ching Huang <ching2048@areca.com.tw>, Bjorn Helgaas <bhelgaas@google.com>,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 Soumya Negi <soumya.negi97@gmail.com>
References: <20240930201937.2020129-1-bvanassche@acm.org>
 <20240930201937.2020129-3-bvanassche@acm.org>
Content-Language: en-US
From: Geoff Levand <geoff@infradead.org>
In-Reply-To: <20240930201937.2020129-3-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/1/24 05:18, Bart Van Assche wrote:
> There is agreement that the word "slave" should not be used in Linux
> kernel source code. Hence this patch that converts all SCSI drivers from
> .slave_configure() to .device_configure(). No functionality has been
> changed.n
> 
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/ps3rom.c                       |  5 +++--
>  47 files changed, 166 insertions(+), 124 deletions(-)
> 
> diff --git a/drivers/scsi/ps3rom.c b/drivers/scsi/ps3rom.c
> index 90495a832f34..dcf911d68cf8 100644
> --- a/drivers/scsi/ps3rom.c
> +++ b/drivers/scsi/ps3rom.c
> @@ -61,7 +61,8 @@ enum lv1_atapi_in_out {
>  };
>  
>  
> -static int ps3rom_slave_configure(struct scsi_device *scsi_dev)
> +static int ps3rom_device_configure(struct scsi_device *scsi_dev,
> +				   struct queue_limits *lim)
>  {
>  	struct ps3rom_private *priv = shost_priv(scsi_dev->host);
>  	struct ps3_storage_device *dev = priv->dev;
> @@ -325,7 +326,7 @@ static irqreturn_t ps3rom_interrupt(int irq, void *data)
>  
>  static const struct scsi_host_template ps3rom_host_template = {
>  	.name =			DEVICE_NAME,
> -	.slave_configure =	ps3rom_slave_configure,
> +	.device_configure =	ps3rom_device_configure,
>  	.queuecommand =		ps3rom_queuecommand,
>  	.can_queue =		1,
>  	.this_id =		7,

Looks good for ps3rom. Thanks for your fixes.

Acked-by: Geoff Levand <geoff@infradead.org>

