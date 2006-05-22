From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH 1/6] mpt fusion - fibre channel target discovery	prematurely terminates
Date: Mon, 22 May 2006 17:09:21 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D7011BD54@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:3276 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751162AbWEVXJ3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 May 2006 19:09:29 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Monday, May 22, 2006 12:41 PM, Michael Reed wrote:

> > I doubt there would be regressions.  We would need to 
> implement timeout
> > on not receiving a mf, then return EAGAIN as we do today.
> 
> Then is there a reason to implement the change at all?  If the caller
> can still receive EAGAIN, the caller still has to handle it.
> Or just view it as an opaque error as callers do today.
> 


Callers of mpt_config don't care about EAGAIN.  Some return the
return value up the calling stack, however ends with them evaulating
a non-zero value as a error, not as retry me later.  So my suggestion of
returning EGAIN after waiting on mf's to be available, really doesn't
matter,
in regards to regressions.

I will not have time the next three weeks to address this, as I will
be on the road.  I prefer mpt_config to be fixed, however I understand
your
concerns, as far as testing and timing goes.

Eric
