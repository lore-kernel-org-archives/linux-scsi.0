From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] scsi: Remove warnings after vsprintf %pV introducation.
Date: Tue, 31 Aug 2010 15:07:46 -0600
Message-ID: <20100831210746.GJ3521@parisc-linux.org>
References: <20100831.133531.186321637.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:60619 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755786Ab0HaVHs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Aug 2010 17:07:48 -0400
Content-Disposition: inline
In-Reply-To: <20100831.133531.186321637.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, joe@perches.com, sfr@canb.auug.org.au

On Tue, Aug 31, 2010 at 01:35:31PM -0700, David Miller wrote:
> diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
> index a7bc8b7..d740a5b 100644
> --- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
> +++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
> @@ -72,10 +72,7 @@ static void sym_printl_hex(u_char *p, int n)
>  
>  static void sym_print_msg(struct sym_ccb *cp, char *label, u_char *msg)
>  {
> -	if (label)
> -		sym_print_addr(cp->cmd, "%s: ", label);
> -	else
> -		sym_print_addr(cp->cmd, "");
> +	sym_print_addr(cp->cmd, "%s: ", label);
>  
>  	spi_print_msg(msg);
>  	printf("\n");
> @@ -4558,7 +4555,8 @@ static void sym_int_sir(struct sym_hcb *np)
>  			switch (np->msgin [2]) {
>  			case M_X_MODIFY_DP:
>  				if (DEBUG_FLAGS & DEBUG_POINTER)
> -					sym_print_msg(cp, NULL, np->msgin);
> +					sym_print_msg(cp, "extended msg ",
> +						      np->msgin);
>  				tmp = (np->msgin[3]<<24) + (np->msgin[4]<<16) + 
>  				      (np->msgin[5]<<8)  + (np->msgin[6]);
>  				sym_modify_dp(np, tp, cp, tmp);

The extra space before the colon looks a little weird.

> @@ -4585,7 +4583,7 @@ static void sym_int_sir(struct sym_hcb *np)
>  		 */
>  		case M_IGN_RESIDUE:
>  			if (DEBUG_FLAGS & DEBUG_POINTER)
> -				sym_print_msg(cp, NULL, np->msgin);
> +				sym_print_msg(cp, "half byte ", np->msgin);
>  			if (cp->host_flags & HF_SENSE)
>  				OUTL_DSP(np, SCRIPTA_BA(np, clrack));
>  			else

Um, half byte?  Oh, I see ...

                /*
                 *  We received a 1/2 byte message not handled from SCRIPTS.

That's a 'one or two byte message', not an 0.5 byte message :-)  There's
really nothing good to print here.  Print a space if you absolutely must,
but why the hell is GCC warning about this?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
