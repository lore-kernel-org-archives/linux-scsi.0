From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH 2/2] convert sg to blk_rq map functions
Date: Mon, 15 Aug 2005 22:29:24 +1000
Message-ID: <43008AA4.6000002@torque.net>
References: <1123562301.6090.14.camel@max>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:16567 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S932294AbVHOM3Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Aug 2005 08:29:24 -0400
In-Reply-To: <1123562301.6090.14.camel@max>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org

Mike Christie wrote:
> Make sg.c use block layer functions so we always use
> scatterlists in scsi.
> 
> Changes from original driver (junk that is broken or
> new *features* :) ):
> 
> - mmap currently not supported. Need some block layer helpers
> so we can support this for all ULDs. Is this needed?

In my testing, mmap-ed IO via sg was faster than DIO which
in turn was faster than using the reserve buffer. So IMO
mmap-ed was the fastest while double buffered IO was the
most robust (e.g. no alignment problems).

One reason for this could be that sg's mmap-ed used its
reserve buffer allocated with 32 KB scatg elements
rather than DIO's user space memory which is almost
always discontiguous PAGE_SIZE (4 KB) blocks.

> - Always do DIO for the new interface if buffer is aligned properly.

In my early testing DIO locked up from time to time
and I put it down to LLD problems (as the more expensive
hardware didn't exhibit problems); hence the
/proc/scsi/sg/allow_dio flag. Hopefully those problems
are a thing of the past.

sg_io_hdr::info could be used to indicate whether DIO
was done or not (as is the present case in sg).

But if you are changing things, why not follow the
user supplied O_DIRECT open() flag?

> - Always obey LLD queue restrictions.

Depends which ones :-)
What have blocks (512 or 2048 byte) got to do with
a task like writing firmware via the WRITE BUFFER
command (which is in SPC-3 rather than SBC-2)?
Scatter gather lists need limits, some of:
  - number of elements
  - max size per element
  - max overall size

If either of the latter are denominated in blocks then
something is amiss. The device can talk about blocks
(see the Block Limits VPD page (0xb0) in SBC-2) but
not the LLD. Think SSC, OSD and block devices with
protection information (see SBC-2). SCSI, at the Primary
Command (SPC-3) level, is byte oriented.

That Block Limits VPD page makes an important distinction:
maximum versus optimal transfer lengths. It also specifies
optimal granularity. A generic block layer should concentrate
on optimal values, a pass-through, on maximum values. Also
with a pass-through talking to a device with transfer length
limits, the user of the pass-through is responsible for
finding out and complying with the limits of that device (or
decoding the error messages if she doesn't).

> - Rely on block layer reserves and bio bounce buffer for
> memory allocations.

Do block layer reserves cope with elements greater
than a PAGE_SIZE? One feature of the current sg driver
is that it can send a single request greater than
max_scatg_elems*PAGE_SIZE. The sg driver uses scatg
elements of 32 KB for a maximum size of 8 MB per transfer
(if max_scatg_elems is 256). Some folks out there
increase the 32 KB per scatg element by increasing
the SG_SCATTER_SZ define in sg.h .
Are "huge" pages a possibility here?

> - SG_DXFER_TO_FROM_DEV may be broken. sg currently works like
> the block layer SG_IO code right now.

Originally (sg version 1) this was a read_from_device
where the app wrote something into a buffer that the
read_from_device would later overwrite, if it worked. These
were the days when the only error from sg was an
EIO and that didn't necessarily occur when a CHECK
CONDITION SCSI status came back...

In any other situation (e.g. SG_IO in the block layer)
SG_DXFER_TO_FROM_DEV should be implemented as
SG_DXFER_FROM_DEV .

If we get around to addressing the bi-directional
transfer problem, two independent scatg lists would
be in order IMO: a to_device list and a from_device
list. Then we don't have to worry about a transfer
direction indicator :-) OSD and some advanced SBC-2 SCSI
commands require bi-directional transfers.

> Patch has been tested by running the sg3 and sg utils
> packaages, so this is not ready for merging (more cleanup
> of old code needed). We also may want to add some scsi
> helpers, but because of the sg_read copy_to_user case and
> sg.c requiring a pointer to the bio to do the uncopy it
> gets a little strange if we are also going to kill
> scsi_request. In this patch sg.c just accesses the bio
> and request directly :(


Doug Gilbert




