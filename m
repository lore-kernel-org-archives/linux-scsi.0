From: Nathan Chancellor <natechancellor@gmail.com>
Subject: Re: [PATCH] pcmcia: Remove unnecessary parentheses
Date: Sat, 26 Jan 2019 12:12:03 -0700
Message-ID: <20190126191203.GC25003@archlinux-ryzen>
References: <20181210235540.7039-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181210235540.7039-1-natechancellor@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Dec 10, 2018 at 04:55:40PM -0700, Nathan Chancellor wrote:
> Clang warns:
> 
> drivers/scsi/pcmcia/nsp_cs.c:1137:27: warning: equality comparison with
> extraneous parentheses [-Wparentheses-equality]
>                 if ((tmpSC->SCp.Message == MSG_COMMAND_COMPLETE)) {
>                      ~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~
> drivers/scsi/pcmcia/nsp_cs.c:1137:27: note: remove extraneous
> parentheses around the comparison to silence this warning
>                 if ((tmpSC->SCp.Message == MSG_COMMAND_COMPLETE)) {
>                     ~                   ^                      ~
> drivers/scsi/pcmcia/nsp_cs.c:1137:27: note: use '=' to turn this
> equality comparison into an assignment
>                 if ((tmpSC->SCp.Message == MSG_COMMAND_COMPLETE)) {
>                                         ^~
>                                         =
> 1 warning generated.
> 
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
>  drivers/scsi/pcmcia/nsp_cs.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
> index f3230494a8c9..f28105b144fc 100644
> --- a/drivers/scsi/pcmcia/nsp_cs.c
> +++ b/drivers/scsi/pcmcia/nsp_cs.c
> @@ -1134,7 +1134,8 @@ static irqreturn_t nspintr(int irq, void *dev_id)
>  
>  		//*sync_neg       = SYNC_NOT_YET;
>  
> -		if ((tmpSC->SCp.Message == MSG_COMMAND_COMPLETE)) {     /* all command complete and return status */
> +		/* all command complete and return status */
> +		if (tmpSC->SCp.Message == MSG_COMMAND_COMPLETE) {
>  			tmpSC->result = (DID_OK		             << 16) |
>  					((tmpSC->SCp.Message & 0xff) <<  8) |
>  					((tmpSC->SCp.Status  & 0xff) <<  0);
> -- 
> 2.20.0
> 

Ping?
