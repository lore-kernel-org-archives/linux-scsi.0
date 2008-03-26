From: "Dan Williams" <dan.j.williams@intel.com>
Subject: get device sysfs path ioctl (was: Re: What to do about the 2TB limit on HDIO_GETGEO ?)
Date: Tue, 25 Mar 2008 21:21:18 -0700
Message-ID: <e9c3a7c20803252121s3eca3576v4d92dbab2afb68f2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg KH <gregkh@suse.de>, Randy Dunlap <randy.dunlap@oracle.com>, Mark Lord <lkml@rtr.ca>, Jens Axboe <axboe@kernel.dk>, Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <htejun@gmail.com>, Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, NeilBrown <neilb@suse.de>
List-Id: linux-scsi@vger.kernel.org

[ adding Neil to the cc ]

On Tue, Mar 25, 2008 at 2:26 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Greg KH wrote:
>  > On Tue, Mar 25, 2008 at 01:36:51PM -0700, H. Peter Anvin wrote:
>  >> Randy Dunlap wrote:
>  >>>> Come on people, adding symlinks for device major:minor numbers in sysfs
>  >>>> to save a few 10s of lines of userspace code?  Can things get sillier?
>  >>>>
>  >>>> You can add a single udev rule to probably build these in a tree in /dev
>  >>>> if you really need such a thing...
>  >>>>
>  >>>> And what's wrong with your new ioctl recomendation?
>  >>> Ah, there's some sanity.  :)
>  >> It's not so much an issue of a few tens of lines of user space code, but
>  >> rather the fact that something that should be O(1) is currently O(n).
>  >
>  > "should"?  why?  Is this some new requirement that everyone needs?  I've
>  > _never_ seen anyone ask for the ability to find sysfs devices by
>  > major:minor number in O(1) time.  Is this somehow a place where such
>  > optimization is warranted?
>
>  Well, when dealing with shell scripts a O(n) very easily becomes O(n^2).
>   For the stuff that I, personally, do, it's not a big deal, but people
>  with large number of disks have serious gripes with our boot times.
>

I will jump in here to point out there would be another user of such
an interface.  Neil proposed an ioctl to retrieve the sysfs path of a
device as part of his md support for external metadata.

Neil's initial patch:
http://marc.info/?l=linux-raid&m=119761445714319&w=2

My attempt to push things along:
http://marc.info/?l=linux-kernel&m=120132398120816&w=2

--
Dan
