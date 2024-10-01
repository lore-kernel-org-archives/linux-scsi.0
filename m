Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 834E717FD
	for <linux-scsi@vger.kernel.org>; Tue,  1 Oct 2024 00:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727741470; cv=none; b=P8bMzYg492l4V5tpiI82hKQ7yGnCY9YkvAUcc/AA85jSIPXIGnwDIxS+P0bBcLcDINmJO+Q9VjLfnTOxsNqnd70W/LAvZ1wiYX8XZzp/S+pu8GNbe9Q5x+DQ39oJ/pzxVAzdPYUW1gxEAdCXI3VHVJzVKWit/aYsNCfLF02uX+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727741470; c=relaxed/simple;
	bh=JAuaznC/KB1UrxWouBuAG3kkqalJKY1tFG/g61ek48Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I3iQHgNXzFW2wrkGtnyC+ykth+JpskTXlBj/dgGX9u/UMBFWRWOrjwCMvBERB1lP3J6VQM8/+H732qU2DaDL80w1J/R95zh+7ZfO+WfUlZd+YMlhYq4TslyJ8VJ12QsEgyHyM3yCfRlBLjJFPorFJF5wY0rtvjowWfWBcvQlf3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FS5RLqQe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FS5RLqQe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D16AC4CEC7;
	Tue,  1 Oct 2024 00:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727741469;
	bh=JAuaznC/KB1UrxWouBuAG3kkqalJKY1tFG/g61ek48Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FS5RLqQeTC2f5D8NURiWkyVXkgCu/EmnC9nfvtdSKZ6oZDk+AqQheMZk3nxeh7eKI
	 WjNdM23nctsAsY7CjKBoIqVSZXsP19sjqf1fWLkjRwekDIhN2kfuHsjeR/jJHhY8eZ
	 GuFa3lJKQlSjHZ7FSUVh9DvnOGZi0dwbCwSVx8thiYWbQJ87cYshfk6n87276tzNHY
	 Aq0M4SLJ+6B2mNPvmM/NT/10JJ6mdZ/doYgqTbQLG231ba7fI4g0ljm1InzYp6S3hU
	 AvIHH7ulDHhKlLYVjOClABNFJvFnDWK9IkLm/Cq2Shg4QExKUW1jR8BMsYsNYk/4Bh
	 f6/HZwFaFfs/A==
Message-ID: <5b3e96da-9fe9-4eb5-ad0e-0377622df5c2@kernel.org>
Date: Tue, 1 Oct 2024 09:10:57 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] scsi: Rename .slave_alloc() and .slave_destroy()
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
 Niklas Cassel <cassel@kernel.org>, Takashi Sakamoto
 <o-takashi@sakamocchi.jp>, Sathya Prakash <sathya.prakash@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
 Tariq Toukan <tariqt@nvidia.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Steffen Maier <maier@linux.ibm.com>,
 Benjamin Block <bblock@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Hannes Reinecke <hare@suse.com>, Anil Gurumurthy
 <anil.gurumurthy@qlogic.com>,
 Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
 Saurav Kashyap <skashyap@marvell.com>, Javed Hasan <jhasan@marvell.com>,
 GR-QLogic-Storage-Upstream@marvell.com, Oliver Neukum <oliver@neukum.org>,
 Ali Akcaagac <aliakc@web.de>, Jamie Lenehan <lenehan@twibble.org>,
 Satish Kharat <satishkh@cisco.com>, Sesidhar Baddela <sebaddel@cisco.com>,
 Karan Tilak Kumar <kartilak@cisco.com>, Yihang Li <liyihang9@huawei.com>,
 Don Brace <don.brace@microchip.com>, Tyrel Datwyler <tyreld@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Brian King <brking@us.ibm.com>,
 James Smart <james.smart@broadcom.com>,
 Dick Kennedy <dick.kennedy@broadcom.com>,
 Kashyap Desai <kashyap.desai@broadcom.com>,
 Sumit Saxena <sumit.saxena@broadcom.com>,
 Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
 Chandrakanth patil <chandrakanth.patil@broadcom.com>,
 Nilesh Javali <njavali@marvell.com>,
 Manish Rangankar <mrangankar@marvell.com>,
 "K. Y. Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Matthew Wilcox <willy@infradead.org>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Juergen Gross <jgross@suse.com>, Stefano Stabellini
 <sstabellini@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Alan Stern <stern@rowland.harvard.edu>, Randy Dunlap
 <rdunlap@infradead.org>, John Garry <john.g.garry@oracle.com>,
 Soumya Negi <soumya.negi97@gmail.com>,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 Peter Wang <peter.wang@mediatek.com>,
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 Avri Altman <avri.altman@wdc.com>, Andrew Halaney <ahalaney@redhat.com>,
 Bean Huo <beanhuo@micron.com>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
