From: "Stephen Bates" <sbates@raithlin.com>
Subject: [LSF/MM TOPIC][LSF/MM ATTEND] IO completion polling for block
 drivers
Date: Wed, 11 Jan 2017 23:09:13 -0600
Message-ID: <7742bcaf65d9f4dc3c0dfede53a85b84.squirrel@webmail.raithlin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gateway33.websitewelcome.com ([192.185.146.130]:36402 "EHLO
        gateway33.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750698AbdALFfL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 12 Jan 2017 00:35:11 -0500
Received: from cm6.websitewelcome.com (cm6.websitewelcome.com [108.167.139.19])
        by gateway33.websitewelcome.com (Postfix) with ESMTP id 00919E1C3D1
        for <linux-scsi@vger.kernel.org>; Wed, 11 Jan 2017 23:14:15 -0600 (CST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, Sagi Grimberg <sagi@grimberg.me>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, Keith Busch <keith.busch@intel.com>

Hi

I'd like to discuss the ongoing work in the kernel to enable high priority
IO via polling for completion in the blk-mq subsystem.

Given that iopoll only really makes sense for low-latency, low queue depth
environments (i.e. down below 10-20us) I'd like to discuss which drivers
we think will need/want to be upgraded (aside from NVMe ;-)).

I'd also be interested in discussing how best to enable and disable
polling. In the past some of us have pushed for a "big hammer" to turn
polling on for a given device or HW queue [1]. I'd like to discuss this
again as well as looking at other methods above and beyond the preadv2
system call and the HIPRI flag.

Finally I'd like to discuss some of the recent work to improve the
heuristics around when to poll and when not to poll. I'd like to see if we
can come up with more optimal balance between CPU load and average
completion times [2].

Stephen Bates

[1] http://marc.info/?l=linux-block&m=146307410101827&w=2
[2] http://marc.info/?l=linux-block&m=147803441801858&w=2

