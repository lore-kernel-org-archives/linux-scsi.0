From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] atp870u: Split long udelay()
Date: Fri, 19 Feb 2010 09:28:19 -0600
Message-ID: <1266593299.2822.7.camel@mulgrave.site>
References: <1266544619.10567.715.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:44129 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864Ab0BSP20 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Feb 2010 10:28:26 -0500
In-Reply-To: <1266544619.10567.715.camel@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-scsi@vger.kernel.org

On Fri, 2010-02-19 at 01:56 +0000, Ben Hutchings wrote:
> udelay() is supposed to be limited to 1 ms, and will generate a
> __bad_udelay() on ARM for constant arguments > 2000.  Split
> udelay(0x800) into mdelay(2); udelay(48).  (I suspect that msleep(3)
> would work but I do not know how critical the timing is here.)

So no to this one.  Either ARM is right and udelay > 2000 is wrong
(which actually sounds correct given how long this will eat CPU for) so
the driver needs fixing, or ARM is wrong and the warning needs fixing.

Splitting the delay to defeat the warning while retaining the behaviour
it was trying to warn about is the wrong thing to do.

James


