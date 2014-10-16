From: michaelc@cs.wisc.edu
Subject: [PATCH 0/5] block/scsi/lio support for COMPARE_AND_WRITE
Date: Thu, 16 Oct 2014 00:37:10 -0500
Message-ID: <1413437835-13778-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:39627 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784AbaJPFhb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Oct 2014 01:37:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, ceph-devel@vger.kernel.org, axboe@kernel.dk

The following patches implement the SCSI command COMPARE_AND_WRITE as a new
bio/request type REQ_CMP_AND_WRITE. COMPARE_AND_WRITE is defined in the
SCSI SBC (SCSI block command) specs as:

The COMPARE AND WRITE command requests that the device server perform the
following as an uninterrupted series of actions:

1) perform the following operations:
        A) read the specified logical blocks; and
        B) transfer the specified number of logical blocks from the Data-Out
        Buffer (i.e., the verify instance of the data is transferred from the
        Data-Out Buffer);

2) compare the data read from the specified logical blocks with the verify
instance of the data; and
3) If the compared data matches, then perform the following operations:
        1) transfer the specified number of logical blocks from the Data-Out
        Buffer (i.e., the write instance of the data transferred from the
        Data-Out Buffer); and
        2) write those logical blocks.

The most command use of this command today is in VMware ESX where it is used
for locking. See
http://blogs.vmware.com/vsphere/2012/05/vmfs-locking-uncovered.html
[in ESX is it is called ATS (atomic test and set)] for more VMware info.
Linux fits into this use, because its SCSI target layer (LIO) is commonly
used as storage for ESX VMs.

Currently, to support this command in LIO we emulate it by taking a lock,
doing a read, comparing it, then doing a write. The problem this patchset
tries to solve is that in many cases it is more efficient to pass the one
COMPARE_AND_REQUEST request directly to the device where it might have
optimized locking and also will require fewer requests to/from the target
and backing storage device.

I am also bugging the ceph-devel list, because I am working on LIO + ceph
support. I am interested in using ceph's rbd device for the backing
storage for LIO, and I was thinking this request could be implemented similar
to how REQ_DISCARD (unmap/trim) is going to be, and I wanted to get some early
feedback. I know the scsi layer better, so I have only added support in sd in
this patchset.

The following patches were made over the target-pending for-next branch but
also apply to Linus's tree.



