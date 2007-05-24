From: Robert Jennings <rcj@linux.vnet.ibm.com>
Subject: Re: [Stgt-devel] Question for pass-through target design
Date: Thu, 24 May 2007 14:01:36 -0500
Message-ID: <20070524190136.GA13684@austin.ibm.com>
References: <463B72F6.3000207@torque.net> <20070506053629P.fujita.tomonori@lab.ntt.co.jp> <463F36AC.3010207@vlnb.net> <20070507182837E.fujita.tomonori@lab.ntt.co.jp> <20070522195656.GD5758@austin.ibm.com> <46541B56.7000501@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:36910 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811AbXEXTBh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 May 2007 15:01:37 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l4OJ1aFV004346
	for <linux-scsi@vger.kernel.org>; Thu, 24 May 2007 15:01:36 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l4OJ1aVo535922
	for <linux-scsi@vger.kernel.org>; Thu, 24 May 2007 15:01:37 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l4OJ1ZoN022231
	for <linux-scsi@vger.kernel.org>; Thu, 24 May 2007 15:01:36 -0400
Content-Disposition: inline
In-Reply-To: <46541B56.7000501@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, stgt-devel@lists.berlios.de, scst-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

* Vladislav Bolkhovitin (vst@vlnb.net) wrote:
> Robert Jennings wrote:
> >>>>What I meant that is that the kernel tgt code (scsi_tgt*) receives
> >>>>SCSI commands from one lld and send them to another lld instead of
> >>>>sending them to user space.
> >>>
> >>>Although the approach of passing SCSI commands from a target LLD to an
> >>>initiator one without any significant interventions from the target
> >>>software looks to be nice and simple, you should realize how limited,
> >>>unsafe and illegal it is, since it badly violates SCSI specs.
> >>
> >>I think that 'implemented cleanly' means that one scsi_host is assigned
> >>to only one initiator.
> >
> >Vladislav listed a number of issues that are inherent in an implementation
> >that does not have a 1:1 relationship of initiators to targets.  The vscsi
> >architecture defines the 1:1 relationship; it's imposible to have more
> >than one initiator per target.
> 
> Just few small notes:
> 
> 1. As I already wrote, complete 1:1 relationship isn't practically 
> possible, because there is always a local access on the target (i.e. one 
> more initiator) and you can't disable it on practice.

I was proposing a 1:1 relationship of initiator to target within the
target framework for in-kernel pass-through.  We would still have the
case that local access on the target is possible; an administrator with
privileges neccessary to create a target would have the responsibility
to not then access the device locally.  

This is no different than if I create my root file system on /dev/sda1,
I should not also 'dd' data to /dev/sda1 while the system is running.
It's a bad idea, but nothing stops me; however this is something that
only a root level user can do.  This would be the same, these targets in
pass-through have permissions by default that do not allow local access
by non-root users.

> 2. 1:1 relationship is a serious limitation for usage cases like an SPI 
> tape library serving backup for several servers on an FC net.

Restricting the relationship to 1:1 would be for pass-through devices
only, this would not necessarily dictate other target types which could
be used for such cases.

--Rob
