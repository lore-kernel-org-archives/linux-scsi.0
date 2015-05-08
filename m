From: Kyuho Choi <chlrbgh0@gmail.com>
Subject: Re: [PATCH] scsi: ufs: enable no_write_same for ufs
Date: Sat, 9 May 2015 00:47:44 +0900
Message-ID: <CAP2JTQKP71bFNi9DXAs5sMfN7ge1rAw0js2jZij+EBcGEyBEbg@mail.gmail.com>
References: <1431003981-7106-1-git-send-email-kyuho.choi@sk.com> <CAC5umyisxmQh9=vKDHPf5gcjF0-u8m8=rbpZTyaVZN6AbsLBEw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:38709 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699AbbEHPsF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 May 2015 11:48:05 -0400
Received: by wiun10 with SMTP id n10so31997006wiu.1
        for <linux-scsi@vger.kernel.org>; Fri, 08 May 2015 08:48:04 -0700 (PDT)
In-Reply-To: <CAC5umyisxmQh9=vKDHPf5gcjF0-u8m8=rbpZTyaVZN6AbsLBEw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: vinayak holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Kyuho Choi <kyuho.choi@sk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

Hi Akinobu,

On Fri, May 8, 2015 at 10:33 PM, Akinobu Mita <akinobu.mita@gmail.com> wrote:
>
> Hi Kyuho,
>
> 2015-05-07 22:06 GMT+09:00 Kyuho Choi <chlrbgh0@gmail.com>:
> > This patch disables write_same for ufs.
> >
> > Signed-off-by: Kyuho Choi <kyuho.choi@sk.com>
> > ---
> >  drivers/scsi/ufs/ufshcd.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > index 648a446..6f770cd 100644
> > --- a/drivers/scsi/ufs/ufshcd.c
> > +++ b/drivers/scsi/ufs/ufshcd.c
> > @@ -4255,6 +4255,7 @@ static struct scsi_host_template ufshcd_driver_template = {
> >         .max_host_blocked       = 1,
> >         .use_blk_tags           = 1,
> >         .track_queue_depth      = 1,
> > +       .no_write_same          = 1,
> >  };
>
> Is there any specific reason to disable WRITE_SAME in the host
> controller level?

Nope.
But, according to UFS specification, does not support WRITE_SAME until UFS 2.0.
So I thought host controller does not need WRITE_SAME command for UFS device.

>
> no_write_same flag in scsi_host_template was introduced by commit
> 54b2b50c ("[SCSI] Disable WRITE SAME for RAID and virtual host adapter
> drivers") for RAID and virtual host adapter drivers which can lead
> to adapter firmware hangs or excessive I/O errors.

Right. I'd refer that for this patch.

>
> The UFS device that does not support WRITE SAME should return
> ILLEGAL_REQUEST sense key (and with INVALID COMMAND OPCODE code for
> example).  If there is a specific product model/revision which causes
> an undesirable result by WRITE_SAME, we should disable only when
> such device is detected.  Otherwise I think this patch could conflict
> with any attempts to support WRITE SAME by some vendors who want it in
> their products or future UFS specification change.

Right. UFS device always should return ILLEGAL_REQUEST about WRITE_SAME command.
But I didn't consider of specification change in future.
