From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: Apple Xserve RAID and qlogic ISP2312 (qla2300)
Date: Thu, 28 Oct 2004 10:21:43 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041028172143.GA20949@praka.san.rr.com>
References: <20041027233321.GA842@astral.ro> <20041028143734.GA16358@beaverton.ibm.com> <20041028153522.GC1915@astral.ro> <20041028164210.GA16905@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-01-qfe0.socal.rr.com ([66.75.162.133]:46584 "EHLO
	ms-smtp-01-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S261866AbUJ1RWF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Oct 2004 13:22:05 -0400
Content-Disposition: inline
In-Reply-To: <20041028164210.GA16905@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Catalin Muresan <catalin.muresan@astral.ro>, James Bottomley <James.Bottomley@steeleye.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-scsi@vger.kernel.org, bogdan.luca@astral.ro

On Thu, 28 Oct 2004, Patrick Mansfield wrote:

> On Thu, Oct 28, 2004 at 06:35:22PM +0300, Catalin Muresan wrote:
> 
> Ok, that should have been lun 5.
> 
> >  > > Oct 28 01:59:37 zerg-b kernel: scsi_scan_host_selected: <0:4294967295:4294967295:4294967295>
> >  > > Oct 28 01:59:37 zerg-b kernel: scsi scan: INQUIRY to host 0 channel 0 id 0 lun 0
> >  > > Oct 28 01:59:37 zerg-b kernel: scsi scan: 1st INQUIRY failed with code 0x10000
> >  > 
> >  > The 0x10000 is a DID_NO_CONNECT, generally the adapter can't talk to
> >  > the target at all.
> > 
> > 	I don't know what the SCSI spec has to say about this, but by
> > looking at the code it should respond with SCSI_SCAN_TARGET_PRESENT.
> 
> Hmmm ... my interpretation of DID_NO_CONNECT was that the adapter cannot
> talk to the target at all.
> 
> You should be able to send an INQUIRY to any LUN on a target, the HBA
> really shouldn't block it.
> 
> Given that, it is correct for the scan to give SCSI_SCAN_TARGET_PRESENT
> on a DID_NO_CONNECT.
> 

Not wanting to go into the history of the qla2xxx driver's internal
port/lun structures, let me just say that the driver should always
create an internal 'lun 0' object so that the mid-layer can perform
its scan.

> So, it looks like the qlogic is giving a DID_NO_CONNECT when it should
> not. We could hack around this in scsi_scan.c but that might be bad.
> 
> James or Andrew what do you think?
> 

Yuck, the midlayer should not have to change.

> Catalin - does the device support REPORT LUNS? Do you have that
> configured? It would avoid this problem.
> 

Yes, Catalin, could you find that out?  I've only had a small amount
of exposure with the XRAID box and know that there were some quirks
about the device not performing an RFT_ID with the SNS, not sure if
that was addressed.

> > 	my goal is to have a kernel with which I can boot from FC, but i see
> > that can be done only with an ugly patch(for now) or with tricks from
> > initrd.
> 
> What tricks and ugly patch? I haven't tried boot via qlogic on an HS20.
> 

Catalin,  could you enable some debug settings:

In qla_dbg.h, modify the following line:

	/* #define QL_DEBUG_LEVEL_2  */ /* Output error msgs to COM1 */

to read as:

	#define QL_DEBUG_LEVEL_2   /* Output error msgs to COM1 */

In qla_settings.h, modify the following line:

	#define DEBUG_QLA2100           0       /* For Debug of qla2x00 */

to read as:

	#define DEBUG_QLA2100           1       /* For Debug of qla2x00 */

recompile the driver, load, and forward over the relevent
var/log/messages snippet to me.


BTW: Regarding the internal queues and port/lun objects -- most of our
'experimental' work with 2.6 is begin done with our iSCSI driver.
This includes removal of the driver's internal queuing mechanism and
dependencies on these port/lun objects being built internally during
the driver scan.  Porting (actually mostly pruning) to the FC driver
will follow shortly.

--
Andrew Vasquez
