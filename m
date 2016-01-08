From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 01/23] devicetree: bindings: hisi_sas: add v2 HW bindings
Date: Fri, 8 Jan 2016 15:19:35 +0000
Message-ID: <20160108151934.GA32692@leverpostej>
References: <1452262542-64589-1-git-send-email-john.garry@huawei.com>
 <1452262542-64589-2-git-send-email-john.garry@huawei.com>
 <20160108145256.GG3097@leverpostej>
 <568FD281.4050207@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:45983 "EHLO foss.arm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167AbcAHPUH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Jan 2016 10:20:07 -0500
Content-Disposition: inline
In-Reply-To: <568FD281.4050207@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: JBottomley@odin.com, martin.petersen@oracle.com, robh+dt@kernel.org, pawel.moll@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, devicetree@vger.kernel.org

> >>@@ -25,11 +26,28 @@ Main node required properties:
> >>  		The phy interrupts are ordered into groups of 3 per phy
> >>  		(broadcast, phyup, and abnormal) in increasing order.
> >>  		Completion queue interrupts : each completion queue has 1
> >>-			interrupt source.
> >>-			The interrupts are ordered in increasing order.
> >>+			interrupt source. The interrupts are ordered in
> >>+			increasing order.
> >>  		Fatal interrupts : the fatal interrupts are ordered as follows:
> >>  			- ECC
> >>  			- AXI bus
> >>+		For v2 hw: Interrupts for phys, Sata, and completion queues;
> >>+		the interrupts are ordered in 3 groups, as follows:
> >>+		  - Phy interrupts
> >>+		  - Sata interrupts
> >>+		  - Completion queue interrupts
> >>+		Phy interrupts : Each controller has 2 phy interrupts:
> >>+			- phy up/down
> >>+			- channel interrupt
> >>+		Sata interrupts : Each phy on the controller has 1 Sata
> >>+			interrupt. The interrupts are ordered in increasing
> >>+			order.
> >>+		Completion queue interrupts : each completion queue has 1
> >>+			interrupt source. The interrupts are ordered in
> >>+			increasing order.
> >
> >There are no fatal interrupts in V2?
> 
> For v2 hardware, broadcast and fatal interrupts are mutliplexed into
> the general purpose channel interrupt line.

Ok, that sounds fine, just thought I should check.

> >>+Optional main node properties:
> >>+ - am-max-trans : limit controller for am max transmissions
> >
> >Is this a boolean? Number?
> >
> 
> This is a boolean. It is for dealing with a quirk in the chipset: an
> instance of the controller in the hip06 chipset requires registers
> set with a different init value.

Ok. I think the property at needs a better description for that.

It's not clear to me how "limit controller for am max transmissions"
maps to writing a specific value to some registers, but I don't know
much about SAS.

Is this some well-known thing, or values specific to hip06?

Thanks,
Mark.
