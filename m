From: "jidong xiao" <jidong.xiao@gmail.com>
Subject: Question about struct scsi_device
Date: Mon, 24 Dec 2007 16:10:59 +0800
Message-ID: <4104961b0712240010j7819d800l445edba6ce293a4d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.185]:50782 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbXLXILA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Dec 2007 03:11:00 -0500
Received: by rv-out-0910.google.com with SMTP id k20so1418276rvb.1
        for <linux-scsi@vger.kernel.org>; Mon, 24 Dec 2007 00:10:59 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I saw these two elements are included in struct scsi_device, i.e.
device_busy and device_blocked.

But I am wondering what the difference between these two variables
are?Or in other words, what do these two variables mean?

struct scsi_device {
	struct Scsi_Host *host;
	struct request_queue *request_queue;

	/* the next two are protected by the host->host_lock */
	struct list_head    siblings;   /* list of all devices on this host */
	struct list_head    same_target_siblings; /* just the devices sharing
same target id */

	/* this is now protected by the request_queue->queue_lock */
	unsigned int device_busy;	/* commands actually active on
					 * low-level. protected by queue_lock. */
                ...
	unsigned int device_blocked;	/* Device returned QUEUE_FULL. */
                ...
}

Thanks
Jason
