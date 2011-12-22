From: Shaohua Li <shaohua.li@intel.com>
Subject: [patch 0/2]scsi: improve fairness of starved list
Date: Thu, 22 Dec 2011 11:10:08 +0800
Message-ID: <1324523408.22361.470.camel@sli10-conroe>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:10380 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752924Ab1LVC4z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Dec 2011 21:56:55 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lkml <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
Cc: JBottomley@Parallels.com, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Ted Ts'o <tytso@mit.edu>, "Wu, Fengguang" <fengguang.wu@intel.com>, "Darrick J. Wong" <djwong@us.ibm.com>

We recently found some performance regressions related to writeback.
See http://marc.info/?l=linux-kernel&m=132391033818515&w=2. The test
system uses a LSI 1068e card and 12 hard disks attached to it. The
workload is a simple FIO test, which runs one thread for each disk to
create files. The filesystem is EXT4. Compared to 3.1 kernel, we found
both data=order and data=writeback mode have performance regression.
data=writeback regression is bigger.
The scsi_host->can_queue = 127, where disk queue_depth=64, 64*12 > 127,
so the fairness to utilize host can_queue is important for the overall
throughput, otherwise some disks will be starved and others run in full
speed. In this workload, we found recent I/O less writeback causes the
fairness issue and the throughput get dropped.
We'd better fix the fairness issue in writeback, but on the other hand,
the scsi layer also has fairness issue regarding to the starve list,
which exists in old kernel too, but not that severe. Below two patches
try to address the scsi issue, the test result is (average of 3 runs,
data=writeback mode):

3.1:		1000045 KB/s
base:		 854016 KB/s
base+patch:	 958122 KB/s

The patches don't fully recover the regression, but give a 12%
improvement.

Thanks,
Shaohua

