From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v4] scsi: ufs: add support of generic PHY and ICE in
 Qualcomm chips
Date: Thu, 4 Dec 2014 07:54:51 -0800
Message-ID: <20141204155451.GA29255@infradead.org>
References: <1417104021-2997-1-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38065 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579AbaLDPyx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Dec 2014 10:54:53 -0500
Content-Disposition: inline
In-Reply-To: <1417104021-2997-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>
Cc: James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, noag@codeaurora.org, draviv@codeaurora.org, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Kishon Vijay Abraham I <kishon@ti.com>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Grant Likely <grant.likely@linaro.org>, Christoph Hellwig <hch@lst.de>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Raviv Shvili <rshvili@codeaurora.org>, Sahitya Tummala <stummala@codeaurora.org>, "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>

On Thu, Nov 27, 2014 at 05:59:58PM +0200, Yaniv Gardi wrote:
> In this change we add support to the generic PHY framework.
> Two UFS phys are implemented:
> qmp-20nm and qmp-28nm.
> 
> Also, the files in this change implement the UFS HW (controller & PHY)
> specific behavior in Qualcomm chips.
> Relocation of a few header files is needed in order to expose routines
> and data structures between PHY driver and UFS driver.
> 
> Also, this change include the implementation of Inline Crypto Engine (ICE)
> in Qualcomm chips.

This whole patch is a mess.  It does way to many things in one patch,
and it doesn't explain enough of it.

Please explain why you need it.  Especially as the PHY API is a generic
phy abstraction, so having to share defintions between the provider and
consumer seems wrong.  Even if you need some shared bits keep them to an
absolute minium insted of moving so much out of the driver directory.
Also if at all possible keep the shared data in a single header under
include/linux instead of having lots of global headers in a deep
directory structure.

Second split this into patches that do a single things, and explain why
you're doing each:

 1) header move if/as needed
 2) add 20nm phy driver
 3) add 28nm phy driver
 4) add ufs-qcom driver
 5) add ufs-qcom-ice support

and so on.
