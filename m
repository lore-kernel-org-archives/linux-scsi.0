From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] hptiop: HighPoint RocketRAID 3xxx controller driver
Date: Sun, 11 Jun 2006 09:14:26 -0400
Message-ID: <448C1732.3060809@garzik.org>
References: <200606111706.52930.linux@highpoint-tech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751273AbWFKNOf@vger.kernel.org>
In-Reply-To: <200606111706.52930.linux@highpoint-tech.com>
Sender: linux-kernel-owner@vger.kernel.org
To: HighPoint Linux Team <linux@highpoint-tech.com>
Cc: James.Bottomley@SteelEye.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, akpm@osdl.org
List-Id: linux-scsi@vger.kernel.org

HighPoint Linux Team wrote:
> --- a/drivers/scsi/hptiop.c
> +++ b/drivers/scsi/hptiop.c
> @@ -504,18 +504,10 @@ static int hptiop_queuecommand(struct sc
>  	BUG_ON(!done);
>  	scp->scsi_done = done;
>  
> -	/*
> -	 * hptiop_shutdown will flash controller cache.
> -	 */
> -	if (scp->cmnd[0] == SYNCHRONIZE_CACHE)  {
> -		scp->result = DID_OK<<16;
> -		goto cmd_done;
> -	}
> -
>  	_req = get_req(hba);
>  	if (_req == NULL) {
>  		dprintk("hptiop_queuecmd : no free req\n");
> -		scp->result = DID_BUS_BUSY << 16;
> +		scp->result = SCSI_MLQUEUE_HOST_BUSY;
>  		goto cmd_done;
>  	}

Close.  For the last bit of code quoted above, you should return 
SCSI_MLQUEUE_HOST_BUSY as your ->queuecommand() return code, rather than 
setting scp->result and calling the done() hook.

	Jeff
