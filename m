From: James.Smart@Emulex.Com
Subject: [Announce] Emulex lpfcdriver v8.0.20 available
Date: Tue, 11 Jan 2005 13:34:37 -0500
Message-ID: <0B1E13B586976742A7599D71A6AC733C12E98D@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:19331 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S261354AbVAKSek convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Jan 2005 13:34:40 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id j0BIYcni015515
	for <linux-scsi@vger.kernel.org>; Tue, 11 Jan 2005 10:34:39 -0800 (PST)
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Smart@Emulex.Com

Christoph and Community,

The 8.0.20 release of the Emulex driver has been recently posted
to SourceForge:
http://prdownloads.sourceforge.net/lpfcxxxx/lpfcdriver-2.6-8.0.20.tar.gz?download


Emulex has been working hard to complete the outstanding items for upstream
acceptance:

- Streamline I/O submission path.
- Removal of GFP_ATOMIC allocations in I/O path. Consider locations
  as well.
- Movement of Consistent Bindings to the FC Transport.
- Discovery changes:
   Target discovery via scsi_scan_single_target. Reduce bookkeeping
     in lpfc_find_target().
   Cleanse target removal. Ensure no more __devices references.
- Removal of ifdefs for older kernel support and different patches

And from our point of view :
- Add management interfaces in support of HBAAPI.


The 8.0.20 release addresses all of the above per the following comments:

- We have significantly streamlined our i/o path, removing all
    GFP_ATOMIC allocations in this path and in most eh_xxxx paths.
    Atomic allocations still exist in our discovery thread, but
    we are looking into removing them as well.
- With the proposed Remote Port additions to the FC transport, we've
    integrated remote ports (rport's) into our node state machine.
    This has reduced much of the target-level housekeeping, moved
    all consistent (semi-persistent) target id bindings into the
    fc transport, and coordinated device discovery/removal with the
    transport.
- Discovery has been reworked such that:
    There is no initial host-level scan.
    Driver registers FC remote ports with FC transport. FC transport
      assigns SCSI target ids for the ports (and implements any
      persistence).
    Driver invokes SCSI bus scans on a per-target level, after
      noticing target id assignments and preparing proper calling
      context.
    If cable pull/device loss, driver calls transport with port-level
      block call (which in turn makes the scsi target block call).
      transport starts target block timer.
    If port returns prior to timeout - driver calls transport
      port-level unblock call, which restarts i/o to devices.
    If port does not return prior to timeout - in timeout handler,
      transport will remove all attached scsi devices.
    When driver decides to release all knowledge of remote port, it
      notifies transport. Transport will remove any attached scsi
      devices.
- We've posted FC Transport patches for host attributes/statistics,
  and remote port attributes, sufficient for HBAAPI.  We've added
  support for these attributes in the driver.
- The ifdefs for older-kernel support and to select kernel patches
  has been removed. The driver expects the latest and greatest
  kernel and patches.


We believe this driver is ready for final reviews for upstream acceptance.
Please return any review comments.

-- James S

