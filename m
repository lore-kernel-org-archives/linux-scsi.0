From: Sitsofe Wheeler <sitsofe@gmail.com>
Subject: Re: [PATCH 2/3] [SCSI] storvsc: Add Hyper-V logical block
 provisioning tests
Date: Thu, 24 Jul 2014 19:03:35 +0100
Message-ID: <20140724180335.GA13999@sucs.org>
References: <1405983961-18782-1-git-send-email-kys@microsoft.com>
 <20140723141028.GA22724@sucs.org>
 <20140723141558.GA9705@infradead.org>
 <20140723201341.GA10292@sucs.org> <20140724074739.GA15127@sucs.org>
 <20140724075653.GC15127@sucs.org>
 <1406210951.2040.5.camel@jarvis.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1406210951.2040.5.camel@jarvis.lan>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: James Bottomley <jbottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "jasowang@redhat.com" <jasowang@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "ohering@suse.com" <ohering@suse.com>, "hch@infradead.org" <hch@infradead.org>, "apw@canonical.com" <apw@canonical.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 24, 2014 at 02:09:11PM +0000, James Bottomley wrote:
> On Thu, 2014-07-24 at 08:56 +0100, Sitsofe Wheeler wrote:
> > Microsoft Hyper-V targets currently only claim SPC-2 compliance / no
> > compliance indicated even though they implement post SPC-2 features
> > which means those features are not tested for. Add a blacklist flag to
> > Hyper-V devices that forces said testing.
> 
> This description is misleading: you don't force the test now, you force
> the driver to send unmap commands down to the device.

I disagree - UNMAP will only be used if the vpd pages say that UNMAP is
supported by the device. I've added two hard disks (one SATA, one on USB) to
the VM and here's the debug output with all three patches applied and some
extra logging:

sd 1:0:0:4: [sdc] Entered read_capacity_16
sd 1:0:0:4: [sdc] Past illegal req
sd 1:0:0:4: [sdc] Protection check
sd 1:0:0:4: [sdc] Got past protection check
sd 1:0:0:4: [sdc] Checking LBPME
sd 1:0:0:4: [sdc] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
sd 1:0:0:4: [sdc] 4096-byte physical blocks
sd 1:0:0:4: [sdc] sd_revalidate_disk: Extended inquiry check...
sd 1:0:0:4: [sdc] sd_revalidate_disk: Performing extended inquiries
sd 1:0:0:4: [sdc] sd_read_block_provisioning: Entered, lbmpe: 0
sd 1:0:0:4: [sdc] sd_read_block_provisioning: Passed lbmpe test
sd 1:0:0:4: [sdc] Entered block limits
sd 1:0:0:4: [sdc] Started block limits
sd 1:0:0:4: [sdc] 0x3c...
sd 1:0:0:4: [sdc] Write Protect is off
sd 1:0:0:4: [sdc] Mode Sense: 0f 00 00 00
sd 1:0:0:2: [sdd] Entered read_capacity_16
sd 1:0:0:4: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 1:0:0:2: [sdd] 976773168 512-byte logical blocks: (500 GB/465 GiB)
sd 1:0:0:4: [sdc] Entered read_capacity_16
sd 1:0:0:2: [sdd] sd_revalidate_disk: Extended inquiry check...
sd 1:0:0:2: [sdd] sd_revalidate_disk: Performing extended inquiries
sd 1:0:0:2: [sdd] sd_read_block_provisioning: Entered, lbmpe: 0
sd 1:0:0:2: [sdd] sd_read_block_provisioning: Passed lbmpe test
sd 1:0:0:4: [sdc] Past illegal req
sd 1:0:0:4: [sdc] Protection check
sd 1:0:0:4: [sdc] Got past protection check
sd 1:0:0:4: [sdc] Checking LBPME
sd 1:0:0:2: [sdd] Entered block limits
sd 1:0:0:4: [sdc] sd_revalidate_disk: Extended inquiry check...
sd 1:0:0:4: [sdc] sd_revalidate_disk: Performing extended inquiries
sd 1:0:0:4: [sdc] sd_read_block_provisioning: Entered, lbmpe: 0
sd 1:0:0:4: [sdc] sd_read_block_provisioning: Passed lbmpe test
sd 1:0:0:4: [sdc] Entered block limits
sd 1:0:0:4: [sdc] Started block limits
sd 1:0:0:4: [sdc] 0x3c...
sd 1:0:0:2: [sdd] Write Protect is off
sd 1:0:0:2: [sdd] Mode Sense: 0f 00 00 00
sd 1:0:0:2: [sdd] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 1:0:0:2: [sdd] Entered read_capacity_16
sd 1:0:0:2: [sdd] sd_revalidate_disk: Extended inquiry check...
sd 1:0:0:2: [sdd] sd_revalidate_disk: Performing extended inquiries
sd 1:0:0:2: [sdd] sd_read_block_provisioning: Entered, lbmpe: 0
sd 1:0:0:2: [sdd] sd_read_block_provisioning: Passed lbmpe test
sd 1:0:0:2: [sdd] Entered block limits
 sdd: unknown partition table
