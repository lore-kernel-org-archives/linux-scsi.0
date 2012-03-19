From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH RESEND 1/2] Drivers: scsi: storvsc: Set the scsi result
 correctly when SRB status is INVALID
Date: Mon, 19 Mar 2012 16:12:40 +0000
Message-ID: <1332173560.3152.65.camel@dabdike>
References: <1332115915-26805-1-git-send-email-kys@microsoft.com>
	 <1332115963-26855-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1332115963-26855-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, hch@infradead.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, 2012-03-18 at 17:12 -0700, K. Y. Srinivasan wrote:
> Currently Windows hosts only support a subset of scsi commands and for commands
> that are not supported, the host returns a generic SRB failure status.
> However, they have agreed to change the return value to indicate that
> the command is not supported. In preparation for that, handle the
> SRB_STATUS_INVALID_REQUEST return value correctly.
> 
> I would like to thank Jeff Garzik <jgpobox@gmail.com> and
> Douglas Gilbert <dgilbert@interlog.com> for suggesting the correct approach
> here.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  drivers/scsi/storvsc_drv.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 44c7a48..018c363 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -202,6 +202,7 @@ enum storvsc_request_type {
>  #define SRB_STATUS_INVALID_LUN	0x20
>  #define SRB_STATUS_SUCCESS	0x01
>  #define SRB_STATUS_ERROR	0x04
> +#define SRB_STATUS_INVALID_REQUEST 0x06

I don't really think this is the correct approach.  We already have a
SCSI error return for this, which you're now translating in the driver
and hypervisor.  Rather than have a special byte return of
SRB_STATUS_INVALID_REQUEST, why not have the hypervisor do the right
thing and fill in the ILLEGAL_REQUEST sense return.  That way you don't
need a special error code and you don't need to construct the sense
buffer in the driver.  Now HyperV will be correctly set up for both pass
through and emulated responses.  It's surely not much work and you
already process sense data correctly in storvsc_command_completion(), so
you wouldn't need any patches to the driver for this approach.

James
