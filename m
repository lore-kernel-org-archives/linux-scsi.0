From: "Larry W. Finger" <Larry.Finger@lwfinger.net>
Subject: Re: Kernel oops in 2.6.1 when loading aha152x_cs.ko
Date: Fri, 09 Jan 2004 22:27:38 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <6.0.0.22.0.20040109221955.01b86f28@pop-server.kc.rr.com>
References: <6.0.0.22.0.20040109124348.01b86068@pop-server.kc.rr.com>
 <1073698638.2026.3.camel@opiate>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:52156 "EHLO
	mtiwmhc11.worldnet.att.net") by vger.kernel.org with ESMTP
	id S264963AbUAJF2m (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Jan 2004 00:28:42 -0500
In-Reply-To: <1073698638.2026.3.camel@opiate>
References: <6.0.0.22.0.20040109124348.01b86068@pop-server.kc.rr.com>
 <1073698638.2026.3.camel@opiate>
List-Id: linux-scsi@vger.kernel.org
To: Eric Kerin <eric@bootseg.com>
Cc: linux-scsi@vger.kernel.org

At 06:37 PM 1/9/2004, Eric Kerin wrote:
>On Fri, 2004-01-09 at 15:14, Larry W. Finger wrote:
> > +                     INIT_LIST_HEAD(&sht->legacy_hosts);
>
>Under the non-pcmcia version of that driver, the above code is handled
>by the module_init function (which is included from scsi_module.c), but
>since that routine isn't used for the PCMCIA version, that list never
>get's initialized.
>
>The below patch handles it in the aha152x driver itself for PCMCIA(which
>is the part that is technically broken). Instead of handling it in
>hosts.c file.
>
>Give this a try, it should work the same, but I don't have the hardware
>to test it on.
>
>Eric
>
>
>-- linux-2.6.1/drivers/scsi/aha152x.c   2003-12-31 11:04:14.000000000
>-0500
>+++ linux-2.6.1/drivers/scsi/aha152x.c.listfix   2004-01-09
>16:21:03.977748000 -0500
>@@ -965,6 +965,12 @@ struct Scsi_Host *aha152x_probe_one(stru
>{
>         struct Scsi_Host *shpnt;
>
>+#ifdef PCMCIA
>+       if(!&aha152x_driver_template->legacy_hosts){
>+               INIT_LIST_HEAD(&aha152x_driver_template->legacy_hosts);
>+       }
>+#endif
>+
>         shpnt = scsi_register(&aha152x_driver_template, sizeof(struct
>aha152x_hostdata));
>         if (!shpnt) {
>                 printk(KERN_ERR "aha152x: scsi_register failed\n");

Unfortunately, this patch doesn't work. When I compile with it, I get the 
following errors:

make[1]: `arch/i386/kernel/asm-offsets.s' is up to date.
   CHK     include/linux/compile.h
   CC [M]  drivers/scsi/pcmcia/aha152x_core.o
In file included from drivers/scsi/pcmcia/aha152x_core.c:3:
drivers/scsi/aha152x.c: In function `aha152x_probe_one':
drivers/scsi/aha152x.c:976: error: invalid type argument of `->'
drivers/scsi/aha152x.c:978: error: invalid type argument of `->'
drivers/scsi/aha152x.c:978: error: invalid type argument of `->'
drivers/scsi/aha152x.c:978: error: invalid type argument of `->'
drivers/scsi/aha152x.c:978: error: invalid type argument of `->'
make[3]: *** [drivers/scsi/pcmcia/aha152x_core.o] Error 1
make[2]: *** [drivers/scsi/pcmcia] Error 2
make[1]: *** [drivers/scsi] Error 2
make: *** [drivers] Error 2

If I change the "->" to ".", the routine will compile but the tested 
location is non-zero, so the list_head is never initialized and the module 
loading fails.

Larry Finger

