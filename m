From: Anton Blanchard <anton@samba.org>
Subject: Re: [PATCH] serialize bus scanning
Date: Thu, 28 Aug 2003 06:29:08 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030827202908.GB7852@krispykreme>
References: <20030825122416.GE15506@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dp.samba.org ([66.70.73.150]:15274 "EHLO lists.samba.org")
	by vger.kernel.org with ESMTP id S262288AbTH0UdU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Aug 2003 16:33:20 -0400
Content-Disposition: inline
In-Reply-To: <20030825122416.GE15506@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org


Hi,

> Synchronize all scanning activity, this fixes long-standing races
> vs /proc/scsi/scsi and sysfs addition and deletion of devices.
> 
> Note that this does not serialize removing, the lists will get
> their own locking soon.

Ive started playing with parallel probe in the lab (on some large ppc64
boxes). I know we have a lot of work to do before this will all work,
but would it be possible to make this semaphore per host?

Even with a per host semaphore, it annoys me how long it takes to spin
up 7 disks especially if a few of them are dead. Longer term are we
planning to overlap spinup of disks on the same host?

(We have a property in our device tree that says how quickly you can
spin disks up on the same host, eg 1sec apart. We should also be able to
do this in parallel on all hosts. We could easily read this property in
a small initramfs program and then issue probe commands via /sys)

Anton
