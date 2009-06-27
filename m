From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] SCSI: userspace cannot use scsi_command_size_tbl,
 COMMAND_SIZE and scsi_device_type
Date: Sat, 27 Jun 2009 12:27:08 -0500
Message-ID: <1246123628.3990.19.camel@mulgrave.site>
References: <1246122359.32198.7.camel@hpdv5.satnam>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34869 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756836AbZF0R1J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 27 Jun 2009 13:27:09 -0400
In-Reply-To: <1246122359.32198.7.camel@hpdv5.satnam>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Boaz Harrosh <bharrosh@panasas.com>, Benny Halevy <bhalevy@panasas.com>, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

All SCSI patches should be cc'd to the SCSI list

On Sat, 2009-06-27 at 22:35 +0530, Jaswinder Singh Rajput wrote:
> userspace cannot use scsi_command_size_tbl, COMMAND_SIZE
> and scsi_device_type defined in kernel
> 
> fix the following 'make headers_check' warnings:
> 
>   usr/include/scsi/scsi.h:159: userspace cannot call function or variable defined in the kernel
>   usr/include/scsi/scsi.h:285: userspace cannot call function or variable defined in the kernel
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  include/scsi/scsi.h |   13 +++++++------
>  1 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
> index 084478e..7ba5acf 100644
> --- a/include/scsi/scsi.h
> +++ b/include/scsi/scsi.h
> @@ -156,9 +156,6 @@ scsi_varlen_cdb_length(const void *hdr)
>  	return ((struct scsi_varlen_cdb_hdr *)hdr)->additional_cdb_length + 8;
>  }
>  
> -extern const unsigned char scsi_command_size_tbl[8];
> -#define COMMAND_SIZE(opcode) scsi_command_size_tbl[((opcode) >> 5) & 7]
> -
>  static inline unsigned
>  scsi_command_size(const unsigned char *cmnd)
>  {
> @@ -166,6 +163,13 @@ scsi_command_size(const unsigned char *cmnd)
>  		scsi_varlen_cdb_length(cmnd) : COMMAND_SIZE(cmnd[0]);

Even a simple eyeball inspection of this patch shows that the removal of
COMMAND_SIZE above causes this inline function to fail to compile.

If you can't be bothered even to read your own patches or at the very
least compile test them, what makes you think I should bother reading
anything you send in?

James



