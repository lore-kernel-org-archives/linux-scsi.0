From: Burkhard Bunk <bunk@physik.hu-berlin.de>
Subject: aic7xxx problem in 2.4.18-SMP
Date: Tue, 21 May 2002 15:31:35 +0200 (MEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.21.0205211450520.19017-100000@irz11.physik.hu-berlin.de>
References: <BD858EA74895F34EBDAED1B61E25B3671F2AC3@whizz999.whizzwork.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <BD858EA74895F34EBDAED1B61E25B3671F2AC3@whizz999.whizzwork.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-smp@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

Hallo,

it took me some time to boot a SCSI system with the aic7xxx driver
compiled into kernel 2.4.18-SMP.

After the boot messages:
========================================================================
May 21 12:21:10 ficus2 kernel: SCSI subsystem driver Revision: 1.00
May 21 12:21:10 ficus2 kernel: (scsi0) <Adaptec AHA-294X Ultra SCSI host
adapter
> found at PCI 0/13/0
May 21 12:21:10 ficus2 kernel: (scsi0) Narrow Channel, SCSI ID=7, 16/255
SCBs
May 21 12:21:10 ficus2 kernel: (scsi0) Cables present (Int-50 YES, Ext-50
NO)
May 21 12:21:10 ficus2 kernel: (scsi0) Downloading sequencer code... 436
instruc
tions downloaded
May 21 12:21:10 ficus2 kernel: scsi0 : Adaptec AHA274x/284x/294x
(EISA/VLB/PCI-F
ast SCSI) 5.2.4/5.2.0
May 21 12:21:10 ficus2 kernel:        <Adaptec AHA-294X Ultra SCSI host
adapter>
========================================================================
the SCSI disk is listed, but then I see (copied from the screen)

	scsi: aborting command due to timeout ...

repeated for various scsi IDs and the a never(?) ending cycle of
	...
	SCSI host0 abort, timed out - resetting
	...
	time out - trying harder
	...


The following didn't help:
 o driver aic7xxx_old
 o kernel patch linux-aic7xxx-6.2.5-2.4.18.patch
With the patch, the error messages look more specific. I would
have to copy them from the screen...

But with kernel boot options "noapic" or "nosmp" the new driver works!
(both with and without the patch.)

There was no such problem with aic7xxx in 2.2.x-SMP kernels.

Hardware: S1662D dual PPro motherboard (440FX)
          Adaptec AHA-2940UW SCSI adapter
	  9GB SCSI disk, QUANTUM ATLAS_V__9_WLS Rev: 0230

Booting with "noapic" is a workaround for me, and the hardware is
old anyway. If, however, someone needs more info for debugging,
please let me know. (I'm not subscribed to linux-scsi.)

Regards,
Burkhard Bunk.
----------------------------------------------------------------------
 bunk@physik.hu-berlin.de      Physics Institute, Humboldt University
 fax:    ++49-30 2093 7628     Invalidenstr. 110
 phone:  ++49-30 2093 7980     10115 Berlin, Germany
----------------------------------------------------------------------


