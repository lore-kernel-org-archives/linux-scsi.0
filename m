From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Move scsi.h, hosts.h to include/linux/scsi ?
Date: Mon, 17 Feb 2003 12:18:40 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030217121840.A24543@infradead.org>
References: <20030216211422.GD8572@mars.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030216211422.GD8572@mars.ravnborg.org>; from sam@ravnborg.org on Sun, Feb 16, 2003 at 10:14:22PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-scsi@vger.kernel.org

On Sun, Feb 16, 2003 at 10:14:22PM +0100, Sam Ravnborg wrote:
> The usual rule within the kernel is that all header files useby more than
> one file, or at least by files spread all over the kernel,
> should be located in include/linux.
> 
> Has this been considered for scsi.h, and if not so - why not?
> The same for hosts.h.
> 
> Background for my question is that I'm doing some kbuild changes,
> and it is rather annoying to support include of scsi.h from all over.
> See the following snippet from: arch/i386/kernel/edd.c

It's not that simple.  First the current hosts.h/scsi.h split doesn't make
sense.  Second include/linux/scsi/ is a bad idea, either add more headers to
include/scsi/ or include/linux/.

I'd prefer either

	include/scsi/core.h
	include/scsi/hba.h
	include/scsi/upper.h

or

	include/linux/scsi.h (for everything)

plus a drivers/scsi/scsiP.h for stuff private to the midlayer.