References: <20240930201937.2020129-1-bvanassche@acm.org>
 <20240930201937.2020129-2-bvanassche@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240930201937.2020129-2-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/1/24 05:18, Bart Van Assche wrote:
> There is agreement that the word "slave" should not be used in Linux
> kernel source code. Hence this patch that renames .slave_alloc() into
> .device_alloc() and .slave_destroy() into .device_destroy() in the SCSI
> core, SCSI drivers, ATA drivers and also in the SCSI documentation.
> Do not modify Documentation/scsi/ChangeLog.lpfc. No functionality has
> been changed.
> 
> This patch has been created as follows:
> * Change the text "slave_alloc" into "device_alloc" in all source files
>   except in the LPFC driver changelog.

Looks good, but like Matthew, I think sdev_xxx may be better names as they make
it clear that the operations take a struct scsi_device. But I will not hold this
series for that though.

The patch is really big too, so maybe move the documentation changes together
with patch 4 ?

Also, please send the cover letter to everyone. Having to look at all patch
titles to try to figure out what your patches do overall is not fun.

> * Change the text "slave_destroy" into "device_destroy" in all source
>   files except in the LPFC driver changelog.
> * Rename lpfc_no_slave() into lpfc_no_device().
> * Manually adjust whitespace where necessary to restore vertical
>   alignment (dc395x driver and include/linux/libata.h).
> 
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

[...]

> diff --git a/include/linux/libata.h b/include/linux/libata.h
> index 9b4a6ff03235..e04184b6d79b 100644
> --- a/include/linux/libata.h
> +++ b/include/linux/libata.h
> @@ -1201,10 +1201,10 @@ extern int ata_std_bios_param(struct scsi_device *sdev,
>  			      struct block_device *bdev,
>  			      sector_t capacity, int geom[]);
>  extern void ata_scsi_unlock_native_capacity(struct scsi_device *sdev);
> -extern int ata_scsi_slave_alloc(struct scsi_device *sdev);
> +extern int ata_scsi_device_alloc(struct scsi_device *sdev);

While at it, drop the extern.

>  int ata_scsi_device_configure(struct scsi_device *sdev,
>  		struct queue_limits *lim);
> -extern void ata_scsi_slave_destroy(struct scsi_device *sdev);
> +extern void ata_scsi_device_destroy(struct scsi_device *sdev);

Here too.

>  extern int ata_scsi_change_queue_depth(struct scsi_device *sdev,
>  				       int queue_depth);
>  extern int ata_change_queue_depth(struct ata_port *ap, struct scsi_device *sdev,
> @@ -1460,8 +1460,8 @@ extern const struct attribute_group *ata_common_sdev_groups[];
>  	.this_id		= ATA_SHT_THIS_ID,		\
>  	.emulated		= ATA_SHT_EMULATED,		\
>  	.proc_name		= drv_name,			\
> -	.slave_alloc		= ata_scsi_slave_alloc,		\
> -	.slave_destroy		= ata_scsi_slave_destroy,	\
> +	.device_alloc		= ata_scsi_device_alloc,	\
> +	.device_destroy		= ata_scsi_device_destroy,	\
>  	.bios_param		= ata_std_bios_param,		\
>  	.unlock_native_capacity	= ata_scsi_unlock_native_capacity,\
>  	.max_sectors		= ATA_MAX_SECTORS_LBA48


-- 
Damien Le Moal
Western Digital Research
