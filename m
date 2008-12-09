From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] Correctly release and allocate a new request upon
 retries
Date: Wed, 10 Dec 2008 08:38:43 +0900
Message-ID: <20081210083909C.fujita.tomonori@lab.ntt.co.jp>
References: <493D2E05.3070108@hp.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:32932 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752357AbYLIXjB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Dec 2008 18:39:01 -0500
In-Reply-To: <493D2E05.3070108@hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan.Brunelle@hp.com
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, andmike@linux.vnet.ibm.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On Mon, 08 Dec 2008 09:24:05 -0500
"Alan D. Brunelle" <Alan.Brunelle@hp.com> wrote:

> Commands needing to be retried require a complete re-initialization.
> 
> The test-unit-ready portion of this patch was causing boots to fail on
> my test machine (as in http://lkml.org/lkml/2008/12/5/161). With this
> patch in place, the system is booting reliably.
> 
> Mike Anderson found the same problem in the hp_hw_start_stop code,
> and I applied the same solution in cdrom_read_cdda_bpc.
> 
> Signed-off-by: Alan D. Brunelle <alan.brunelle@hp.com>
> Cc: Jens Axboe <jens.axboe@oracle.com>
> Cc: Mike Anderson <andmike@linux.vnet.ibm.com>
> ---
>  drivers/cdrom/cdrom.c                       |   16 ++++++++++------
>  drivers/scsi/device_handler/scsi_dh_hp_sw.c |   12 ++++++++----
>  2 files changed, 18 insertions(+), 10 deletions(-)

> diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
> index 9aec4ca..f7da753 100644
> --- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
> +++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
> @@ -107,6 +107,7 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
>  	struct request *req;
>  	int ret;
>  
> +retry:
>  	req = blk_get_request(sdev->request_queue, WRITE, GFP_NOIO);
>  	if (!req)
>  		return SCSI_DH_RES_TEMP_UNAVAIL;
> @@ -121,7 +122,6 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
>  	memset(req->sense, 0, SCSI_SENSE_BUFFERSIZE);
>  	req->sense_len = 0;
>  
> -retry:
>  	ret = blk_execute_rq(req->q, NULL, req, 1);
>  	if (ret == -EIO) {
>  		if (req->sense_len > 0) {
> @@ -136,8 +136,10 @@ retry:
>  		h->path_state = HP_SW_PATH_ACTIVE;
>  		ret = SCSI_DH_OK;
>  	}
> -	if (ret == SCSI_DH_IMM_RETRY)
> +	if (ret == SCSI_DH_IMM_RETRY) {
> +		blk_put_request(req);
>  		goto retry;
> +	}
>  	if (ret == SCSI_DH_DEV_OFFLINED) {
>  		h->path_state = HP_SW_PATH_PASSIVE;
>  		ret = SCSI_DH_OK;
> @@ -200,6 +202,7 @@ static int hp_sw_start_stop(struct scsi_device *sdev, struct hp_sw_dh_data *h)
>  	struct request *req;
>  	int ret, retry;
>  
> +retry:
>  	req = blk_get_request(sdev->request_queue, WRITE, GFP_NOIO);
>  	if (!req)
>  		return SCSI_DH_RES_TEMP_UNAVAIL;
> @@ -216,7 +219,6 @@ static int hp_sw_start_stop(struct scsi_device *sdev, struct hp_sw_dh_data *h)
>  	req->sense_len = 0;
>  	retry = h->retries;
>  
> -retry:
>  	ret = blk_execute_rq(req->q, NULL, req, 1);
>  	if (ret == -EIO) {
>  		if (req->sense_len > 0) {
> @@ -231,8 +233,10 @@ retry:
>  		ret = SCSI_DH_OK;
>  
>  	if (ret == SCSI_DH_RETRY) {
> -		if (--retry)
> +		if (--retry) {
> +			blk_put_request(req);
>  			goto retry;
> +		}
>  		ret = SCSI_DH_IO;
>  	}

Looks like the majority of the usage of
blk_get_request/blk_execute_rq/blk_put_request can be simply replaced
with scsi_execute()? The problem is that scsi_execute doesn't return
all the information about errors?


