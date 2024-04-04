Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2043E82869;
	Thu,  4 Apr 2024 13:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712235745; cv=none; b=bSrRQlD/mnER1GhKJhbkbFglOtWUsJJm5CXbAzjA1P3zoXizPuppmNfhqNnFJLpZNC75YknE61fI5e7ALi/NXUPJqNa5EiV+nzh9S5DYc1iiTlvUT+yuvYMk3dRNCLBRN6JUY69ZbPV4TrFL1Uwsy/KWSf+zjsyEQ6lg8nbHsfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712235745; c=relaxed/simple;
	bh=7pnNVobmpgyZTe16jRV/6bw4ZMlQxfeaW6/ZyW0OS5c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TcIq2o6sGhawTXqFmZ2eBcinhLl8NwBso3uHGPM5mdm6h7WsTUwZiqJoagil6oMuH6RVDQ4mDEs39eXuyjwTaEZImx4uhASnfChUVPkoRSrUdhZgr85UOm0sC+iZgHzIfwLuRXK26uXnV7vf4eDCiJj6V45iDbPcHDKXxjKQbnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wRPZ06sw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wRPZ06sw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AD9BC43390;
	Thu,  4 Apr 2024 13:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712235744;
	bh=7pnNVobmpgyZTe16jRV/6bw4ZMlQxfeaW6/ZyW0OS5c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=wRPZ06swiOXGDkR5LDGhbTD20vCpQJRXl6GUgJisu04HDven1EMqzQhKeLlNydPYe
	 m91DWRZCw18Q1/WgUgG3uH0YVrazdLvWibeMaEB2ReM3pIxevp+5nk2oICuGedqMDh
	 nANzmhxQGUMdF0RS86bEWHacFsWW9l2RhKSi4llw=
Date: Thu, 4 Apr 2024 15:02:21 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	"Juergen E. Fischer" <fischer@norbit.de>,
	Xiang Chen <chenxiang66@hisilicon.com>,
	HighPoint Linux Team <linux@highpoint-tech.com>,
	Tyrel Datwyler <tyreld@linux.ibm.com>,
	Brian King <brking@us.ibm.com>, Lee Duncan <lduncan@suse.com>,
	Chris Leech <cleech@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Alan Stern <stern@rowland.harvard.edu>, linux-block@vger.kernel.org,
	linux-ide@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
	MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
	megaraidlinux.pdl@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com,
	linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net
Subject: Re: [PATCH 07/23] scsi: add a dma_alignment field to the host and
 host template
Message-ID: <2024040412-reacquire-wrangle-3e1e@gregkh>
References: <20240402130645.653507-1-hch@lst.de>
 <20240402130645.653507-8-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240402130645.653507-8-hch@lst.de>

On Tue, Apr 02, 2024 at 03:06:29PM +0200, Christoph Hellwig wrote:
> Get drivers out of the business of having to call the block layer
> dma alignment limits helpers themselves.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> Reviewed-by: John Garry <john.g.garry@oracle.com>
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>  drivers/firewire/sbp2.c           |  6 ------
>  drivers/message/fusion/mptfc.c    |  1 +
>  drivers/message/fusion/mptsas.c   |  1 +
>  drivers/message/fusion/mptscsih.c |  2 --
>  drivers/message/fusion/mptspi.c   |  1 +
>  drivers/scsi/hosts.c              |  6 ++++++
>  drivers/scsi/iscsi_tcp.c          |  2 +-
>  drivers/scsi/qla2xxx/qla_os.c     |  6 +++---
>  drivers/scsi/scsi_lib.c           | 11 ++---------
>  drivers/staging/rts5208/rtsx.c    | 24 ++++++++++++------------
>  drivers/usb/image/microtek.c      |  8 +-------
>  drivers/usb/storage/scsiglue.c    | 11 +++++------
>  drivers/usb/storage/uas.c         | 13 ++++++-------
>  include/scsi/scsi_host.h          |  3 +++
>  14 files changed, 42 insertions(+), 53 deletions(-)
> 

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
