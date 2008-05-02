From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: + scsi-use-get_unaligned_-helpers.patch added to -mm tree
Date: Fri, 02 May 2008 18:47:01 -0500
Message-ID: <1209772021.3121.72.camel@localhost.localdomain>
References: <200805022309.m42N9OJj019849@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:56275 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759302AbYEBXrI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 May 2008 19:47:08 -0400
In-Reply-To: <200805022309.m42N9OJj019849@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-scsi@vger.kernel.org, harvey.harrison@gmail.com

On Fri, 2008-05-02 at 16:09 -0700, akpm@linux-foundation.org wrote:
> The patch titled
>      scsi: use get_unaligned_* helpers
> has been added to the -mm tree.  Its filename is
>      scsi-use-get_unaligned_-helpers.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
> out what to do about this
> 
> The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
> 
> ------------------------------------------------------
> Subject: scsi: use get_unaligned_* helpers
> From: Harvey Harrison <harvey.harrison@gmail.com>
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/scsi/libiscsi.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff -puN drivers/scsi/libiscsi.c~scsi-use-get_unaligned_-helpers drivers/scsi/libiscsi.c
> --- a/drivers/scsi/libiscsi.c~scsi-use-get_unaligned_-helpers
> +++ a/drivers/scsi/libiscsi.c
> @@ -508,7 +508,7 @@ invalid_datalen:
>  			goto out;
>  		}
>  
> -		senselen = be16_to_cpu(get_unaligned((__be16 *) data));
> +		senselen = get_unaligned_be16(data);
>  		if (datalen < senselen)
>  			goto invalid_datalen;
>  

Actually, if you want to be useful, there's far more than just this.
The whole of SCSI and SAS is peppered with thinks like this.  See for
example the include/scsi/scsi.h:scsi_to_u32() sas.h:SAS_ADDR() etc.

Unfortunately, since SCSI is a BE bus, a lot of it is simply roll your
own inside the .c files.

James


