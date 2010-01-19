From: Alok Kataria <akataria@vmware.com>
Subject: Re: [Pv-drivers] [PATCH] PVSCSI: fix signedness warning with newer
	compilers
Date: Tue, 19 Jan 2010 10:04:33 -0800
Message-ID: <1263924273.24149.1.camel@ank32.eng.vmware.com>
References: <20100119173819.GA28630@dtor-ws.eng.vmware.com>
Reply-To: akataria@vmware.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:33118 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752335Ab0ASSEe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Jan 2010 13:04:34 -0500
In-Reply-To: <20100119173819.GA28630@dtor-ws.eng.vmware.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dmitry Torokhov <dtor@vmware.com>
Cc: James Bottomley <James.Bottomley@suse.de>, VMware PV-Drivers <pv-drivers@vmware.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, 2010-01-19 at 09:38 -0800, Dmitry Torokhov wrote:
> pvscsi_setup_msix() expects 'irq' argument to be an int but is being
> passed unsigned int. Unsigned int is more proper type for IRQ number
> so let's use it. This shuts off a compile warning with recent
> compilers.
> 
> Signed-off-by: Dmitry Torokhov <dtor@vmware.com>

LGTM.

Signed-off-by: Alok N Kataria <akataria@vmware.com>

Thanks.
> ---
>  drivers/scsi/vmw_pvscsi.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
> index d2604c8..e4ac582 100644
> --- a/drivers/scsi/vmw_pvscsi.c
> +++ b/drivers/scsi/vmw_pvscsi.c
> @@ -1069,7 +1069,8 @@ static void pvscsi_free_sgls(const struct pvscsi_adapter *adapter)
>  		free_pages((unsigned long)ctx->sgl, get_order(SGL_SIZE));
>  }
>  
> -static int pvscsi_setup_msix(const struct pvscsi_adapter *adapter, int *irq)
> +static int pvscsi_setup_msix(const struct pvscsi_adapter *adapter,
> +			     unsigned int *irq)
>  {
>  	struct msix_entry entry = { 0, PVSCSI_VECTOR_COMPLETION };
>  	int ret;
> 
> _______________________________________________
> Pv-drivers mailing list
> Pv-drivers@vmware.com
> http://mailman2.vmware.com/mailman/listinfo/pv-drivers

