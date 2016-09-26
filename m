From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: UAS driver seems to be reporting a 4k sector size for a 512 byte
 sector device?
Date: Mon, 26 Sep 2016 17:52:47 -0400
Message-ID: <20160926215247.nplawebmdmyarldo@thunk.org>
References: <20160926161926.cmayrily476v3wa7@thunk.org>
 <20160926162511.GA1949@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34688 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1423793AbcIZVy2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Sep 2016 17:54:28 -0400
Content-Disposition: inline
In-Reply-To: <20160926162511.GA1949@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net

On Mon, Sep 26, 2016 at 09:25:11AM -0700, Christoph Hellwig wrote:
> On Mon, Sep 26, 2016 at 12:19:26PM -0400, Theodore Ts'o wrote:
> > Is this a problem with the hardware, or with the UAS driver?
> 
> UAS is just SCSI transport, and doesn't touch the content of command,
> so it's a very unlikely culprit.  The SCSI layer intreprets it, but I
> don't really think it's doing any of this either..  Your bridge most
> likely always reports 4k sectors when using UAS for some reason.
> 
> To verify this call sg_readcap on the device node for both the
> usb-storage and uas mode.

sg_readcap doesn't report the physical sector size, just the logical
block size:

# sg_readcap  /dev/sdd
Read Capacity results:
   Last logical block address=4000797359 (0xee7752af), Number of blocks=4000797360
   Logical block length=512 bytes
Hence:
   Device size: 2048408248320 bytes, 1953514.3 MiB, 2048.41 GB

And this is the same for both with and with UAS.

So with UAS we get:

# blockdev --getpbsz /dev/sdd
4096

...even though hdparm -I reports:

	Logical  Sector size:                   512 bytes
	Physical Sector size:                   512 bytes

I guess this is mostly cosmetic, since although lsblk -t reports:

# lsblk -t
NAME                    ALIGNMENT MIN-IO   OPT-IO PHY-SEC LOG-SEC ROTA SCHED RQ-SIZE  RA WSAME
sdd                             0   4096 33553920    4096     512    1 cfq       128 128   32M
├─sdd2                          0   4096 33553920    4096     512    1 cfq       128 128   32M
│ └─callcc_crypt               -1   4096        0    4096     512    1           128 128    0B

nothing is actually _breaking_ since the logical sector size is still
512, and the minimum I/O and physical sector size are performance
hints.

							- Ted

