From: Doug Ledford <dledford@redhat.com>
Subject: Re: PATCH: scsi device queue depth adjustability patch
Date: Tue, 1 Oct 2002 21:41:44 -0400
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20021002014144.GA29093@redhat.com>
References: <20021002002854.GF28265@redhat.com> <1033521367.20103.57.camel@irongate.swansea.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1033521367.20103.57.camel@irongate.swansea.linux.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Oct 02, 2002 at 02:16:07AM +0100, Alan Cox wrote:
> On Wed, 2002-10-02 at 01:28, Doug Ledford wrote:
> > 2.5.40 test machine is blowing chunks on the serverworks IDE support right 
> > now so it isn't tested :-(
> 
> Please provide more details

[ linux-kernel added to the Cc: since that's where IDE stuff goes ]

OK, it repeatedly hits a BUG() during startup (after detecting the first 
two hard drives on the Primary IDE channel, it takes an interrupt and then 
during that context calls detect_ide_disk_speed or something like that, 
which then calls _kmem_cache_alloc during said interrupt context, 
resulting in the stack printout and traceback, then it continues).  Second 
problem is that as soon as I started up /dev/md0, a raid1 array that was 
dirty due to all the failed boots, it almost immediately hard locks the 
system.  That could be a raid1 hardlock, or it could be a serverworks or 
generic ide code lockup.  Important details would be that the two mirror 
disks for /dev/md0 are on ide0 and ide1 so a rebuild would generate lots 
of primary/secondary controller parallel traffic.

I didn't provide a lot of details before because this machine doesn't have
a serial console host to grab logs and I didn't write all the stuff down.  
Then there is the additional fubar stuff but it's mainly in the category
of "Red Hat Linux 8.0 made initrd images using nash as the shell blow
chunks in regards to actually working with the 2.5.40 kernel, failing
simple operations such as mounting /proc, which of course causes damn near
everything else it tries to do to fail since the normal /proc files aren't
available".

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
