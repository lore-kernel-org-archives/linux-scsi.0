From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: 'Device not ready' issue on mpt2sas since 3.1.10
Date: Wed, 25 Jul 2012 23:55:55 +0400
Message-ID: <1343246155.12094.59.camel@dabdike>
References: <4FFB8A86.7000009@farcaster.org>
	 <4FFCBA4C.4000502@farcaster.org> <4FFD6F3D.2030708@matthiasprager.de>
	 <4FFD8410.7050604@matthiasprager.de> <20120717180932.GB2878@google.com>
	 <5005BF7D.2050703@matthiasprager.de> <20120717200136.GC24336@google.com>
	 <500A9D7C.8080801@matthiasprager.de>
	 <20120722173146.GE5144@dhcp-172-17-108-109.mtv.corp.google.com>
	 <1343225953.12094.55.camel@dabdike> <20120725171723.GB32378@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:47877 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752432Ab2GYT4D (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jul 2012 15:56:03 -0400
In-Reply-To: <20120725171723.GB32378@google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Matthias Prager <linux@matthiasprager.de>, Robert Trace <maillist@farcaster.org>, linux-scsi@vger.kernel.org, Jens Axboe <jaxboe@fusionio.com>, Eric Moore <Eric.Moore@lsi.com>, Alan <alan@lxorguk.ukuu.org.uk>, "Darrick J. Wong" <djwong@us.ibm.com>, linux-ide@vger.kernel.org

On Wed, 2012-07-25 at 10:17 -0700, Tejun Heo wrote:
> Hello, James.
> 
> On Wed, Jul 25, 2012 at 06:19:13PM +0400, James Bottomley wrote:
> > > I haven't consulted SAT but it seems like a bug in SAS driver or
> > > firmware.  If it's a driver bug, we better fix it there.  If a
> > > firmware bug, working around those is one of major roles of drivers,
> > > so I think setting allow_restart is fine.
> > 
> > Actually, I don't think so.  SAT-2 section 8.12.2 does say 
> > 
> >         if the device is in the stopped state as the result of
> >         processing a START STOP UNIT command (see 9.11), then the SATL
> >         shall terminate the TEST UNIT READY command with CHECK CONDITION
> >         status with the sense key set to NOT READY and the additional
> >         sense code of LOGICAL UNIT NOT READY, INITIALIZING COMMAND
> >         REQUIRED;
> > 
> > START STOP UNIT (with START=0) translates to STANDBY IMMEDIATE, and
> > that's what hdparm -y issues.  We don't see this in /drivers/ata because
> > TEST UNIT READY always returns success.
> 
> Urgh... ATA device in standby mode is ready for any command and
> definitely doesn't need an "initializing command".  Oh, well...

Well, it does in sleep mode ... which seems to most closely map to what
SCSI thinks of as a stopped unit. I checked the specs just in case there
was an error ... they all say STANDBY not SLEEP.

> > So it looks like the mpt2sas SAT is doing the correct thing and we only
> > don't see this problem in normal SATA devices because of a bug in the
> > libata-scsi SAT.
> 
> libata is inconsistent with the standard but I think the standard is
> wrong here. :(

Well, reading it, so do I.  Unfortunately, we get to deal with the world
as it is rather than as we would wish it to be.  We likely have this
problem with a lot of USB SATLs as well ...

It looks like a hack like this might be needed.

James

---

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 4a6381c..7e59a7f 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -42,6 +42,8 @@
 
 #include <trace/events/scsi.h>
 
+static void scsi_eh_done(struct scsi_cmnd *scmd);
+
 #define SENSE_TIMEOUT		(10*HZ)
 
 /*
@@ -241,6 +243,14 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 	if (! scsi_command_normalize_sense(scmd, &sshdr))
 		return FAILED;	/* no valid sense data */
 
+	if (scmd->cmnd[0] == TEST_UNIT_READY && scmd->scsi_done != scsi_eh_done)
+		/* 
+		 * nasty: for mid-layer issued TURs, we need to return the
+		 * actual sense data without any recovery attempt.  For eh
+		 * issued ones, we need to try to recover and interpret
+		 */
+		return SUCCESS;
+
 	if (scsi_sense_is_deferred(&sshdr))
 		return NEEDS_RETRY;
 
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 56a9379..91d3366 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -764,6 +764,16 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	sdev->model = (char *) (sdev->inquiry + 16);
 	sdev->rev = (char *) (sdev->inquiry + 32);
 
+	if (strncmp(sdev->vendor, "ATA     ", 8) == 0) {
+		/* 
+		 * sata emulation layer device.  This is a hack to work around
+		 * the SATL power management specifications which state that
+		 * when the SATL detects the device has gone into standby
+		 * mode, it shall respond with NOT READY.
+		 */
+		sdev->allow_restart = 1;
+	}
+
 	if (*bflags & BLIST_ISROM) {
 		sdev->type = TYPE_ROM;
 		sdev->removable = 1;


