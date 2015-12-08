From: Boaz Harrosh <ooo@electrozaur.com>
Subject: Re: [PATCH] [SCSI] osd: fix signed char versus %02x issue
Date: Wed, 09 Dec 2015 00:21:12 +0200
Message-ID: <566757D8.4060400@electrozaur.com>
References: <1449584716-21093-1-git-send-email-linux@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1449584716-21093-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: osd-dev@open-osd.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 12/08/2015 04:25 PM, Rasmus Villemoes wrote:
> If char is signed and one of these bytes happen to have a value
> outside the ascii range, the corresponding output will consist of
> "ffffff" followed by the two hex chars that were actually
> intended. One way to fix it would be to change the casts to (u8*) aka
> (unsigned char*), but it is much simpler (and generates smaller code)
> to use the %ph extension which was created for such short hexdumps.
> 

Ha real cool, thanks I hated that crap

ACK-by: Boaz Harrosh <ooo@electrozaur.com>

> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> ---
>  drivers/scsi/osd/osd_initiator.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
> index 0cccd6033feb..d8a2b5185f56 100644
> --- a/drivers/scsi/osd/osd_initiator.c
> +++ b/drivers/scsi/osd/osd_initiator.c
> @@ -170,10 +170,7 @@ static int _osd_get_print_system_info(struct osd_dev *od,
>  
>  	/* FIXME: Where are the time utilities */
>  	pFirst = get_attrs[a++].val_ptr;
> -	OSD_INFO("CLOCK                  [0x%02x%02x%02x%02x%02x%02x]\n",
> -		((char *)pFirst)[0], ((char *)pFirst)[1],
> -		((char *)pFirst)[2], ((char *)pFirst)[3],
> -		((char *)pFirst)[4], ((char *)pFirst)[5]);
> +	OSD_INFO("CLOCK                  [0x%6phN]\n", pFirst);
>  
>  	if (a < nelem) { /* IBM-OSD-SIM bug, Might not have it */
>  		unsigned len = get_attrs[a].len;
> 
