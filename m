From: Kashyap Desai <kashyap.desai@broadcom.com>
Subject: RE: [PATCH] Fix: scsi: megaraid: reduce the scope of pending-list
 lock to avoid double lock
Date: Thu, 20 Oct 2016 14:04:09 +0530
Message-ID: <2b0fa36ddee87fdb9ebab76d91d33fad@mail.gmail.com>
References: <1476689406-31316-1-git-send-email-iari@itu.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:35442 "EHLO
        mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751012AbcJTIeM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Oct 2016 04:34:12 -0400
Received: by mail-it0-f50.google.com with SMTP id 4so159890650itv.0
        for <linux-scsi@vger.kernel.org>; Thu, 20 Oct 2016 01:34:11 -0700 (PDT)
In-Reply-To: <1476689406-31316-1-git-send-email-iari@itu.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: iari@itu.dk, Jiri Kosina <jkosina@suse.cz>
Cc: Kashyap Desai <kashyap.desai@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, Iago Abal <mail@iagoabal.eu>

> -----Original Message-----
> From: iari@itu.dk [mailto:iari@itu.dk]
> Sent: Monday, October 17, 2016 1:00 PM
> To: Jiri Kosina
> Cc: Kashyap Desai; Sumit Saxena; Uday Lingala; James E.J. Bottomley;
Martin K.
> Petersen; megaraidlinux.pdl@avagotech.com; linux-scsi@vger.kernel.org;
Iago
> Abal
> Subject: [PATCH] Fix: scsi: megaraid: reduce the scope of pending-list
lock to
> avoid double lock
>
> From: Iago Abal <mail@iagoabal.eu>
>
> The EBA code analyzer (https://github.com/models-team/eba) reported the
> following double lock:
>
>     1. In function `megaraid_reset_handler' at 2571;
>     2. take `&adapter->pend_list_lock' for the first time at 2602:
>
>            // FIRST
>            spin_lock_irqsave(PENDING_LIST_LOCK(adapter), flags);
>
>     3. enter the `list_for_each_entry_safe' loop at 2603;
>     4. call `megaraid_mbox_mm_done' at 2616;
>     5. call `megaraid_mbox_runpendq' at 3782;
>     6. take `&adapter->pend_list_lock' for the second time at 1892:
>
>            // SECOND: DOUBLE LOCK !!!
>            spin_lock_irqsave(PENDING_LIST_LOCK(adapter), flags);
>
> From my shallow understanding of the code (so please review carefully),
I think
> that it is not necessary to hold `PENDING_LIST_LOCK(adapter)' while
executing
> the body of the `list_for_each_entry_safe' loop. I assume this because
both
> `megaraid_mbox_mm_done' and `megaraid_dealloc_scb' are called from
> several places where, as far as I can tell, this lock is not hold. In
fact, as reported
> by EBA, at some point `megaraid_mbox_mm_done' will acquire this lock
again.
>
> Fixes: c005fb4fb2d2 ("[SCSI] megaraid_{mm,mbox}: fix a bug in reset
handler")
> Signed-off-by: Iago Abal <mail@iagoabal.eu>
> ---
>  drivers/scsi/megaraid/megaraid_mbox.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/scsi/megaraid/megaraid_mbox.c
> b/drivers/scsi/megaraid/megaraid_mbox.c
> index f0987f2..7f11898 100644
> --- a/drivers/scsi/megaraid/megaraid_mbox.c
> +++ b/drivers/scsi/megaraid/megaraid_mbox.c
> @@ -2603,6 +2603,7 @@ static DEF_SCSI_QCMD(megaraid_queue_command)
>  	list_for_each_entry_safe(scb, tmp, &adapter->pend_list, list) {
>  		list_del_init(&scb->list);	// from pending list
>
> +		spin_unlock_irqrestore(PENDING_LIST_LOCK(adapter), flags);
>  		if (scb->sno >= MBOX_MAX_SCSI_CMDS) {
>  			con_log(CL_ANN, (KERN_WARNING
>  			"megaraid: IOCTL packet with %d[%d:%d] being
> reset\n", @@ -2630,6 +2631,7 @@ static
> DEF_SCSI_QCMD(megaraid_queue_command)
>
>  			megaraid_dealloc_scb(adapter, scb);
>  		}
> +		spin_lock_irqsave(PENDING_LIST_LOCK(adapter), flags);
>  	}
>  	spin_unlock_irqrestore(PENDING_LIST_LOCK(adapter), flags);

Looks correct, but please note that MEGARAID_MAILBOX and MEGARAID_MM is
not supported by LSI/ Broadcom.   We will revert back to you shortly if we
can safely remove those two modules.

.

>
> --
> 1.9.1
