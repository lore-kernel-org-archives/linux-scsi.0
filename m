From: Jesse Barnes <jbarnes@engr.sgi.com>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: Tue, 21 Sep 2004 11:58:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200409211158.25122.jbarnes@engr.sgi.com>
References: <20040917183029.GW642@parcelfarce.linux.theplanet.co.uk> <200409211113.20998.jbarnes@engr.sgi.com> <1095781309.2467.88.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx3-ext.sgi.com ([192.48.171.20]:60082 "EHLO omx3.sgi.com")
	by vger.kernel.org with ESMTP id S267709AbUIUP7B (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 11:59:01 -0400
In-Reply-To: <1095781309.2467.88.camel@mulgrave>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Grant Grundler <grundler@parisc-linux.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, pj@sgi.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>

On Tuesday, September 21, 2004 11:41 am, James Bottomley wrote:
> Just to get back to the actual qla2xxx problem.
>
> Do we agree that there are two possible solutions:
>
> 1) Find a safe mmio read to trigger the flush of the posted reset write.
>
> 2) Use a pio write to trigger the reset because we know the reset is
> active as soon as the write returns.
>
> and if so, which one are we going to implement?

or
 3) use a regular write() with an associated pioflush()

For now, (1) is a good option if the driver can do it (I still haven't heard 
if qla2xxx supports this).  I suspect that neither (1) nor (2) is available 
to some device, leaving only udelay() or (3), which I'm working on.

Jesse
