From: "Martin K. Petersen" <mkp@mkp.net>
Subject: Re: [RFC] Persistent naming of scsi devices
Date: 09 Apr 2002 23:37:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <yq18z7w1awn.fsf@austin.mkp.net>
References: <OF8B2F3581.590066BE-ONC1256B95.0068B28C@de.ibm.com>
	<3CB39285.8000609@vitalstream.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3CB39285.8000609@vitalstream.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Rick> E.g. "/dev/dsk/c0t1d2s3" is controller 0 (first SCSI controller
Rick> seen on the bus), target ID 1, LUN 2, partition (slice) 3.
Rick> Simple, unambiguous and repeatable.

You plug in another SCSI controller and then what happens?  Or one of
your existing controllers goes up in blue smoke?

What we want is (at least) three ways of addressing a device:

1. By content.  This is the persistent naming.  Think
   filesystem/MD/LVM UUID.  This is what you put in /etc/fstab and
   what metadisk systems use to assemble logical volumes.

   Content referencing is used for accessing data.

2. By physical path.  This naming is not persistent.  Not even runtime
   because hotplug, iSCSI and whatnot may mess things up.

   Path naming is for discovery and recovery.  When you add an
   unlabeled disk you want to reference it by path to give it a name.
   When you have a failed disk on your system you want to know which
   physical device to pull from the array.

3. By enumeration.  This is what the kernel happens to be using to
   reference the device.  diskN.  Certainly not persistent.

   Enumeration is for the kernel.

Now, some magic needs to be involved at discovery time because we
can't rely only on neither content addressing, nor path addressing
alone to do the right thing.  And why is that?

Well, imagine you have a set of mirrored disks.  If you only address
by content, you will find have two devices that match (or three if MD
has done autodetection).  What you really want to mount is the MD
device.

Multipathing has a similar problem.  You'll see two copies of the same
filesystem/UUID.  And again you really want the metadevice to be
mounted.

So not only is your proposal a bad idea for persistency reasons.  The
scheme does not carry enough information to do what is needed.

-- 
Martin K. Petersen, Principal Linux Consultant, Linuxcare, Inc.
mkp@linuxcare.com, http://www.linuxcare.com/
SGI XFS for Linux Developer, http://oss.sgi.com/projects/xfs/
