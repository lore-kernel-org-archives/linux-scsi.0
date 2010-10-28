From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [Bug 13602] some HFS CD-ROM's can't be read
Date: Thu, 28 Oct 2010 10:28:45 -0500
Message-ID: <1288279725.3043.49.camel@mulgrave.site>
References: <bug-13602-11613@https.bugzilla.kernel.org/>
	 <201010281253.o9SCr5d8024479@demeter1.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38720 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757524Ab0J1P2u (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Oct 2010 11:28:50 -0400
In-Reply-To: <201010281253.o9SCr5d8024479@demeter1.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

On Thu, 2010-10-28 at 12:53 +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=13602
> 
> 
> Christoph Hellwig <hch@lst.de> changed:
> 
>            What    |Removed                     |Added
> ----------------------------------------------------------------------------
>           Component|HFS/HFSPLUS                 |SCSI
>          AssignedTo|hch@lst.de                  |linux-scsi@vger.kernel.org
>             Product|File System                 |IO/Storage

Why is this actually a bug?  Linux has never supported filesystem block
sizes smaller than device ones ... we don't have the necessary RMW code
for it.  The sr driver supports 512 byte sectors but *only* if the CD
was burned with them (which isn't always possible depending on CD
burner) and the reader supports them.  I'd need the dmesgs to be sure
but i'd guess READ_CAPACITY on this cd returns 2048 as the block size.

James


