From: Andrey Konovalov <andreyknvl@google.com>
Subject: Re: [PATCH] scsi: sg: Fix mismatch in sg_get_rq_mark
Date: Tue, 16 May 2017 16:55:37 +0200
Message-ID: <CAAeHK+y9-z-vM8JY_X69UznhF02Byuy=B_NnvUZWknK_zRxWQA@mail.gmail.com>
References: <20170516145244.19402-1-firogm@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f181.google.com ([209.85.161.181]:33931 "EHLO
        mail-yw0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750949AbdEPOzi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 May 2017 10:55:38 -0400
Received: by mail-yw0-f181.google.com with SMTP id l14so54186897ywk.1
        for <linux-scsi@vger.kernel.org>; Tue, 16 May 2017 07:55:38 -0700 (PDT)
In-Reply-To: <20170516145244.19402-1-firogm@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: firogm@gmail.com
Cc: Doug Gilbert <dgilbert@interlog.com>, Dmitry Vyukov <dvyukov@google.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, syzkaller <syzkaller@googlegroups.com>, LKML <linux-kernel@vger.kernel.org>

On Tue, May 16, 2017 at 4:52 PM,  <firogm@gmail.com> wrote:
> From: Firo Yang <firogm@gmail.com>
>
> This bug was reported by Andrey Konovalov with syzkaller:
>
> Call Trace:
>  sg_finish_rem_req+0x2a6/0x320 drivers/scsi/sg.c:1839
>  sg_new_read+0x3c/0x430 drivers/scsi/sg.c:567
>  sg_read+0x866/0x1830 drivers/scsi/sg.c:455
>  __vfs_read+0x5c3/0x750 fs/read_write.c:450
>  vfs_read+0x11e/0x350 fs/read_write.c:473
>  SYSC_read fs/read_write.c:589
>  SyS_read+0xfb/0x230 fs/read_write.c:582
>  entry_SYSCALL_64_fastpath+0x1f/0xbe arch/x86/entry/entry_64.S:204
>
> If there is nothing matched in the loop of list_for_each_entry,
> at last the iteration variable 'resp' will point to
> list_entry(&sfp->rq_list, typeof(resp), entry); it's not a valid
> Sg_request. Finnally, 'resp' will be wrongly returned to the caller
> function.
>
> To fix it, add another return variable to record the correct
> match and return it to the caller function.

I think this was already fixed by https://lkml.org/lkml/2017/5/10/83

Thanks!

>
> Signed-off-by: Firo Yang <firogm@gmail.com>
> ---
>  drivers/scsi/sg.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 0a38ba0..74a9188 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -2065,7 +2065,7 @@ sg_unlink_reserve(Sg_fd * sfp, Sg_request * srp)
>  static Sg_request *
>  sg_get_rq_mark(Sg_fd * sfp, int pack_id)
>  {
> -       Sg_request *resp;
> +       Sg_request *resp, *ret_resp = NULL;
>         unsigned long iflags;
>
>         write_lock_irqsave(&sfp->rq_list_lock, iflags);
> @@ -2074,11 +2074,12 @@ sg_get_rq_mark(Sg_fd * sfp, int pack_id)
>                 if ((1 == resp->done) && (!resp->sg_io_owned) &&
>                     ((-1 == pack_id) || (resp->header.pack_id == pack_id))) {
>                         resp->done = 2; /* guard against other readers */
> +                       ret_resp =  resp;
>                         break;
>                 }
>         }
>         write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
> -       return resp;
> +       return ret_resp;
>  }
>
>  /* always adds to end of list */
> --
> 2.9.4
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller+unsubscribe@googlegroups.com.
> For more options, visit https://groups.google.com/d/optout.
