From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: [PATCH 16/41] scsi: imm: mark expected switch fall-throughs
Date: Wed, 19 Dec 2018 16:26:09 -0600
Message-ID: <9f283763-f5e5-3da2-84e4-7e2a3543cb23@embeddedor.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
 <42e3f9f751b662b7f0e4e763aa880bd752511c60.1543374820.git.gustavo@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <42e3f9f751b662b7f0e4e763aa880bd752511c60.1543374820.git.gustavo@embeddedor.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

Friendly ping:

Who can ack or review this patch, please?

Thanks
-- 
Gustavo

On 11/27/18 10:29 PM, Gustavo A. R. Silva wrote:
> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
> where we are expecting to fall through.
> 
> Notice that, in this particular case, I placed all the "Phase N - ..."
> comments on the same line as its corresponding switch case. The same
> way in which similar comments appear in drivers/scsi/ppa.c. This makes
> it possible to place the "fall through" annotations at the bottom of
> each switch case, which is what GCC is expecting to find.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>   drivers/scsi/imm.c | 33 +++++++++++++++++----------------
>   1 file changed, 17 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/scsi/imm.c b/drivers/scsi/imm.c
> index 8c6627bc8a39..629e0bc70d3e 100644
> --- a/drivers/scsi/imm.c
> +++ b/drivers/scsi/imm.c
> @@ -796,21 +796,21 @@ static int imm_engine(imm_struct *dev, struct scsi_cmnd *cmd)
>   			return 0;
>   		}
>   		return 1;	/* wait until imm_wakeup claims parport */
> -		/* Phase 1 - Connected */
> -	case 1:
> +
> +	case 1:		/* Phase 1 - Connected */
>   		imm_connect(dev, CONNECT_EPP_MAYBE);
>   		cmd->SCp.phase++;
> +		/* fall through */
>   
> -		/* Phase 2 - We are now talking to the scsi bus */
> -	case 2:
> +	case 2:		/* Phase 2 - We are now talking to the scsi bus */
>   		if (!imm_select(dev, scmd_id(cmd))) {
>   			imm_fail(dev, DID_NO_CONNECT);
>   			return 0;
>   		}
>   		cmd->SCp.phase++;
> +		/* fall through */
>   
> -		/* Phase 3 - Ready to accept a command */
> -	case 3:
> +	case 3:		/* Phase 3 - Ready to accept a command */
>   		w_ctr(ppb, 0x0c);
>   		if (!(r_str(ppb) & 0x80))
>   			return 1;
> @@ -818,9 +818,9 @@ static int imm_engine(imm_struct *dev, struct scsi_cmnd *cmd)
>   		if (!imm_send_command(cmd))
>   			return 0;
>   		cmd->SCp.phase++;
> +		/* fall through */
>   
> -		/* Phase 4 - Setup scatter/gather buffers */
> -	case 4:
> +	case 4:		/* Phase 4 - Setup scatter/gather buffers */
>   		if (scsi_bufflen(cmd)) {
>   			cmd->SCp.buffer = scsi_sglist(cmd);
>   			cmd->SCp.this_residual = cmd->SCp.buffer->length;
> @@ -834,8 +834,9 @@ static int imm_engine(imm_struct *dev, struct scsi_cmnd *cmd)
>   		cmd->SCp.phase++;
>   		if (cmd->SCp.this_residual & 0x01)
>   			cmd->SCp.this_residual++;
> -		/* Phase 5 - Pre-Data transfer stage */
> -	case 5:
> +		/* fall through */
> +
> +	case 5:		/* Phase 5 - Pre-Data transfer stage */
>   		/* Spin lock for BUSY */
>   		w_ctr(ppb, 0x0c);
>   		if (!(r_str(ppb) & 0x80))
> @@ -850,9 +851,9 @@ static int imm_engine(imm_struct *dev, struct scsi_cmnd *cmd)
>   			if (imm_negotiate(dev))
>   				return 0;
>   		cmd->SCp.phase++;
> +		/* fall through */
>   
> -		/* Phase 6 - Data transfer stage */
> -	case 6:
> +	case 6:		/* Phase 6 - Data transfer stage */
>   		/* Spin lock for BUSY */
>   		w_ctr(ppb, 0x0c);
>   		if (!(r_str(ppb) & 0x80))
> @@ -866,9 +867,9 @@ static int imm_engine(imm_struct *dev, struct scsi_cmnd *cmd)
>   				return 1;
>   		}
>   		cmd->SCp.phase++;
> +		/* fall through */
>   
> -		/* Phase 7 - Post data transfer stage */
> -	case 7:
> +	case 7:		/* Phase 7 - Post data transfer stage */
>   		if ((dev->dp) && (dev->rd)) {
>   			if ((dev->mode == IMM_NIBBLE) || (dev->mode == IMM_PS2)) {
>   				w_ctr(ppb, 0x4);
> @@ -878,9 +879,9 @@ static int imm_engine(imm_struct *dev, struct scsi_cmnd *cmd)
>   			}
>   		}
>   		cmd->SCp.phase++;
> +		/* fall through */
>   
> -		/* Phase 8 - Read status/message */
> -	case 8:
> +	case 8:		/* Phase 8 - Read status/message */
>   		/* Check for data overrun */
>   		if (imm_wait(dev) != (unsigned char) 0xb8) {
>   			imm_fail(dev, DID_ERROR);
> 
