From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Linux Driver test tools?
Date: 01 Jun 2002 14:03:50 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1022936630.20343.37.camel@irongate.swansea.linux.org.uk>
References: <F6A3AFC9BCD92E48B79C14E4AAAEA20F2633D1@nonamea.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <F6A3AFC9BCD92E48B79C14E4AAAEA20F2633D1@nonamea.ptu.promise.com>
List-Id: linux-scsi@vger.kernel.org
To: Haofeng Kou <haofengk@ptu.promise.com>
Cc: linux-scsi@vger.kernel.org

On Sat, 2002-06-01 at 02:42, Haofeng Kou wrote:
> I finish one linux driver and want to do the whole features testing for
> this driver, any body know certain tools for this testing ?
> It is a RAID controller linux scsi driver.

When I'm testing the promise i2o controllers I've run the following
test sets over them

Run fdisk on it - check the geometry and size seem sane

Create an ext2 file system on it
Run bonnie a few times (need to do this anyway to check performance)
unmount it
fsck -f /dev/whatever

It should check the fs and report no errors

remount it
cp -r an entire CD-ROM into a directory on that file system
umount it

fsck -f /dev/whatever

It should again be clean

mount it
Make about 20 copies of the CD in parallel (cp -r blah blah & ; cp -r
....)
unmount it

fsck -f /dev/whatever should be clean

mount it
rm -rf all the data on it
umount it

fsck -f /dev/whatever should be clean

dd if=/dev/zero of=/dev/sdwhatever

[this fills the disk rapidly, and destroys the fs on it, but should not 
hang or spew errors - it tends to show up out of queue type errors]

Run ten of the above at the same time and make sure that works too


You can also use the 'sg' driver to issue raw scsi commands to the
interface, if you want to do things like coverage testing its command
processing.

