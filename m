From: Ron Pitts <aussieron@gmail.com>
Subject: Re: Problem with RR3520 (HighPoint Raid) - Fedora -
Date: Sun, 24 Oct 2010 13:40:53 +1100
Message-ID: <AANLkTikKyF3cYF8wD=dQd0pPjOseJsV8cC9f=_-M5den@mail.gmail.com>
References: <AANLkTimVsA-_Z=LgL4pOVc1uY7bB1nwDSbRMZwdWZNpy@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33073 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754837Ab0JXCky convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 23 Oct 2010 22:40:54 -0400
Received: by iwn34 with SMTP id 34so2754858iwn.19
        for <linux-scsi@vger.kernel.org>; Sat, 23 Oct 2010 19:40:53 -0700 (PDT)
In-Reply-To: <AANLkTimVsA-_Z=LgL4pOVc1uY7bB1nwDSbRMZwdWZNpy@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Guys,

Any idea why this would fail? geez...I was hoping to setup my new
system this weekend.

53 static int iop_wait_ready_itl(struct hptiop_hba *hba, u32 millisec)
 54 {
 55         u32 req =3D 0;
 56         int i;
 57
 58         for (i =3D 0; i < millisec; i++) {
 59                 req =3D readl(&hba->u.itl.iop->inbound_queue);
 60                 if (req !=3D IOPMU_QUEUE_EMPTY)
 61                         break;
 62                 msleep(1);
 63         }
 64
 65         if (req !=3D IOPMU_QUEUE_EMPTY) {
 66                 writel(req, &hba->u.itl.iop->outbound_queue);
 67                 readl(&hba->u.itl.iop->outbound_intstatus);
 68                 return 0;
 69         }
 70
 71         return -1;
 72 }

Its looks to be emptying the IO queue, however this would be empty
anyway given the driver is trying to load?


On Sat, Oct 23, 2010 at 10:48 PM, Ron Pitts <aussieron@gmail.com> wrote=
:
>
>
> I'm trying to load the hptiop driver within Fedora V13 and its curren=
tly
> returning scsi11: firmware not ready.
>
> I've located the section of code below:
>
>
> hptiop.c
>
> =A0if (hba->ops->iop_wait_ready(hba, 20000)) {
> 1017=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 printk(KERN_ERR =
"scsi%d: firmware not ready\n",
> 1018=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 hba->host->host_no);
> 1019=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 goto unmap_pci_b=
ar;
> 1020=A0=A0=A0=A0=A0=A0=A0=A0 }
>
> What does this mean?=A0 Faulty raid card?
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
