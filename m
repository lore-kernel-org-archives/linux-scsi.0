From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: linux kernel panic when ejecting ieee1394 ipod
Date: Fri, 09 Dec 2005 19:39:55 +0100
Message-ID: <4399CF7B.7060708@s5r6.in-berlin.de>
References: <200512072358.15398.adq_dvb@lidskialf.net> <200512080119.48740.adq@lidskialf.net> <200512080159.10913.adq_dvb@lidskialf.net> <200512080209.17757.adq_dvb@lidskialf.net> <43979E1A.30801@s5r6.in-berlin.de> <20051208173429.GA2666@us.ibm.com> <20051209133743.GN26185@suse.de> <20051209134216.GO26185@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:64963 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S932510AbVLISnO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Dec 2005 13:43:14 -0500
In-Reply-To: <20051209134216.GO26185@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Andrew de Quincey <adq_dvb@lidskialf.net>, linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

Jens Axboe wrote:
> This looks like the real bug.
> 
> ---
> 
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 4afef5c..0978887 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1215,12 +1215,12 @@ static int scsi_prep_fn(struct request_q
>  		} else {
>  			memcpy(cmd->cmnd, req->cmd, sizeof(cmd->cmnd));
>  			cmd->cmd_len = req->cmd_len;
> -			if (rq_data_dir(req) == WRITE)
> +			if (!req->data_len)
> +				cmd->sc_data_direction = DMA_NONE;
> +			else if (rq_data_dir(req) == WRITE)
>  				cmd->sc_data_direction = DMA_TO_DEVICE;
> -			else if (req->data_len)
> -				cmd->sc_data_direction = DMA_FROM_DEVICE;
>  			else
> -				cmd->sc_data_direction = DMA_NONE;
> +				cmd->sc_data_direction = DMA_FROM_DEVICE;
>  			
>  			cmd->transfersize = req->data_len;
>  			cmd->allowed = 3;
> 
> 

And then there are also sd_init_command(), sr_init_command(), 
st_init_command() in s[drt].c. sr_init_command() looks OK to me, the 
other two feature the same flaw like scsi_prep_fn().

Or is there any reason why they should set DMA_TO_DEVICE while 
rq->data_len == 0?

Furthermore, is there any other code path which may set 
cmd->sc_data_direction, aside from s[drt]_init_command() and 
scsi_prep_fn()? I was just browsing the code to find out myself but am 
not 100% sure.
-- 
Stefan Richter
-=====-=-=-= ==-- -=--=
http://arcgraph.de/sr/
