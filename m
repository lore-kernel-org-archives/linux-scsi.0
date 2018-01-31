From: Ming Lei <ming.lei@redhat.com>
Subject: [LSF/MM TOPIC] KPTI effect on IO performance
Date: Wed, 31 Jan 2018 16:23:32 +0800
Message-ID: <20180131082331.GA25888@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33344 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751534AbeAaIXq (ORCPT <rfc822;Linux-scsi@vger.kernel.org>);
        Wed, 31 Jan 2018 03:23:46 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lsf-pc@lists.linux-foundation.org, Linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org

Hi All,

After KPTI is merged, there is extra load introduced to context switch
between user space and kernel space. It is observed on my laptop that one
syscall takes extra ~0.15us[1] compared with 'nopti'.

IO performance is affected too, it is observed that IOPS drops by 32% in
my test[2] on null_blk compared with 'nopti':

randread IOPS on latest linus tree:
-------------------------------------------------
| randread IOPS     | randread IOPS with 'nopti'|	
------------------------------------------------
| 928K              | 1372K                     |	
------------------------------------------------


Two paths are affected, one is IO submission(read, write,... syscall),
another is the IO completion path in which interrupt may be triggered
from user space, and context switch is needed.

So is there something we can do for decreasing the effect on IO performance?

This effect may make Hannes's issue[3] worse, and maybe 'irq poll' should be
used more widely for all high performance IO device, even some optimization
should be considered for KPTI's effect.


[1] http://people.redhat.com/minlei/tests/tools/syscall_speed.c
[2] http://people.redhat.com/minlei/tests/tools/null_perf
[3] [LSF/MM TOPIC] irq affinity handling for high CPU count machines
	https://marc.info/?t=151722156800002&r=1&w=2

Thanks,
Ming
