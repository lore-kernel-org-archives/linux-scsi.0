From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: can't access LUN >2TB with aic7xxx, Infortrend EonStor and
 2.6.31-rc1
Date: Mon, 29 Jun 2009 09:33:03 -0500
Message-ID: <1246285984.3838.9.camel@mulgrave.site>
References: <20090629130835.GA3657@mother.pipebreaker.pl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38696 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753274AbZF2OdE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Jun 2009 10:33:04 -0400
In-Reply-To: <20090629130835.GA3657@mother.pipebreaker.pl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomasz Torcz <tomek@pipebreaker.pl>
Cc: linux-scsi@vger.kernel.org

On Mon, 2009-06-29 at 15:08 +0200, Tomasz Torcz wrote:
> Hello,
> 
>   recently I've acquired Infortrend EonStor A16U-G2421 array
> with 16x 500GB SATA drives inside. It is connected via:
> 04:00.0 SCSI storage controller: Adaptec AHA-2940U2/U2W
> to host running Fedora 12 with following kernel:
> 2.6.31-0.33.rc1.git2.fc12.x86_64
> 
>   When I export LUN >2TB from array I got following errors:
> 
> scsi 5:0:0:1: Direct-Access     VW       VRU1610          347G PQ: 0 ANSI: 5
> scsi target5:0:0: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 127)
> scsi5:A:0:1: Tagged Queuing enabled.  Depth 4
> sd 5:0:0:1: Attached scsi generic sg3 type 0
> sd 5:0:0:1: [sdd] READ CAPACITY(16) failed
> sd 5:0:0:1: [sdd] Result: hostbyte=DID_ABORT driverbyte=DRIVER_OK
> sd 5:0:0:1: [sdd] Sense not available.
> sd 5:0:0:1: [sdd] 4294967296 512-byte logical blocks: (2.19 TB/2.00 TiB)
> sd 5:0:0:1: [sdd] Write Protect is off
> sd 5:0:0:1: [sdd] Mode Sense: 9b 00 00 08
> sd 5:0:0:1: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> sd 5:0:0:1: [sdd] READ CAPACITY(16) failed
> sd 5:0:0:1: [sdd] Result: hostbyte=DID_ABORT driverbyte=DRIVER_OK
> sd 5:0:0:1: [sdd] Sense not available.
>  sdd: unknown partition table
> sd 5:0:0:1: [sdd] READ CAPACITY(16) failed
> sd 5:0:0:1: [sdd] Result: hostbyte=DID_ABORT driverbyte=DRIVER_OK
> sd 5:0:0:1: [sdd] Sense not available.
> sd 5:0:0:1: [sdd] Attached SCSI disk
> 
>   According to manufacturer, this array supports LUNs up to 64TB, 
> although >2TB LUNs require enigmatic ,,support from OS side''.
> I was under impression that aic7xxx supports them, but it seems
> not true. What can I tweak on the Linux side to use 6TB volumes?

Both aic7xxx and aic79xx should support up to 32 byte CDBs, but no-one's
actually bothered to inform the kernel of this.  The attached patch will
do this.

There's a problem for you in that you have an aic7xxx and they use a
different SCB for >12 byte cdbs, so they have a separate code path,
which has obviously never been tested ... so don't try this with data
you care about.

James

----

diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 75b2331..e36d053 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -1241,6 +1241,7 @@ ahd_linux_register_host(struct ahd_softc *ahd, struct scsi_host_template *templa
 	host->max_lun = AHD_NUM_LUNS;
 	host->max_channel = 0;
 	host->sg_tablesize = AHD_NSEG;
+	host->max_cmd_len = 32;
 	ahd_lock(ahd, &s);
 	ahd_set_unit(ahd, ahd_linux_unit++);
 	ahd_unlock(ahd, &s);
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index fd2b978..2d069de 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -1115,6 +1115,7 @@ ahc_linux_register_host(struct ahc_softc *ahc, struct scsi_host_template *templa
 	host->max_lun = AHC_NUM_LUNS;
 	host->max_channel = (ahc->features & AHC_TWIN) ? 1 : 0;
 	host->sg_tablesize = AHC_NSEG;
+	host->max_cmd_len = 32;
 	ahc_lock(ahc, &s);
 	ahc_set_unit(ahc, ahc_linux_unit++);
 	ahc_unlock(ahc, &s);


