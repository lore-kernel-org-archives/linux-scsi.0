From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] mptsas: remove pointless null check
Date: Mon, 13 Oct 2008 10:22:58 -0400
Message-ID: <1223907778.5566.3.camel@localhost.localdomain>
References: <20081006172653.GA26427@oksana.dev.rtsoft.ru>
	 <48F2F138.6020103@kernel.org> <48F34CB9.3020000@pobox.com>
	 <20081013150529.75f22702@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20081013150529.75f22702@lxorguk.ukuu.org.uk>
Sender: linux-ide-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2008-10-13 at 15:05 +0100, Alan Cox wrote:
> mptsas: remove unneeded check
> 
> From: Alan Cox <alan@redhat.com>
> 
> >From coverity checker. Closes #9675
> 
> Signed-off-by: Alan Cox <alan@redhat.com>
> ---
> 
>  drivers/message/fusion/mptsas.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)

-EWRONGLIST

This is a SCSI patch (although I admit with fusion sitting in
drivers/message it's hard to tell without looking in the MAINTAINERS
file).

> 
> diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
> index 12b7325..a9019f0 100644
> --- a/drivers/message/fusion/mptsas.c
> +++ b/drivers/message/fusion/mptsas.c
> @@ -2279,9 +2279,8 @@ mptsas_delete_expander_phys(MPT_ADAPTER *ioc)
>  	mutex_lock(&ioc->sas_topology_mutex);
>  	list_for_each_entry_safe(port_info, n, &ioc->sas_topology, list) {
>  
> -		if (port_info->phy_info &&

If I remember rightly this check is necessary because phy_info can be
NULL in certain situations.  Your patch will trip this to oops.  What
your description needs to say is that we no longer need to check this
pointer for NULL because it was checked somewhere else in the stack ...
but I can't see where that is, where is it?

> -		    (!(port_info->phy_info[0].identify.device_info &
> -		    MPI_SAS_DEVICE_INFO_SMP_TARGET)))
> +		if (!(port_info->phy_info[0].identify.device_info &
> +		    MPI_SAS_DEVICE_INFO_SMP_TARGET))
>  			continue;
>  
>  		if (mptsas_sas_expander_pg0(ioc, &buffer,

James


