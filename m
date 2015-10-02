From: Christoph Hellwig <hch@lst.de>
Subject: Re: Bugs in multipath scsi in 4.3-rc2
Date: Fri, 2 Oct 2015 14:56:08 +0200
Message-ID: <20151002125608.GB14899@lst.de>
References: <20150925121636.GC12540@fergus.ozlabs.ibm.com> <20150925151802.GB20282@lst.de> <1443202278.2188.13.camel@HansenPartnership.com> <20150930151449.GC26299@lst.de> <20150930215303.GI2627@mtj.duckdns.org> <1443652494.2185.57.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:43930 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919AbbJBM4K (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Oct 2015 08:56:10 -0400
Content-Disposition: inline
In-Reply-To: <1443652494.2185.57.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Tejun Heo <tj@kernel.org>, Christoph Hellwig <hch@lst.de>, Paul Mackerras <paulus@ozlabs.org>, linux-scsi@vger.kernel.org

On Wed, Sep 30, 2015 at 03:34:54PM -0700, James Bottomley wrote:
> Perhaps we don't have to be that draconian.  There's no real reason we
> can't autoload asynchronously.  If the module isn't ready by the time we
> come to check the attachment, then it will attach to the device later
> when the module init routine runs.

I don't think this works.  We're attaching just after the request_module
call, so modprobe doesn't really have a chance to finish before we
return.

> Should we do anything to limit the module_request floods?  This will
> likely happen for every LUN of an ALUA system ... there can be hundreds
> of those.

Once the alua module is loaded there won't be any request_module calls.
If you build with device handler support but without ALUA support
you'll get a lot of calls, but that's not any different than probing
for other optional features.

Personally I think we probably should simple build ALUA support into
scsi_mod if SCSI_DH is selected, as that's part of the standard and
supported by any modern multi pathing device.
