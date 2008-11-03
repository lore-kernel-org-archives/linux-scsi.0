From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [RFC 0/9] osdfs
Date: Mon, 03 Nov 2008 16:07:53 -0500
Message-ID: <490F6829.3020104@garzik.org>
References: <4909C41A.7000406@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:53569 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755091AbYKCVIF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Nov 2008 16:08:05 -0500
In-Reply-To: <4909C41A.7000406@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Avishay Traeger <avishay@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, open-osd <osd-dev@open-osd.org>, LKML <linux-kernel@vger.kernel.org>

Boaz Harrosh wrote:
> Please review an OSD based file system. 
> 
> Given that our OSD initiator library is accepted into Kernel, we would
> like to also submit an osdfs. This is the first iteration of this file system.
> 
> The next stage is to make it exportable by the pNFS-over-objects Server.
> osdfs is one of the building blocks for a full, end-to-end open source
> reference implementation of a Server/Client pNFS-over-objects we
> want to have available in Linux. Other parts are the Generic pNFS
> client project with the objects-layout-driver, and the generic pNFS
> server plus osdfs once it is adapted to be exportable.
> (See all about pNFS in Linux at:
> http://wiki.linux-nfs.org/wiki/index.php/PNFS_prototype_design)
> 
> osdfs was originally developed by Avishay Traeger <avishay@gmail.com>
> from IBM. A very old version of it is hosted on sourceforge as the osdfs
> project. It was originally developed for the 2.6.10 Kernel over the old
> IBM's osd-initiator Linux driver.
> 
> Since then it was picked by us, open-osd, and was both forward ported to
> current Kernel, as well as converted to run over our osd Kernel Library.
> The conversion effort, if anyone is interested, is also available as a
> patchset here:
>   git-clone git://git-open-osd.org/open-osd.git osdfs-devel
> or on the web at:
>   http://git.open-osd.org/gitweb.cgi?p=open-osd.git;a=shortlog;h=refs/heads/osdfs-devel
> 
> The Original code is based on ext2 code from the Kernel at the time.
> Further reading is available at the last patch in the osdfs.txt file.
> 
> I have mechanically divided the code in parts, each introducing a
> group of vfs function vectors, all tied at the end into a full filesystem.
> Each patch can be compiled but it will only run at the very end.
> This was done for the hope of easier reviewing.
> 
> Here is the list of patches
> [RFC 1/9] osdfs: osd Swiss army knife
> [RFC 2/9] osdfs: file and file_inode operations
> [RFC 3/9] osdfs: symlink_inode and fast_symlink_inode operations
> [RFC 4/9] osdfs: address_space_operations
> [RFC 5/9] osdfs: dir_inode and directory operations
> [RFC 6/9] osdfs: super_operations and file_system_type
> [RFC 7/9] osdfs: mkosdfs
> [RFC 8/9] osdfs: Documentation

Pretty cool stuff.

I've been wondering when we would start seeing OSD filesystems make 
their appearance.

Random, unordered comments:

* This is important stuff.  Should have been posted to LKML.  Please CC 
LKML in the future.

* As discussed at the filesystem summit, OSD use implies a need for an 
MD-like layer for OSD objects.  Has anyone even started the design work 
for this?

* I tend to think there is room for more than one OSD filesystem in the 
Linux kernel.  Assuming all OSDs will use the same Linux filesystem 
driver will lead to bloat, and you potentially "code yourself into a 
corner."  Let's not rule out multiple filesystems.

As such, "osdfs" seems like too-generic a name. How about boazfs?  :)

* Get this into the kernel ASAP!  OSD stuff languishes outside the 
kernel for _far_ too long.  OSD is a key storage technology that needs 
to be developed in the full light of the Linux community, not off in a 
dark corner somewhere, where few see progress or discussions.

Object-based storage, and its SCSI incarnation OSD, is a MAJOR revision 
of the block storage API, moving away from LBA-addressed linear APIs. 
That's a big deal, and should be discussed on LKML, IMO...

	Jeff





