From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [RFC] libata support for async scanning
Date: Sat, 13 May 2006 07:16:39 -0600
Message-ID: <20060513131639.GT12272@parisc-linux.org>
References: <20060513050529.GS12272@parisc-linux.org> <44656BBE.7020806@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:33234 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S932426AbWEMNQl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 13 May 2006 09:16:41 -0400
Content-Disposition: inline
In-Reply-To: <44656BBE.7020806@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org

On Sat, May 13, 2006 at 01:16:46AM -0400, Jeff Garzik wrote:
> Matthew Wilcox wrote:
> >I don't think SATA target scanning occupies a huge amount of boot time,
> >however it will currently force all async scanners to complete before it
> >scans.  The Rolls-Royce solution would be somethinkg akin to the new
> >scsi_scan_host(), but I don't think that's necessaary.  This patch just
> >acknowledges that async scanning exists and will permit the drive
> >additions to finish some time after libata has triggered the probe.
> 
> This seems to add needless complexity.

It doesn't, honest.

> The internal probe is complete before the loop begins.  Thus, 
> ata_scan_scan_host() is simply walking data structures in memory (due to 
> SCSI simulator) for ATA devices, and for ATAPI devices parallelism is 
> largely inadvisable :)  Its overkill, and in some rare cases could make 
> debugging more annoying.

It won't be parallelised with respect to itself, just with respect to
other scsi scans.  See my message
http://marc.theaimsgroup.com/?l=linux-scsi&m=114735805518594&w=2

Without this patch (on top of that one), libata's calls to
scsi_scan_target() will block until all asynchronous scans have
completed (see the conditional call to scsi_complete_async_scans() in
scsi_scan_target()).  With this patch, libata will scan the targets
in parallel with other scsi hosts scanning their targets.  It will still
block, but it'll do it later, when it calls scsi_finish_async_scan().

Hmm.  Maybe I can improve the API such that scsi_finish_async_scan()
won't make it block ...

Anyway, the point here is actually to make your life easier.  If someone
has a lot of scsi hosts and libata doesn't have this patch, all of a
sudden people are going to be asking you why libata's taking so long to
initialise.  And if you debug it, you'll find it's sleeping in
scsi_complete_async_scans().