sd 1:0:0:2: [sdd] Entered read_capacity_16
sd 1:0:0:2: [sdd] sd_revalidate_disk: Extended inquiry check...
sd 1:0:0:2: [sdd] sd_revalidate_disk: Performing extended inquiries
sd 1:0:0:2: [sdd] sd_read_block_provisioning: Entered, lbmpe: 0
sd 1:0:0:2: [sdd] sd_read_block_provisioning: Passed lbmpe test
sd 1:0:0:2: [sdd] Entered block limits
sd 1:0:0:2: [sdd] Attached SCSI disk
 sdc: sdc1 sdc2
sd 1:0:0:4: [sdc] Entered read_capacity_16
sd 1:0:0:4: [sdc] Past illegal req
sd 1:0:0:4: [sdc] Protection check
sd 1:0:0:4: [sdc] Got past protection check
sd 1:0:0:4: [sdc] Checking LBPME
sd 1:0:0:4: [sdc] sd_revalidate_disk: Extended inquiry check...
sd 1:0:0:4: [sdc] sd_revalidate_disk: Performing extended inquiries
sd 1:0:0:4: [sdc] sd_read_block_provisioning: Entered, lbmpe: 0
sd 1:0:0:4: [sdc] sd_read_block_provisioning: Passed lbmpe test
sd 1:0:0:4: [sdc] Entered block limits
sd 1:0:0:4: [sdc] Started block limits
sd 1:0:0:4: [sdc] 0x3c...
sd 1:0:0:4: [sdc] Attached SCSI disk

Both
/sys/block/sdc/device/scsi_disk/1\:0\:0\:4/thin_provisioning
and
cat /sys/block/sdd/device/scsi_disk/1\:0\:0\:2/thin_provisioning
return 0.

A Hyper-V VHDX disk had output like this:
sd 0:0:0:0: [sda] Entered read_capacity_16
sd 0:0:0:0: [sda] Past illegal req
sd 0:0:0:0: [sda] Protection check
sd 0:0:0:0: [sda] Got past protection check
sd 0:0:0:0: [sda] Checking LBPME
sd 0:0:0:0: [sda] LBPME OK!
sd 0:0:0:0: [sda] Discard mode: 2
sd 0:0:0:0: [sda] 8388608 512-byte logical blocks: (4.29 GB/4.00 GiB)
sd 0:0:0:0: [sda] sd_revalidate_disk: Extended inquiry check...
sd 0:0:0:0: [sda] sd_revalidate_disk: Performing extended inquiries
sd 0:0:0:0: [sda] sd_read_block_provisioning: Entered, lbmpe: 1
sd 0:0:0:0: [sda] sd_read_block_provisioning: Passed lbmpe test
sd 0:0:0:0: [sda] sd_read_block_provisioning: Setting block provisioning
sd 0:0:0:0: [sda] Entered block limits
sd 0:0:0:0: [sda] Started block limits
sd 0:0:0:0: [sda] 0x3c...
sd 0:0:0:0: [sda] Testing lbpme...
sd 0:0:0:0: [sda] ...lbpme test done
sd 0:0:0:0: [sda] Entering discard switch via LBP VPD
sd 0:0:0:0: [sda] Discard mode: 1
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 0f 00 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] Entered read_capacity_16
sd 0:0:0:0: [sda] Past illegal req
sd 0:0:0:0: [sda] Protection check
sd 0:0:0:0: [sda] Got past protection check
sd 0:0:0:0: [sda] Checking LBPME
sd 0:0:0:0: [sda] LBPME OK!
sd 0:0:0:0: [sda] Discard mode: 2
sd 0:0:0:0: [sda] sd_revalidate_disk: Extended inquiry check...
sd 0:0:0:0: [sda] sd_revalidate_disk: Performing extended inquiries
sd 0:0:0:0: [sda] sd_read_block_provisioning: Entered, lbmpe: 1
sd 0:0:0:0: [sda] sd_read_block_provisioning: Passed lbmpe test
sd 0:0:0:0: [sda] sd_read_block_provisioning: Setting block provisioning
sd 0:0:0:0: [sda] Entered block limits
sd 0:0:0:0: [sda] Started block limits
sd 0:0:0:0: [sda] 0x3c...
sd 0:0:0:0: [sda] Testing lbpme...
sd 0:0:0:0: [sda] ...lbpme test done
sd 0:0:0:0: [sda] Entering discard switch via LBP VPD
sd 0:0:0:0: [sda] Discard mode: 1
 sda: sda1
