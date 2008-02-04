From: "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>
Subject: RE: [PATCH 5/24][RFC] dpt_i2o: Use new scsi_eh_cpy_sense()
Date: Mon, 4 Feb 2008 10:32:43 -0800
Message-ID: <532ABFBDAAC3A34EB12EBA6CEC2838F439766174@ADPE2K703.adaptec.com>
References: 47A72A7F.1050301@panasas.com
 <1202140722-4650-1-git-send-email-bharrosh@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ts.adaptec.com ([162.62.93.58]:42041 "EHLO mail-gw3.adaptec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753011AbYBDScr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 13:32:47 -0500
In-Reply-To: <1202140722-4650-1-git-send-email-bharrosh@panasas.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>

ACK with condition that community accepts the RFC's entire premise.

The removed code that shunted the REQUEST_SENSE was based on the assumption that the sense data in the current scsi command packet was left over from the previous command's execution with a check condition as the scsi command packet is reused to issue the REQUEST_SENSE. For a new, or second from the target's point of view, request sense to the target issued by these older kernels would always return an erased sense. The dpt_i2o driver does not itself maintain the sense history, nor does the Firmware. This behavior, I believe, is not the case for current kernels so the code fragment made little sense (pun not intended). If my historical knowledge is correct, this (now removed) workaround makes no more sense because the scsi layer correctly manages adapters that produce auto-request sense an
 d does not ever turn around the command and send a second request for sense information.

Given this understanding, I have no problem with the removed fragment of REQUEST_SENSE shunting. However, I do urge some target error recovery testing, tape drives being the likely type of target affected by this change. I have no such hardware to confirm...

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Boaz Harrosh
> Sent: Monday, February 04, 2008 10:59 AM
> To: James Bottomley; FUJITA Tomonori; Christoph Hellwig; Jens
> Axboe; Jeff Garzik; linux-scsi
> Cc: Andrew Morton
> Subject: [PATCH 5/24][RFC] dpt_i2o: Use new scsi_eh_cpy_sense()
>
>   - Abstract away scsi_cmnd->sense_buffer for later removal.
>
>   - Removed a filtering out of a REQUEST_SENSE at .queuecommand
>     In the case of sense beeing clean. This is no longer relevant
>     since scsi-ml will always send a zero out sense buffer even
>     on a resend, so this means outside REQUEST_SENSE would never
>     go through. If this is intended then comment and check should
>     change.
>
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> ---
>  drivers/scsi/dpt_i2o.c |   25 +++++++------------------
>  1 files changed, 7 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
> index c9dd839..6ee6fcd 100644
> --- a/drivers/scsi/dpt_i2o.c
> +++ b/drivers/scsi/dpt_i2o.c
> @@ -71,6 +71,7 @@ MODULE_DESCRIPTION("Adaptec I2O RAID Driver");
>  #include <scsi/scsi_device.h>
>  #include <scsi/scsi_host.h>
>  #include <scsi/scsi_tcq.h>
> +#include <scsi/scsi_eh.h>
>
>  #include "dpt/dptsig.h"
>  #include "dpti.h"
> @@ -385,18 +386,6 @@ static int adpt_queue(struct scsi_cmnd *
> cmd, void (*done) (struct scsi_cmnd *))
>         struct adpt_device* pDev = NULL;        /* dpt per
> device information */
>
>         cmd->scsi_done = done;
> -       /*
> -        * SCSI REQUEST_SENSE commands will be executed
> automatically by the
> -        * Host Adapter for any errors, so they should not be executed
> -        * explicitly unless the Sense Data is zero
> indicating that no error
> -        * occurred.
> -        */
> -
> -       if ((cmd->cmnd[0] == REQUEST_SENSE) &&
> (cmd->sense_buffer[0] != 0)) {
> -               cmd->result = (DID_OK << 16);
> -               cmd->scsi_done(cmd);
> -               return 0;
> -       }
>
>         pHba = (adpt_hba*)cmd->device->host->hostdata[0];
>         if (!pHba) {
> @@ -2226,8 +2215,6 @@ static s32 adpt_i2o_to_scsi(void
> __iomem *reply, struct scsi_cmnd* cmd)
>
>         pHba = (adpt_hba*) cmd->device->host->hostdata[0];
>
> -       cmd->sense_buffer[0] = '\0';  // initialize sense
> valid flag to false
> -
>         if(!(reply_flags & MSG_FAIL)) {
>                 switch(detailed_status & I2O_SCSI_DSC_MASK) {
>                 case I2O_SCSI_DSC_SUCCESS:
> @@ -2297,11 +2284,13 @@ static s32 adpt_i2o_to_scsi(void
> __iomem *reply, struct scsi_cmnd* cmd)
>                 // copy over the request sense data if it was a check
>                 // condition status
>                 if (dev_status == SAM_STAT_CHECK_CONDITION) {
> -                       u32 len = min(SCSI_SENSE_BUFFERSIZE, 40);
> +                       u8 sense_buffer[40];
> +                       u32 len = sizeof(sense_buffer);
>                         // Copy over the sense data
> -                       memcpy_fromio(cmd->sense_buffer,
> (reply+28) , len);
> -                       if(cmd->sense_buffer[0] == 0x70 /*
> class 7 */ &&
> -                          cmd->sense_buffer[2] == DATA_PROTECT ){
> +                       memcpy_fromio(sense_buffer, (reply+28) , len);
> +                       scsi_eh_cpy_sense(cmd, sense_buffer, len);
> +                       if (sense_buffer[0] == 0x70 /* class 7 */ &&
> +                          sense_buffer[2] == DATA_PROTECT){
>                                 /* This is to handle an array
> failed */
>                                 cmd->result = (DID_TIME_OUT << 16);
>                                 printk(KERN_WARNING"%s: SCSI
> Data Protect-Device (%d,%d,%d) hba_status=0x%x,
> dev_status=0x%x, cmd=0x%x\n",
> --
> 1.5.3.3
>
> -
> To unsubscribe from this list: send the line "unsubscribe
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
