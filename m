From: Eric Kerin <eric@bootseg.com>
Subject: Re: Kernel oops in 2.6.1 when loading aha152x_cs.ko
Date: Sat, 10 Jan 2004 01:38:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1073716698.2026.18.camel@opiate>
References: <6.0.0.22.0.20040109124348.01b86068@pop-server.kc.rr.com>
	 <1073698638.2026.3.camel@opiate>
	 <6.0.0.22.0.20040109221955.01b86f28@pop-server.kc.rr.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mxsf07.cluster1.charter.net ([209.225.28.207]:57100 "EHLO
	mxsf07.cluster1.charter.net") by vger.kernel.org with ESMTP
	id S265071AbUAJGxI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Jan 2004 01:53:08 -0500
In-Reply-To: <6.0.0.22.0.20040109221955.01b86f28@pop-server.kc.rr.com>
List-Id: linux-scsi@vger.kernel.org
To: "Larry W. Finger" <Larry.Finger@lwfinger.net>
Cc: linux-scsi@vger.kernel.org

On Sat, 2004-01-10 at 00:27, Larry W. Finger wrote:
> Unfortunately, this patch doesn't work. When I compile with it, I get the 
> following errors:

<snip>

No idea what I was thinking when I wrote that fix, oh well.

Let's try this again, with the proper check. This one even compiles!

Sorry about that first patch,
Eric


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


