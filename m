From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 00/20, v4] Make ib_srp better suited for H.A. purposes
Date: Tue, 28 Aug 2012 10:04:28 +0000
Message-ID: <503C97AC.9060703@acm.org>
References: <5023DA39.7020000@acm.org> <20120827183731.GB6094@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay01ant.iops.be ([212.53.4.34]:50958 "EHLO
	relay01ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575Ab2H1KEf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Aug 2012 06:04:35 -0400
In-Reply-To: <20120827183731.GB6094@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dongsu Park <dongsu.park@profitbricks.com>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, David Dillow <dillowda@ornl.gov>

On 08/27/12 18:37, Dongsu Park wrote:
> while testing ib_srp based on your srp-ha,
> we sometimes hit kernel crashes with the call trace below.
> 
> How to reproduce:
> 
> 0. Kernel 3.2.15 with SCST v4193 on the target,
>    Kernel 3.2.8 with ib_srp-ha on the initiator.
> 1. Configure 500+ vdisks on target, and get initiator connected.
> 2. Exchange data intensively, which works well.
> 3. (On initiator) delete SRP remote port occasionally, e.g.
>    # echo "1" > /sys/class/srp_remote_ports/port-6\:1/delete
>    And configure again the SRP target.
> 4. (On target) disable Infiniband interface, and enable it again.
> 5. Repeat 3 and 4.
> 
> Then the initiator's kernel suddenly crashes. (but not always)
> 
> Do you have any idea why?

Hello Dongsu,

That's unfortunate. I've just finished running the above test 1000 times
on my test setup. The test ran perfectly - login succeeded every time,
the test finished in the expected time, no kernel crash did occur and no
memory was leaked. I've been running my test with kernel 3.6-rc3 instead
of kernel 3.2.8 though. Can you repeat your test with kernel 3.6-rc3 on
the initiator system instead of kernel 3.2.8 ? The 3.6-rc3 kernel
contains multiple patches that improve robustness with regard to SCSI
device removal.

Thanks,

Bart.
