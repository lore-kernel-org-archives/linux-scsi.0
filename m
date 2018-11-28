From: Michael Schmitz <schmitzmic@gmail.com>
Subject: Re: [PATCH 02/41] scsi: NCR5380: Mark expected switch fall-through
Date: Wed, 28 Nov 2018 21:22:04 +1300
Message-ID: <0caad885-94ad-9226-fbf1-996b5d465473@gmail.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
 <8b4ef418aa7803199954100fd89717f38d61ae06.1543374820.git.gustavo@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8b4ef418aa7803199954100fd89717f38d61ae06.1543374820.git.gustavo@embeddedor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Gustavo,


Am 28.11.18 um 17:24 schrieb Gustavo A. R. Silva:
> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
> where we are expecting to fall through.
>
> Notice that in this particular case, I replaced "Fall through to reject message"
> with a "fall through" annotation at the bottom of the case, which is what GCC
> is expecting to find.
>
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>  drivers/scsi/NCR5380.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
> index 01c23d27f290..12073e52a0eb 100644
> --- a/drivers/scsi/NCR5380.c
> +++ b/drivers/scsi/NCR5380.c
> @@ -1933,12 +1933,11 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
>  					if (!hostdata->connected)
>  						return;
>  
> -					/* Fall through to reject message */
> -
>  					/*
>  					 * If we get something weird that we aren't expecting,
>  					 * reject it.
>  					 */
> +					/* fall through */
>  				default:
>  					if (tmp == EXTENDED_MESSAGE)
>  						scmd_printk(KERN_INFO, cmd,
I believe the 'if we get something weird' comment block relates to the
default branch of the switch, _not_ the fall through from the case above
(extended message received that we end up rejecting). Ordering the
comments like you did just for GCC's sake is misleading.

The comment block should perhaps be moved after the default label. And
it would be nice if the reason for the fall through could be retained in
the comment.

Cheers,

    Michael
