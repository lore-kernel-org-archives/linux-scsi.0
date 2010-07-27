From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [PATCH] mptfusion: release resources in error return path
Date: Tue, 27 Jul 2010 15:36:10 +0530
Message-ID: <1C9608B8A4CD534FB19C7C7543CBB249029913DD78@inbmail02.lsi.com>
References: <4C4D9E89.3020307@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:40380 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756032Ab0G0KGV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jul 2010 06:06:21 -0400
In-Reply-To: <4C4D9E89.3020307@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@suse.de>, "Moore, Eric" <Eric.Moore@lsi.com>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>

Please consider this patch as an ACKed.
It has valid error handling in mpt_mapreousrces().

Thanks, Kashyap

> -----Original Message-----
> From: Tomas Henzl [mailto:thenzl@redhat.com]
> Sent: Monday, July 26, 2010 8:11 PM
> To: 'linux-scsi@vger.kernel.org'
> Cc: James Bottomley; Desai, Kashyap; Moore, Eric; Prakash, Sathya
> Subject: [PATCH] mptfusion: release resources in error return path
> 
> We should release the resources in error return code path.
> The requested pci bars should be released under an error condition,
> when mpt_mapresources fails.
> 
> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
> ---
> diff --git a/drivers/message/fusion/mptbase.c
> b/drivers/message/fusion/mptbase.c
> index e319abc..ea12663 100644
> --- a/drivers/message/fusion/mptbase.c
> +++ b/drivers/message/fusion/mptbase.c
> @@ -1632,6 +1632,7 @@ mpt_mapresources(MPT_ADAPTER *ioc)
>  		} else {
>  			printk(MYIOC_s_WARN_FMT "no suitable DMA mask for
> %s\n",
>  			    ioc->name, pci_name(pdev));
> +			pci_release_selected_regions(pdev, ioc->bars);
>  			return r;
>  		}
>  	} else {
> @@ -1645,6 +1646,7 @@ mpt_mapresources(MPT_ADAPTER *ioc)
>  		} else {
>  			printk(MYIOC_s_WARN_FMT "no suitable DMA mask for
> %s\n",
>  			    ioc->name, pci_name(pdev));
> +			pci_release_selected_regions(pdev, ioc->bars);
>  			return r;
>  		}
>  	}
> @@ -1675,6 +1677,7 @@ mpt_mapresources(MPT_ADAPTER *ioc)
>  	if (mem == NULL) {
>  		printk(MYIOC_s_ERR_FMT ": ERROR - Unable to map adapter"
>  			" memory!\n", ioc->name);
> +		pci_release_selected_regions(pdev, ioc->bars);
>  		return -EINVAL;
>  	}
>  	ioc->memmap = mem;
> 

