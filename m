From: "Adam J. Richter" <adam@yggdrasil.com>
Subject: Re: [PATCH] get rid of ->detect for upper layer drivers
Date: Thu, 7 Nov 2002 10:30:08 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200211071830.KAA30039@adam.yggdrasil.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: hch@lst.de
Cc: andmike@us.ibm.com, linux-scsi@vger.kernel.org

	I'd like to respond to the claim that bus_type.match()
is inherently racy, as in the current PCI, USB and SCSI code.

	Bear in mind that I have to catch a plane shortly and will
have uncertain internet access for the next ten days.

	Regardless of whether you have a separate bus.match() routine
or you have the attach routine make that decision, a hot unplug can
occur at any time (or at least a request for one if you have an
architecture where the computer has to give the user permission to
remove the device).  So you need to have some locking to ensure that
the device address (e.g., SCSI unit number) that you are talking to
will not be reallocated by a subsequent hot plug event until the
software is ready to release it.  So, while routines like match() and
attach() may not have a guarantee that the device is still there, they
do have a guarantee that their efforts to communicate with the device
will fail in an orderly manner if it is not there.

	Also, if SCSI hot unplugging is a scheme where the user has to
wait for permission from the computer, then a simple way to achieve
what I described in the previous paragarph would be to allocate some
kind of mutex around the call to device_register in scsi_add_lun.
Even without bus.match(), the individual device.attach() functions
would have to do this kind of locking or have it done for them further
up the call chain.  Probably some larger section of code would be
bracketed that way, perhaps further up the call chain than
scsi_add_lun.

Adam J. Richter     __     ______________   575 Oroville Road
adam@yggdrasil.com     \ /                  Milpitas, California 95035
+1 408 309-6081         | g g d r a s i l   United States of America
                         "Free Software For The Rest Of Us."


