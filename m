From: "Govindan, Thiru" <GovinT@LOUISVILLE.STORTEK.COM>
Subject: FW:  Re. Allocation of scatter gather table in __init_io
Date: Mon, 9 Aug 2004 13:50:20 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <E5A17223DA27AB4DABB18A5955F4235545CFCE@EXCHVS1.louisville.stortek.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sherman.stortek.com ([129.80.22.146]:3924 "EHLO
	sherman.stortek.com") by vger.kernel.org with ESMTP id S265978AbUHIEu3
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Aug 2004 00:50:29 -0400
Received: from sherman.stortek.com (localhost [127.0.0.1])
	by sherman.stortek.com (8.12.10/8.12.0) with ESMTP id i794oSZ1003153
	for <linux-scsi@vger.kernel.org>; Sun, 8 Aug 2004 22:50:28 -0600 (MDT)
Received: from ap-jpto-msg02.pacificrim.stortek.com (AP-JPTO-MSG02.stortek.com [129.191.235.69])
	by sherman.stortek.com (8.12.10/8.12.0) with ESMTP id i794oRsk003149
	for <linux-scsi@vger.kernel.org>; Sun, 8 Aug 2004 22:50:28 -0600 (MDT)
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

Hi,
    I'm running into an issue that seems to be caused by __init_io() in
scsi_merge.c. Apparently __init_io() is allocating the scatter gather list
before even merging the segments in the queue. In my case the request
nr_segments  has a value of 2 and the scatter gather table is allocated for
2 entries. But  then the logic merges the 2 segments into 1 and fills in one
entry, my HBA driver complains that one entry is invalid and panics. Can you
clarify how this works, I suppose getting mergeable segments in a request is
common and hence __init_io() must allocate the table after having at least
identified how may segments are really there. 

Is this a known issue and is there a patch that fixes this?

Govindan
