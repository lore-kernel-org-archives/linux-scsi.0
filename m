From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [RFC] Persistent naming of scsi devices
Date: Mon, 08 Apr 2002 11:34:26 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200204081634.g38GYQC04210@localhost.localdomain>
References: <hch@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id JAA02990
	for <linux-scsi@vger.kernel.org>; Mon, 8 Apr 2002 09:34:30 -0700
In-Reply-To: Message from Christoph Hellwig <hch@infradead.org>
   of "Mon, 08 Apr 2002 16:04:45 BST." <20020408160445.A25213@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: sullivan <sullivan@austin.ibm.com>, linux-scsi@vger.kernel.org

On Mon, Apr 08, 2002 at 09:18:44AM -0600, sullivan wrote:
> I would welcome any thoughts, comments, or suggestions.

hch@infradead.org said:
> What is the rationale for doing this?  I think we should rather get
> people to actually use the UUID= option to mount.. 

I think, actually, that this feature is aimed more generally.  UUID really 
only works for filesystems that support it (and in Linux, I believe, this is 
currently only ext2/3 for 2.4 plus reiser in 2.5).  A persistent device 
binding would be of use to people adopting Linux in their SAN enterprise who 
were not (at least initially) planning to convert all their filesystems over 
to Linux ones.  It would also work for raw devices, which don't have an 
underlying filesystem to store the UUID.

I'm not sure we want to get into writing a UUID to a "safe" place on a device 
for such legacy filesystem types (especially as most administrators loathe 
this feature in NT).

The proposal for the device naming project says 

"[...] Some of the characteristics examined include information returned from 
the SCSI Inquiry command, and the labels found on the disks partitions."

which implies to me that you can bind by UUID if desired.

One of the things I'm not so keen on in the proposed patch is that there is a 
large amount of code placed in the kernel for determining the vital product 
data IDs.  For the scheme to be fully flexible, it would be much better to 
move this out to user land, using the /dev/sg pipe into the device, so that 
determining and using the device "characteristics" can be much more flexible.  
Hotplug is probably more useful to this type of user level based configuration 
than devfs et al.

James


