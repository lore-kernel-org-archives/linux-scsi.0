From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/11]  qla2xxx: Add MBX command routines for ISP24xx support.
Date: Tue, 14 Jun 2005 22:50:37 +0100
Message-ID: <20050614215037.GC5849@infradead.org>
References: <20050614053136.12127.506.sendpatchset@plap.qlogic.com> <20050614053156.12127.12164.sendpatchset@plap.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:38355 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261361AbVFNVul (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Jun 2005 17:50:41 -0400
Content-Disposition: inline
In-Reply-To: <20050614053156.12127.12164.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

> +//ISP24xx

C++ comments again.

>  	/* Load mailbox registers. */
> -	optr = (uint16_t __iomem *)MAILBOX_REG(ha, reg, 0);
> +	if (IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
> +		reg24 = (struct device_reg_24xx __iomem *)ha->iobase;
> +		optr = (uint16_t __iomem *)&reg24->mailbox0;
> +	} else {
> +		reg = ha->iobase;
> +		optr = (uint16_t __iomem *)MAILBOX_REG(ha, reg, 0);
> +	}

Looking over the patches you have things like this a lot, and it's ugly
as hell.  There must be a nicer way to get all this sorted out.
As a start make the ha->iobase and union of the both different register
laouts, dito for the reg variable in all the functions, then make sure
MAILBOX_REG & co work for the 24xx and 25xx aswell.

