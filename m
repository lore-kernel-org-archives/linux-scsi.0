From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 6/8] mptfusion: fc transport
Date: Fri, 3 Dec 2004 18:17:36 +0000
Message-ID: <20041203181736.GA15916@infradead.org>
References: <91888D455306F94EBD4D168954A9457C73423E@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:33712 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262459AbULCSRj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Dec 2004 13:17:39 -0500
Content-Disposition: inline
In-Reply-To: <91888D455306F94EBD4D168954A9457C73423E@nacos172.co.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, Dec 03, 2004 at 10:33:17AM -0700, Moore, Eric Dean wrote:
> Why does spi_attach_transport or fc_attach_transport have to be
> done from the module_init routines?  Meaning there is an assumption
> that spi and FC are separate drivers.  Why can't the xxx_attach_transport be
> done
> later from the probe routines when we know which pci devices we are
> attaching?

That's fine.  But as soon as a module uses symbols from another module that
second module needs to be loaded.

But I think splitting doesn't make a lot of sense here, we can introduce
config options to disable SPI/FC/SAS support so people building custom
kernels don't waste memory.
