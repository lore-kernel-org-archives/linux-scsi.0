From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] sdd scsi-ml event wq
Date: Mon, 07 Jun 2004 17:54:23 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40C41F2F.7050205@torque.net>
References: <40B6F16B.6070909@cs.wisc.edu> <1085732140.2782.14.camel@laptop.fenrus.com> <40B70137.70106@cs.wisc.edu> <20040528091825.GA17960@devserv.devel.redhat.com> <40B70DBC.4020400@cs.wisc.edu>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:49163 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S261904AbUFGHyl
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Jun 2004 03:54:41 -0400
In-Reply-To: <40B70DBC.4020400@cs.wisc.edu>
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Mike Christie wrote:

[snip]

> For the short term would it be best to harden the SCSI side of the API then
> worry about the API we are using, or is the kobject_hotplug/userspace 
> route not
> looking to be the best option?

Passing state change information out to the userspace via hotplug
and sysfs has problems which are exacerbated by the sysfs policy
of one datapoint per node. If there were multiple state changes
in succession then a userspace program that reads several sysfs
variables could be getting inconsistent state.

Persistent reservations in SPC-3 handle a similar problem by having
a "PRgeneration" variable which is a 32 bit counter that is
incremented every time there is a (registration) state change.

Could such an approach (i.e. an appropriately placed "generation"
state change counter in sysfs) be useful for the hotplug/userspace
route?

Doug Gilbert

