From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [RFC] Persistent naming of scsi devices
Date: Mon, 8 Apr 2002 11:27:36 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020408112735.A26427@eng2.beaverton.ibm.com>
References: <hch@infradead.org> <200204081634.g38GYQC04210@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200204081634.g38GYQC04210@localhost.localdomain>; from James.Bottomley@steeleye.com on Mon, Apr 08, 2002 at 11:34:26AM -0500
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Christoph Hellwig <hch@infradead.org>, sullivan <sullivan@austin.ibm.com>, linux-scsi@vger.kernel.org

On Mon, Apr 08, 2002 at 11:34:26AM -0500, James Bottomley wrote:
> On Mon, Apr 08, 2002 at 09:18:44AM -0600, sullivan wrote:
> > I would welcome any thoughts, comments, or suggestions.

> One of the things I'm not so keen on in the proposed patch is that there is a 
> large amount of code placed in the kernel for determining the vital product 
> data IDs.  For the scheme to be fully flexible, it would be much better to 
> move this out to user land, using the /dev/sg pipe into the device, so that 
> determining and using the device "characteristics" can be much more flexible.  
> Hotplug is probably more useful to this type of user level based configuration 
> than devfs et al.
> 
> James

James -

We could have a set of interfaces to get a SCSI UUID, and then have
hotplug tell us which interface (or module?) to use. That way we don't
require sg.

The device_list[] (black/white list) should also come from user land.
Maybe hotplug could get the device_list[] characteristics, including
the UUID method for the device.

I'd also like a uuid stored in Scsi_Device for multi-path support in the
mid-layer (independent of how it's set). This uuid could not be stored
in the partition or as part of the file system.

-- Patrick
