From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Another SCSI Sync
Date: Wed, 5 Mar 2003 11:01:29 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030305190129.GG1090@beaverton.ibm.com>
References: <1046315953.1834.177.camel@mulgrave> <Pine.LNX.4.44.0303050753080.4759-100000@home.transmeta.com> <20030305181003.GC1090@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030305181003.GC1090@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@transmeta.com>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

The patch below fixed the problem on my system. I had my list empty
checks reversed if aborting and bus device reset failed. The condition
that causes the error handler to run is still unknown. I will look at it
when I get a chance.

The patch applies to 2.5.63, 2.5.64 and scsi-misc-2.5

Mike Anderson [andmike@us.ibm.com] wrote:
> I am looking at this now. I switched my config from new AIC to old AIC
> and see a failure similar to what Andrew Morton was seeing when he switched.
> 
> It looks to be a bug in error handling while probing.
> 
> Linus Torvalds [torvalds@transmeta.com] wrote:
> > 
> > Hmm.. Some part of the last syncs seem to break for a lot of people. See
> > the linux kernel mailing list. One report (Rob Radez <rob@osinvestor.com>)  
> > chased it down some:
> > 
> > 	On Tue, Mar 04, 2003 at 11:42:41PM -0600, David van Hoose wrote:
> > 	> Kernels 2.5.63 and 2.5.64 lock up when displaying the information for my 
> > 	> ZipDrive during SCSI probe. Attached is my .config for 2.5.64.
> > 
> > 	I suspect I'm seeing something similar.  On SPARC, I'm getting a hang
> > 	after displaying the information for my SCSI CD-ROM drive.
> > 
> > 	scsi0 : Sparc ESP100A-FAST
> > 	Vendor: SEAGATE   Model: ST31200W SUN1.05  Rev: 8724
> > 	Type:   Direct-Access                      ANSI SCSI revision: 02
> > 	Vendor: SEAGATE   Model: ST32155W SUN2.1G  Rev: 8456
> > 	Type:   Direct-Access                      ANSI SCSI revision: 02
> > 	Vendor: TOSHIBA   Model: XM-4101TASUNSLCD  Rev: 1755
> > 	Type:   CD-ROM                             ANSI SCSI revision: 02
> > 	<hang>
> > 
> > 	Worked fine in 2.5.62, hangs in 2.5.63. Reverting the scsi changes
> > 	listed at
> > 		http://osinvestor.com/sparc/patch/2.5.63-revertscsi.diff
> > 	allows 2.5.63 to boot.
> > 
> > Please check it out.. The common thread seems to be "non-disk".
> > 
> > 		Linus
-andmike
--
Michael Anderson
andmike@us.ibm.com


=====
name:		00_scsi_error_ready_devs-1.diff
version:	2003-03-05.10:39:28-0800
against:	2.5.63

 scsi_error.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

=====
===== drivers/scsi/scsi_error.c 1.38 vs edited =====
--- 1.38/drivers/scsi/scsi_error.c	Sat Feb 22 08:17:01 2003
+++ edited/drivers/scsi/scsi_error.c	Wed Mar  5 10:14:22 2003
@@ -1490,9 +1490,9 @@
 			       struct list_head *work_q,
 			       struct list_head *done_q)
 {
-	if (scsi_eh_bus_device_reset(shost, work_q, done_q))
-		if (scsi_eh_bus_reset(shost, work_q, done_q))
-			if (scsi_eh_host_reset(work_q, done_q))
+	if (!scsi_eh_bus_device_reset(shost, work_q, done_q))
+		if (!scsi_eh_bus_reset(shost, work_q, done_q))
+			if (!scsi_eh_host_reset(work_q, done_q))
 				scsi_eh_offline_sdevs(work_q, done_q);
 }
 

