From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] Fix lpfc_parse_bg_err()'s use of do_div()
Date: Tue, 14 Apr 2009 12:09:02 -0400
Message-ID: <49E4B51E.3040402@emulex.com>
References: <20090414155948.27755.2131.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:63081 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbZDNQKC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Apr 2009 12:10:02 -0400
In-Reply-To: <20090414155948.27755.2131.stgit@warthog.procyon.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

David,

I already posted the same fix on 4/7. See:
http://marc.info/?l=linux-scsi&m=123912745216961&w=2

-- james s

David Howells wrote:
> Fix lpfc_parse_bg_err()'s use of do_div().  It should be passing a 64-bit
> variable as the first parameter.  However, since it's only using a 32-bit
> variable, it doesn't need to use do_div() at all, but can instead use the
> division operator.
>
> This deals with the following warnings:
>
>   CC      drivers/scsi/lpfc/lpfc_scsi.o
> drivers/scsi/lpfc/lpfc_scsi.c: In function 'lpfc_parse_bg_err':
> drivers/scsi/lpfc/lpfc_scsi.c:1397: warning: comparison of distinct pointer types lacks a cast
> drivers/scsi/lpfc/lpfc_scsi.c:1397: warning: right shift count >= width of type
> drivers/scsi/lpfc/lpfc_scsi.c:1397: warning: passing argument 1 of '__div64_32' from incompatible pointer type
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
>
>  drivers/scsi/lpfc/lpfc_scsi.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
>
> diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
> index b1bd3fc..36fd2e7 100644
> --- a/drivers/scsi/lpfc/lpfc_scsi.c
> +++ b/drivers/scsi/lpfc/lpfc_scsi.c
> @@ -1394,7 +1394,7 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_scsi_buf *lpfc_cmd,
>  		 */
>  		cmd->sense_buffer[8] = 0;     /* Information */
>  		cmd->sense_buffer[9] = 0xa;   /* Add. length */
> -		do_div(bghm, cmd->device->sector_size);
> +		bghm /= cmd->device->sector_size;
>  
>  		failing_sector = scsi_get_lba(cmd);
>  		failing_sector += bghm;
>
>   
