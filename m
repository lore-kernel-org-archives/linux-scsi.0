From: Alexander Viro <viro@math.psu.edu>
Subject: Re: [patches] rq_dev removal
Date: Thu, 31 Oct 2002 18:40:29 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.21.0210311825200.16688-100000@weyl.math.psu.edu>
References: <20021031231801.GE13860@linnie.riede.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021031231801.GE13860@linnie.riede.org>
List-Id: linux-scsi@vger.kernel.org
To: Willem Riede <wrlk@riede.org>
Cc: linux-scsi@vger.kernel.org



On Thu, 31 Oct 2002, Willem Riede wrote:

> > and old uses of disk->private_data are updated to compensate.
> > 	* st.c, osst.c and sg.c got gendisks allocated, but not registered.
> 
> How appropriate is it, to have something called '*disk' in a tape driver?
> I assume that at least the data in it is valid for this type of driver?

About as much as having character device number stored in ->rq_dev?
As for the data in it - it is valid, but obviously not suitable for
opening a block device (->fops is NULL).

It's allocated and initialized, but never activated (i.e. add_disk()
is never called for it).  So it's perfectly valid, but unreachable
from the data structures used by blkdev_open() and friends - from
their POV it isn't there.

