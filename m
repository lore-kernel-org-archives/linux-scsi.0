From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [BK PATCH] SCSI update for 2.6.3
Date: Tue, 24 Feb 2004 10:15:12 -0800
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20040224101512.A19617@beaverton.ibm.com>
References: <Pine.LNX.4.58.0402240919490.1129@spektro.metla.fi> <20040224170412.GA31268@kroah.com> <1077642529.1804.170.camel@mulgrave> <20040224171629.GA31369@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20040224171629.GA31369@kroah.com>; from greg@kroah.com on Tue, Feb 24, 2004 at 09:16:29AM -0800
To: Greg KH <greg@kroah.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Kai Makisara <Kai.Makisara@metla.fi>, Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, kai.makisara@kolumbus.fi
List-Id: linux-scsi@vger.kernel.org

On Tue, Feb 24, 2004 at 09:16:29AM -0800, Greg KH wrote:

> 
> Can you print out the sysfs tree this patch creates?
> 
> What's that "tape" symlink for?  Does it go from the scsi device in
> /sys/devices/... to the class device?  Or the other way around?
> 
> Other than that question, the patch looks sane to me.

Current 2.6 kernel default names are of the form: st[0-9]m[0-3][n]

Current /dev naming is of the form: [n]st[0-9][alm]

Should the st kernel names be changed to map to current /dev names?

For udev, even with that we need differing pre and postfix values wrapped
around a peristent name.

Here's /dev and /udev (for a dlt tape drive):

[elm3a49 Documentation]$ ls -l /udev/*st0* | sort -k 5
crw-------    1 root     root       9,   0 Feb 24 17:47 /udev/st0m0
crw-------    1 root     root       9,  32 Feb 24 17:47 /udev/st0m1
crw-------    1 root     root       9,  64 Feb 24 17:47 /udev/st0m2
crw-------    1 root     root       9,  96 Feb 24 17:47 /udev/st0m3
crw-------    1 root     root       9, 128 Feb 24 17:47 /udev/st0m0n
crw-------    1 root     root       9, 160 Feb 24 17:47 /udev/st0m1n
crw-------    1 root     root       9, 192 Feb 24 17:47 /udev/st0m2n
crw-------    1 root     root       9, 224 Feb 24 17:47 /udev/st0m3n
[elm3a49 Documentation]$ ls -l /dev/*st0* | sort -k 5
crw-rw----    1 root     tape       9,   0 Nov 14 14:34 /dev/st0
crw-rw----    1 root     tape       9,  32 Nov 14 14:34 /dev/st0l
crw-rw----    1 root     tape       9,  64 Nov 14 14:34 /dev/st0m
crw-rw----    1 root     tape       9,  96 Nov 14 14:34 /dev/st0a
crw-rw----    1 root     tape       9, 128 Nov 14 14:34 /dev/nst0
crw-rw----    1 root     tape       9, 160 Nov 14 14:34 /dev/nst0l
crw-rw----    1 root     tape       9, 192 Nov 14 14:34 /dev/nst0m
crw-rw----    1 root     tape       9, 224 Nov 14 14:34 /dev/nst0a

-- Patrick Mansfield
