From: Catalin Muresan <catalin.muresan@astral.ro>
Subject: Re: Apple Xserve RAID and qlogic ISP2312 (qla2300)
Date: Fri, 29 Oct 2004 11:58:00 +0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041029085800.GF6671@astral.ro>
References: <20041027233321.GA842@astral.ro> <20041028143734.GA16358@beaverton.ibm.com> <20041028153522.GC1915@astral.ro> <20041028164210.GA16905@beaverton.ibm.com> <20041028172143.GA20949@praka.san.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dummy.cluj.astral.ro ([193.230.240.25]:29596 "EHLO
	cnn.astral.ro") by vger.kernel.org with ESMTP id S263162AbUJ2JEI
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Oct 2004 05:04:08 -0400
Content-Disposition: inline
In-Reply-To: <20041028172143.GA20949@praka.san.rr.com>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>, Patrick Mansfield <patmans@us.ibm.com>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, bogdan.luca@astral.ro

On Thu, Oct 28, 2004 at 10:21:43AM -0700, Andrew Vasquez wrote:
 > Not wanting to go into the history of the qla2xxx driver's internal
 > port/lun structures, let me just say that the driver should always
 > create an internal 'lun 0' object so that the mid-layer can perform
 > its scan.

	that sound like fixing hardware bugs in software ;)

 > > Catalin - does the device support REPORT LUNS? Do you have that
 > > configured? It would avoid this problem.
 > > 
 > 
 > Yes, Catalin, could you find that out?  I've only had a small amount
 > of exposure with the XRAID box and know that there were some quirks
 > about the device not performing an RFT_ID with the SNS, not sure if
 > that was addressed.

	i don't know how to find that, i'm gonna go and look at the source
and try to figure it out untill you respond.

 > > > 	my goal is to have a kernel with which I can boot from FC, but i see
 > > > that can be done only with an ugly patch(for now) or with tricks from
 > > > initrd.
 > > 
 > > What tricks and ugly patch? I haven't tried boot via qlogic on an HS20.
 > > 
 > 
 > Catalin,  could you enable some debug settings:
 > 
 > In qla_dbg.h, modify the following line:
 > 
 > 	/* #define QL_DEBUG_LEVEL_2  */ /* Output error msgs to COM1 */
 > 
 > to read as:
 > 
 > 	#define QL_DEBUG_LEVEL_2   /* Output error msgs to COM1 */
 > 
 > In qla_settings.h, modify the following line:
 > 
 > 	#define DEBUG_QLA2100           0       /* For Debug of qla2x00 */
 > 
 > to read as:
 > 
 > 	#define DEBUG_QLA2100           1       /* For Debug of qla2x00 */
 > 
 > recompile the driver, load, and forward over the relevent
 > var/log/messages snippet to me.

	will do that asap.

 > BTW: Regarding the internal queues and port/lun objects -- most of our
 > 'experimental' work with 2.6 is begin done with our iSCSI driver.
 > This includes removal of the driver's internal queuing mechanism and
 > dependencies on these port/lun objects being built internally during
 > the driver scan.  Porting (actually mostly pruning) to the FC driver
 > will follow shortly.
 > 
 > --
 > Andrew Vasquez

-- 
Kat
