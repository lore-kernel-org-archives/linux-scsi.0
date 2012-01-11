From: Mark Salyzyn <mark_salyzyn@xyratex.com>
Subject: Re: [patch 3/6] drivers/scsi/aacraid/commctrl.c: fix mem leak in aac_send_raw_srb()
Date: Wed, 11 Jan 2012 09:03:22 -0500
Message-ID: <E8578821-0AC4-44E7-BE64-4271C597E17C@xyratex.com>
References: <20120110234233.17DB120012E@hpza10.eem.corp.google.com>
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xyratex195.xyratex.com ([194.131.166.195]:50815 "EHLO
	XY01EX22.xy01.xyratex.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751862Ab2AKOSi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Jan 2012 09:18:38 -0500
In-Reply-To: <20120110234233.17DB120012E@hpza10.eem.corp.google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, jj@chaosbits.net, akpm@linux-foundation.org, aacraid@adaptec.com

Ack!!!

3/21/11 Jesper Jul
9/20/11 akpm
1/10/12 akpm

Sincerely -- Mark Salyzyn

On Jan 10, 2012, at 6:42 PM, akpm@linux-foundation.org wrote:

> From: Jesper Juhl <jj@chaosbits.net>
> Subject: drivers/scsi/aacraid/commctrl.c: fix mem leak in aac_send_raw_srb()
> 
> We leak in drivers/scsi/aacraid/commctrl.c::aac_send_raw_srb() :
> 
> We allocate memory:
>        ...
>                        struct user_sgmap* usg;
>                        usg = kmalloc(actual_fibsize - sizeof(struct aac_srb)
>                          + sizeof(struct sgmap), GFP_KERNEL);
> and then neglect to free it:
>        ...
>                        for (i = 0; i < usg->count; i++) {
>                                u64 addr;
>                                void* p;
>                                if (usg->sg[i].count >
>                                    ((dev->adapter_info.options &
>                                     AAC_OPT_NEW_COMM) ?
>                                      (dev->scsi_host_ptr->max_sectors << 9) :
>                                      65536)) {
>                                        rcode = -EINVAL;
>                                        goto cleanup;
>        ... this 'goto' makes 'usg' go out of scope and leak the memory we
>            allocated.
>            Other exits properly kfree(usg), it's just here it is neglected.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
> drivers/scsi/aacraid/commctrl.c |    1 +
> 1 file changed, 1 insertion(+)
> 
> diff -puN drivers/scsi/aacraid/commctrl.c~drivers-scsi-aacraid-commctrlc-fix-mem-leak-in-aac_send_raw_srb drivers/scsi/aacraid/commctrl.c
> --- a/drivers/scsi/aacraid/commctrl.c~drivers-scsi-aacraid-commctrlc-fix-mem-leak-in-aac_send_raw_srb
> +++ a/drivers/scsi/aacraid/commctrl.c
> @@ -650,6 +650,7 @@ static int aac_send_raw_srb(struct aac_d
> 				     AAC_OPT_NEW_COMM) ?
> 				      (dev->scsi_host_ptr->max_sectors << 9) :
> 				      65536)) {
> +					kfree(usg);
> 					rcode = -EINVAL;
> 					goto cleanup;
> 				}

