From: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>
Subject: Re: TYPE_RBC cache fixes (sbp2.c affected)
Date: Mon, 16 May 2005 05:18:09 +0100
Message-ID: <20050516041809.GM1150@parcelfarce.linux.theplanet.co.uk>
References: <20050516015955.GL1150@parcelfarce.linux.theplanet.co.uk> <428812FE.90602@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:14748 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S261266AbVEPERu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 May 2005 00:17:50 -0400
Content-Disposition: inline
In-Reply-To: <428812FE.90602@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net

On Mon, May 16, 2005 at 01:26:54PM +1000, Douglas Gilbert wrote:
> >TYPE_RBC - these guys have writeback cache flag there and are not 
> >guaranteed
> >to have page 8 at all.
> 
> The Write(back) Cache Disable (WCD) flag in mode page 6
> is logically flipped from WCE in DASD (i.e. disk) caching
> mode page (page number 8).

Thus the
                if (modepage == 8) {
                        sdkp->WCE = ((buffer[offset + 2] & 0x04) != 0);
                        sdkp->RCD = ((buffer[offset + 2] & 0x01) != 0);
                } else {
                        sdkp->WCE = ((buffer[offset + 2] & 0x01) == 0);
                        sdkp->RCD = 0;
                }
in there - note the inverse check in the second case.

> >	f) sbp2 sets sdev->use_10_for_rw and sdev->use_10_for_ms instead
> >of bothering to remap READ6/WRITE6/MOD_SENSE, so most of the conversions
> >in there are gone now.
> 
> RBC makes MODE_SENSE/SELECT (6) support mandatory but does
> not support MODE_SENSE/SELECT(10).

I know.  However, behaviour of sbp2 before that patch was to remap
MODE_SENSE(6) to MODE_SENSE(10).  I'd rather not change that without
heavy testing - note that here we are talking about firewire devices
that talk sbp2 and happen to claim RBC as command set.  *IF* they
work with driver in Linus' tree, they will with ->use_10_for_...;
if/when we decide to change that behaviour, we'd better get ready for
random breakage.  IMO that's a separate story - let's keep the current
behaviour for now and just get rid of (badly broken) remapping in
favour of using flags.
