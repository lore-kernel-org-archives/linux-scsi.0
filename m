From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] tmscsim: INQUIRY always only untagged
Date: Sun, 5 Sep 2004 17:31:34 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040905173134.A31521@infradead.org>
References: <Pine.LNX.4.60.0409040033310.5266@poirot.grange> <20040904140102.A15247@infradead.org> <Pine.LNX.4.60.0409050022570.3092@poirot.grange> <20040904233835.A18659@infradead.org> <Pine.LNX.4.60.0409051654460.3039@poirot.grange> <1094398979.10977.9.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:48390 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S266871AbUIEQbh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 5 Sep 2004 12:31:37 -0400
Content-Disposition: inline
In-Reply-To: <1094398979.10977.9.camel@mulgrave>; from James.Bottomley@SteelEye.com on Sun, Sep 05, 2004 at 11:42:58AM -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sun, Sep 05, 2004 at 11:42:58AM -0400, James Bottomley wrote:
> On Sun, 2004-09-05 at 10:56, Guennadi Liakhovetski wrote:
> > Ok, how about the attached version?
> 
> Well, it looks like it would cure the symptoms, and I can apply it as a
> palliative.
> 
> However, the disease in this driver is that it snoops the inquiry data
> and gets confused by the double inquiry we now do for certain drives.
> 
> What really needs to happen is
> 
> 1) remove the inquiry snooping and believe the flags in struct
> scsi_device instead
> 2) Don't turn on TCQ until slave_configure()
> 3) remove it's internal TCQ black list and put it at the mid-layer.

Umm yes.  But lets get the driver no oops first and then move forward.
There's still a lot of work to do on the driver.
