From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/3] scsi: Move user-shareable stuff in scsi/scsi.h to
	uapi/scsi/scsi.h
Date: Fri, 9 Jan 2015 16:46:13 +0100
Message-ID: <20150109154613.GA29124@lst.de>
References: <1420746479-25949-1-git-send-email-agrover@redhat.com> <1420746479-25949-3-git-send-email-agrover@redhat.com> <20150109101422.GA23804@lst.de> <1420817266.2064.1.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:36744 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757297AbbAIPqQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Jan 2015 10:46:16 -0500
Content-Disposition: inline
In-Reply-To: <1420817266.2064.1.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andy Grover <agrover@redhat.com>, linux-scsi@vger.kernel.org

On Fri, Jan 09, 2015 at 07:27:46AM -0800, James Bottomley wrote:
> Actually, they are exported.  If you look at what glibc supplies, it has
> it's own copies of scsi.h and scsi_ioctl.h.  If we try to repace those
> with uapi, we have to make sure nothing breaks, so the opcodes have to
> be in scsi.h somehow.
> 
> Now, I agree that the opcodes in our scsi.h shouldn't be the definitive
> ones because they're the only the ones the kernel cares about.  However,
> the fact is that any userspace programme including scsi.h and
> scsi_ioctl.h is expecting to get the opcodes and we can't break that.
> 
> Were you thinking of moving opcodes to scsi_opcodes.h and #including
> that in scsi.h but not exporting it so glibc supplies its own?

I don't think trying to replace glibcs fork of our scsi/*.h is
a good use of our time.  They will have keep it complatible with
their old version anyway.  So they will still have to provide their
old subset of operations.

What does however make sense is to export our ioctl ABI.  As with
most other ioctls we should do that through and UAPI linux/*.h file,
e.g. linux/scsi_ioctl.h.  On our side it will replace the existing
ioctl defintions, and if we're careful glibc can also use it include
it from their files.  Trying to export all the opcodes, device types,
SCSI-2 messages and similar on the other hand is a lot of pain for
little gain.

Oh, and we also should have a uapi/linux/sg.h for the ioctls that
came from the sg driver.

