From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 27/27] scsi: ratelimit I/O error messages
Date: Tue, 21 Oct 2014 16:10:26 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295931CCBB@G4W3296.americas.hpqcorp.net>
References: <1413787950-14659-1-git-send-email-hare@suse.de>
 <1413787950-14659-28-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:58658 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755925AbaJUQL0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Oct 2014 12:11:26 -0400
In-Reply-To: <1413787950-14659-28-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Monday, 20 October, 2014 1:53 AM
> To: James Bottomley
> Cc: Christoph Hellwig; linux-scsi@vger.kernel.org; Elliott, Robert (Server
> Storage); Hannes Reinecke
> Subject: [PATCH 27/27] scsi: ratelimit I/O error messages
> 
> There can be quite a lot of I/O error messages, even on smaller
> machines. So we need to ratelimit them to not overwhelm logging.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/scsi_lib.c | 30 ++++++++++++++++++------------
>  1 file changed, 18 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 2df485f..9d248d2 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -22,6 +22,7 @@
>  #include <linux/hardirq.h>
>  #include <linux/scatterlist.h>
>  #include <linux/blk-mq.h>
> +#include <linux/ratelimit.h>
> 
>  #include <scsi/scsi.h>
>  #include <scsi/scsi_cmnd.h>
> @@ -1037,18 +1038,23 @@ void scsi_io_completion(struct scsi_cmnd *cmd,
> unsigned int good_bytes)
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
> +		if (unlikely(scsi_logging_level)) {

I don't think wrapping all that inside:
	if (unlikely(scsi_logging_level))
is correct.  That means unrelated logging levels (e.g., LLQUEUE)
have an impact on whether this print happens.

> +			static DEFINE_RATELIMIT_STATE(_rs,
> +					DEFAULT_RATELIMIT_INTERVAL,
> +					DEFAULT_RATELIMIT_BURST);
> +			level = SCSI_LOG_LEVEL(SCSI_LOG_MLCOMPLETE_SHIFT,
> +					       SCSI_LOG_MLCOMPLETE_BITS);
> +			/*
> +			 * if logging is enabled the failure will be printed
> +			 * in scsi_log_completion(), so avoid duplicate messages
> +			 */
> +			if (__ratelimit(&_rs) && !level &&
> +			    !(req->cmd_flags & REQ_QUIET)) {

__ratelimit should only be invoked if the other two are 
leading towards printing, since it is fairly involved
(including a spinlock):
		if (!level && !(req->cmd_flags & REQ_QUIET) && 
			(__ratelimit(&_rs)) {

> +				scsi_print_result(cmd, NULL, FAILED);
> +				if (driver_byte(result) & DRIVER_SENSE)
> +					scsi_print_sense(cmd);
> +				scsi_print_command(cmd);
> +			}
>  		}
>  		if (!scsi_end_request(req, error, blk_rq_err_bytes(req), 0))
>  			return;

Here are some results from removing devices during sequential reads.

With the scsi logging level clear, just 10 block layer prints show up
(that outer "if" blocks everything):
[48973.034156] blk_update_request: critical target error, dev sdr, sector 7447280
[48973.035298] blk_update_request: critical target error, dev sdr, sector 7591344
[48973.035302] blk_update_request: critical target error, dev sdr, sector 7591352
[48973.035351] blk_update_request: critical target error, dev sdr, sector 7591360
[48973.035355] blk_update_request: critical target error, dev sdr, sector 7591368
[48973.035391] blk_update_request: critical target error, dev sdr, sector 7591376
[48973.035394] blk_update_request: critical target error, dev sdr, sector 7591384
[48973.035436] blk_update_request: critical target error, dev sdr, sector 7591392
[48973.035439] blk_update_request: critical target error, dev sdr, sector 7591400
[48973.035471] blk_update_request: critical target error, dev sdr, sector 7591408

With scsi_logging_level --set --error=5, there are: 
* 10 "FAILED Result" prints
  * the first has no CDB
  * at the end, there is a much later CDB print not preceded by a FAILED print
* 10 "blk_update_request: critical target error" prints
  * their sector number matches the preceding CDB print
* 1 "blk_update_request: 539 callbacks suppressed" print
* fio printed 33 io_u errors
  * the first at offset 27118616, matching the first print
  * one of the later ones is at offset 28297168, matching the last print
* no "callbacks suppressed" messages from scsi_io_completion


[49190.331376] sd 2:0:0:1: [sds] FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[49190.334394] sd 2:0:0:1: [sds] Sense Key : Hardware Error [current]
[49190.336516] sd 2:0:0:1: [sds] Add. Sense: Logical unit failure
[49190.337228] sd 2:0:0:1: [sds] FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[49190.337231] sd 2:0:0:1: [sds] Sense Key : Hardware Error [current]
[49190.337234] sd 2:0:0:1: [sds] Add. Sense: Logical unit failure
[49190.337236] sd 2:0:0:1: [sds] CDB:
[49190.337241] Read(10): 28 00 01 9d cc 18 00 00 08 00
[49190.337243] blk_update_request: 539 callbacks suppressed
[49190.337245] blk_update_request: critical target error, dev sds, sector 27118616	 <0x019dcc18>
[49190.337252] sd 2:0:0:1: [sds] FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[49190.337254] sd 2:0:0:1: [sds] Sense Key : Hardware Error [current]
[49190.337256] sd 2:0:0:1: [sds] Add. Sense: Logical unit failure
[49190.337258] sd 2:0:0:1: [sds] CDB:
[49190.337262] Read(10): 28 00 01 9d cc 20 00 00 08 00
[49190.337264] blk_update_request: critical target error, dev sds, sector 27118624
[49190.337268] sd 2:0:0:1: [sds] FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[49190.337270] sd 2:0:0:1: [sds] Sense Key : Hardware Error [current]
[49190.337272] sd 2:0:0:1: [sds] Add. Sense: Logical unit failure
[49190.337274] sd 2:0:0:1: [sds] CDB:
[49190.337278] Read(10): 28 00 01 9d cc 28 00 00 08 00
[49190.337279] blk_update_request: critical target error, dev sds, sector 27118632
[49190.337284] sd 2:0:0:1: [sds] FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[49190.337286] sd 2:0:0:1: [sds] Sense Key : Hardware Error [current]
[49190.337288] sd 2:0:0:1: [sds] Add. Sense: Logical unit failure
[49190.337289] sd 2:0:0:1: [sds] CDB:
[49190.337294] Read(10): 28 00 01 9d cc 30 00 00 08 00
[49190.337295] blk_update_request: critical target error, dev sds, sector 27118640
[49190.337300] sd 2:0:0:1: [sds] FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[49190.337302] sd 2:0:0:1: [sds] Sense KeyHardware Error [current]
[49190.337304] sd 2:0:0:1: [sds] Add. Sense: Logical unit failure
[49190.337305] sd 2:0:0:1: [sds] CDB:
[49190.337310] Read(10): 28 00 01 9d cc 38 00 00 08 00
[49190.337311] blk_update_request: critical target error, dev sds, sector 27118648
[49190.337315] sd 2:0:0:1: [sds] FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[49190.337317] sd 2:0:0:1: [sds] Sense Key : Hardware Error [current]
[49190.337319] sd 2:0:0:1: [sds] Add. Sense: Logical unit failure
[49190.337321] sd 2:0:0:1: [sds] CDB:
[49190.337324] Read(10): 28 00 01 9d cc 40 00 00 08 00
[49190.337326] blk_update_request: critical target error, dev sds, sector 27118656
[49190.337331] sd 2:0:0:1: [sds] FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[49190.337333] sd 2:0:0:1: [sds] Sense Key : Hardware Error [current]
[49190.337335] sd 2:0:0:1: [sds] Add. Sense: Logical unit failure
[49190.337336] sd 2:0:0:1: [sds] CDB:
[49190.337340] Read(10): 28 00 01 9d cc 48 00 00 08 00
[49190.337342] blk_update_request: critical target error, dev sds, sector 27118664
[49190.337386] sd 2:0:0:1: [sds] FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[49190.337388] sd 2:0:0:1: [sds] Sense Key : Hardware Error [current]
[49190.337390] sd 2:0:0:1: [sds] Add. Sense: Logical unit failure
[49190.337392] sd 2:0:0:1: [sds] CDB:
[49190.337396] Read(10): 28 00 01 9d cc 50 00 00 08 00
[49190.337397] blk_update_request: critical target error, dev sds, sector 27118672
[49190.337402] sd 2:0:0:1: [sds] FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[49190.337404] sd 2:0:0:1: [sds] Sense Key : Hardware Error [current]
[49190.337406] sd 2:0:0:1: [sds] Add. Sense: Logical unit failure
[49190.337408] sd 2:0:0:1: [sds] CDB:
[49190.337412] Read(10): 28 00 01 9d cc 58 00 00 08 00
[49190.337413] blk_update_request: critical target error, dev sds, sector 27118680 <0x19dcc58>
[49190.337417] blk_update_request: critical target error, dev sds, sector 27118688 <0x19dcc60>
[49190.554043] sd 2:0:0:1: [sds] CDB:
[49190.555178] Read(10): 28 00 01 af c7 d0 00 00 08 00 <28297168>


Tag printing is not included in this patch series, so you cannot 
tell which lines go together.  The first three lines:
[49190.331376] sd 2:0:0:1: [sds] FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[49190.334394] sd 2:0:0:1: [sds] Sense Key : Hardware Error [current]
[49190.336516] sd 2:0:0:1: [sds] Add. Sense: Logical unit failure

probably go with the last two lines:
[49190.554043] sd 2:0:0:1: [sds] CDB:
[49190.555178] Read(10): 28 00 01 af c7 d0 00 00 08 00 <28297168>

with the other 9 prints in between coming from another CPU.


