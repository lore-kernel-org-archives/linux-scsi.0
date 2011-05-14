From: Oliver Neukum <oliver@neukum.org>
Subject: Re: [PATCH] scsi/sd: fix suspend with USB-connected Android phone (one line)
Date: Sat, 14 May 2011 21:11:52 +0200
Message-ID: <201105142111.53266.oliver@neukum.org>
References: <BANLkTi=XNyR8GD43GGnMag+=JmhUd_5HtA@mail.gmail.com> <201105122203.13671.rjw@sisk.pl> <1305232563.2575.85.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1305232563.2575.85.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>, hare@suse.de
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Charles Hannum <root@ihack.net>, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>, linux-scsi <linux-scsi@vger.kernel.org>, linux-usb@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Am Donnerstag, 12. Mai 2011, 22:36:03 schrieb James Bottomley:

> Instinct tells me the correct set of fixes is to add a sync cache from
> release (so we automatically sync on last close, which is usually when
> an ordered remove happens), keep the one on shutdown, just in case the
> system goes down with stuff still mounted and print a nasty message on
> suspend for a write back device that's been removed.
> 
> I also think we shouldn't abort the suspend if the disk doesn't respond
> correctly to start/stop ... the power is going to be disconnected
> anyway, so it's no issue if the disk spins for a second or so longer.
> 
> The problem this is going to cause is double sync on shutdown (once when
> final unmount closes the device and once on shutdown) ... do people
> agree that's a price worth paying?
> 
> Something like this?

Hi,

it seems to me that the error codes should really be evaluated a bit better.
How about this?

	Regards
		Oliver

>From 2ab03ae46d6dc126a51ee9cd38206fbdc8bf6a34 Mon Sep 17 00:00:00 2001
From: Oliver Neukum <oliver@neukum.org>
Date: Mon, 25 Oct 2010 12:25:26 +0200
Subject: [PATCH 2/5] SCSI:sd:error handling in sd_sync_cache()

The SCSI commands sd_sync_cache() uses may fail.
These errors needs to be evaluated to return correct
error codes. This fixes system suspension while a device
removal is being handled.

Signed-off-by: Oliver NEukum <oneukum@suse.de>
---
 drivers/scsi/sd.c |   28 ++++++++++++++++++++++++----
 1 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index fcba7d2..5ed75bf 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1104,11 +1104,31 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
 		sd_print_result(sdkp, res);
 		if (driver_byte(res) & DRIVER_SENSE)
 			sd_print_sense_hdr(sdkp, &sshdr);
-	}
 
-	if (res)
-		return -EIO;
-	return 0;
+		/* we need to evaluate the error return  */
+		if ((scsi_sense_valid(&sshdr) &&
+			/* 0x3a is medium not present */
+			sshdr.asc == 0x3a))
+			/* this is no error here */
+			return 0;
+
+		switch (host_byte(res)) {
+		/* ignore errors due to racing a disconnection */
+		case DID_BAD_TARGET:
+		case DID_NO_CONNECT:	
+			return 0;
+		/* signal the upper layer it might try again */
+		case DID_BUS_BUSY:
+		case DID_IMM_RETRY:
+		case DID_REQUEUE:
+		case DID_SOFT_ERROR:
+			return -EBUSY;
+		default:
+			return -EIO;
+		}
+	} else {
+		return 0;
+	}
 }
 
 static void sd_rescan(struct device *dev)
-- 
1.7.1
