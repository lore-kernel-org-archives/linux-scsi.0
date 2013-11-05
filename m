From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH 1/2] libata: use sleep instead of standby command
Date: Tue, 05 Nov 2013 10:23:50 +0800
Message-ID: <527856B6.8030901@intel.com>
References: <1383612780-6591-1-git-send-email-psusi@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1383612780-6591-1-git-send-email-psusi@ubuntu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Robert Hancock <hancockr@shaw.ca>
List-Id: linux-scsi@vger.kernel.org

+linux-ide

On 11/05/2013 08:52 AM, Phillip Susi wrote:
> The ATA SLEEP mode saves some more power than SUSPEND, and
> has basically the same recovery time, so use it instead.

I suppose this is mainly for runtime PM? Since for system
suspend/hibernation, the disk and its controller will be powered off
anyway.

Best regards,
Aaron

> 
> Signed-off-by: Phillip Susi <psusi@ubuntu.com>
> ---
>  drivers/ata/libata-scsi.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 97a0cef..79b75fd 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -1362,8 +1362,8 @@ static unsigned int ata_scsi_start_stop_xlat(struct ata_queued_cmd *qc)
>  		     system_entering_hibernation())
>  			goto skip;
>  
> -		/* Issue ATA STANDBY IMMEDIATE command */
> -		tf->command = ATA_CMD_STANDBYNOW1;
> +		/* Issue ATA SLEEP command */
> +		tf->command = ATA_CMD_SLEEP;
>  	}
>  
>  	/*
> 
