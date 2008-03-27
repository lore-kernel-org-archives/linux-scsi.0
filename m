From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 9/9][RESEND] mvsas: ATAPI lun issue
Date: Thu, 27 Mar 2008 09:38:54 -0400
Message-ID: <47EBA36E.10606@garzik.org>
References: <47EB44F6.8070708@marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:54524 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755883AbYC0Niz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Mar 2008 09:38:55 -0400
In-Reply-To: <47EB44F6.8070708@marvell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kewei@marvell.com
Cc: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com

Ke Wei wrote:
>     I found that sending REPORT_LUNS command to some DVD device will cause fis error and controller error record. As a result, scsi mid layer get some wrong LUNs. Also I can get some queer messages.
> 
> scsi: host 12 channel 0 id 2 lun 0x30302e302f686f73 has a LUN larger
> than currently supported.
> scsi: host 12 channel 0 id 2 lun 0x7431322f706f7274 has a LUN larger
> than currently supported.
> scsi: host 12 channel 0 id 2 lun 0x2d31323a322f656e has a LUN larger
> than currently supported.
> ...
> 
>     The patch forced to clear the sg buffer of SATA response if FIS is error. But I suggest these codes should merge to the libsas module.
> 
> 
> Signed-off-by: Ke Wei <kewei@marvell.com>
> ---
>  drivers/scsi/mvsas.c |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/mvsas.c b/drivers/scsi/mvsas.c
> index e55b903..42f3e90 100644
> --- a/drivers/scsi/mvsas.c
> +++ b/drivers/scsi/mvsas.c
> @@ -1263,8 +1263,14 @@ static int mvs_sata_done(struct mvs_info *mvi, struct sas_task *task,
>  	       SATA_RECEIVED_D2H_FIS(port->taskfileset),
>  	       sizeof(struct dev_to_host_fis));
>  	tstat->buf_valid_size = sizeof(*resp);
> -	if (unlikely(err))
> +	if (unlikely(err)) {
> +		struct scatterlist *sg = task->scatter;
> +		u8 *buf;
>  		stat = SAS_PROTO_RESPONSE;
> +		buf = kmap_atomic(sg_page(sg), KM_IRQ0) + sg->offset;
> +		memset(buf, 0, sg->length);
> +		kunmap_atomic(buf - sg->offset, KM_IRQ0);
> +	}

double-check that this is inside spin_lock_irqsave()

if not, kmap_atomic()..kunmap_atomic() needs to be surrounded by 
local_irq_save() and local_irq_restore()

	Jeff




