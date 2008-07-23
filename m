From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [RFC PATCH] HP (Compaq) Smart Array 5xxx controller SCSI driver
Date: Wed, 23 Jul 2008 22:46:49 +0900
Message-ID: <20080723224432G.tomof@acm.org>
References: <20080719195150Y.fujita.tomonori@lab.ntt.co.jp>
	<48858611.8020401@suse.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754328AbYGWNrc@vger.kernel.org>
In-Reply-To: <48858611.8020401@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: hare@suse.de
Cc: fujita.tomonori@lab.ntt.co.jp, mike.miller@hp.com, James.Bottomley@HansenPartnership.com, Jens.Axboe@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 22 Jul 2008 09:02:41 +0200
Hannes Reinecke <hare@suse.de> wrote:

> > There isn't any easy migration path for users. So I think that we need
> > to keep the block and scsi drivers for cciss for some time (say two
> > years).
> > 
> > My scsi driver is still in an early stage (I tried to keep the changes
> > minimum). I can detect logical units, mount a file system, do lots of
> > I/Os, however, there are lots of TODOs in the management features.
> > 
> > If I can get an ACK from HP about the long-term migration of cciss to
> > SCSI, I'm happy to keep working on the SCSI cciss driver and maintain
> > it until HP takes over the driver.
> > 
> First of all, thanks, Tomo, for doing this.
> It's been on my to-do list for about as long as I started looking on
> the cciss code. However, some thoughts:
> 
> - Having cciss using the SCSI infrastructure is indeed far more logical.
>   Although it looks as if it doesn't support the SCSI spec in full
>   (ie no conformity claimed in the INQUIRY data) it certainly implements
>   quite a large subset.

I'm not sure about this. The ciss spec says that the controllers
support mandatory SCSI commands. About INQUIRY data, at least, debian
udev rules nicely created symbolic links under /dev/disk/by-id/.


> - The error handling in the SCSI infrastructure is far better structured
>   as that one in the existing cciss driver, so the SCSI driver would
>   benefit from this.

Agreed, this is an area that we can improve greatly with the scsi
infrastructure, I think.


> - Nevertheless, the cciss driver and the corresponding sysfs / device node
>   layout has become the de-facto standard over the years and it will be
>   _hard_ to change that.
> 
> - However, given that the sysfs information from the cciss driver is quite
>   rudimentary I doubt if anyone will indeed notice if the _internal_ driver
>   is a SCSI or a block level driver, as long as the _external_ interface
>   (ioctl, device-node layout etc) stays the same.
> 
> Having said that I think this is the direction it should take:
> 
> - Split the existing cciss driver in two parts, one part for the
>   block-level interface and one for the lower-level device handling bits.
> - Redo the patch based on that, so that existing code can be shared
>   (and fixes there would be included in both drivers).
> - Add some hooks/safeguards so that only _one_ interface driver can
>   be loaded.
> 
> This way we would be able keep the existing functionality and allow
> users to play around with the new driver.
> Long-term we can start moving the driver itself to SCSI, and keeping
> the existing cciss block interface only as a wrapper which adjusts
> the major:minor numbers; the device-node layout can be handled by udev.

Agreed about keeping the existing interfaces (changing only the
internal implementation, which users don't care about). I thought
about the similar things (tricks like ide-scsi does) during writing a
patch but also thought that udev rules can do the similar jobs, as
James pointed out. And seems that udev rules nicely works.
