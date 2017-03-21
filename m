From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: Re: [PATCH] scsi: sr: fix oob access in get_capabilities
Date: Tue, 21 Mar 2017 10:20:25 +0800
Message-ID: <ab8949b1-e6df-2237-275b-bfbf0c7466a9@huawei.com>
References: <1488536272-10509-1-git-send-email-wangkefeng.wang@huawei.com>
 <yq1r31yf5ie.fsf@oracle.com>
 <3f08ece0-531e-6853-d47d-a860e81e55d6@huawei.com>
 <yq160j7lbx1.fsf@oracle.com>
 <0d4c496b-c435-b622-58f8-25bd4490186a@huawei.com>
 <yq18to0hvib.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq18to0hvib.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>
List-Id: linux-scsi@vger.kernel.org



On 2017/3/20 22:29, Martin K. Petersen wrote:
> Kefeng Wang <wangkefeng.wang@huawei.com> writes:
> 
> Kefeng,
> 
>> The issue still exists, the patch return zero in scsi_mode_sense(), but zero means
>> SAM_STAT_GOOD in scsi_status_is_good(), so n will be still bigger than 512;
> 
> OK, I checked the other users of scsi_mode_sense(). So let's keep this
> fix local to sr.c for now.
> 
> How about the following?
> 
> 
> scsi: sr: Sanity check returned mode data
>     
> Kefeng Wang discovered that old versions of the QEMU CD driver would
> return mangled mode data causing us to walk off the end of the buffer in
> an attempt to parse it. Sanity check the returned mode sense data.
>     
> Cc: <stable@vger.kernel.org>
> Reported-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> 
> diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
> index 0b29b9329b1c..a8f630213a1a 100644
> --- a/drivers/scsi/sr.c
> +++ b/drivers/scsi/sr.c
> @@ -836,6 +836,7 @@ static void get_capabilities(struct scsi_cd *cd)
>  	unsigned char *buffer;
>  	struct scsi_mode_data data;
>  	struct scsi_sense_hdr sshdr;
> +	unsigned int ms_len = 128;
>  	int rc, n;
>  
>  	static const char *loadmech[] =
> @@ -862,10 +863,11 @@ static void get_capabilities(struct scsi_cd *cd)
>  	scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES, &sshdr);
>  
>  	/* ask for mode page 0x2a */
> -	rc = scsi_mode_sense(cd->device, 0, 0x2a, buffer, 128,
> +	rc = scsi_mode_sense(cd->device, 0, 0x2a, buffer, ms_len,
>  			     SR_TIMEOUT, 3, &data, NULL);
>  

move n = data.header_length + data.block_descriptor_length; here,

> -	if (!scsi_status_is_good(rc)) {
> +	if (!scsi_status_is_good(rc) || data.length > ms_len ||
> +	    data.header_length + data.block_descriptor_length > data.length) {

n > data.length

Tested-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Thanks,
Kefeng

>  		/* failed, drive doesn't have capabilities mode page */
>  		cd->cdi.speed = 1;
>  		cd->cdi.mask |= (CDC_CD_R | CDC_CD_RW | CDC_DVD_R |
> 
> 
> 
> .
> 
