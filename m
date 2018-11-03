From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: myrb: fix sprintf buffer overflow warning
Date: Sat, 3 Nov 2018 09:46:49 +0100
Message-ID: <6a012c05-67a5-e899-f636-db01b79dfbf2@suse.de>
References: <20181102153458.1567593-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181102153458.1567593-1-arnd@arndb.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, Hannes Reinecke <hare@kernel.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11/2/18 4:34 PM, Arnd Bergmann wrote:
> gcc warns that the 12 byte fw_version field might not be long enough to
> contain the generated firmware name string:
> 
> drivers/scsi/myrb.c: In function 'myrb_get_hba_config':
> drivers/scsi/myrb.c:1052:38: error: '%02d' directive writing between 2 and 3 bytes into a region of size between 2 and 5 [-Werror=format-overflow=]
>    sprintf(cb->fw_version, "%d.%02d-%c-%02d",
>                                        ^~~~
> drivers/scsi/myrb.c:1052:26: note: directive argument in the range [0, 255]
>    sprintf(cb->fw_version, "%d.%02d-%c-%02d",
>                            ^~~~~~~~~~~~~~~~~
> drivers/scsi/myrb.c:1052:2: note: 'sprintf' output between 10 and 14 bytes into a destination of size 12
>    sprintf(cb->fw_version, "%d.%02d-%c-%02d",
>    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>     enquiry2->fw.major_version,
>     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
>     enquiry2->fw.minor_version,
>     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
>     enquiry2->fw.firmware_type,
>     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
>     enquiry2->fw.turn_id);
>     ~~~~~~~~~~~~~~~~~~~~~
> 
> I have not checked whether there are appropriate range checks before the
> sprintf, but there is a range check after it that will bail out in case
> of out of range version numbers. This means we can simply use snprintf()
> instead of sprintf() to limit the output buffer size, and it will work
> correctly.
> 
> Fixes: 081ff398c56c ("scsi: myrb: Add Mylex RAID controller (block interface)")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>   drivers/scsi/myrb.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
> index aeb282f617c5..0642f2d0a3bb 100644
> --- a/drivers/scsi/myrb.c
> +++ b/drivers/scsi/myrb.c
> @@ -1049,7 +1049,8 @@ static int myrb_get_hba_config(struct myrb_hba *cb)
>   		enquiry2->fw.firmware_type = '0';
>   		enquiry2->fw.turn_id = 0;
>   	}
> -	sprintf(cb->fw_version, "%d.%02d-%c-%02d",
> +	snprintf(cb->fw_version, sizeof(cb->fw_version),
> +		"%d.%02d-%c-%02d",
>   		enquiry2->fw.major_version,
>   		enquiry2->fw.minor_version,
>   		enquiry2->fw.firmware_type,
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
