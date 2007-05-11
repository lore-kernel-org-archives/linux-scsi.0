From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH v2] add bidi support for block pc requests
Date: Fri, 11 May 2007 11:26:29 -0500
Message-ID: <1178900789.3692.51.camel@mulgrave.il.steeleye.com>
References: <1178722514.3695.23.camel@mulgrave.il.steeleye.com>
	 <4641FCC8.4040600@panasas.com>
	 <20070510155322R.fujita.tomonori@lab.ntt.co.jp>
	 <20070510164535F.fujita.tomonori@lab.ntt.co.jp> <4643121C.600@panasas.com>
	 <464335D2.3020900@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:50688 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759729AbXEKQ10 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 May 2007 12:27:26 -0400
In-Reply-To: <464335D2.3020900@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Boaz Harrosh <bharrosh@panasas.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, bhalevy@panasas.com, hch@infradead.org, akpm@linux-foundation.org, michaelc@cs.wisc.edu

On Thu, 2007-05-10 at 11:10 -0400, Douglas Gilbert wrote:
> > +#define scsi_resid(cmd) ((cmd)->resid)
> 
> I have defined resid in the past as a signed (32 bit)
> integer following the CAM spec. The cases are:
>    - resid=0 : initiator's DMA engine got (or sent?) the
>                number of bytes it expected
>    - resid>0 : dxfer_len-resid bytes received, less than
>                expected
>    - resid<0 : more bytes received (or could have been)
>                than indicated by dxfer_len
> 
> Some definitions of resid make it unsigned which rules out
> the less common resid<0 case. Can this case happen? Does it
> happen in practice? Naturally no more than dxfer_len should
> be placed in the scatter gather list.

Attempted overrun is usually, and correctly in my opinion, treated as a
fatal error in most drivers, so for them the resid < 0 case can never
happen.

> SPI and SAS do not convey dxfer_len (or data direction) to
> a target in their transport frames. This means that the
> relevant field in the cdb (e.g. transfer length) dictates
> how much data a target sends back to an initiator in the
> case of a read like operation. So that opens up the
> possibility that dxfer_len and the cdb disagree.

Well, actually the drivers do (or those few that pay attention).
dxfer_len is used to program the SG lists into the device DMA engine, so
drivers can retrieve the actuals from the DMA engine at the end of the
transfer and set resid accordingly.

> FCP does convey dxfer_len and data_direction to a target.
> So a FCP target can detect a mismatch between this and the
> cdb and send resid information (either under or over) in its
> response frame back to the initiator. Alternatively it
> can treat the "over" case as an error (fcp3r04.pdf section
> 9.4.2).
> iSCSI and SRP?
> 
> The resid<0 case may become more common if a driver or
> application does not properly take account of protection
> information being sent together with the requested
> data.
> 
> So should we keep resid signed?

I don't really see a compelling reason to alter the driver behaviour (at
least for those where overrun is fatal).  However, since resid is signed
in the current structure, it makes sense to propagate that.

James


