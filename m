From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 24/24] scsi_error: document scsi_try_to_abort_cmd
Date: Fri, 3 Oct 2014 02:54:00 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958CCBF23@G4W3202.americas.hpqcorp.net>
References: <1412144580-72880-1-git-send-email-hare@suse.de>
 <1412144580-72880-25-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:1851 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbaJCCzx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2014 22:55:53 -0400
In-Reply-To: <1412144580-72880-25-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Wednesday, 01 October, 2014 1:23 AM
> To: James Bottomley
> Cc: Christoph Hellwig; linux-scsi@vger.kernel.org; Elliott, Robert (Server
> Storage); Hannes Reinecke
> Subject: [PATCH 24/24] scsi_error: document scsi_try_to_abort_cmd
> 
> scsi_try_to_abort_cmd() should only return
> SUCCESS or FAILED. So document that in the
> function description and simplify the
> logging message.
> 
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Cc: Robert Elliott <elliott@hp.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/scsi_error.c | 20 +++++++++++++++++---
>  1 file changed, 17 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index a41ef5b..75dd203 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -157,8 +157,7 @@ scmd_eh_abort_handler(struct work_struct *work)
>  		} else {
>  			SCSI_LOG_ERROR_RECOVERY(3,
>  				scmd_printk(KERN_INFO, scmd,
> -					    "scmd %p abort failed, rtn %d\n",
> -					    scmd, rtn));
> +					    "scmd %p abort failed\n", scmd));
>  		}
>  	}
> 
> @@ -869,7 +868,22 @@ static int scsi_try_bus_device_reset(struct scsi_cmnd
> *scmd)
>  	return rtn;
>  }
> 
> -static int scsi_try_to_abort_cmd(struct scsi_host_template *hostt, struct
> scsi_cmnd *scmd)
> +/**
> + * scsi_try_to_abort_cmd - Ask host to abort a SCSI command
> + * @scmd:	SCSI cmd used to send a target reset
> + *
> + * Return value:
> + *	SUCCESS or FAILED
> + *
> + * Notes:
> + *    SUCCESS does not necessarily indicate that the command
> + *    has been aborted; it only indicates that the LLDDs
> + *    has cleared all references to that command.
> + *    LLDDs should return FAILED only if an abort was required
> + *    but could not be executed.
> + */
> +static int scsi_try_to_abort_cmd(struct scsi_host_template *hostt,
> +				 struct scsi_cmnd *scmd)
>  {
>  	if (!hostt->eh_abort_handler)
>  		return FAILED;

Since the rest of that function is just:
        return hostt->eh_abort_handler(scmd);

this relies on the LLD to use only those values:
#define SUCCESS         0x2002
#define FAILED          0x2003

which is hard to ensure.

Randomly picking on one, megaraid.c registers this
function:
	.eh_abort_handler               = megaraid_abort,

megaraid_abort returns the return code from 
megaraid_abort_and_reset, which returns TRUE or FALSE, 
not SUCCESS and FAILED.

Printing the return value helps expose such problems
(if the code path is exercised).

---
Rob Elliott    HP Server Storage




