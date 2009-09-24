From: Matthew Wilcox <matthew-Ztpu424NOJ8@public.gmane.org>
Subject: Re: Reducing the verbosity of inserting a USB storage device
Date: Thu, 24 Sep 2009 16:17:02 -0600
Message-ID: <20090924221702.GA7943@parisc-linux.org>
References: <20090920225348.GB3690@parisc-linux.org> <Pine.LNX.4.44L0.0909202104300.14465-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0909202104300.14465-100000-pYrvlCTfrz9XsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Sun, Sep 20, 2009 at 09:09:45PM -0400, Alan Stern wrote:
> I approve of these changes in general, but there should be one more
> line of information.  In the "after" example, there's nothing to relate
> the USB device mentioned in the first two lines with the SCSI device
> mentioned in the remaining six.  I'd like to see one line in between
> from usb-storage, to indicate which USB interface is being registered
> as which SCSI host.
> 
> We don't print anything quite like that right now, so this would have 
> to be something new.  The closest we come is the "scsi4 : SCSI 
> emulation for USB Mass Storage devices" line, and it doesn't mention 
> the USB interface.

I think you're right.  Here's my current dmesg:

usb 1-4: new high speed USB device using ehci_hcd and address 3
scsi4 : usb-storage 1-4:1.0
scsi 4:0:0:0: Direct-Access              Flash Disk       5.00 PQ: 0 ANSI: 2
sd 4:0:0:0: Attached scsi generic sg1 type 0
sd 4:0:0:0: [sdb] Assuming drive cache: write through
sd 4:0:0:0: [sdb] 2009088 512-byte logical blocks: (1.02 GB/981 MiB)
sd 4:0:0:0: [sdb] Removable disk, Write Protect is off
 sdb: unknown partition table

That actually makes the patchset slightly simpler; before:

 drivers/scsi/hosts.c           |    3 +
 drivers/scsi/sd.c              |   78 +++++++++++++++++++++++------------------
 drivers/usb/storage/scsiglue.c |    3 +
 drivers/usb/storage/usb.c      |   13 ++++--
 include/scsi/scsi_host.h       |    3 +
 5 files changed, 60 insertions(+), 40 deletions(-)

after:

 drivers/scsi/sd.c              |   78 +++++++++++++++++++++++------------------
 drivers/usb/core/generic.c     |    2 -
 drivers/usb/storage/scsiglue.c |    3 +
 drivers/usb/storage/usb.c      |   15 +++++--
 drivers/usb/storage/usb.h      |    1 
 5 files changed, 58 insertions(+), 41 deletions(-)

Patches to follow.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
