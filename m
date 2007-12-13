From: Mark Lord <lkml@rtr.ca>
Subject: QUEUE_FLAG_CLUSTER: not working in 2.6.24 ?
Date: Thu, 13 Dec 2007 13:36:02 -0500
Message-ID: <47617B92.6020908@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rtr.ca ([76.10.145.34]:2060 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753036AbXLMSgD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Dec 2007 13:36:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>, IDE/ATA development list <linux-ide@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

Jens,

I'm experimenting here with trying to generate large I/O through libata,
and not having much luck.

The limit seems to be the number of hardware PRD (SG) entries permitted
by the driver (libata:ata_piix), which is 128 by default.

The problem is, the block layer *never* sends an SG entry larger than 8192 bytes,
and even that size is exceptionally rare.  Nearly all I/O segments are 4096 bytes,
so I never see a single I/O larger than 512KB (128 * 4096).

If I patch various parts of block and SCSI, this limit doesn't budge,
but when I change the hardware PRD limit in libata, it scales by exactly
whatever I set the new value to.  This tells me that adjacent I/O segments
are not being combined.

I thought that QUEUE_FLAG_CLUSTER (aka. SCSI host .use_clustering=1) should
result in adjacent single pages being combined into larger physical segments?

This is x86-32 with latest 2.6.24-rc*.
I'll re-test on older kernels next.

???
