From: Willem Riede <wrlk@riede.org>
Subject: Re: 2 PATCHES: fix request_tranferlength
Date: Sun, 21 Jul 2002 18:52:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020721225233.GG7700@linnie.riede.org>
References: <20020721151523.D1909@one-eyed-alien.net>
Reply-To: wrlk@riede.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from linnie.riede.org (linnie.riede.org [192.168.2.2])
	by serve.riede.org (8.11.6/8.9.3) with ESMTP id g6LMqXu02686
	for <linux-scsi@vger.kernel.org>; Sun, 21 Jul 2002 18:52:33 -0400
Content-Disposition: inline
In-Reply-To: <20020721151523.D1909@one-eyed-alien.net>; from mdharm-usb@one-eyed-alien.net on Sun, Jul 21, 2002 at 18:15:23 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On 2002.07.21 18:15 Matthew Dharm wrote:
> These two BK patches fix two instances where a command is issued with an
> incorrect transfer length.  The first is in the probing code... the section
> where we make the second INQUIRY request for the full INQUIRY data.  The
> second is in sd.c where the MODE_SENSE request is issued.
> 
[snip]
> diff -Nru a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> --- a/drivers/scsi/sd.c	Sun Jul 21 00:55:44 2002
> +++ b/drivers/scsi/sd.c	Sun Jul 21 00:55:44 2002
> @@ -1102,7 +1102,7 @@
>  	SRpnt->sr_data_direction = SCSI_DATA_READ;
>  
>  	scsi_wait_req(SRpnt, (void *) cmd, (void *) buffer,
> -		      512, SD_TIMEOUT, MAX_RETRIES);
> +		      255, SD_TIMEOUT, MAX_RETRIES);
>  
>  	the_result = SRpnt->sr_result;
>  
Matt, 

is asking for an odd number of bytes a good idea? There have been problems
with doing so on OnStream tape drives...

Thanks, Willem Riede.
