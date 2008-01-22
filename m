From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH 1/3] scsi_debug: add get_data_transfer_info helper function
Date: Wed, 23 Jan 2008 00:10:46 +0100
Message-ID: <479677F6.6070301@torque.net>
References: <20080123013012N.tomof@acm.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:58389 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353AbYAVXLG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Jan 2008 18:11:06 -0500
In-Reply-To: <20080123013012N.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: James.Bottomley@HansenPartnership.com, bharrosh@panasas.com, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, Jens.Axboe@oracle.com

FUJITA Tomonori wrote:
> This adds get_data_transfer_info helper function that get lha and
> sectors for READ_* and WRITE_* commands (and XDWRITEREAD_10 later).
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  drivers/scsi/scsi_debug.c |   83 ++++++++++++++++++++------------------------
>  1 files changed, 38 insertions(+), 45 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 82c06f0..31f7378 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -311,12 +311,47 @@ static void sdebug_max_tgts_luns(void);
>  static struct device pseudo_primary;
>  static struct bus_type pseudo_lld_bus;
>  
> +static void get_data_transfer_info(unsigned char *cmd,
> +				   unsigned long long *lba, unsigned int *num)
> +{
> +	int i;
> +
> +	switch (*cmd) {
> +	case WRITE_16:
> +	case READ_16:
> +		for (*lba = 0, i = 0; i < 8; ++i) {
> +			if (i > 0)
> +				*lba <<= 8;
> +			*lba += cmd[2 + i];
> +		}
> +		*num = cmd[13] + (cmd[12] << 8) +
> +			(cmd[11] << 16) + (cmd[10] << 24);
> +		break;
> +	case WRITE_12:
> +	case READ_12:
> +		*lba = cmd[5] + (cmd[4] << 8) +	(cmd[3] << 16) + (cmd[2] << 24);
> +		*num = cmd[9] + (cmd[8] << 8) +	(cmd[7] << 16) + (cmd[6] << 24);
> +		break;
> +	case WRITE_10:
> +	case READ_10:
> +		*lba = cmd[5] + (cmd[4] << 8) +	(cmd[3] << 16) + (cmd[2] << 24);
> +		*num = cmd[8] + (cmd[7] << 8);
> +		break;
> +	case WRITE_6:
> +	case READ_6:
> +		*lba = cmd[3] + (cmd[2] << 8) + ((cmd[1] & 0x1f) << 16);
> +		*num = (0 == cmd[4]) ? 256 : cmd[4];
> +		break;
> +	default:
> +		break;
> +	}
> +}
>  
>  static
>  int scsi_debug_queuecommand(struct scsi_cmnd * SCpnt, done_funct_t done)
>  {
>  	unsigned char *cmd = (unsigned char *) SCpnt->cmnd;
> -	int len, k, j;
> +	int len, k;
>  	unsigned int num;
>  	unsigned long long lba;
>  	int errsts = 0;
> @@ -452,28 +487,7 @@ int scsi_debug_queuecommand(struct scsi_cmnd * SCpnt, done_funct_t done)
>  			break;
>  		if (scsi_debug_fake_rw)
>  			break;
> -		if ((*cmd) == READ_16) {
> -			for (lba = 0, j = 0; j < 8; ++j) {
> -				if (j > 0)
> -					lba <<= 8;
> -				lba += cmd[2 + j];
> -			}
> -			num = cmd[13] + (cmd[12] << 8) +
> -				(cmd[11] << 16) + (cmd[10] << 24);
> -		} else if ((*cmd) == READ_12) {
> -			lba = cmd[5] + (cmd[4] << 8) +
> -				(cmd[3] << 16) + (cmd[2] << 24);
> -			num = cmd[9] + (cmd[8] << 8) +
> -				(cmd[7] << 16) + (cmd[6] << 24);
> -		} else if ((*cmd) == READ_10) {
> -			lba = cmd[5] + (cmd[4] << 8) +
> -				(cmd[3] << 16) + (cmd[2] << 24);
> -			num = cmd[8] + (cmd[7] << 8);
> -		} else {	/* READ (6) */
> -			lba = cmd[3] + (cmd[2] << 8) +
> -				((cmd[1] & 0x1f) << 16);
> -			num = (0 == cmd[4]) ? 256 : cmd[4];
> -		}
> +		get_data_transfer_info(cmd, &lba, &num);
>  		errsts = resp_read(SCpnt, lba, num, devip);
>  		if (inj_recovered && (0 == errsts)) {
>  			mk_sense_buffer(devip, RECOVERED_ERROR,
> @@ -500,28 +514,7 @@ int scsi_debug_queuecommand(struct scsi_cmnd * SCpnt, done_funct_t done)
>  			break;
>  		if (scsi_debug_fake_rw)
>  			break;
> -		if ((*cmd) == WRITE_16) {
> -			for (lba = 0, j = 0; j < 8; ++j) {
> -				if (j > 0)
> -					lba <<= 8;
> -				lba += cmd[2 + j];
> -			}
> -			num = cmd[13] + (cmd[12] << 8) +
> -				(cmd[11] << 16) + (cmd[10] << 24);
> -		} else if ((*cmd) == WRITE_12) {
> -			lba = cmd[5] + (cmd[4] << 8) +
> -				(cmd[3] << 16) + (cmd[2] << 24);
> -			num = cmd[9] + (cmd[8] << 8) +
> -				(cmd[7] << 16) + (cmd[6] << 24);
> -		} else if ((*cmd) == WRITE_10) {
> -			lba = cmd[5] + (cmd[4] << 8) +
> -				(cmd[3] << 16) + (cmd[2] << 24);
> -			num = cmd[8] + (cmd[7] << 8);
> -		} else {	/* WRITE (6) */
> -			lba = cmd[3] + (cmd[2] << 8) +
> -				((cmd[1] & 0x1f) << 16);
> -			num = (0 == cmd[4]) ? 256 : cmd[4];
> -		}
> +		get_data_transfer_info(cmd, &lba, &num);
>  		errsts = resp_write(SCpnt, lba, num, devip);
>  		if (inj_recovered && (0 == errsts)) {
>  			mk_sense_buffer(devip, RECOVERED_ERROR,

Tomo,
Thanks.

Signed-off-by: Douglas Gilbert <dougg@torque.net>

