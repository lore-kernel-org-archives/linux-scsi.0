From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 2/5] Refactoring scsi_error to facilitate in synchronous
 REQUEST_SENSE
Date: Mon, 10 Sep 2007 08:19:59 -0700
Message-ID: <20070910081959.5636785c.randy.dunlap@oracle.com>
References: <46E5508B.7030108@panasas.com>
	<46E55378.1090600@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:55031 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758446AbXIJPWj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Sep 2007 11:22:39 -0400
In-Reply-To: <46E55378.1090600@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@suse.de>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Christoph Hellwig <hch@infradead.org>

On Mon, 10 Sep 2007 17:23:52 +0300 Boaz Harrosh wrote:


Hi Boaz,

Just a small nit:  several of the kernel-doc lines need ':' added.
See below.

> Sign-off-by Boaz Harrosh <bharrosh@panasas.com>
> ---
>  drivers/scsi/scsi_error.c |  133 +++++++++++++++++++++++++++------------------
>  include/scsi/scsi_eh.h    |   23 ++++++++-
>  2 files changed, 102 insertions(+), 54 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 0bcfbe5..0327e20 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -590,42 +590,24 @@ static void scsi_abort_eh_cmnd(struct scsi_cmnd *scmd)
>  }
>  
>  /**
> - * scsi_send_eh_cmnd  - submit a scsi command as part of error recory
> + * scsi_prep_eh_cmnd  - Save a scsi command info as part of error recory
>   * @scmd:       SCSI command structure to hijack
> - * @cmnd:       CDB to send
> + * @sesci       structure to save restore information

 * @sesci:

> + * @cmnd:       CDB to send. Can be NULL if no new cmnd is needed
>   * @cmnd_size:  size in bytes of @cmnd
> - * @timeout:    timeout for this request
>   * @copy_sense: request sense data if set to 1
>   *
>   **/
> -static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
> -			     int cmnd_size, int timeout, int copy_sense)
> +void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd,
> +	struct scsi_eh_save_cmnd_info *sesci, unsigned char *cmnd,
> +	int cmnd_size, int copy_sense)
>  {

> @@ -676,7 +659,62 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
>  
> +/**
> + * scsi_restore_eh_cmnd  - Restore a scsi command info as part of error recory
> + * @scmd:       SCSI command structure to restore
> + * @sesci	saved information from a coresponding call to scsi_prep_eh_cmnd

 * @sesci:

> + *
> + * Undo any damage done by above scsi_prep_eh_cmnd().
> + **/
> +void scsi_eh_restore_cmnd(struct scsi_cmnd* scmd,
> +	struct scsi_eh_save_cmnd_info *sesci)
> +{
> +}
> +EXPORT_SYMBOL(scsi_eh_restore_cmnd);

Thanks.
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
