From: Doug Ledford <dledford@redhat.com>
Subject: Re: scsi_scan.c complaints...
Date: Fri, 20 Dec 2002 20:29:23 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021221012923.GB6554@redhat.com>
References: <20021214223934.P3547-100000@localhost.my.domain> <4011340000.1039908562@aslan.scsiguy.com> <20021219185657.GG1862@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021219185657.GG1862@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>, Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Thu, Dec 19, 2002 at 01:56:57PM -0500, Doug Ledford wrote:
> OK, so I've been working on that patch.  I've got it close to done, but it 
> oopses on me at bootup (somewhere I think there is a single init that I'm 
> missing that causes the first command we insert into the request queue to 
> oops).

And I was right.  One little q = NULL; is all that was missing.  Anyway, 
here's a printout of what startup looks like with this patch in place 
under 2.5.52.  This should make you happy Justin ;-)

[root@aladin root]# insmod /lib/modules/2.5.52/kernel/drivers/scsi/scsi_mod.ko
[root@aladin root]# insmod /lib/modules/2.5.52/kernel/drivers/scsi/sd_mod.ko
[root@aladin root]# insmod /lib/modules/2.5.52/kernel/drivers/scsi/aic7xxx_old.ko
[root@aladin root]# dmesg | tail -41
device class 'scsi-host': registering
(scsi0) <Adaptec AIC-7850 SCSI host adapter> found at PCI 0/9/0
(scsi0) Narrow Channel, SCSI ID=7, 3/255 SCBs
(scsi0) Cables present (Int-50 NO, Ext-50 YES)
(scsi0) Downloading sequencer code... 415 instructions downloaded
scsi0 : Adaptec AHA274x/284x/294x (EISA/VLB/PCI-Fast SCSI) 5.2.6/5.2.0
       <Adaptec AIC-7850 SCSI host adapter>
aic7xxx_old: slave_alloc 0/0/0
  Vendor: iomega    Model: jaz 2GB           Rev: E.17
  Type:   Direct-Access                      ANSI SCSI revision: 02
aic7xxx_old: slave_configure 0/0/0
aic7xxx_old: slave_alloc 0/1/0
  Vendor: IOMEGA    Model: ZIP 100           Rev: J.03
  Type:   Direct-Access                      ANSI SCSI revision: 02
aic7xxx_old: slave_configure 0/1/0
aic7xxx_old: slave_alloc 0/2/0
  Vendor: ARCHIVE   Model: Python 04106-XXX  Rev: 7350
  Type:   Sequential-Access                  ANSI SCSI revision: 02
aic7xxx_old: slave_configure 0/2/0
aic7xxx_old: slave_alloc 0/3/0
  Vendor: QUANTUM   Model: FIREBALL_TM3200S  Rev: 301B
  Type:   Direct-Access                      ANSI SCSI revision: 02
aic7xxx_old: slave_configure 0/3/0
aic7xxx_old: slave_alloc 0/4/0
  Vendor: PLEXTOR   Model: CD-ROM PX-4XCS    Rev: 1.04
  Type:   CD-ROM                             ANSI SCSI revision: 02
aic7xxx_old: slave_configure 0/4/0
aic7xxx_old: slave_alloc 0/5/0
aic7xxx_old: slave_destroy 0/5/0
aic7xxx_old: slave_alloc 0/6/0
aic7xxx_old: slave_destroy 0/6/0
(scsi0:0:0:0) Synchronous at 10.0 Mbyte/sec, offset 15.
SCSI device sda: drive cache: write back
Attached scsi removable disk sda at scsi0, channel 0, id 0, lun 0
SCSI device sdb: cache data unavailable
Attached scsi removable disk sdb at scsi0, channel 0, id 1, lun 0
(scsi0:0:3:0) Synchronous at 10.0 Mbyte/sec, offset 15.
SCSI device sdc: drive cache: write back
SCSI device sdc: 6281856 512-byte hdwr sectors (3216 MB)
 sdc: sdc1
Attached scsi disk sdc at scsi0, channel 0, id 3, lun 0
[root@aladin root]#



-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
