Received: from mailout.easymail.ca (mailout.easymail.ca [64.68.200.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E17748F
	for <linux-scsi@vger.kernel.org>; Wed,  2 Oct 2024 15:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=64.68.200.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727882728; cv=none; b=lb+2f2bM6eUybCnfkkvdcl2Arq7M9fsLvitfBtQq5CsXBacw+MrUJRJfnxP1U+/6eaaX4wOs7RDfUfFQp1e0Z+2GnCQsPsqBs0xIr8bqCvC2f2Ayooww7jtpte8E91Kw8gcKyeHJzbtNvGkh/H1lqAt+Ug4/6MzefN/EhkpX8E8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727882728; c=relaxed/simple;
	bh=JLh19awGuKDeC6Dt/rcaI8nI+NJ2Nb5T2B+iEGO2ZPk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SOA088nQiVTRmAg/uqaiG3AgtQ+7W7SNjqMW6jpv6C5X4rwsTa+EYriob/C2Djf4OYvUbrNitMLnbu4VU99zVHSWNuenRbIWYMQnEp610X8QtIF312KBRRslSIee0oA5nuea2TgRx6kempe7qMpXHe1zZhjI7y936ueGg+lJFFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gonehiking.org; spf=pass smtp.mailfrom=gonehiking.org; arc=none smtp.client-ip=64.68.200.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gonehiking.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gonehiking.org
Received: from localhost (localhost [127.0.0.1])
	by mailout.easymail.ca (Postfix) with ESMTP id 11C0963745;
	Wed,  2 Oct 2024 15:19:52 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at emo07-pco.easydns.vpn
Received: from mailout.easymail.ca ([127.0.0.1])
	by localhost (emo07-pco.easydns.vpn [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NSNiAYvWBg6H; Wed,  2 Oct 2024 15:19:51 +0000 (UTC)
Received: from mail.gonehiking.org (unknown [38.175.170.29])
	by mailout.easymail.ca (Postfix) with ESMTPA id 400A1636F8;
	Wed,  2 Oct 2024 15:19:51 +0000 (UTC)
Received: from [192.168.1.4] (internal [192.168.1.4])
	by mail.gonehiking.org (Postfix) with ESMTP id 7CBFB3EE5E;
	Wed,  2 Oct 2024 09:19:50 -0600 (MDT)
Message-ID: <d3d97295-fefc-4843-807a-8b01cb7ba935@gonehiking.org>
Date: Wed, 2 Oct 2024 09:19:48 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: khalid@gonehiking.org
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
 Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
 Matthew Wilcox <willy@infradead.org>, Hannes Reinecke <hare@suse.com>,
 Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
 Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
 Saurav Kashyap <skashyap@marvell.com>, Javed Hasan <jhasan@marvell.com>,
 GR-QLogic-Storage-Upstream@marvell.com, Don Brace <don.brace@microchip.com>,
 Tyrel Datwyler <tyreld@linux.ibm.com>, Michael Ellerman
 <mpe@ellerman.id.au>, James Smart <james.smart@broadcom.com>,
 Dick Kennedy <dick.kennedy@broadcom.com>, Geoff Levand
 <geoff@infradead.org>, Nilesh Javali <njavali@marvell.com>,
 Karan Tilak Kumar <kartilak@cisco.com>, Sesidhar Baddela
 <sebaddel@cisco.com>, "K. Y. Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Juergen Gross <jgross@suse.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 ching Huang <ching2048@areca.com.tw>, Bjorn Helgaas <bhelgaas@google.com>,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 Soumya Negi <soumya.negi97@gmail.com>
References: <20240930201937.2020129-1-bvanassche@acm.org>
 <20240930201937.2020129-3-bvanassche@acm.org>
Content-Language: en-US
From: Khalid Aziz <khalid@gonehiking.org>
Autocrypt: addr=khalid@gonehiking.org; keydata=
 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
In-Reply-To: <20240930201937.2020129-3-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/30/24 2:18 PM, Bart Van Assche wrote:
> There is agreement that the word "slave" should not be used in Linux
> kernel source code. Hence this patch that converts all SCSI drivers from
> .slave_configure() to .device_configure(). No functionality has been
> changed.
> 
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/infiniband/ulp/srp/ib_srp.c         |  5 +++--
>   drivers/message/fusion/mptfc.c              |  2 +-
>   drivers/message/fusion/mptsas.c             |  6 +++---
>   drivers/message/fusion/mptscsih.c           |  4 ++--
>   drivers/message/fusion/mptscsih.h           |  3 ++-
>   drivers/message/fusion/mptspi.c             |  7 ++++---
>   drivers/net/ethernet/allwinner/sun4i-emac.c |  4 ++--
>   drivers/s390/scsi/zfcp_scsi.c               |  5 +++--
>   drivers/scsi/3w-9xxx.c                      |  7 ++++---
>   drivers/scsi/3w-sas.c                       |  7 ++++---
>   drivers/scsi/3w-xxxx.c                      |  9 ++++----
>   drivers/scsi/53c700.c                       |  7 ++++---
>   drivers/scsi/BusLogic.c                     |  7 ++++---
>   drivers/scsi/BusLogic.h                     |  3 ++-
>   drivers/scsi/aacraid/linit.c                |  8 ++++---
>   drivers/scsi/advansys.c                     | 23 +++++++++++----------
>   drivers/scsi/aic7xxx/aic79xx_osm.c          |  4 ++--
>   drivers/scsi/aic7xxx/aic7xxx_osm.c          |  4 ++--
>   drivers/scsi/arcmsr/arcmsr_hba.c            |  8 ++++---
>   drivers/scsi/bfa/bfad_im.c                  |  6 +++---
>   drivers/scsi/bnx2fc/bnx2fc_fcoe.c           |  5 +++--
>   drivers/scsi/csiostor/csio_scsi.c           |  6 +++---
>   drivers/scsi/esp_scsi.c                     |  7 ++++---
>   drivers/scsi/hpsa.c                         |  8 ++++---
>   drivers/scsi/ibmvscsi/ibmvfc.c              |  7 ++++---
>   drivers/scsi/ibmvscsi/ibmvscsi.c            |  8 ++++---
>   drivers/scsi/ips.c                          |  6 +++---
>   drivers/scsi/ips.h                          |  3 ++-
>   drivers/scsi/lpfc/lpfc_scsi.c               | 21 ++++++++++++-------
>   drivers/scsi/mvumi.c                        |  5 +++--
>   drivers/scsi/myrb.c                         |  5 +++--
>   drivers/scsi/myrs.c                         |  5 +++--
>   drivers/scsi/ncr53c8xx.c                    |  5 +++--
>   drivers/scsi/ps3rom.c                       |  5 +++--
>   drivers/scsi/qedf/qedf_main.c               |  5 +++--
>   drivers/scsi/qla1280.c                      |  6 +++---
>   drivers/scsi/qla2xxx/qla_os.c               |  4 ++--
>   drivers/scsi/qlogicpti.c                    |  5 +++--
>   drivers/scsi/scsi_debug.c                   |  7 ++++---
>   drivers/scsi/scsi_scan.c                    |  2 +-
>   drivers/scsi/smartpqi/smartpqi_init.c       |  5 +++--
>   drivers/scsi/snic/snic_main.c               |  6 +++---
>   drivers/scsi/stex.c                         |  4 ++--
>   drivers/scsi/storvsc_drv.c                  |  5 +++--
>   drivers/scsi/sym53c8xx_2/sym_glue.c         |  5 +++--
>   drivers/scsi/xen-scsifront.c                |  7 ++++---
>   drivers/staging/rts5208/rtsx.c              |  4 ++--
>   47 files changed, 166 insertions(+), 124 deletions(-)
> 
> 
> ...... snipped.........
> diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
> index 2135a2b3e2d0..88839c81db97 100644
> --- a/drivers/scsi/BusLogic.c
> +++ b/drivers/scsi/BusLogic.c
> @@ -2153,14 +2153,15 @@ static void __init blogic_inithoststruct(struct blogic_adapter *adapter,
>   }
>   
>   /*
> -  blogic_slaveconfig will actually set the queue depth on individual
> +  blogic_device_configure will actually set the queue depth on individual
>     scsi devices as they are permanently added to the device chain.  We
>     shamelessly rip off the SelectQueueDepths code to make this work mostly
>     like it used to.  Since we don't get called once at the end of the scan
>     but instead get called for each device, we have to do things a bit
>     differently.
>   */
> -static int blogic_slaveconfig(struct scsi_device *dev)
> +static int blogic_device_configure(struct scsi_device *dev,
> +				   struct queue_limits *lim)
>   {
>   	struct blogic_adapter *adapter =
>   		(struct blogic_adapter *) dev->host->hostdata;
> @@ -3672,7 +3673,7 @@ static const struct scsi_host_template blogic_template = {
>   	.name = "BusLogic",
>   	.info = blogic_drvr_info,
>   	.queuecommand = blogic_qcmd,
> -	.slave_configure = blogic_slaveconfig,
> +	.device_configure = blogic_device_configure,
>   	.bios_param = blogic_diskparam,
>   	.eh_host_reset_handler = blogic_hostreset,
>   #if 0
> diff --git a/drivers/scsi/BusLogic.h b/drivers/scsi/BusLogic.h
> index 7d1ec10f2430..1eb61e886ee3 100644
> --- a/drivers/scsi/BusLogic.h
> +++ b/drivers/scsi/BusLogic.h
> @@ -1274,7 +1274,8 @@ static inline void blogic_incszbucket(unsigned int *cmdsz_buckets,
>   static const char *blogic_drvr_info(struct Scsi_Host *);
>   static int blogic_qcmd(struct Scsi_Host *h, struct scsi_cmnd *);
>   static int blogic_diskparam(struct scsi_device *, struct block_device *, sector_t, int *);
> -static int blogic_slaveconfig(struct scsi_device *);
> +static int blogic_device_configure(struct scsi_device *,
> +				   struct queue_limits *lim);
>   static void blogic_qcompleted_ccb(struct blogic_ccb *);
>   static irqreturn_t blogic_inthandler(int, void *);
>   static int blogic_resetadapter(struct blogic_adapter *, bool hard_reset);
> 
Looks fine for BusLogic driver.

Acked-by: Khalid Aziz <khalid@gonehiking.org>

