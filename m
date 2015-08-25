From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH] SCSI: DTC: Adding KERN_ facility level
Date: Tue, 25 Aug 2015 11:53:53 +1000 (AEST)
Message-ID: <alpine.LNX.2.00.1508241518160.19365@nippy.intranet>
References: <1435681756-5508-1-git-send-email-rudhreshj@cdac.in>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1435681756-5508-1-git-send-email-rudhreshj@cdac.in>
Sender: linux-kernel-owner@vger.kernel.org
To: Rudhresh Kumar J <rudhresh.jk@gmail.com>
Cc: schmitzmic@gmail.com, JBottomley@odin.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Rudhresh Kumar J <rudhreshj@cdac.in>
List-Id: linux-scsi@vger.kernel.org


On Tue, 30 Jun 2015, Rudhresh Kumar J wrote:

> Fixed coding style issue by adding KERN_ facility level to some of
> the printk functions.
> 
> Signed-off-by: Rudhresh Kumar J <rudhresh.jk@gmail.com>
> ---
>  drivers/scsi/dtc.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/dtc.c b/drivers/scsi/dtc.c
> index 4c74c7b..a3a2a71 100644
> --- a/drivers/scsi/dtc.c
> +++ b/drivers/scsi/dtc.c
> @@ -156,7 +156,7 @@ static int __init dtc_setup(char *str)
>  
>  	get_options(str, ARRAY_SIZE(ints), ints);
>  	if (ints[0] != 2)
> -		printk("dtc_setup: usage dtc=address,irq\n");
> +		printk(KERN_DEBUG "dtc_setup: usage dtc=address,irq\n");

No, that is an error message that the user needs to see.

>  	else if (commandline_current < NO_OVERRIDES) {
>  		overrides[commandline_current].address = ints[1];
>  		overrides[commandline_current].irq = ints[2];
> @@ -272,7 +272,7 @@ found:
>  		instance->irq = NO_IRQ;
>  #endif
>  #if defined(DTCDEBUG) && (DTCDEBUG & DTCDEBUG_INIT)
> -		printk("scsi%d : irq = %d\n", instance->host_no, instance->irq);
> +		printk(KERN_DEBUG "scsi%d : irq = %d\n", instance->host_no, instance->irq);
>  #endif
>  
>  		++current_override;
> 

I have a better patch for this, which makes use of the dprintk macro to 
replace {DTC,P,T}DEBUG_INIT with NDEBUG_INIT. Thanks anyway.

-- 
