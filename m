From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH]: Re: qla1280.c broken on SGI visws, PCI coherency
	problem
Date: Mon, 12 Dec 2005 15:47:37 -0600
Message-ID: <1134424057.3713.18.camel@mulgrave>
References: <4399D6EB.4080603@c-lab.de> <439A17BE.5000904@sgi.com>
	 <439DE50B.90007@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:62443 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750766AbVLLVsC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Dec 2005 16:48:02 -0500
In-Reply-To: <439DE50B.90007@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: pazke@donpac.ru, Michael Joosten <michael.joosten@c-lab.de>, linux-scsi@vger.kernel.org

On Mon, 2005-12-12 at 15:00 -0600, Michael Reed wrote:
> (The subject of this email isn't quite accurate.  It's not
> a pci coherency problem, it's a pio write ordering problem.)
> 
> I've been asked to pass along the suggestion that "mmiowb"
> should be implemented for the platform.

> Given that I've been unable to unearth the chipset documentation
> for the Vis WS, I can only hope that you've got some good ideas
> on how this might be accomplished.

Well, the idea was that mmiowb and posting flushes were orthogonal.
mmiowb would be used in places where a posted write flush was done but
was strictly unnnecessary.  This bug report is implying that the posted
write flush was necessary, so it was incorrectly replaced with mmiowb
(which is a nop on most platforms).

> I agree that replacing the pio read which flushed the preceeding
> pio write with mmiowb() is what has likely broken the driver.  If you
> restore them,  please make it either mmiowb or pio read, but not both.
> 
> Perhaps something like this?  It's not the most elegant solution....

I'm tempted to say I think we need to put the write posting flush back
in and dump the mmiowb(), but since the driver is supposedly doing PIO
for VISWS, there's something else going on here (PIO writes aren't
supposed to post).  I've cc'd the VISWS maintainer in case he can think
of anything.

James


