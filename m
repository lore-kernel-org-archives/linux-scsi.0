From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: Control Mode page (0xA) QERR bit setting
Date: Mon, 30 Aug 2004 21:48:00 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040831044800.GA2307@sgi.com>
References: <20040831024520.GA2118@sgi.com> <1093923230.3731.22.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.SGI.COM ([192.48.171.19]:38795 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S266566AbUHaEsE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Aug 2004 00:48:04 -0400
Content-Disposition: inline
In-Reply-To: <1093923230.3731.22.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, Aug 30, 2004 at 11:33:46PM -0400, James Bottomley wrote:
> On Mon, 2004-08-30 at 22:45, Jeremy Higdon wrote:
> > It looks as though the midlayer assumes that QERR is 0.  Is that correct?
> 
> Actually, no, the mid-layer is agnostic to the setting of QERR.  On
> error, it simply quiesces the host and waits for all the commands to
> timeout or complete.
>
> > If QERR is 0, then a check condition for one command will not affect other
> > commands, whereas if QERR is 1, then when one command gets a check condition,
> > all others for that ITL are silently aborted.
> 
> Yes, so we see them time out in the error handler.

Well okay.  They are handled, just not too quickly :-)
Not optimal behavior if lots of devices have QERR set to 1.  Fortunately,
they are rare, as you mention below.  Though some OSes actually set
that bit when they can.

> > Since I wasn't able to find any code (other than in the ipr driver) that
> > completed all outstanding commands to a Lun when a check condition is
> > received, I figure that we depend on QERR=0.
> 
> No, we work for either.  QERR != 0 is very rare in mode pages, primarily
> because it's almost impossible to predict what tags actually got dropped
> on the floor because you don't know the status of the head scheduler
> (only tasks accepted and scheduled behind the failing tag actually get
> dropped; executing tasks ahead of it are allowed to complete as long as
> the failing condition doesn't impact them).

Right.  It kind of has to be handled by the host driver or perhaps the
adapter itself, since in many cases only the adapter knows what the
device has actually accepted.  Even then, some complex devices may
theoretically have race conditions in their SCSI engine (though one would
hope not).

> James

thanks,

jeremy
