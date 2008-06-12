From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC] Set functions for scsi_cmnd result
Date: Thu, 12 Jun 2008 10:55:41 -0500
Message-ID: <1213286142.3426.26.camel@localhost.localdomain>
References: <20080612092955.GA9032@schmichrtp.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40411 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755431AbYFLPzp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Jun 2008 11:55:45 -0400
In-Reply-To: <20080612092955.GA9032@schmichrtp.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Thu, 2008-06-12 at 11:29 +0200, Christof Schmitt wrote:
> zfcp currently has helper functions to set the host and driver bytes
> in the scsi_cmnd result. These functions do not belong in the
> low-level driver. The attached patch moves the functions to the global
> SCSI header file, so that every driver can use them.
> 
> If nobody wants ths, i will remove them from zfcp and directly
> manipulate the status like other drivers do.
> 
> ---
>  drivers/s390/scsi/zfcp_scsi.c |   20 --------------------
>  include/scsi/scsi.h           |   10 ++++++++++
>  2 files changed, 10 insertions(+), 20 deletions(-)
> 
> --- a/drivers/s390/scsi/zfcp_scsi.c	2008-06-12 11:00:16.000000000 +0200
> +++ b/drivers/s390/scsi/zfcp_scsi.c	2008-06-12 11:06:37.000000000 +0200
> @@ -107,27 +107,7 @@ zfcp_set_fcp_dl(struct fcp_cmnd_iu *fcp_
>  	*zfcp_get_fcp_dl_ptr(fcp_cmd) = fcp_dl;
>  }
>  
> -/*
> - * note: it's a bit-or operation not an assignment
> - * regarding the specified byte
> - */
> -static inline void
> -set_byte(int *result, char status, char pos)
> -{
> -	*result |= status << (pos * 8);
> -}
>  
> -void
> -set_host_byte(int *result, char status)
> -{
> -	set_byte(result, status, 2);
> -}
> -
> -void
> -set_driver_byte(int *result, char status)
> -{
> -	set_byte(result, status, 3);
> -}
>  
>  static int
>  zfcp_scsi_slave_alloc(struct scsi_device *sdp)
> --- a/include/scsi/scsi.h	2008-06-10 17:30:49.000000000 +0200
> +++ b/include/scsi/scsi.h	2008-06-12 11:06:34.000000000 +0200
> @@ -425,6 +425,16 @@ struct scsi_lun {
>  #define driver_byte(result) (((result) >> 24) & 0xff)
>  #define suggestion(result)  (driver_byte(result) & SUGGEST_MASK)
>  
> +static inline void set_host_byte(int *result, char status)
> +{
> +	*result |= status << 16;
> +}
> +
> +static inline void set_driver_byte(int *result, char status)
> +{
> +	*result |= status << 24;
> +}
> +

If we're making accessors, it might be better if they took a struct
scsi_cmnd rather than a pointer to one of its elements.  Other than
that, this looks fine.

James


