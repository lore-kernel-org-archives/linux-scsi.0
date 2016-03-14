From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH] Avoid that long log lines are truncated
Date: Mon, 14 Mar 2016 10:38:40 -0400
Message-ID: <1457966320.4188.17.camel@localhost.localdomain>
References: <56E6C88B.6010201@sandisk.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53665 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755904AbcCNOim (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Mar 2016 10:38:42 -0400
In-Reply-To: <56E6C88B.6010201@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Robert Elliott <Elliott@hp.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, 2016-03-14 at 07:19 -0700, Bart Van Assche wrote:
> While testing the latest version of the SRP initiator and target
> drivers I encountered the following message in the kernel log:
> 
> sd 16:0:0:0: Warning! Received an indication that the LUN assignments on this target have changed. The Linux SCSI layer does not automatical
> 
> This is a truncated message. Avoid that such truncation happens
> by increasing the SCSI_LOG_BUFSIZE constant.
> 
> Fixes: ded85c193a39 (scsi: Implement per-cpu logging buffer)
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Robert Elliott <elliott@hp.com>
> Cc: Ewan D. Milne <emilne@redhat.com>
> Cc: <stable@vger.kernel.org> # v4.0+
> ---
>  include/scsi/scsi_dbg.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/scsi/scsi_dbg.h b/include/scsi/scsi_dbg.h
> index 56710e0..05d36eb 100644
> --- a/include/scsi/scsi_dbg.h
> +++ b/include/scsi/scsi_dbg.h
> @@ -5,7 +5,7 @@ struct scsi_cmnd;
>  struct scsi_device;
>  struct scsi_sense_hdr;
>  
> -#define SCSI_LOG_BUFSIZE 128
> +#define SCSI_LOG_BUFSIZE 256
>  
>  extern void scsi_print_command(struct scsi_cmnd *);
>  extern size_t __scsi_format_command(char *, size_t,

Hmm.  Perhaps we should make the message less verbose instead?
It looks like if we increase SCSI_LOG_BUFSIZE then we get fewer
per-message buffers unless we also increase SCSI_LOG_SPOOLSIZE.

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


