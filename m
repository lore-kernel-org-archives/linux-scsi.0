From: Al Viro <viro@ftp.linux.org.uk>
Subject: Re: Fw: [Bugme-new] [Bug 6114] New: Initio sbp2 causes: "slab error in cache_free_debugcheck(): cache `size-512(DMA)': double free, or memory outside" object was overwritten
Date: Wed, 22 Feb 2006 03:25:41 +0000
Message-ID: <20060222032541.GZ27946@ftp.linux.org.uk>
References: <43FBB608.5060202@torque.net> <20060222012057.GX27946@ftp.linux.org.uk> <43FBCEF0.4090208@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:62956 "EHLO
	ZenIV.linux.org.uk") by vger.kernel.org with ESMTP id S1751276AbWBVDZm
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Feb 2006 22:25:42 -0500
Content-Disposition: inline
In-Reply-To: <43FBCEF0.4090208@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net

On Tue, Feb 21, 2006 at 09:39:44PM -0500, Douglas Gilbert wrote:
> >>Stefan Richter wrote:
> >>>What I don't understand is why mode page 8 is still accessed in your
> >>>log: http://bugzilla.kernel.org/attachment.cgi?id=7432&action=view
> >>>(Log lines "command: Mode Sense (10): 5a 00 08 00 00 00 00 00 d9 00",
> 
> Also apart from being a MODE SENSE (10) rather than the
> required MODE SENSE (6), the DBD bit is not set as
> required by: www.t10.org/ftp/t10/drafts/rbc/rbc-r10a.pdf
> section 6.3 .
> 
> Perhaps someone could try setting DBD and see if
> the bridge is any better behaved. The cdb would be:
>   5a 08 08 00 ....   or
>   1a 08 08 00 ....

DBD doesn't affect the result, MODE SENSE (6) is actually even worse -
you get the same page without header _and_ with the first byte missing.
BTW, the reason why we don't get DBD is that bridge lies, claiming to be
type 0.  Note that for _all_ values of modepage it returns (mutilated)
page 6, which isn't even defined for type 0.

And yes, the only chance that creators of that thing would ever
see the light is colonoscopy; what else is new?
