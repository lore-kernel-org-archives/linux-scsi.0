From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: I2O enhancement for Adaptec management software
Date: 07 Apr 2004 16:10:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1081370204.1747.5.camel@mulgrave>
References: <40712A47.4090903@shadowconnect.com>
	<1081159378.4679.1.camel@laptop.fenrus.com>
	<20040405110524.A3987@infradead.org>
	<20040405101007.GA27710@devserv.devel.redhat.com>
	<20040405111245.A4077@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:39832 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264193AbUDGVK3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Apr 2004 17:10:29 -0400
In-Reply-To: <20040405111245.A4077@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Arjan van de Ven <arjanv@redhat.com>, Markus Lidel <Markus.Lidel@shadowconnect.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2004-04-05 at 05:12, Christoph Hellwig wrote:
> SG_IO is for scsi passthrough.  now you could invent fake scsi command
> opcodes for native messages, but at that point it starts to get silly.

Actually, no it's not.  SG_IO will to IDE taskfile passthrough just as
well.  As arjan says, it's for native command passthrough.

Now, since the dpt_i20 commontly accepts SCSI commands it would have to
have some way to distinguish these "native" commands from other SCSI
commands, but surely a vendor specific service action would do that.

The consummate advantage is that we don't have to have the driver trying
to construct the SG list on its own (which is what about 50% of this
patch is doing), it can use the block layer to do that on a passed in
area of application memory.

James


