From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 1/1] build modular usb isd200 with modular ide
Date: Sun, 24 Oct 2004 14:45:53 +0200
Sender: linux-ide-owner@vger.kernel.org
Message-ID: <58cb370e041024054575c09679@mail.gmail.com>
References: <200410240055.i9O0taCf006206@falcon10.austin.ibm.com>
	 <20041024100319.GA17183@lst.de>
Reply-To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20041024100319.GA17183@lst.de>
To: Christoph Hellwig <hch@lst.de>
Cc: Doug Maxey <dwm@austin.ibm.com>, Paul Mackerras <paulus@samba.org>, Greg Kroah-Hartman <greg@kroah.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux IDE Mailing List <linux-ide@vger.kernel.org>, linuxppc64-dev@ozlabs.org
List-Id: linux-scsi@vger.kernel.org

On Sun, 24 Oct 2004 12:03:19 +0200, Christoph Hellwig <hch@lst.de> wrote:
> On Sat, Oct 23, 2004 at 07:55:36PM -0500, Doug Maxey wrote:
> >
> > Name: inline ide_fix_driveid()
> >
> > Rationale:
> >       This is a fix for bugme.osdl 3819.
> 
> bugme.osdl.org doesn't know of a bug #3819.
> 
> >       With any of the 2.6.9 release flavors (vanilla, mm1, ac3), one
> >       cannot build the usb isd200 module due to the dependency on
> >       ide_fix_driveid() being exported from ide-iops.
> >
> > Description:
> >       When building IDE modular, the current ide_fix_driveid() is
> >       exported from ide-iops.c.  This patch makes the function an inline.
> 
> Still doesn't make any sense. ide_fix_driveid is properly exported from
> ide-iops.c, so you use it from other modules.  The only case that
> doesn't work is modular ide and builtin usb-storage, and the BLK_DEV_IDE
> depency should fix that one.

The new ide_fix_driveid function seems buggy,
ie. it byte-swaps id->max_multsect with id->vendor3.

> If you think that depency is ugly (I do) just copy the routine to
> isd200.c, it's a) too large to inline but b) just a trivial byteswap
> that should need much changes over time.

The dependency is a bug, <linux/ide.h> is for IDE driver only.

Doug, if you kill debugging code in isd200.c then only:

id->command_set_1
id->model
id->fw_rev
id->capability
id->lba_capacity
id->heads
id->cyls
id->sectors
id->command_set_2

need to be byte-swapped.
