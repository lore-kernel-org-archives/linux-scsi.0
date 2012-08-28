From: Dongsu Park <dongsu.park@profitbricks.com>
Subject: Re: [PATCH 00/20, v4] Make ib_srp better suited for H.A. purposes
Date: Tue, 28 Aug 2012 14:25:28 +0200
Message-ID: <20120828122528.GB28144@gmail.com>
References: <5023DA39.7020000@acm.org>
 <20120827183731.GB6094@gmail.com>
 <503C97AC.9060703@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39696 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610Ab2H1MZe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Aug 2012 08:25:34 -0400
Received: by bkwj10 with SMTP id j10so1625413bkw.19
        for <linux-scsi@vger.kernel.org>; Tue, 28 Aug 2012 05:25:33 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <503C97AC.9060703@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, David Dillow <dillowda@ornl.gov>

Hi Bart,

On 28.08.2012 10:04, Bart Van Assche wrote:
> On 08/27/12 18:37, Dongsu Park wrote:
> > while testing ib_srp based on your srp-ha,
> > we sometimes hit kernel crashes with the call trace below.
> > 
> > How to reproduce:
> > 
> > 0. Kernel 3.2.15 with SCST v4193 on the target,
> >    Kernel 3.2.8 with ib_srp-ha on the initiator.
> > 1. Configure 500+ vdisks on target, and get initiator connected.
> > 2. Exchange data intensively, which works well.
> > 3. (On initiator) delete SRP remote port occasionally, e.g.
> >    # echo "1" > /sys/class/srp_remote_ports/port-6\:1/delete
> >    And configure again the SRP target.
> > 4. (On target) disable Infiniband interface, and enable it again.
> > 5. Repeat 3 and 4.
> > 
> > Then the initiator's kernel suddenly crashes. (but not always)
> > 
> > Do you have any idea why?
> 
> Hello Dongsu,
> 
> That's unfortunate. I've just finished running the above test 1000 times
> on my test setup. The test ran perfectly - login succeeded every time,
> the test finished in the expected time, no kernel crash did occur and no
> memory was leaked. I've been running my test with kernel 3.6-rc3 instead
> of kernel 3.2.8 though. Can you repeat your test with kernel 3.6-rc3 on
> the initiator system instead of kernel 3.2.8 ? The 3.6-rc3 kernel
> contains multiple patches that improve robustness with regard to SCSI
> device removal.

Ok, when I get a chance to set up a new test system with kernel 3.6-rc3,
I'll do a new test and let you know.

By the way, as long as I've observed today, the crash occurs only if
rport_dev_loss_timedout() is called. It means, without device loss,
a simple rport_delete does not make any crash.

Is that probably because arguments to pr_err() are accessing to invalid
addresses?

drivers/scsi/scsi_transport_srp.c:275

        pr_err("SRP transport: dev_loss_tmo (%ds) expired - removing %s.\n",
               rport->dev_loss_tmo, dev_name(&rport->dev));

Cheers,
Dongsu

