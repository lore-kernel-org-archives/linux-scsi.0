From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] qlogicpti: increase timeout
Date: Fri, 07 Oct 2011 09:16:59 -0500
Message-ID: <1317997019.21544.7.camel@dabdike.int.hansenpartnership.com>
References: <alpine.SOC.1.00.1110071050080.648@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <alpine.SOC.1.00.1110071050080.648@math.ut.ee>
Sender: sparclinux-owner@vger.kernel.org
To: Meelis Roos <mroos@linux.ee>
Cc: sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2011-10-07 at 10:53 +0300, Meelis Roos wrote:
> qlogicpti times out for some tape library operations (like mtx 
> inventory). It seems SCSI command timeout is hardcoded into the driver. 
> So let's increase it to some arbitrary higher value that Works For 
> Me(tm).
> 
> Signed-off-by: Meelis Roos <mroos@linux.ee>
> 
> diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
> index 9689d41c..4290141 100644
> --- a/drivers/scsi/qlogicpti.c
> +++ b/drivers/scsi/qlogicpti.c
> @@ -880,7 +880,7 @@ static inline void cmd_frob(struct Command_Entry *cmd, struct scsi_cmnd *Cmnd,
>  		cmd->control_flags |= CFLAG_WRITE;
>  	else
>  		cmd->control_flags |= CFLAG_READ;
> -	cmd->time_out = 30;
> +	cmd->time_out = 120;

What about just using the actual command specific timeout:

cmd->time_out = Cmnd->request->timeout/HZ;

?

James


James


