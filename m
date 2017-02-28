From: Steve Magnani <steve.magnani@digidescorp.com>
Subject: Re: [PATCH] sd: close hole in > 2T device rejection when
 !CONFIG_LBDAF
Date: Tue, 28 Feb 2017 07:53:26 -0600
Message-ID: <5813345e-3f43-f044-6b41-2fd3d7a58e4b@digidescorp.com>
References: <1488208949-3811-1-git-send-email-steve@digidescorp.com>
 <1488211985.2656.1.camel@sandisk.com>
 <3a6783ec-200d-5df5-2e1e-756c7e8b7c22@digidescorp.com>
 <1488221849.2656.8.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1488221849.2656.8.camel@sandisk.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "steve@digidescorp.com" <steve@digidescorp.com>
List-Id: linux-scsi@vger.kernel.org


On 02/27/2017 12:57 PM, Bart Van Assche wrote:
> ...
> How about the (untested) patch below? The approach below avoids that the check is
> duplicated and - at least in my opinion - results in code that is easier to read.
I find lba_too_large() a little dense, but functionally OK. The "shift 
 >= 0" clause could be dropped.
I tested this on my "problem" system (READ CAPACITY(10)) without incident.
>
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index cb6e68dd6df0..3533d1e46bde 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2082,6 +2082,16 @@ static void read_capacity_error(struct scsi_disk *sdkp, struct scsi_device *sdp,
>   	sdkp->capacity = 0; /* unknown mapped to zero - as usual */
>   }
>   
> +/*
> + * Check whether or not logical_to_sectors(sdp, lba) will overflow.
> + */
> +static bool lba_too_large(u64 lba, u32 logical_block_size)
> +{
> +	int shift = sizeof(sector_t) * 8 + 9 - ilog2(logical_block_size);
> +
> +	return shift >= 0 && shift < 64 && lba >= (1ULL << shift);
> +}
> +
>   #define RC16_LEN 32
>   #if RC16_LEN > SD_BUF_SIZE
>   #error RC16_LEN must not be more than SD_BUF_SIZE
> @@ -2154,7 +2164,7 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
>   		return -ENODEV;
>   	}
>   
> -	if ((sizeof(sdkp->capacity) == 4) && (lba >= 0xffffffffULL)) {
> +	if (lba_too_large(lba + 1, sector_size)) {
>   		sd_printk(KERN_ERR, sdkp, "Too big for this kernel. Use a "
>   			"kernel compiled with support for large block "
>   			"devices.\n");
> @@ -2243,7 +2253,7 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
>   		return sector_size;
>   	}
>   
> -	if ((sizeof(sdkp->capacity) == 4) && (lba == 0xffffffff)) {
> +	if (lba_too_large(lba + 1ULL, sector_size)) {
>   		sd_printk(KERN_ERR, sdkp, "Too big for this kernel. Use a "
>   			"kernel compiled with support for large block "
>   			"devices.\n");
