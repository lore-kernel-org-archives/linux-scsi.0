From: Andries Brouwer <aebr@win.tue.nl>
Subject: Re: Why /dev/sdc1 doesn't show up...
Date: Tue, 19 Nov 2002 23:33:56 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021119223356.GA2525@win.tue.nl>
References: <20021119055636.94C182C088@lists.samba.org> <Pine.GSO.4.21.0211190116420.27757-100000@steklov.math.psu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.GSO.4.21.0211190116420.27757-100000@steklov.math.psu.edu>
List-Id: linux-scsi@vger.kernel.org
To: Alexander Viro <viro@math.psu.edu>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Doug Ledford <dledford@redhat.com>, Linux Scsi Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@transmeta.com>

On Tue, Nov 19, 2002 at 02:12:54AM -0500, Alexander Viro wrote:

> BTW, remember the flamef^Warguments about turning kdev_t into a pointer
> and thus avoiding digging through piles and piles of cr^Hode?  Didn't
> fly for exactly the same reasons - there's no way to do it magically
> for entire kernel without breaking tons of code and/or creating an
> impossible-to-debug mess...

You never convinced me. Maybe we ever meet and can talk..

In the meantime:
Yesterday or so I built versions of 2.5.48 with 32-bit and 64-bit dev_t.

The code is full of conversions dev_t -> int -> dev_t -> int.
Ugly. I gave the mknod method in struct inode_operations type
	int (*mknod) (struct inode *,struct dentry *,int,dev_t);
thus avoiding much conversion.
Do you have objections?

Andries

# mount /dev/hde6 /fbsd6 -t ufs -o ufstype=44bsd,ro
# ./ls -l /fbsd6/dev/da2s[34]
brw-r-----   1     root      disk    4, 0x040012 Oct 31 21:06 /fbsd6/dev/da2s3
brw-r-----   1     root      disk    4, 0x050012 Oct 31 21:06 /fbsd6/dev/da2s4
#
