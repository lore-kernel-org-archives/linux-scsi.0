From: Mark Salyzyn <Mark_Salyzyn@adaptec.com>
Subject: Re: [PATCH] dpt_i2o: Add PROC_IA64 define
Date: Thu, 12 Jun 2008 09:22:18 -0400
Message-ID: <81F7F1EB-F658-40EE-ADBA-62CB85BD1F66@adaptec.com>
References: <4850A5A0.1040601@suse.com>
Mime-Version: 1.0 (Apple Message framework v924)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([162.62.93.58]:36783 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762124AbYFLNWX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jun 2008 09:22:23 -0400
In-Reply-To: <4850A5A0.1040601@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Mahoney <jeffm@suse.com>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

NAK, the management tools need to see the processor as manufactured by  
Intel.

Leave PROC_INTAL, PROC_IA64 in the second fragment.

Sincerely -- Mark Salyzyn

On Jun 12, 2008, at 12:27 AM, Jeff Mahoney wrote:

> This fixes the following compile failure in 2.6.26-rc5-git5:
> drivers/scsi/dpt_i2o.c:83: error: 'PROC_IA64' undeclared here (not  
> in a function)
>
> I'm not sure if these values are magic and defined somewhere, but the
> kernel wouldn't build on IA64 without it.
>
> I changed the value in dpt_i2o.c because the comments indicated that
> PROC_INTEL refered to the 80x86 family, which doesn't include ia64.
>
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
> drivers/scsi/dpt/dptsig.h |    1 +
> drivers/scsi/dpt_i2o.c    |    2 +-
> 2 files changed, 2 insertions(+), 1 deletion(-)
>
> --- a/drivers/scsi/dpt/dptsig.h
> +++ b/drivers/scsi/dpt/dptsig.h
> @@ -92,6 +92,7 @@ typedef unsigned int sigINT;
> #define PROC_POWERPC    0x04    /* IBM Power PC */
> #define PROC_i960       0x05    /* Intel i960 */
> #define PROC_ULTRASPARC 0x06    /* SPARC processor */
> +#define PROC_IA64       0x07    /* IA64 processor */
>
> /* Specific Minimim Processor - sigBYTE dsProcessor;    FLAG BITS */
> /*  
> ------------------------------------------------------------------ */
> --- a/drivers/scsi/dpt_i2o.c
> +++ b/drivers/scsi/dpt_i2o.c
> @@ -80,7 +80,7 @@ static dpt_sig_S DPTI_sig = {
> #ifdef __i386__
>        PROC_INTEL, PROC_386 | PROC_486 | PROC_PENTIUM | PROC_SEXIUM,
> #elif defined(__ia64__)
> -       PROC_INTEL, PROC_IA64,
> +       PROC_IA64, PROC_IA64,
> #elif defined(__sparc__)
>        PROC_ULTRASPARC, PROC_ULTRASPARC,
> #elif defined(__alpha__)
>
> --
> Jeff Mahoney
> SUSE Labs
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

