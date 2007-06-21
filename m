From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] zfcp: Report FCP LUN to SCSI midlayer
Date: Thu, 21 Jun 2007 18:46:13 +0200
Message-ID: <467AAB55.9040306@s5r6.in-berlin.de>
References: <200706191025.30986.swen@vnet.ibm.com> <20070619171217.GA30099@infradead.org> <1182307586.10507.7.camel@mulgrave.il.steeleye.com> <20070621150308.GA29643@schmichrtp.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:57523 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754908AbXFUQqV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Jun 2007 12:46:21 -0400
In-Reply-To: <20070621150308.GA29643@schmichrtp.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

Christof Schmitt wrote:
> sysfs and lsscsi display the LUN as decimal number. For the FCP LUN
> 0x401040c300000000, sysfs and lsscsi display this:
> 
> $ ls -l /sys/bus/scsi/devices/
> total 0
> lrwxrwxrwx 1 root root 0 Jun 21 16:49 0:0:0:1086537744 ->
> ../../../devices/css0/0.0.0010/0.0.181d/host0/rport-0:0-0/target0:0:0/0:0:0:1086537744
> 
> $ lsscsi
> [0:0:0:1086537744]disk    IBM      2107900          .270  /dev/sda

The error here is that these are *not* LUNs.  They are some mangled
derivatives of LUNs.

You probably want that Linux' SCSI mid layer passes the LUNs through and
shows them for example in a representation format as per SAM-4 4.6.2.

Or maybe you want that all the different transport layer implementations
expose their target port identifiers + logical unit identifiers (and
perhaps also initiator port identifiers) in their transport-dependent
formats but in a unified sysfs attribute.

For example, the SCSI midlayer H:C:T:L tuple is useless for
SBP-2-attached devices.  What is useful is the ieee1394_id sysfs
attribute which we expose as a scsi_device's sysfs attribute.  This
attribute was something implementation-defined until now, but I changed
it to the concatenation of target port identifier and logical unit
identifier for Linux 2.6.22, as per SAM(-4) annex A.  (That change is
merely an alternative format for the old sbp2 driver and the only format
for the new fw-sbp2 driver.)

Or did I miss something and there is already a mechanism for transports
to expose target/LU identifiers?  So that userland doesn't have to care
what transport it is, except as far as the details of the identifiers'
formats are concerned?
-- 
Stefan Richter
-=====-=-=== -==- =-=-=
http://arcgraph.de/sr/
