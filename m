From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [Fwd: [RFT] major libata update]
Date: Tue, 16 May 2006 09:18:18 -0500
Message-ID: <1147789098.3505.19.camel@mulgrave.il.steeleye.com>
References: <4468B596.9090508@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:44473 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751110AbWEPOS1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 May 2006 10:18:27 -0400
In-Reply-To: <4468B596.9090508@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2006-05-15 at 13:08 -0400, Jeff Garzik wrote:
> linux-scsi should have been included in the CC.

Yes, it should, thanks.

It's a pretty huge change, so I haven't gone over it all.  However, two
things leap to mind immediately about this patch set

1) your host_eh_scheduled logic looks wrong.  It seems to me that you
can miss the wakeup if the host is busy?  I also don't see a need to
move the prototype out of scsi_priv.h ... it should only be used by
transport classes, anyway.

2) This scsi_req_abort_cmd() is fundamentally the wrong logic.
Everything else is communicated back as a result code from the command
in done().  This should be no different ... A status return of
DID_FAILED which scsi_decide_disposition() always translates to FAILED
would seem to do exactly what you want without all the overhead.

I'll find time to go over the rest of this later ...

James


