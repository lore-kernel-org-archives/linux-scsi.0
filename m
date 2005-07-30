From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [ANNOUNCE 0/7] Open-iSCSI/Linux-iSCSI-5 High-Performance
 Initiator
Date: Sat, 30 Jul 2005 12:53:12 -0700 (PDT)
Message-ID: <20050730.125312.78734701.davem@davemloft.net>
References: <429E15CD.2090202@yahoo.com>
	<1122744762.5055.10.camel@mulgrave>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dsl027-180-168.sfo1.dsl.speakeasy.net ([216.27.180.168]:20883
	"EHLO sunset.davemloft.net") by vger.kernel.org with ESMTP
	id S263124AbVG3TxL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 30 Jul 2005 15:53:11 -0400
In-Reply-To: <1122744762.5055.10.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: itn780@yahoo.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hch@lst.de

From: James Bottomley <James.Bottomley@SteelEye.com>
Date: Sat, 30 Jul 2005 12:32:42 -0500

> FIB has taken your netlink number, so I changed it to 32

MAX_LINKS is 32, so there is no way this reassignment would
work.

You have to pick something in the range 0 --> 32, and as is
no surprise, there are no numbers available :-)

Since ethertap has been deleted, 16-->31 could be made allocatable
once more, but I simply do not want to do that and have the flood
gates open up for folks allocating random netlink numbers.

Instead, we need to take one of those netlink numbers, and turn
it into a multiplexable layer that can support an arbitrary
number of sub-netlink types.  Said protocol would need some
shim header that just says the "sub-netlink" protocol number,
something as simple as just a "u32", this gets pulled off the
front of the netlink packet and then it's passed on down to the
real protocol.
