From: James Wellnitz <Jamie.Wellnitz@emulex.com>
Subject: Re: [PATCH] sd: Fix handling of NO_SENSE check condition
Date: Wed, 24 Sep 2008 15:56:47 -0400
Message-ID: <1222286207.29604.81.camel@shrimp.ma.emulex.com>
References: <1221183576-11724-1-git-send-email-Jamie.Wellnitz@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:33333 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900AbYIXT44 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Sep 2008 15:56:56 -0400
In-Reply-To: <1221183576-11724-1-git-send-email-Jamie.Wellnitz@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@hansenpartnership.com
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

James,

I haven't seem any comment on this patch to fix sd's NO_SENSE handling.
Can it go into scsi-post-merge-2.6?

Thanks,
Jamie

On Thu, 2008-09-11 at 18:39 -0700, Wellnitz, Jamie wrote:
> The current handling of NO_SENSE check condition is the same as
> RECOVERED_ERROR, and assumes that in both cases, the I/O was fully
> transferred.
> 
> We have seen cases of arrays returning with NO_SENSE (no error), but
> the I/O was not completely transferred, thus residual set.  Thus,
> rather than return good_bytes as the entire transfer, set good_bytes
> to 0, so that the midlayer then applies the residual in calculating
> the transfer, and for sd, will fail the I/O and fall into a retry
> path.
> 
> Signed-off-by: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>
> ---
>  drivers/scsi/sd.c |   10 +++++++++-
>  1 files changed, 9 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index af9e406..2a5fe5e 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1048,7 +1048,6 @@ static int sd_done(struct scsi_cmnd *SCpnt)
>                 good_bytes = sd_completed_bytes(SCpnt);
>                 break;
>         case RECOVERED_ERROR:
> -       case NO_SENSE:
>                 /* Inform the user, but make sure that it's not treated
>                  * as a hard error.
>                  */
> @@ -1057,6 +1056,15 @@ static int sd_done(struct scsi_cmnd *SCpnt)
>                 memset(SCpnt->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
>                 good_bytes = scsi_bufflen(SCpnt);
>                 break;
> +       case NO_SENSE:
> +               /* This indicates a false check condition, so ignore it.  An
> +                * unknown amount of data was transferred so treat it as an
> +                * error.
> +                */
> +               scsi_print_sense("sd", SCpnt);
> +               SCpnt->result = 0;
> +               memset(SCpnt->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
> +               break;
>         case ABORTED_COMMAND:
>                 if (sshdr.asc == 0x10) { /* DIF: Disk detected corruption */
>                         scsi_print_result(SCpnt);
> --
> 1.6.0.1.308.gede4c
> 

