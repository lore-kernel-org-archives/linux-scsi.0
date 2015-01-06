From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] Allow EA reservation holders to read from device.
Date: Tue, 06 Jan 2015 13:23:27 -0800
Message-ID: <1420579407.6927.20.camel@haakon3.risingtidesystems.com>
References: <54AADCC8.2010403@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:57646 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755877AbbAFVX3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jan 2015 16:23:29 -0500
In-Reply-To: <54AADCC8.2010403@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lee Duncan <lduncan@suse.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

Hi Lee,

Apologies for the delayed response, just catching up from the holidays.

Comments below.

On Mon, 2015-01-05 at 10:49 -0800, Lee Duncan wrote:
> From: Lee Duncan <lduncan@suse.com>
> 
> For PGR reservation type Exclusive Access, allow all
> registrants to read from the device.
> 
> Signed-off-by: Lee Duncan <lduncan@suse.com>
> Cc: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
>  drivers/target/target_core_pr.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
> index 85564998500a..cb762b174c08 100644
> --- a/drivers/target/target_core_pr.c
> +++ b/drivers/target/target_core_pr.c
> @@ -551,6 +551,18 @@ static int core_scsi3_pr_seq_non_holder(
> 
>                         return 0;
>                 }
> +       } else if (we && registered_nexus) {
> +               /*
> +                * Reads are allowed for Write Exclusive locks
> +                * from all registrants.
> +                */
> +               if (cmd->data_direction == DMA_FROM_DEVICE) {
> +                       pr_debug("Allowing READ CDB: 0x%02x for %s"
> +                               " reservation\n", cdb[0],
> +                               core_scsi3_pr_dump_type(pr_reg_type));
> +
> +                       return 0;
> +               }
>         }
>         pr_debug("%s Conflict for %sregistered nexus %s CDB: 0x%2x"
>                 " for %s reservation\n", transport_dump_cmd_direction(cmd),

I'm confused as to why this is necessary..

Doesn't the conditional check directly above this one ensure that
all_reg=true && registered_nexus=true implicitly allow READ CDBs to be
processed..?

How is this new check for PR_TYPE_WRITE_EXCLUSIVE_ALLREG reservation any
different..?

--nab











