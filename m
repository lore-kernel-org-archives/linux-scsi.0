From: Matthew Wilcox <matthew@wil.cx>
Subject: Disabling SCSI parity checking
Date: Thu, 17 Nov 2005 08:48:56 -0700
Message-ID: <20051117154856.GB17171@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:35734 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S1750741AbVKQPs5
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Nov 2005 10:48:57 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


In trying to fix bug #2236 I came across this little gem:

        /* If any device does not support parity, we will not use this option */
        if (!(tn->flags & TEKRAM_PARITY_CHECK))
                np->rv_scntl0  &= ~0x0a; /* SCSI parity checking disabled */

I'm pretty fundamentally opposed to disabling parity checking, so I'm
going to delete this code.  However, I've taken flack before (oh yes, in
bug 2236 ;-) for "not honouring the controller's own setup", so I thought
I'd let people know in advance that I'm going to take away this option.

It would be possible to put it back if it really hurts people.
