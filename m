From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Patch 2/4] aacraid: expanded expose physical device code
Date: Wed, 24 Jan 2007 05:49:02 +0000
Message-ID: <20070124054902.GA14694@infradead.org>
References: <1169593190.10440.23.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:50987 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030215AbXAXFtS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Jan 2007 00:49:18 -0500
Content-Disposition: inline
In-Reply-To: <1169593190.10440.23.camel@markh3.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

> +		if ((scsicmd->cmnd[0] == INQUIRY) && (expose_physicals <= 0)) {
> +			u8 b;
> +			u8 b1;
> +			/* We can't expose disk devices because we can't
> +			 * tell whether they are the raw container drives
> +			 * or stand alone drives.  If they have the removable
> +			 * bit set then we should expose them though.
> +			 */
> +			b = (*(u8*)scsicmd->request_buffer)&0x1f;
> +			b1 = ((u8*)scsicmd->request_buffer)[1];
> +			if (b == TYPE_TAPE || b == TYPE_WORM ||
> +			    b == TYPE_ROM || b==TYPE_MOD ||
> +			    b == TYPE_MEDIUM_CHANGER ||
> +			    (b == TYPE_DISK && (b1 & 0x80))) {
> +				scsicmd->result = DID_OK << 16 |
> +					COMMAND_COMPLETE << 8;

This can't work at all.  request_buffer is always a scatterlist these days.
Besides this implementation bug it's also not the wrong way to do it either.
Please just return -ENXIO in ->slave_configure if sdev->type is not to
your liking instead of failing the INQUIRY command.
