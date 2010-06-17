From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [PATCH] mpt fusion: Cleanup some duplicate calls in mptbase.c
Date: Thu, 17 Jun 2010 16:18:52 +0530
Message-ID: <1C9608B8A4CD534FB19C7C7543CBB2490290109758@inbmail02.lsi.com>
References: <20100616173942.GE336@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:40876 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759595Ab0FQKtM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jun 2010 06:49:12 -0400
In-Reply-To: <20100616173942.GE336@stratus.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bandan Das <bandan.das@stratus.com>, James Bottomley <James.Bottomley@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Barand, I reviewed your below patch and it is valid.

James, Can you please consider this patch as ACKed and consider it for next merge window.

Thanks, Kashyap

> -----Original Message-----
> From: Bandan Das [mailto:bandan.das@stratus.com]
> Sent: Wednesday, June 16, 2010 11:10 PM
> To: James Bottomley
> Cc: Desai, Kashyap; linux-scsi@vger.kernel.org
> Subject: [PATCH] mpt fusion: Cleanup some duplicate calls in mptbase.c
> 
> In mpt_detach, call to pci_set_drvdata is redundant because it
> has already been called in mpt_adapter_disable. In mpt_attach,
> ioc->pcidev is set to pdev two times.
> 
> Signed-off-by: Bandan Das <bandan.das@stratus.com>
> ---
>  drivers/message/fusion/mptbase.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/message/fusion/mptbase.c
> b/drivers/message/fusion/mptbase.c
> index a6a5701..2ec2fa7 100644
> --- a/drivers/message/fusion/mptbase.c
> +++ b/drivers/message/fusion/mptbase.c
> @@ -1770,7 +1770,6 @@ mpt_attach(struct pci_dev *pdev, const struct
> pci_device_id *id)
>  	ioc->req_sz = MPT_DEFAULT_FRAME_SIZE;		/* avoid div by
> zero! */
>  	ioc->reply_sz = MPT_REPLY_FRAME_SIZE;
> 
> -	ioc->pcidev = pdev;
> 
>  	spin_lock_init(&ioc->taskmgmt_lock);
>  	mutex_init(&ioc->internal_cmds.mutex);
> @@ -2051,7 +2050,6 @@ mpt_detach(struct pci_dev *pdev)
> 
>  	mpt_adapter_dispose(ioc);
> 
> -	pci_set_drvdata(pdev, NULL);
>  }
> 
> 
> /**********************************************************************
> ****
> --
> 1.6.6.1

