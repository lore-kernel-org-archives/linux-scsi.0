From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: I/O Topology v3
Date: Fri, 15 May 2009 00:40:22 -0400
Message-ID: <1242362435-11953-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:43369 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbZEOEmE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2009 00:42:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rwheeler@redhat.com, snitzer@redhat.com, jeff@garzik.org, neilb@suse.de, James.Bottomley@hansenpartnership.com, jens.axboe@oracle.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org


Third take of the I/O topology patches.  This time against Jens' 2.6.31
tree.

Changes:

 - Remove the notion of hardsect_size as it about to become a confusing
   anachronism.  Use logical_block_size to refer to the block size used
   when talking to the device via ATA/SCSI.

 - Use the term physical_block_size to refer to the device physical
   sector size.

   (Logical and physical are the terms used in the T10/T13 standards).

 - Move queue limits to an embedded struct so DM can get rid of its
   internal I/O restriction housekeeping and use the same stacking
   function as MD.

 - Switch MD to new stacking API.  Once MD has been updated, the old
   stacking function can be removed.

Block layer topology enablement:

        0001-block-Do-away-with-the-notion-of-hardsect_size.patch
        0002-block-Use-accessor-functions-for-queue-limits.patch
        0003-block-Move-queue-limits-to-an-embedded-struct.patch
        0004-block-Expose-stacked-device-queues-in-sysfs.patch
        0005-block-Export-I-O-topology-for-block-devices-and-par.patch

Post merge:

        0006-MD-Use-new-topology-calls-to-indicate-alignment-and.patch
        0007-block-Deprecate-blk_queue_stack_limits.patch
        0008-sd-Physical-block-size-and-alignment-support.patch
        0009-sd-Detect-non-rotational-devices.patch
        0010-sd-Block-limits-VPD-support.patch

Independent:

        0011-scsi_debug-Add-support-for-physical-block-exponent.patch
        0012-libata-Report-disk-alignment-and-physical-block-siz.patch
        0013-libata-Media-rotation-rate-and-form-factor-heuristi.patch

--
Martin K. Petersen      Oracle Linux Engineering