sd 0:0:0:0: [sda] Entered read_capacity_16
sd 0:0:0:0: [sda] Past illegal req
sd 0:0:0:0: [sda] Protection check
sd 0:0:0:0: [sda] Got past protection check
sd 0:0:0:0: [sda] Checking LBPME
sd 0:0:0:0: [sda] LBPME OK!
sd 0:0:0:0: [sda] Discard mode: 2
sd 0:0:0:0: [sda] sd_revalidate_disk: Extended inquiry check...
sd 0:0:0:0: [sda] sd_revalidate_disk: Performing extended inquiries
sd 0:0:0:0: [sda] sd_read_block_provisioning: Entered, lbmpe: 1
sd 0:0:0:0: [sda] sd_read_block_provisioning: Passed lbmpe test
sd 0:0:0:0: [sda] sd_read_block_provisioning: Setting block provisioning
sd 0:0:0:0: [sda] Entered block limits
sd 0:0:0:0: [sda] Started block limits
sd 0:0:0:0: [sda] 0x3c...
sd 0:0:0:0: [sda] Testing lbpme...
sd 0:0:0:0: [sda] ...lbpme test done
sd 0:0:0:0: [sda] Entering discard switch via LBP VPD
sd 0:0:0:0: [sda] Discard mode: 1
sd 0:0:0:0: [sda] Attached SCSI disk


The hard disk never set the Discard mode so why would UNMAP be forced.

> >  	/*
> > -	 * Add blist flags to permit the reading of the VPD pages even when
> > -	 * the target may claim SPC-2 compliance. MSFT targets currently
> > -	 * claim SPC-2 compliance while they implement post SPC-2 features.
> > -	 * With this patch we can correctly handle WRITE_SAME_16 issues.
> > +	 * Forcefully enable logical block provisioning testing.
> >  	 */
> > -	sdevice->sdev_bflags |= msft_blist_flags;
> > +	sdevice->sdev_bflags |= BLIST_TRY_LBP;
> > +	sdevice->try_lbp = 1;
> 
> Really no way to this one.  You're forcing unmap support on every
> hyper-v device; including spinning rust pass through ones which won't
> support it.  The hyper-v storage interface has proven to be somewhat
> fragile, so it may explode when the device tries to send illegal command
> sense back.

OK this one I can't deny but I couldn't see how else to cope with passthrough
disks (see below)...

> If you have a specific IDENTITY string for a faulty SSD that fails to
> report unmap support correctly, then we could quirk for that, but not
> everything attached to the hyper-v driver.

Let me be clear that there are two cases:

1. Hyper-V VHDX files.
2. Passthrough devices (such as SSDs) that support discard.

We can definitely identify 1. (and I have an unposted patch that
modified the struct in scsi_devinfo.c to only quirk on Hyper-V VHDX
devices) but with 2. the SATA SSD I have enables discard fine with Linux
on the host directly - it's the act of passing it through Hyper-V that
causes the issue (no SCSI conformance level is claimed and lbmpe is not
set) and that could theoretically apply to all TRIM supporting SATA SSDs
that are passed through Hyper-V.

Additionally K. Y.  Srinivasan had a similar (but slightly different)
patch to my unposted one and Christoph said:

> This looks way to complicated - should be a single line added to your
> slave_configure function, maybe plus a comment stating what you do
> in your commit message:
> 
> 
>         sdev->sdev_bflags |= BLIST_TRY_VPD_PAGES;

So it was changed to be similar to impact everything attached to
Hyper-V. If you don't like this you may want to chime in on
https://lkml.org/lkml/2014/7/24/33 (Re: [PATCH 1/1] Drivers: scsi:
storvsc: Add blist flags).

-- 
Sitsofe | http://sucs.org/~sits/
