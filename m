From: Doug Ledford <dledford@redhat.com>
Subject: Re: Inhibit auto-attach of scsi disks ?
Date: Tue, 1 Oct 2002 21:58:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021002015838.GE29093@redhat.com>
References: <20021001080115.A27028@eng2.beaverton.ibm.com> <200210011514.g91FEC703750@localhost.localdomain> <20021001161819.36c43d89.Scsi@PragmaSoft.com> <1033519584.20103.38.camel@irongate.swansea.linux.org.uk> <20021001214937.6eebe5d2.Scsi@PragmaSoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021001214937.6eebe5d2.Scsi@PragmaSoft.com>
List-Id: linux-scsi@vger.kernel.org
To: Scott Merritt <Scsi@PragmaSoft.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-scsi@vger.kernel.org

On Tue, Oct 01, 2002 at 09:49:37PM -0400, Scott Merritt wrote:
> 
> Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > You can do all those things while it is attached as a disk device.
> 
> Yes - my concerns are perhaps more "artistic" (and possibly misguided).  If I am mounting a disk for low level maintenance, it may not have a valid partition table and I may not appreciate the Syslog warnings related to the partition table.  Furthermore, all though I haven't investigated, it seems like it might be tricky to determine that I have altered the partition table and that /dev/sdb6 is no longer a valid partition.  To me, it just seemed that giving the user/administrator some way to control/inhibit the auto-attachment would be a "cleaner" solution to the problem - but that's just one man's opinion ... :)

You are confusing auto attachment with auto mounting.  When you do the low 
level things you suggest, the disk should not be *mounted* but it *must* 
be attached (or else there won't be a scsi device for you to open and tell 
to format itself for instance).  Same goes for fdisk partition operations, 
the disk shouldn't be mounted, but it must be attached for fdisk to be 
able to write to it.  Then, when the partition tables are rewritten, fdisk 
tells the kernel to reread the tables from disk, which the kernel happily 
does as long as no one currently has any of the previous partitions still 
mounted.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
