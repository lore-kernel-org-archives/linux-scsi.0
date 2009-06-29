From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: can't access LUN >2TB with aic7xxx, Infortrend EonStor and
	2.6.31-rc1
Date: Mon, 29 Jun 2009 07:46:03 -0600
Message-ID: <20090629134602.GN5480@parisc-linux.org>
References: <20090629130835.GA3657@mother.pipebreaker.pl> <20090629133431.GM5480@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:36014 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758566AbZF2NqB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2009 09:46:01 -0400
Content-Disposition: inline
In-Reply-To: <20090629133431.GM5480@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomasz Torcz <tomek@pipebreaker.pl>
Cc: linux-scsi@vger.kernel.org

On Mon, Jun 29, 2009 at 07:34:31AM -0600, Matthew Wilcox wrote:
> SCSI commands come in different sizes.  Drivers are assumed to support
> commands up to 12 bytes long, unless they report otherwise by setting
> their max_cmd_len parameter.  Unfortunately, the command that reports
> the device capacity for devices over 2TB is a 16 byte command, and the
> aic7xxx driver doesn't claim it supports 16 byte commands, so we refuse
> to even send it to the driver.
> 
> It's possible the aic7xxx hardware does support 16 byte commands.  If so,
> this is an easy fix.  If it doesn't, you could try replacing the card
> with one that does (for example, the LSI 8xx and 10xx cards all support
> 16 byte commands).
> 
> You could also go for a configuration fix where you reconfigure the array
> with LUNs below 2TB and then use MD or DM to stitch them back together
> into a single device.
> 
> Let's hope someone who understands the aic7xxx hardware can tell us
> whether it supports 16 byte commands or not.

I should have read the driver more thoroughly before writing that email.

It seems the driver does support larger commands.  Here's the hint:

        hscb->cdb_len = cmd->cmd_len;
        if (hscb->cdb_len <= 12) {
                memcpy(hscb->shared_data.cdb, cmd->cmnd, hscb->cdb_len);
        } else {
                memcpy(hscb->cdb32, cmd->cmnd, hscb->cdb_len);
                scb->flags |= SCB_CDB32_PTR;
        }

The aic79xx is a little more tricky ... it seems it has different cases to
support 12, 16 and >16 byte CDBs, but it's not clear that the >16 byte CDB case is implemented.  Let's be conservative for now and bump it up to 16 bytes instead of 32.


diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 75b2331..3853f33 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -1241,6 +1241,7 @@ ahd_linux_register_host(struct ahd_softc *ahd, struct scsi_host_template *templa
 	host->max_lun = AHD_NUM_LUNS;
 	host->max_channel = 0;
 	host->sg_tablesize = AHD_NSEG;
+	host->max_cmd_len = 16;
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

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
