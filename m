From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch 14/16] qla2xxx: use memory_read_from_buffer()
Date: Fri, 04 Jul 2008 09:42:35 -0500
Message-ID: <1215182555.5413.8.camel@localhost.localdomain>
References: <200807040647.m646lXpN017508@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:51097 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753409AbYGDOmj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jul 2008 10:42:39 -0400
In-Reply-To: <200807040647.m646lXpN017508@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-scsi@vger.kernel.org, akinobu.mita@gmail.com, andrew.vasquez@qlogic.com, linux-driver@qlogic.com, seokmann.ju@qlogic.com

On Thu, 2008-07-03 at 23:47 -0700, akpm@linux-foundation.org wrote:
> From: Akinobu Mita <akinobu.mita@gmail.com>
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Andrew Vasquez <linux-driver@qlogic.com>
> Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
> Tested-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
> Cc: Seokmann Ju <seokmann.ju@qlogic.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/scsi/qla2xxx/qla_attr.c |   45 ++++++------------------------
>  1 file changed, 10 insertions(+), 35 deletions(-)
> 
> diff -puN drivers/scsi/qla2xxx/qla_attr.c~qla2xxx-use-memory_read_from_buffer drivers/scsi/qla2xxx/qla_attr.c
> --- a/drivers/scsi/qla2xxx/qla_attr.c~qla2xxx-use-memory_read_from_buffer
> +++ a/drivers/scsi/qla2xxx/qla_attr.c
> @@ -8,6 +8,7 @@
>  
>  #include <linux/kthread.h>
>  #include <linux/vmalloc.h>
> +#include <linux/fs.h>

For such a micro optimisation, this is a pretty big price to pay.

Inclusion of linux/fs.h in a low level driver was always a danger signal
usually it meant the driver was trying to access files or something at
the very least it was a warning of a potential layering violation.  Now
you're trying to make it standard practice ... I really don't like that.
Surely a function that does memory to memory copies belongs either in
string.h with the rest of our memory copies ... or in another header
that would be a usual include for the potential users.

James


