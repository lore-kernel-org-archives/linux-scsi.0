From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [SCSI] correct transport class abstraction to work outside SCSI
Date: Mon, 17 Apr 2006 10:48:32 -0400
Message-ID: <1145285312.4574.5.camel@mulgrave.il.steeleye.com>
References: <BAY112-F3701EC7A4597119EA266AEA0C70@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:1172 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751048AbWDQOsf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Apr 2006 10:48:35 -0400
In-Reply-To: <BAY112-F3701EC7A4597119EA266AEA0C70@phx.gbl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mun Hamlet <hamletmun@hotmail.com>
Cc: linux-scsi@vger.kernel.org

On Mon, 2006-04-17 at 11:33 -0300, Mun Hamlet wrote:
> Thank you for your reply.
> 
> To verify the git bisecting result, I did
> 
> Vanilla kernel 2.6.13
> www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.13.tar.bz2
> Your patch
> http://www.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff_plain;h=d0a7e574007fd547d72ec693bfa35778623d0738;hp=10c1b88987d618f4f89c10e11e574c76de73b5e7
> 
> 
> It does BOOT, but it shows this strange dmesg...

Yes, that's not unexpected ... there were several updates to that patch.

> http://bugzilla.kernel.org/show_bug.cgi?id=5659

I'm fairly certain the problem with this one is multiple outstanding
untagged commands.  Could you try this on the latest kernel (2.6.17-rc1)
and see if it fixes the problem?

Note that if this is the problem, having user daemons which poke at scsi
devices periodically, like hald, will still disrupt CD burning, because
only one command can be active to the device at any one time.

Thanks,

James

diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 66e4a47..c818dfa 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -818,7 +818,7 @@ struct scsi_host_template aic79xx_driver
 #endif
 	.can_queue		= AHD_MAX_QUEUE,
 	.this_id		= -1,
-	.cmd_per_lun		= 2,
+	.cmd_per_lun		= 1,
 	.use_clustering		= ENABLE_CLUSTERING,
 	.slave_alloc		= ahd_linux_slave_alloc,
 	.slave_configure	= ahd_linux_slave_configure,
@@ -1138,7 +1138,7 @@ ahd_linux_register_host(struct ahd_softc
 	*((struct ahd_softc **)host->hostdata) = ahd;
 	ahd->platform_data->host = host;
 	host->can_queue = AHD_MAX_QUEUE;
-	host->cmd_per_lun = 2;
+	host->cmd_per_lun = 1;
 	host->sg_tablesize = AHD_NSEG;
 	host->this_id = ahd->our_id;
 	host->irq = ahd->platform_data->irq;
@@ -1400,12 +1400,6 @@ ahd_platform_set_tags(struct ahd_softc *
 		scsi_activate_tcq(sdev, dev->openings + dev->active);
 		break;
 	default:
-		/*
-		 * We allow the OS to queue 2 untagged transactions to
-		 * us at any time even though we can only execute them
-		 * serially on the controller/device.  This should
-		 * remove some latency.
-		 */
 		scsi_deactivate_tcq(sdev, 1);
 		break;
 	}
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index 2c80167..b9f200c 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -778,7 +778,7 @@ struct scsi_host_template aic7xxx_driver
 #endif
 	.can_queue		= AHC_MAX_QUEUE,
 	.this_id		= -1,
-	.cmd_per_lun		= 2,
+	.cmd_per_lun		= 1,
 	.use_clustering		= ENABLE_CLUSTERING,
 	.slave_alloc		= ahc_linux_slave_alloc,
 	.slave_configure	= ahc_linux_slave_configure,
@@ -1074,7 +1074,7 @@ ahc_linux_register_host(struct ahc_softc
 	*((struct ahc_softc **)host->hostdata) = ahc;
 	ahc->platform_data->host = host;
 	host->can_queue = AHC_MAX_QUEUE;
-	host->cmd_per_lun = 2;
+	host->cmd_per_lun = 1;
 	/* XXX No way to communicate the ID for multiple channels */
 	host->this_id = ahc->our_id;
 	host->irq = ahc->platform_data->irq;
@@ -1334,13 +1334,7 @@ ahc_platform_set_tags(struct ahc_softc *
 		scsi_activate_tcq(sdev, dev->openings + dev->active);
 		break;
 	default:
-		/*
-		 * We allow the OS to queue 2 untagged transactions to
-		 * us at any time even though we can only execute them
-		 * serially on the controller/device.  This should
-		 * remove some latency.
-		 */
-		scsi_deactivate_tcq(sdev, 2);
+		scsi_deactivate_tcq(sdev, 1);
 		break;
 	}
 }


