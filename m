From: Bjorn Helgaas <bjorn_helgaas@hp.com>
Subject: sym53c8xx duplicate device detection
Date: Thu, 25 Jul 2002 13:29:22 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200207251329.22563.bjorn_helgaas@hp.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: groudier@free.fr

Hello,

sym53c8xx.c contains the following code, apparently to work around
a problem with some HP boxes:

                /* Some HW as the HP LH4 may report twice PCI devices */
                for (i = 0; i < count ; i++) {
                        if (devtbl[i].slot.bus       == PciBusNumber(pcidev) && 
                            devtbl[i].slot.device_fn == PciDeviceFn(pcidev))
                                break;
                }
                if (i != count) /* Ignore this device if we already have it */
                        continue;

I'm working on a box with multiple PCI segments, i.e., there are
several PCI domains, each with its own range of 0-255 bus numbers.
So if we put an adapter at 10:00.0 on segment 0, and another at
10:00.0 on segment 1, the driver ignores the second because it
has the same bus and device/fn as the first.

So I'm interested in specifics about this problem so I can think
about possibilities for fixing my segment problem without
reintroducing an LH4 problem.  For instance, maybe we can
change the architecture-specific PCI code to deal with the
"multiple devices" problem for ALL drivers, not just sym53c8xx.
-- 
Bjorn Helgaas - bjorn_helgaas at hp.com
Linux Systems Operation R&D
Hewlett-Packard Company
