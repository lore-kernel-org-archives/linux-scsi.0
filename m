From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/1] build modular usb isd200 with modular ide
Date: Sun, 24 Oct 2004 12:03:19 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041024100319.GA17183@lst.de>
References: <200410240055.i9O0taCf006206@falcon10.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:35234 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261416AbUJXKDv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Oct 2004 06:03:51 -0400
Content-Disposition: inline
In-Reply-To: <200410240055.i9O0taCf006206@falcon10.austin.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Doug Maxey <dwm@austin.ibm.com>
Cc: Bartlomiej Zolnierkiewicz <B.Zolnierkiewicz@elka.pw.edu.pl>, Paul Mackerras <paulus@samba.org>, Greg Kroah-Hartman <greg@kroah.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux IDE Mailing List <linux-ide@vger.kernel.org>, linuxppc64-dev@ozlabs.org

On Sat, Oct 23, 2004 at 07:55:36PM -0500, Doug Maxey wrote:
> 
> Name: inline ide_fix_driveid()
> 
> Rationale:
> 	This is a fix for bugme.osdl 3819.

bugme.osdl.org doesn't know of a bug #3819.

> 	With any of the 2.6.9 release flavors (vanilla, mm1, ac3), one
> 	cannot build the usb isd200 module due to the dependency on
> 	ide_fix_driveid() being exported from ide-iops.
> 
> Description:
> 	When building IDE modular, the current ide_fix_driveid() is
> 	exported from ide-iops.c.  This patch makes the function an inline.

Still doesn't make any sense. ide_fix_driveid is properly exported from
ide-iops.c, so you use it from other modules.  The only case that
doesn't work is modular ide and builtin usb-storage, and the BLK_DEV_IDE 
depency should fix that one.

If you think that depency is ugly (I do) just copy the routine to
isd200.c, it's a) too large to inline but b) just a trivial byteswap
that should need much changes over time.

