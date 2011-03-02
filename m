From: Dan Williams <dan.j.williams@intel.com>
Subject: Should isci create its own device class?
Date: Tue, 01 Mar 2011 19:22:39 -0800
Message-ID: <4D6DB7FF.4090506@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:30423 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757722Ab1CBDWk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Mar 2011 22:22:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>, James Bottomley <James.Bottomley@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Nadolski, Edmund" <edmund.nadolski@intel.com>, "Jiang, Dave" <dave.jiang@intel.com>, "Skirvin, Jeffrey D" <jeffrey.d.skirvin@intel.com>, "Danecki, Jacek" <jacek.danecki@intel.com>

For compatibility with other software raid environments an isci [1] 
device may contain up to two controller instances per pci device.

Currently the sysfs path for its scsi_host objects is:
> ../../devices/pci0000:00/0000:00:01.0/0000:01:00.0/0000:02:08.0/0000:03:00.0/host10/scsi_host/host10
> ../../devices/pci0000:00/0000:00:01.0/0000:01:00.0/0000:02:08.0/0000:03:00.0/host11/scsi_host/host11

But to reflect reality the pci device is actually the parent of two 
independent controller instances.  With a mockup like:
> ../../devices/pci0000:00/0000:00:01.0/0000:01:00.0/0000:02:08.0/0000:03:00.0/controller0/host10/scsi_host/host10
> ../../devices/pci0000:00/0000:00:01.0/0000:01:00.0/0000:02:08.0/0000:03:00.0/controller1/host11/scsi_host/host11

I can see this being beneficial in a few ways:

1/ fix dev_printk() messages which right now give an ambiguous "isci 
0000:03:00.0" prefix
2/ controller boundaries are visible via the sysfs path without need to 
to look at sas_addresses to determine the controller.
2/ if we ever wanted to support some per controller attributes between 
the global pci attributes and the scsi_host attributes.

...but would this confuse /dev/disk/by-path/ or any other unintended 
side effects?

--
Dan

[1]: http://marc.info/?l=linux-scsi&m=129703780424729&w=2
