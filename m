From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC] Persistent naming of scsi devices
Date: Wed, 10 Apr 2002 09:19:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020410091918.C546@thunk.org>
References: <OF8B2F3581.590066BE-ONC1256B95.0068B28C@de.ibm.com> <3CB39285.8000609@vitalstream.com> <yq18z7w1awn.fsf@austin.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq18z7w1awn.fsf@austin.mkp.net>; from mkp@mkp.net on Tue, Apr 09, 2002 at 11:37:44PM -0400
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <mkp@mkp.net>
Cc: linux-scsi@vger.kernel.org

On Tue, Apr 09, 2002 at 11:37:44PM -0400, Martin K. Petersen wrote:
> Well, imagine you have a set of mirrored disks.  If you only address
> by content, you will find have two devices that match (or three if MD
> has done autodetection).  What you really want to mount is the MD
> device.
> 
> Multipathing has a similar problem.  You'll see two copies of the same
> filesystem/UUID.  And again you really want the metadevice to be
> mounted.

Note that fsck (and I think mount, but I definitely know about fsck
because I maintain it) solves the above problem by searching the MD
devices first.  Once the multipathing becomes stable, again the right
answer for fsck is to search the metadevice first.

Andreas Dilger has written a block-device-id library which is really
promising, and the goal is to abstract out the current search
algorithms currently used by fsck and mount into a single library.
Said library will also cache the location of filesystems by UUID and
label name, and when a particular block device corresponding to
UUID=XXX or LABEL=YYY is requested, it can look up the location in the
cache, validate it to make sure that someone hasn't inserted or
removed a SCSI controller card, and then return the answer.  If the
validation fails, the library will then do a full sweep of all of the
known devices (again, doing the metadevices --- LVM, MD, et. al ---
first, to deal with the problem you listed).

This basically deals with all of the problems except for swap (which
doesn't have a UUID --- but it shouldn't be too hard to add a UUID
into the swap signature, and then teach swapon how to use it), and the
problem of initializing new disks, before they have UUID's attached to
it. 

That is indeed a hard problem, and ultimately, the thing that will
make this easier is if there's some way we can read out a
drive-specific serial number out of the ATAPI or SCSI interfaces.  I
don't know if disk serial numbers are commonly supported by disk
manufacturers, but hopefully the newer disks have something like that
we can use.  Without it, though, the problem is very, very hard if you
want to make it 100% foolproof --- and hence, something which
civilians (i.e., stupid users) can use.

						- Ted
