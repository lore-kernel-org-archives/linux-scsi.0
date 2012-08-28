From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 00/20, v4] Make ib_srp better suited for H.A. purposes
Date: Tue, 28 Aug 2012 12:58:16 +0000
Message-ID: <503CC068.9040904@acm.org>
References: <5023DA39.7020000@acm.org> <20120827183731.GB6094@gmail.com> <503C97AC.9060703@acm.org> <20120828122528.GB28144@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay01ant.iops.be ([212.53.4.34]:56036 "EHLO
	relay01ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550Ab2H1M60 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Aug 2012 08:58:26 -0400
In-Reply-To: <20120828122528.GB28144@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dongsu Park <dongsu.park@profitbricks.com>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, David Dillow <dillowda@ornl.gov>

On 08/28/12 12:25, Dongsu Park wrote:
> By the way, as long as I've observed today, the crash occurs only if
> rport_dev_loss_timedout() is called. It means, without device loss,
> a simple rport_delete does not make any crash.
> 
> Is that probably because arguments to pr_err() are accessing to invalid
> addresses?
> 
> drivers/scsi/scsi_transport_srp.c:275
> 
>         pr_err("SRP transport: dev_loss_tmo (%ds) expired - removing %s.\n",
>                rport->dev_loss_tmo, dev_name(&rport->dev));

It's not clear to me how that could happen. The dev_loss timer is
stopped before the rport device is removed. See also the
srp_stop_rport() call (which stops the dev_loss timer) and
srp_remove_host() call (which removes the rport) in srp_remove_target().

Bart.
