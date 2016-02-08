From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 3/3] add support for DWC UFS Host Controller
Date: Mon, 8 Feb 2016 15:30:06 +0000
Message-ID: <20160208153005.GB12536@leverpostej>
References: <cover.1454498292.git.jpinto@synopsys.com>
 <2072510.CA47OHQsUN@wuerfel>
 <56B2164E.5060007@synopsys.com>
 <2087303.0ORDEBS3hn@wuerfel>
 <56B222C8.5010509@synopsys.com>
 <20160204162700.GD17587@leverpostej>
 <56B8B177.2050000@synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:33527 "EHLO foss.arm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754852AbcBHPag (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Feb 2016 10:30:36 -0500
Content-Disposition: inline
In-Reply-To: <56B8B177.2050000@synopsys.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joao Pinto <Joao.Pinto@synopsys.com>
Cc: Arnd Bergmann <arnd@arndb.de>, santosh.sy@samsung.com, h.vinayak@samsung.com, julian.calaby@gmail.com, akinobu.mita@gmail.com, hch@infradead.org, gbroner@codeaurora.org, subhashj@codeaurora.org, CARLOS.PALMINHA@synopsys.com, ijc+devicetree@hellion.org.uk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, devicetree@vger.kernel.org

On Mon, Feb 08, 2016 at 03:17:11PM +0000, Joao Pinto wrote:
> Hi Mark and Arnd,
> 
> I am planning the v2 of this patch set. I have a doubt in the version
> compatibility strings... The core driver must support the UFS 2.0 controller and
> this patch set includes a patch that adds 2.0 capabilities to it.

Ok. It wasn't clear to me that this series added support for features
specific to 2.0.

> The core driver can get from the controller's version and with that
> use or not a specific 2.0 feature.

It can be detected from the hardware?

> What would be the real added-value of having a compatibility string like
> "snps,ufshcd-1.1" and "snps,ufshcd-2.0" if the driver can perform as 2.0 if it
> detects a 2.0 controller?

Generally having specify strings ensure that it's possible to handle
things in future (e.g. errata workarounds), or if we realise something
isn't as clear-cut as we thought it was (i.e. 2.0 not being a strict
superset of 1.1).

It's difficult to predict when you need that, so we err on the side of
requiring it. At worst it means you have a small redundant few
characters in a DT, but that's a much better proposition than having too
little information.

> Are you saying that a user that puts "snps,ufshcd-1.1"
> in the DT compatibility string disables the UFS 2.0 in the core driver despite
> the controller is 2.0? Please clarify.

If you can consistently and safely detect that the HW is 2.0, using 2.0
functionality is fine.

Regardless, you should have a -1.1 compatible string for the 1.1 HW, and
a -2.0 string for the 2.0 HW, so that DTs are explicit about what the
hardware is. If 2.0 is intended to be a superset of 1.1, you can have a
1.1 fallback entry for the 2.0 hardware.

Thanks,
Mark.
