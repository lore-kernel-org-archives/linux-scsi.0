From: Andrew Morton <akpm@google.com>
Subject: Re: [PATCH] scsi: fix qla2xxx printk format warning
Date: Fri, 23 Sep 2011 15:50:58 -0700
Message-ID: <20110923155058.c0a42f68.akpm@google.com>
References: <4E7D0AF2.7020401@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:7294 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413Ab1IWWvF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Sep 2011 18:51:05 -0400
In-Reply-To: <4E7D0AF2.7020401@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: scsi <linux-scsi@vger.kernel.org>, JBottomley@parallels.com, linux-driver@qlogic.com, Andrew Vasquez <andrew.vasquez@qlogic.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>

On Fri, 23 Sep 2011 15:40:50 -0700
Randy Dunlap <rdunlap@xenotime.net> wrote:

> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> sector_t can be different types, so cast it to its largest
> possible type.
> 
> drivers/scsi/qla2xxx/qla_isr.c:1509:5: warning: format '%lx' expects type 'long unsigned int', but argument 5 has type 'sector_t'
> 
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> ---
>  drivers/scsi/qla2xxx/qla_isr.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- lnx-31-rc7.orig/drivers/scsi/qla2xxx/qla_isr.c
> +++ lnx-31-rc7/drivers/scsi/qla2xxx/qla_isr.c
> @@ -1507,8 +1507,8 @@ qla2x00_handle_dif_error(srb_t *sp, stru
>  
>  			if (k != blocks_done) {
>  				qla_printk(KERN_WARNING, sp->fcport->vha->hw,
> -				    "unexpected tag values tag:lba=%x:%lx)\n",
> -				    e_ref_tag, lba_s);
> +				    "unexpected tag values tag:lba=%x:%llx)\n",
> +				    e_ref_tag, (unsigned long long)lba_s);

The patch does more than fix a warning - that's a runtime bug.
