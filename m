From: Hannes Reinecke <hare@suse.de>
Subject: Re: [AIC7xxx] tree things to report
Date: Tue, 29 May 2007 09:19:54 +0200
Message-ID: <465BD41A.20708@suse.de>
References: <JIO6G3$AA5BDB4D4ABCE85E697964C3BA55EC36@laposte.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030109070208000700090101"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:33542 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753894AbXE2HUE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 May 2007 03:20:04 -0400
In-Reply-To: <JIO6G3$AA5BDB4D4ABCE85E697964C3BA55EC36@laposte.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-1?Q?Emmanuel_Fust=E9?= <emmanuel.fuste@laposte.net>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>

This is a multi-part message in MIME format.
--------------030109070208000700090101
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Emmanuel Fusté wrote:
> Hello,
> 
>> What you should do here is:
>>
>> - hook up a serial cable and re-route console messages to that
>> - Switch off syslog (as this might block if the SCSI bus frozen)
>> - Enable scsi debugging (Error, Timeout, Scan, and Midlayer is
>> sufficient) and start cdrwtools.
>> - Send me the log from the serial console.
>>
> Ok, I've got logs with netconsole after swapping my Ethernet
> card  with another one.

Grand. Well done, son.
The logs have been very instructive.

Again we're hitting this 'two commands per lun' problem.
For historic reasons the aic7xxx and aic79xx driver accepted two
commands per luns, as they implemented their internal queueing and could
hold the second command on the queue.
With later versions I've removed this internal queueing and relied on
the block-layer for this.
But this also means we can only accept one command per lun.

Please try the attached patch and see if it helps.

James, I know that the aic7xxx has some 'next_queued_hscb' pointer which
might be utilized for this sort of thing. But I didn't really figure out
how this thing is supposed to work nor how we could utilize it.
So I figured that the added complexity is not really worth it.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)

--------------030109070208000700090101
Content-Type: text/plain;
 name="aic7xxx-allow-only-single-commands"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="aic7xxx-allow-only-single-commands"

Allow only a single command per lun for aic7xxx

With the conversion to use transport classes we also removed the
internal queueing from the driver. Hence the existing hack of
accepting two commands per lun and just holding this other one
internally is no longer valid.

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 6054881..df8a3b2 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -775,7 +775,7 @@ struct scsi_host_template aic79xx_driver
 	.can_queue		= AHD_MAX_QUEUE,
 	.this_id		= -1,
 	.max_sectors		= 8192,
-	.cmd_per_lun		= 2,
+	.cmd_per_lun		= 1,
 	.use_clustering		= ENABLE_CLUSTERING,
 	.slave_alloc		= ahd_linux_slave_alloc,
 	.slave_configure	= ahd_linux_slave_configure,
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index 660f26e..e6b87b9 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -755,7 +755,7 @@ struct scsi_host_template aic7xxx_driver
 	.can_queue		= AHC_MAX_QUEUE,
 	.this_id		= -1,
 	.max_sectors		= 8192,
-	.cmd_per_lun		= 2,
+	.cmd_per_lun		= 1,
 	.use_clustering		= ENABLE_CLUSTERING,
 	.slave_alloc		= ahc_linux_slave_alloc,
 	.slave_configure	= ahc_linux_slave_configure,

--------------030109070208000700090101--
