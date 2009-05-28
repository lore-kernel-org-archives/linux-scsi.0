From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Subject: Re: [PATCH v6] cciss: add cciss driver sysfs entries
Date: Thu, 28 May 2009 15:24:59 -0500
Message-ID: <20090528202459.GC4846@beardog.cca.cpqcorp.net>
References: <20090413164524.17977.99322.stgit@bluto.andrew>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0027.austin.hp.com ([15.216.28.34]:14250 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761608AbZE1UYh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 May 2009 16:24:37 -0400
Content-Disposition: inline
In-Reply-To: <20090413164524.17977.99322.stgit@bluto.andrew>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@beardog.cca.cpqcorp.net, jens@beardog.cca.cpqcorp.net, Andrew Patterson <andrew.patterson@hp.com>
Cc: LKML <linux-kernel@vger.kernel.org>, LKML-SCSI <linux-scsi@vger.kernel.org>

On Mon, Apr 13, 2009 at 10:45:25AM -0600, Andrew Patterson wrote:
This is version six of my patch to add sysfs entries to the cciss driver.

Changelog:

Version 3
Got rid of /sys/class/cciss_* entries.  Now only show vendor, model, 
rev, and unique_id at /sys/bus/pci/devices/ccissX/cXdY.  Where X is the
controller nubmer and Y is the logical drive number.
Fixed a double memcpy of the serial number.
Documented new sysfs entries in 
Documentation/ABI/testing/sysfs-bus-pci-devices-cciss
Fixed tabs in Documentation/ABI/testing/sysfs-bus-pci-devices-cciss
Removed unneeded device_attribute release functions
Fixed pahole-reported holes.

Version 4
Moved cciss_sysfs.c into cciss.c
Added cciss_bus_type to logical drive so we get /sys/bus/cciss/device/ccissX.

Version 5 
Added cciss_bus_type to hba so we get /sys/bus/cciss/device/cYdZ.

Version 6

Use "sizeof() + 1" instead of "*LEN + 2" for *_show() routines.
Added back in ABI docs.
The following patch adds sysfs entries for the cciss driver. It adds
vendor, model, rev, and unique_id under /sys/block/cciss!c#d#/device
needed for RedHat BZ:

   https://bugzilla.redhat.com/show_bug.cgi?id=484419

This patch is based off os linus's 2.6 tree (2.6.30-rc1).

 .../ABI/testing/sysfs-bus-pci-devices-cciss        |   33 ++
 drivers/block/cciss.c                              |  267 ++++++++++++++++++++
 drivers/block/cciss.h                              |   24 +-
 3 files changed, 314 insertions(+), 10 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-pci-devices-cciss


-- 
Andrew Patterson
