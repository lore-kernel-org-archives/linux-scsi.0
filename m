From: Eric Kerin <eric@bootseg.com>
Subject: Re: Kernel oops in 2.6.1 when loading aha152x_cs.ko
Date: Fri, 09 Jan 2004 20:37:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1073698638.2026.3.camel@opiate>
References: <6.0.0.22.0.20040109124348.01b86068@pop-server.kc.rr.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mxsf22.cluster1.charter.net ([209.225.28.222]:17427 "EHLO
	mxsf22.cluster1.charter.net") by vger.kernel.org with ESMTP
	id S264879AbUAJBqz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Jan 2004 20:46:55 -0500
In-Reply-To: <6.0.0.22.0.20040109124348.01b86068@pop-server.kc.rr.com>
List-Id: linux-scsi@vger.kernel.org
To: "Larry W. Finger" <Larry.Finger@lwfinger.net>
Cc: linux-scsi@vger.kernel.org

On Fri, 2004-01-09 at 15:14, Larry W. Finger wrote: 
> +			INIT_LIST_HEAD(&sht->legacy_hosts);

Under the non-pcmcia version of that driver, the above code is handled
by the module_init function (which is included from scsi_module.c), but
since that routine isn't used for the PCMCIA version, that list never
get's initialized.

The below patch handles it in the aha152x driver itself for PCMCIA(which
is the part that is technically broken). Instead of handling it in
hosts.c file.

Give this a try, it should work the same, but I don't have the hardware
to test it on.

Eric


-- linux-2.6.1/drivers/scsi/aha152x.c   2003-12-31 11:04:14.000000000
-0500
+++ linux-2.6.1/drivers/scsi/aha152x.c.listfix   2004-01-09
16:21:03.977748000 -0500
@@ -965,6 +965,12 @@ struct Scsi_Host *aha152x_probe_one(stru
{
        struct Scsi_Host *shpnt;

+#ifdef PCMCIA
+       if(!&aha152x_driver_template->legacy_hosts){
+               INIT_LIST_HEAD(&aha152x_driver_template->legacy_hosts);
+       }
+#endif
+
        shpnt = scsi_register(&aha152x_driver_template, sizeof(struct 
aha152x_hostdata));
        if (!shpnt) {
                printk(KERN_ERR "aha152x: scsi_register failed\n");


