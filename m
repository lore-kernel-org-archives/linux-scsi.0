From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 27/27] scsi: ratelimit I/O error messages
Date: Fri, 24 Oct 2014 21:00:15 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B4029593375F6@G9W0745.americas.hpqcorp.net>
References: <1414153627-2863-1-git-send-email-hare@suse.de>
 <1414153627-2863-28-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:32720 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbaJXVBf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Oct 2014 17:01:35 -0400
In-Reply-To: <1414153627-2863-28-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Friday, 24 October, 2014 7:27 AM
> To: James Bottomley
> Cc: Christoph Hellwig; Elliott, Robert (Server Storage); linux-
> scsi@vger.kernel.org; Hannes Reinecke
> Subject: [PATCH 27/27] scsi: ratelimit I/O error messages
> 
> There can be quite a lot of I/O error messages, even on smaller
> machines. So we need to ratelimit them to not overwhelm logging.
> 
> Cc: Robert Elliott <elliott@hp.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/scsi_lib.c | 32 ++++++++++++++++++++------------
>  1 file changed, 20 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 3ea5969..4572991 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
...
> @@ -1038,18 +1039,25 @@ void scsi_io_completion(struct scsi_cmnd
> *cmd, unsigned int good_bytes)
>  	switch (action) {
>  	case ACTION_FAIL:
>  		/* Give up and fail the remainder of the request */
> -		if (unlikely(scsi_logging_level))
> -			level = SCSI_LOG_LEVEL(SCSI_LOG_MLQUEUE_SHIFT,
> -					       SCSI_LOG_MLQUEUE_BITS);
> -		/*
> -		 * if logging is enabled the failure will be printed
> -		 * in scsi_log_completion(), so avoid duplicate messages
> -		 */
> -		if (!level && !(req->cmd_flags & REQ_QUIET)) {
> -			scsi_print_result(cmd, NULL, FAILED);
> -			if (driver_byte(result) & DRIVER_SENSE)
> -				scsi_print_sense(cmd);
> -			scsi_print_command(cmd);
> +		if (!(req->cmd_flags & REQ_QUIET)) {
> +			static DEFINE_RATELIMIT_STATE(_rs,
> +					DEFAULT_RATELIMIT_INTERVAL,
> +					DEFAULT_RATELIMIT_BURST);
> +
> +			if (unlikely(scsi_logging_level))
> +				level =
> SCSI_LOG_LEVEL(SCSI_LOG_MLQUEUE_SHIFT,
> +						       SCSI_LOG_MLQUEUE_BITS);
> +

This switched back to MLQUEUE from MLCOMPLETE (which v7 had
corrected).

With MLCOMPLETE level 1, the scsi_log_completion prints
also occur, so everything is doubled.

This should use MLCOMPLETE.


> +			/*
> +			 * if logging is enabled the failure will be
> printed
> +			 * in scsi_log_completion(), so avoid duplicate
> messages
> +			 */
> +			if (!level && __ratelimit(&_rs)) {
> +				scsi_print_result(cmd, NULL, FAILED);
> +				if (driver_byte(result) & DRIVER_SENSE)
> +					scsi_print_sense(cmd);
> +				scsi_print_command(cmd);

The scsi_log_completion equivalent section calls scsi_print_command
before scsi_print_sense (noticed due to the previous issue).  You 
may want to make them the same (though in this case the subtle
difference was helpful).

> +			}
>  		}
>  		if (!scsi_end_request(req, error, blk_rq_err_bytes(req),
> 0))
>  			return;
> --
> 1.8.5.2

With MLQUEUE level 0 and MLCOMPLETE level 0, v8 runs those prints, 
and they work as expected:
* the value in the ratelimit message matches the block layer (82)
* the number of print_result/print_sense/print_command matches 
  the number of block layer prints (10)
* the SCSI prints end up interleaved, but that's for the next 
  patch series to fix

Assuming the MLQUEUE -> MLCOMPLETE fix is put back in,
you may add:
Tested-by: Robert Elliott <elliott@hp.com>
Reviewed-by: Robert Elliott <elliott@hp.com> 

Thanks.

Excerpt with MLQUEUE level 0, MLCOMPLETE level 0:
[  789.844126] scsi_io_completion: 82 callbacks suppressed
[  789.844231] blk_update_request: 82 callbacks suppressed
[  789.844233] blk_update_request: critical target error, dev sds, sector 35768
[  789.844263] blk_update_request: critical target error, dev sds, sector 3984
[  789.844267] blk_update_request: critical target error, dev sds, sector 74936
[  789.844310] blk_update_request: critical target error, dev sds, sector 46592
[  789.844481] blk_update_request: critical target error, dev sds, sector 111072
[  789.844485] blk_update_request: critical target error, dev sds, sector 160608
[  789.844488] blk_update_request: critical target error, dev sds, sector 1232
[  789.844492] blk_update_request: critical target error, dev sds, sector 129896
[  789.844498] blk_update_request: critical target error, dev sds, sector 119672
[  789.844535] blk_update_request: critical target error, dev sds, sector 14272
[  789.872076] sd 2:0:0:1: [sds] FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[  789.874743] sd 2:0:0:1: [sds] Sense Key : Hardware Error [current]
[  789.876820] sd 2:0:0:1: [sds] Add. Sense: Logical unit failure
[  789.878778] sd 2:0:0:1: [sds] CDB:
[  789.880073] Read(10): 28 00 00 00 98 90 00 00 08 00
[  789.882431] sd 2:0:0:1: [sds] FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[  789.885034] sd 2:0:0:1: [sds] Sense Key : Hardware Error [current]
[  789.887046] sd 2:0:0:1: [sds] Add. Sense: Logical unit failure
[  789.889049] sd 2:0:0:1: [sds] CDB:
[  789.890258] sd 2:0:0:1: [sds] FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[  789.890261] sd 2:0:0:1: [sds] Sense Key : Hardware Error [current]
[  789.890264] sd 2:0:0:1: [sds] Add. Sense: Logical unit failure
[  789.890266] sd 2:0:0:1: [sds] CDB:
[  789.890271] Read(10): 28 00 00 02 12 c0 00 00 08 00
[  789.890278] sd 2:0:0:1: [sds] FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[  789.890280] sd 2:0:0:1: [sds] Sense Key : Hardware Error [current]
[  789.890283] sd 2:0:0:1: [sds] Add. SensLogical unit failure
[  789.890284] sd 2:0:0:1: [sds] CDB:
[  789.890289] Read(10): 28 00 00 01 52 50 00 00 08 00
[  789.890295] sd 2:0:0:1: [sds] FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[  789.890298] sd 2:0:0:1: [sds] FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[  789.890299] sd 2:0:0:1: [sds] Sense Key : Hardware Error [current]
[  789.890302] sd 2:0:0:1: [sds] Sense Key : Hardware Error [current]
[  789.890303] sd 2:0:0:1: [sds] Add. Sense: Logical unit failure
[  789.890305] sd 2:0:0:1: [sds] Add. Sense: Logical unit failure
[  789.890306] sd 2:0:0:1: [sds] CDB:
[  789.890308] sd 2:0:0:1: [sds] CDB:
[  789.890309] Read(10)
[  789.890309] Read(10)
[  789.890310] :
[  789.890311] :
[  789.890312]  28
[  789.890313]  28
[  789.890314]  00
[  789.890315]  00
[  789.890316]  00
[  789.890316]  00
[  789.890317]  01
[  789.890318]  01
[  789.890318]  42
[  789.890319]  62
[  789.890320]  b8
[  789.890321]  b8
[  789.890322]  00
[  789.890322]  00
[  789.890323]  00
[  789.890324]  00
[  789.890325]  08
[  789.890326]  08
[  789.890326]  00
[  789.890327]  00
[  789.890327]
[  789.890328]
[  789.890334] sd 2:0:0:1: [sds] FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[  789.890336] sd 2:0:0:1: [sds] FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[  789.890338] sd 2:0:0:1: [sds] Sense Key : Hardware Error [current]
[  789.890339] sd 2:0:0:1: [sds] Sense Key : Hardware Error [current]
[  789.890340] sd 2:0:0:1: [sds] Add. Sense: Logical unit failure
[  789.890342] sd 2:0:0:1: [sds] Add. Sense: Logical unit failure
[  789.890343] sd 2:0:0:1: [sds] CDB:
[  789.890344] sd 2:0:0:1: [sds] CDB:
[  789.890345] Read(10)
[  789.890346] Read(10)
[  789.890346] :
[  789.890347] :
[  789.890348]  28
[  789.890349]  28
[  789.890350]  00
[  789.890350]  00
[  789.890351]  00
[  789.890352]  00
[  789.890352]  01
[  789.890353]  00
[  789.890354]  52
[  789.890355]  82
[  789.890356]  d8
[  789.890356]  d8
[  789.890357]
[  789.890358]  00
[  789.890359]  00
[  789.890361]  00
[  789.890362] sd 2:0:0:1: [sds] FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[  789.890363]  08
[  789.890364]  08
[  789.890365]  00
[  789.890366] sd 2:0:0:1: [sds] Sense Key : Hardware Error [current]
[  789.890367]  00
[  789.890367]
[  789.890368]
[  789.890369] sd 2:0:0:1: [sds] Add. Sense: Logical unit failure
[  789.890371] sd 2:0:0:1: [sds] CDB:
[  789.890374] Read(10): 28 00
[  789.890375] sd 2:0:0:1: [sds] FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[  789.890377]  00 02 21
[  789.890378] sd 2:0:0:1: [sds] Sense Key : Hardware Error [current]
[  789.890381]  98 00 00 08 00
[  789.890381] sd 2:0:0:1: [sds] Add. Sense: Logical unit failure
[  789.890381]
[  789.890383] sd 2:0:0:1: [sds] CDB:
[  789.890387] Read(10): 28 00 00 02 18 f8 00 00 08 00
[  790.190093] Read(10): 28 00 00 02 24 80 00 00 08 00


---
Rob Elliott    HP Server Storage



