From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 06/10] sd: don't use scsi_setup_blk_pc_cmnd for discard
 requests
Date: Mon, 7 Jul 2014 00:01:53 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958B8AD4C@G9W0745.americas.hpqcorp.net>
References: <1404048881-19526-1-git-send-email-hch@lst.de>
 <1404048881-19526-7-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:28130 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbaGGACN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Jul 2014 20:02:13 -0400
In-Reply-To: <1404048881-19526-7-git-send-email-hch@lst.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Christoph Hellwig
> Sent: Sunday, 29 June, 2014 8:35 AM
> To: James Bottomley
> Cc: Martin K. Petersen; linux-scsi@vger.kernel.org
> Subject: [PATCH 06/10] sd: don't use scsi_setup_blk_pc_cmnd for discard
> requests
> 
> Simplify handling of discard requests by setting up the command directly
> instead of initializing request fields and then calling
> scsi_setup_blk_pc_cmnd to propagate the information into the command.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/sd.c |   43 ++++++++++++++++++++++++-------------------
>  1 file changed, 24 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 25f25dd..9737e78 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -691,8 +691,10 @@ static void sd_config_discard(struct scsi_disk *sdkp,
> unsigned int mode)
>   * Will issue either UNMAP or WRITE SAME(16) depending on preference
>   * indicated by target device.
>   **/
> -static int sd_setup_discard_cmnd(struct scsi_device *sdp, struct request
> *rq)
> +static int sd_setup_discard_cmnd(struct scsi_cmnd *cmd)
>  {
> +	struct request *rq = cmd->request;
> +	struct scsi_device *sdp = cmd->device;
>  	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
>  	sector_t sector = blk_rq_pos(rq);
>  	unsigned int nr_sectors = blk_rq_sectors(rq);
> @@ -704,9 +706,6 @@ static int sd_setup_discard_cmnd(struct scsi_device *sdp,
> struct request *rq)
> 
>  	sector >>= ilog2(sdp->sector_size) - 9;
>  	nr_sectors >>= ilog2(sdp->sector_size) - 9;
> -	rq->timeout = SD_TIMEOUT;
> -
> -	memset(rq->cmd, 0, rq->cmd_len);

Is *cmd guaranteed to be zero at this point?

With scsi-mq.2 I've seen UNMAP CDBs with garbage in CDB bytes 
2 to 5 (which causes a drive that checks reserved fields to
reject the command), which suggests there is a case in which 
that is not guaranteed.

[  295.280838] sd 0:0:0:0: [sda] Done: scmd ffff88042b564770 SUCCESS (0x1)
[  295.283368] sd 0:0:0:0: [sda] Result: hostbyte=DID_TARGET_FAILURE driverbyte=DRIVER_OK
[  295.286652] Unmap/Read sub-channel
[  295.287823] sd 0:0:0:0: [sda] scmd ffff88042b564770 CDB:  42 00 09 6a ed 10 00 00 18 00
[  295.290696] sd 0:0:0:0: [sda] Sense Key : Illegal Request [current]
[  295.293621] sd 0:0:0:0: [sda] Add. Sense: Invalid field in cdb
[  295.296206] sd 0:0:0:0: [sda] scmd ffff88042b564770 Discard failure result DID_OK DRIVER_SENSE
[  295.299296] sd 0:0:0:0: [sda] Sense Key : Illegal Request [current]
[  295.302104] sd 0:0:0:0: [sda] Add. Sense: Invalid field in cdb
[  295.304719] Unmap/Read sub-channel
[  295.305829] sd 0:0:0:0: [sda] scmd ffff88042b564770 CDB:  42 00 09 6a ed 10 00 00 18 00
[  295.308777] end_request: critical target error, dev sda, sector 385875968

If so, then getting rid of the double memset is another 
benefit, and removing it from scsi_setup_fs_cmnd would
be good too.  Since that function is EXPORTED, does that
prevent removing its memset?

---
Rob Elliott    HP Server Storage



