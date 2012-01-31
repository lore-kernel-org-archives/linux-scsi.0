From: Shaohua Li <shaohua.li@intel.com>
Subject: [LSF/MM TOPIC][ATTEND]IOPS based ioscheduler
Date: Tue, 31 Jan 2012 16:16:46 +0800
Message-ID: <1327997806.21268.47.camel@sli10-conroe>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:45672 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973Ab2AaIRp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Jan 2012 03:17:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lsf-pc@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org

Flash based storage has its characteristics. CFQ has some optimizations
for it, but not enough. The big problem is CFQ doesn't drive deep queue
depth, which causes poor performance in some workloads. CFQ also isn't
quite fair for fast storage (or further sacrifice of performance to get
fairness) because it uses time based accounting. This isn't good for
block cgroup. We need something different to make both performance and
fairness good.

A recent attempt is to use IOPS based ioscheduler for flash based
storage. It's expected to drive deep queue depth (so better performance)
and be more fairness (IOPS based accounting instead of time based).

I'd like to discuss:
 - Do we really need it? Or the question is if it is popular real
workloads drive deep io depth?
 - Should we have a separate ioscheduler for this or merge it to CFQ?
 - Other implementation discussions like differentiation of read/write
requests and request size. Flash based storage doesn't like rotate
storage, request cost of read/write and different request size usually
is different.

Thanks,
Shaohua

