From: "Scott M. Ferris" <sferris@acm.org>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Wed, 3 Dec 2003 15:53:31 -0600 (CST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031203215331.72A865DC7E@bambi.visi.com>
References: <1070486082.1771.48.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from corb.mc.mpls.visi.com ([208.42.156.1]:47543 "EHLO
	corb.mc.mpls.visi.com") by vger.kernel.org with ESMTP
	id S261936AbTLCVxd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Dec 2003 16:53:33 -0500
In-Reply-To: <1070486082.1771.48.camel@mulgrave> from James Bottomley at "Dec
 3, 2003 03:25:35 pm"
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Clay Haapala <chaapala@cisco.com>, naveenb@cisco.com, Roman Zippel <zippel@linux-m68k.org>, hch@infradead.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, davmyers@cisco.com

James Bottomley wrote:
> On Wed, 2003-12-03 at 14:31, Clay Haapala wrote:
> > In discussions around here it was pointed out that the driver should
> > *not* retry on COMMAND ABORT situations, rather let the upper layers
> > handle it.  A retry at the driver level might be outright incorrect in
> > the case of tape devices, for instance.
> 
> I agree.  I didn't mean handle the command retry internally, but
> translate the sense internally to a DID_ code (rather than relying on us
> to modify the sense parser).  We could actually give you one which would
> do an immediate retry without decrementing the retries count (for crc
> conditions you new shouldn't contribute to the retry processing), say
> DID_IMMEDIATE_RETRY.

DID_SOFT_ERROR used to be an unconditional retry in 2.2 and early 2.4
kernels.  Someone "fixed" it to check the allowed count.

-- 
Scott M. Ferris,
sferris@acm.org 
