From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: unexpected sync delays in dpkg for small pre-allocated files on
 ext4
Date: Wed, 1 Jun 2016 10:12:18 -0400
Message-ID: <20160601141218.GE5357@thunk.org>
References: <57448A5D.4050805@siemens.com>
 <20160524231328.GB387@thunk.org>
 <574BF988.5050202@siemens.com>
 <20160531002152.GQ26977@dastard>
 <574EAE69.5040003@siemens.com>
 <574EE05A.9070302@siemens.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56782 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750697AbcFAOMW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Jun 2016 10:12:22 -0400
Content-Disposition: inline
In-Reply-To: <574EE05A.9070302@siemens.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gernot Hillier <gernot.hillier@siemens.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-scsi@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com, linux-ext4@vger.kernel.org, sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com

On Wed, Jun 01, 2016 at 03:17:14PM +0200, Gernot Hillier wrote:
> I repeated the discussed tests and found comparable results on this machine:
> 
> - 3 seconds dpkg install time on ext3 vs. 80 seconds for ext4
>   on same partition for same package
> - 40 ms for fallocate+write+sync_file_range for writing a few bytes
> - 15 ms for write+fdatasync vs. 45 ms for BLKZEROOUT on raw device
> 
> So this seems to be not bound to one specific disk+controller setup, but
> it still can't be a common problem affecting many people as then we
> would see more reports about it...

OK, so let's try to get common baseline, shall we?  I'm using as my
test package:

http://debug.mirrors.debian.org/debian-debug/pool/main/e/e2fsprogs/e2fsprogs-dbgsym_1.43-2_amd64.deb

% ls -s /tmp/e2fsprogs-dbgsym_1.43-3_amd64.deb
1108 /tmp/e2fsprogs-dbgsym_1.43-3_amd64.deb
% md5sum /tmp/e2fsprogs-dbgsym_1.43-3_amd64.deb
148ee631f46ed2e05a17faf36cc9d630  /tmp/e2fsprogs-dbgsym_1.43-3_amd64.deb

# dpkg --purge e2fsprogs-dbgsym
(Reading database ... 322967 files and directories currently installed.)
Removing e2fsprogs-dbgsym (1.43-3) ...

# /usr/bin/time dpkg --force-depends -i /tmp/e2fsprogs-dbgsym_1.43-3_amd64.deb 
Selecting previously unselected package e2fsprogs-dbgsym.
(Reading database ... 322947 files and directories currently installed.)
Preparing to unpack .../e2fsprogs-dbgsym_1.43-3_amd64.deb ...
Unpacking e2fsprogs-dbgsym (1.43-3) ...
Setting up e2fsprogs-dbgsym (1.43-3) ...
0.21user 0.19system 0:00.54elapsed 74%CPU (0avgtext+0avgdata 73188maxresident)k
0inputs+10168outputs (0major+24935minor)pagefaults 0swaps

Something else would be useful is to make sure /tmp is a tmpfs mounted
file system (so you don't get any I/O's caused by /tmp), and then do:

# dpkg --purge e2fsprogs-dbgsym
# btrace /dev/sda3 > /tmp/btrace.out &
# /usr/bin/time dpkg --force-depends -i /tmp/e2fsprogs-dbgsym_1.43-3_amd64.deb
# kill %btrace

Replace /dev/sda3 with the device name of your root partition, and
then send us the compressed btrace.out file, which might give us a
clue about what is going on.

Cheers,

					- Ted
