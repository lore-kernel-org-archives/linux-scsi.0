From: David Brownell <david-b@pacbell.net>
Subject: driverfs bus_id, name (was: [PATCH] /proc/scsi/map)
Date: Tue, 25 Jun 2002 10:47:07 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D18AC9B.8050306@pacbell.net>
References: <Pine.LNX.4.33.0206250920150.8496-100000@geena.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mochel <mochel@osdl.org>
Cc: Nick Bellinger <nickb@attheoffice.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

 > The bus_id of the device is intended to represent the bus-specific ID of
 > the device, and is the name of the driverfs directory.

Right, I was just commenting that the SCSI folk seem to like a particular
historical usage (based on driver enumeration order) that'd seem good to
do away with ... since it's not necessary (given the _real_ bus-specific
ID from their parent device) and has _always_ been problematic (those
enumeration-related IDs can change unexpectedly).


 > The name should user-friendly. It shouldn't be a unique name. Use
 > something nice and pretty.

I've been wondering about that.  Right now PCI and USB both use fairly
unfriendly/unpretty values in device.name ... "{PCI,USB} device VVVV:PPPP".

Let me make sure I understand you right here, by examples of two
changes I'd like to see.  Correct me if these seem wrong:

- It'd be more appropriate for PCI devices to copy pci_device.name into
   device.name and get the user-friendly names from the PCI device name
   database (when available), and only fallback to those nasty strings
   when the more user-friendly names aren't available.

- Likewise it'd be more appropriate for USB devices to take the
   descriptive strings from the devices, like "Philips USB Digital
   Speaker System", than "USB device 0471:0104".

In both cases the current strings might make reasonable fallbacks
for the case when something better isn't available.  But as examples,
I don't think they match a "user friendly, pretty" model ... :)

Would it be appropriate for device drivers to set the "name" in
some cases, or is that something you'd only expect bus drivers
to be setting up (once, and read-only)?

Given that in one common usage the "bus_id" is the "true name" of
those devices, I've thought that "description" might be a slightly
better way identify that attribute.  "Name" is a word with a thousand
meanings, all of them context-dependent, and easily confused.

- Dave





