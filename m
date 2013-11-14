From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH v3] sg: O_EXCL and other lock handling
Date: Thu, 14 Nov 2013 11:17:19 -0500
Message-ID: <5284F78F.6010600@interlog.com>
References: <5282CEB4.4050708@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:48337 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755464Ab3KNQRo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Nov 2013 11:17:44 -0500
In-Reply-To: <5282CEB4.4050708@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@hansenpartnership.com>
Cc: vaughan <vaughan.cao@oracle.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, linux-kernel <linux-kernel@vger.kernel.org>

On 13-11-12 07:58 PM, Douglas Gilbert wrote:
> After feedback on version 2 and a new report of a failure
> in the vicinity of sg_remove() [remove device] during
> a shutdown on a large machine, the locking has been
> revised again.

The shutdown problem in the vicinity of sg_remove() has
been traced to the st driver and a patch to fix st has
been sent to this list. So there are now no reported
problems against this patch.

Doug Gilbert

> ChangeLog v3:
>    - change Sg_device::exclude and detached (renamed to
>      detaching) to atomic_t
>    - introduce atomic_t Sg_device::open_cnt and use for
>      open(O_EXCL) logic. Hence stop using list_empty(sfds)
>      which decouples the open/release logic from
>      sg_remove_device() and other post-release cleanup
>      functions
>    - use a mutex to stop races between sg_open() and
>      sg_release() on the same device
>    - reduce the use of driver wide sg_index_lock so now
>      it only protects sg_index_idr (the device array)
>    - expand cleanups requested by checkpatch.pl to the
>      remaining code in the driver
>
> ChangeLog v2:
>    - favour non O_EXCL open()s over open(dev, O_EXCL)s
>    - wake all open(dev)s if dev is removed (detached)
>    - wake all read(dev_fd)s that are waiting for a response
>      if dev is removed (detached)
>    - other cleanups requested by checkpatch.pl
>
> ChangeLog v1:
>    - introduce a finer grain (per device) lock to protect
>      access and changes to the file descriptor objects
>    - introduce a semaphore for mutual exclusion of co-incident
>      open and release calls to the same device
>    - improve the O_EXCL handling of sg_open() when multiple
>      callers are waiting for an O_EXCL condition to clear
>    - change some seq_printf()s to seq_puts()s as requested
>      by checkpatch.pl
>    - update copyright notice, version number and date
>
>
> The patch is against lk 3.12.0 (and should work on lk 3.10
> and lk 3.11 as the sg driver hasn't changed).
>
> Testing is ongoing (see the v2 post) with focus on host
> removal and shutdown. The driver survives bombarding 4 LUs
> with queued requests spread across 6000 scsi_debug LUs.
> Some log noise is generated, but it is not from the sg
> driver:
>    scsi 9:0:33:3: rejecting I/O to offline device
>    scsi 9:0:33:3: [sg1000] killing request
> <multiple times>
>
> This is not seen when there are only 600 LUs.
>
>
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

