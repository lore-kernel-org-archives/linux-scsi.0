From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH RFC 0/4] use scatter lists for all block pc	requests	and
 simplify hw handlers
Date: Wed, 08 Jun 2005 10:50:54 -0400
Message-ID: <42A705CE.7000605@adaptec.com>
References: <1117847972.23638.62.camel@mina> <20050607180716.GA8172@suse.de>	 <1118173118.4791.17.camel@mulgrave>  <42A65F5D.6060805@torque.net> <1118235541.5042.16.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:10192 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261277AbVFHOv1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jun 2005 10:51:27 -0400
In-Reply-To: <1118235541.5042.16.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Douglas Gilbert <dougg@torque.net>, Jens Axboe <axboe@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>, Kai.Makisara@kolumbus.fi

On 06/08/05 08:59, James Bottomley wrote:
> Also, I really don't think OSD should be a character device.  It's
> definitely a block device, it just happens to have a two dimensional
> address space instead of a one dimensional one.

Very true.  Although _management_ of OSD contents would not be
"block device", but the next layer up. (hint)

> Really, I think it's cleaner for head or tail insertion to be handled at
> the time the request is generated.  However, the block queues of
> character taps are special; we certainly don't need all the elevator
> merging machinery, so perhaps we should have a way of setting them up as
> noop elevator?

Agreed.  Treating block queues of character devices with no-op elevator
would yield very clean and generalized implementation.

	Luben
