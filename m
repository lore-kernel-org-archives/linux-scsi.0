From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 21/24] scsi: simplify scsi_log_(send|completion)
Date: Fri, 3 Oct 2014 02:32:38 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958CCBEE9@G4W3202.americas.hpqcorp.net>
References: <1412144580-72880-1-git-send-email-hare@suse.de>
 <1412144580-72880-22-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:49870 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbaJCCe1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2014 22:34:27 -0400
In-Reply-To: <1412144580-72880-22-git-send-email-hare@suse.de>
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
> Subject: [PATCH 21/24] scsi: simplify scsi_log_(send|completion)
> 
> Simplify scsi_log_(send|completion) by externalizing
> scsi_mlreturn_string() and always print the command address.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/constants.c | 39 ++++++++++++++++++++++++++++++++++++---
>  drivers/scsi/scsi.c      | 43 ++++++-------------------------------------
>  drivers/scsi/scsi_lib.c  | 13 ++++++++++---
>  include/scsi/scsi_dbg.h  |  3 ++-
>  4 files changed, 54 insertions(+), 44 deletions(-)
> 
> diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
> index b131900..207ebef 100644
> --- a/drivers/scsi/constants.c
> +++ b/drivers/scsi/constants.c
> @@ -1437,19 +1437,52 @@ const char *scsi_driverbyte_string(int result)
>  }
>  EXPORT_SYMBOL(scsi_driverbyte_string);
> 
> -void scsi_print_result(struct scsi_cmnd *cmd)
> +#ifdef CONFIG_SCSI_CONSTANTS
> +#define scsi_mlreturn_name(result)	{ result, #result }
> +static const struct value_name_pair scsi_mlreturn_arr[] = {
> +	scsi_mlreturn_name(NEEDS_RETRY),
> +	scsi_mlreturn_name(SUCCESS),
> +	scsi_mlreturn_name(FAILED),
> +	scsi_mlreturn_name(QUEUED),
> +	scsi_mlreturn_name(SOFT_ERROR),
> +	scsi_mlreturn_name(ADD_TO_MLQUEUE),
> +	scsi_mlreturn_name(TIMEOUT_ERROR),
> +	scsi_mlreturn_name(SCSI_RETURN_NOT_HANDLED),
> +	scsi_mlreturn_name(FAST_IO_FAIL)
> +};

SUCCESS is a misleading name to print on commands that were
really not successful.  Example:
[ 5978.573297] sd 2:0:0:8: [sdz] tag#209 Done: SUCCESS Result: hostbyte=DID_OK driverbyte=DRIVER_OK
[ 5978.576335] sd 2:0:0:8: [sdz] tag#209 CDB: Test Unit Ready 00 00 00 00 00 00
[ 5978.578721] sd 2:0:0:8: [sdz] tag#209 Sense Key : Unit Attention [current]
[ 5978.581177] sd 2:0:0:8: [sdz] tag#209 Add. Sense: Bus device reset function occurred

Maybe that mlreturn value should be printed as 
"COMPLETE" since it is similar to the SAM service
responses called COMMAND COMPLETE and FUNCTION COMPLETE.
That is a more neutral term.

---
Rob Elliott    HP Server Storage




