From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: mpt2sas,mpt3sas watchdog device removal
Date: Wed, 15 May 2013 13:24:01 -0400
Message-ID: <20130515132401.6a8ff7fb@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.stratus.com ([134.111.1.17]:45689 "EHLO
	mailhub4.stratus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759750Ab3EOR2c (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 May 2013 13:28:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, "Desai, Kashyap" <Kashyap.Desai@lsi.com>, Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, Bjorn Helgaas <bhelgaas@google.com>

This is a followup to the earlier discussion of MPT watchdog device
removal calling directly into PCI core API:

[1] http://thread.gmane.org/gmane.linux.scsi/80629

I've tested two safer, alternative methods of removing MPT hosts from
the SCSI topology. Both involve wrapping the existing MPT .remove
routine, ensuring mutual exclusion between regularly scheduled PCI
device removal and the drivers' periodic watchdog thread. Both changes
tested well against surprise PCI removal of LSI SAS 9211-8i HBAs while
driving direct IO out to attached disks.

The first version is straightforward, essentially just adding a common
mutex and checking that the driver still cares about a given PCI device
before removing.

The second version is an attempt to detach only from the SCSI topology as
soon as possible. Later PCI removal cleans up the rest of the resources.

Neither patch maps cleanly to the MPT fusion driver as its watchdog
thread resides in the mptbase module. The code currently uses PCI core
API pci_remove_bus_device to route around the driver's module
dependencies to call from mptbase to mptsas:

Module                  Size  Used by
mptsas                 62366  8                      << PCI .remove
mptscsih               38803  1 mptsas
mptbase                99878  2 mptsas,mptscsih      << watchdog

The fusion driver has devised other means of calling from mptbase to
mptscsih, for example, via the schedule_dead_ioc_flush_running_cmds
function pointer. The two changes I explored were made with a relatively
light hand, so I didn't know how best to proceed with a MPT fusion
patch.

Comments on either removal patch strategy welcome. It would also be
great if we had documentation guiding the SCSI LLDs in how to safely and
completely remove attached hosts in hotplug and defective HW scenarios.

Regards,

-- Joe
