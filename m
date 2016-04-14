From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [patch v2] scsi_dh_alua: uninitialized variable in alua_rtpg()
Date: Thu, 14 Apr 2016 11:55:40 -0700
Message-ID: <570FE7AC.9000309@sandisk.com>
References: <20160414182034.GA32469@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20160414182034.GA32469@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 04/14/2016 11:20 AM, Dan Carpenter wrote:
> It's possible to use "err" without initializing it.  If it happens to be
> a 2 which is SCSI_DH_RETRY then that could cause a bug.  Bart Van Assche
> pointed out that we should probably re-initialize it for every iteration
> through the retry loop.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> v2: The first version just initialized it at the start of the function.
>
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
> index 8eaed05..a655cf2 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -532,6 +532,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
>   		return SCSI_DH_DEV_TEMP_BUSY;
>
>    retry:
> +	err = 0;
>   	retval = submit_rtpg(sdev, buff, bufflen, &sense_hdr, pg->flags);
>
>   	if (retval) {

Although I would have preferred that that initialization would have been 
closer to the other 'err' assignments this patch looks fine to me. If 
this patch does not get integrated in kernel v4.6 a "Cc: stable" tag 
will be needed.

Bart.
