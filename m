From: "Larry W. Finger" <Larry.Finger@lwfinger.net>
Subject: Re: Kernel oops in 2.6.1 when loading aha152x_cs.ko
Date: Sat, 10 Jan 2004 10:09:46 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <6.0.0.22.0.20040110100325.01b88158@pop-server.kc.rr.com>
References: <6.0.0.22.0.20040109124348.01b86068@pop-server.kc.rr.com>
 <1073698638.2026.3.camel@opiate>
 <6.0.0.22.0.20040109221955.01b86f28@pop-server.kc.rr.com>
 <1073716698.2026.18.camel@opiate>
 <1073747000.1945.5.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:18861 "EHLO
	mtiwmhc12.worldnet.att.net") by vger.kernel.org with ESMTP
	id S265255AbUAJRNJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Jan 2004 12:13:09 -0500
In-Reply-To: <1073747000.1945.5.camel@mulgrave>
References: <6.0.0.22.0.20040109124348.01b86068@pop-server.kc.rr.com>
 <1073698638.2026.3.camel@opiate>
 <6.0.0.22.0.20040109221955.01b86f28@pop-server.kc.rr.com>
 <1073716698.2026.18.camel@opiate>
 <1073747000.1945.5.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, eric@bootseg.com, turbo-desktop-environment@t-online.de

At 08:03 AM 1/10/2004, James Bottomley wrote:
>The problem seems to be this code in aha152x.c:
>
>#ifndef PCMCIA
>#define driver_template aha152x_driver_template
>#include "scsi_module.c"
>#endif
>
>Since it's still behaving as a legacy driver (by calling
>register_scsi()), it needs the aha152x_driver_template.legacy_hosts list
>initialised (which is done in scsi_module.c).
>
>The true fix would be to convert aha152x to the new API.  However, a
>quick fix is probably to add
>
>         INIT_LIST_HEAD(&s.legacy_hosts);
>
>just before the call to aha152x_probe_one() in aha152x_stub.c
>
>James

This doesn't compile. The structure 's' has no member named 'legacy_hosts'. 
On the other hand, the patch from Eric Kerin fixes the problem. Although 
this sample may be mangled by my mailer, it is as follows:

--- drivers/scsi/aha152x.c.orig 2003-12-31 11:04:14.000000000 -0500
+++ drivers/scsi/aha152x.c      2004-01-10 01:23:31.568684000 -0500
@@ -965,6 +965,12 @@ struct Scsi_Host *aha152x_probe_one(stru
  {
         struct Scsi_Host *shpnt;

+#ifdef PCMCIA
+       if(!aha152x_driver_template.legacy_hosts.next){
+               INIT_LIST_HEAD(&aha152x_driver_template.legacy_hosts);
+       }
+#endif
+
         shpnt = scsi_register(&aha152x_driver_template, sizeof(struct
aha152x_hostdata));
         if (!shpnt) {
                 printk(KERN_ERR "aha152x: scsi_register failed\n");

Larry

