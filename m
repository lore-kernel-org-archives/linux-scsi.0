From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: storageworks controlers & linux-scsi
Date: Thu, 28 Aug 2003 01:37:06 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030828013706.45760cb5.christophe.varoqui@free.fr>
References: <1061816116.3f4a073487d64@impt3-1.free.fr>
	<1061999793.1660.8.camel@mulgrave>
Reply-To: christophe.varoqui@free.fr
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp8.wanadoo.fr ([193.252.22.30]:15419 "EHLO
	mwinf0101.wanadoo.fr") by vger.kernel.org with ESMTP
	id S262467AbTH0XhI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Aug 2003 19:37:08 -0400
In-Reply-To: <1061999793.1660.8.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On 27 Aug 2003 10:56:30 -0500
James Bottomley <James.Bottomley@steeleye.com> wrote:

> On Mon, 2003-08-25 at 07:55, christophe.varoqui@free.fr wrote:
> > In 2.4.21, a LUN hosted by a storageworks FC controler in multibus failover was
> > shown through 4 devices per HBA. 2 usable devices, 2 hang process that submit IO
> > in D-state. Such unusable devices, ghost paths, could be activated by sg_start.
> > 
> > In current 2.4.22 pre-release and 2.6, only the valid path get presented though
> > associated sd are allocated and partialy setup. There is no longer a clear way
> > to start the ghosts as sg_utils will refuse to submit commands. This behaviour
> > is dicted by the new BLIST_NOSTARTONADD bflag.
> 
> What's the inquiry strings of the array?  That's what the
> BLIST_NOSTARTONADD flag uses.  I'm curious to know why it even
> recognised the need not to start an array not in the black list.
> 
I'm away from this array for 2 weeks.
I can only tell for sure that the vendor string is COMPAQ and model HSV110.
the BLIST_NOSTARTONADD bflag is set for this tuple in 2.4.22.

I did not say the linux kernel tried to start the array, only that  before the BLIST_NOSTARTONADD patch it presented all 4 paths and now it only presents the 2 active path,  which does not permit admins to manualy start inactive path (sg_start /dev/sg?? 1).
The situation before this patch was not perfect either, as ghost paths blocked I/O submitters in D-state rather than returning I/O.

I successfully tested setting the BLIST_ISDISK bflag instead of BLIST_NOSTARTONADD and all 4 paths are rightfully presented and inactive paths rightfully return I/O errors on media acces cmds. I did not test BLIST_NOSTARTONADD | BLIST_ISDISK yet, but it seems the way to go.

> > I would like to know what was the intention of this patch (from steeleye I
> > guess) ? What problems does it solve ?
> > Wouldn't it be better to consider ghosts as removable media, as one would get
> > automatic activation on IO submition ?
> 
> The intention of the patch is not to send spurious start commands to
> arrays as we boot up.  The HP MSA/EVA storage gets very annoyed by this
> because a start triggers a path switch..you can imagine what this does
> to a SAN when lots of machines boot, since we try to start every visible
> path.
> 
Only clusters are concerned, as LUN are masked in most SANs.
Argument is valid though.

> The MSA/EVA seem to handle this fine and the switch over start command
> can be sent to the passive path on the event of active failure.
> 
Not any more in 2.4.22 and 2.6.x
For now I'll stick to BLIST_ISDISK for this array.

I leave for a 2 week vacation, but if the HSV LUNs handling is turned to a usable state I'll be able to post a GPL C agent to handle DM multipath autoconfig & reconfig on event (through VPD 0x83 for wwid detection and TUR for ghosts detection) in  about 3 weeks. In hope there will interest to move it to a broader use.

regards,
cvaroqui
