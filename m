From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: storageworks controlers & linux-scsi
Date: 27 Aug 2003 10:56:30 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1061999793.1660.8.camel@mulgrave>
References: <1061816116.3f4a073487d64@impt3-1.free.fr>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:5895 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263450AbTH0P4i (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Aug 2003 11:56:38 -0400
In-Reply-To: <1061816116.3f4a073487d64@impt3-1.free.fr>
List-Id: linux-scsi@vger.kernel.org
To: christophe.varoqui@free.fr
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2003-08-25 at 07:55, christophe.varoqui@free.fr wrote:
> In 2.4.21, a LUN hosted by a storageworks FC controler in multibus failover was
> shown through 4 devices per HBA. 2 usable devices, 2 hang process that submit IO
> in D-state. Such unusable devices, ghost paths, could be activated by sg_start.
> 
> In current 2.4.22 pre-release and 2.6, only the valid path get presented though
> associated sd are allocated and partialy setup. There is no longer a clear way
> to start the ghosts as sg_utils will refuse to submit commands. This behaviour
> is dicted by the new BLIST_NOSTARTONADD bflag.

What's the inquiry strings of the array?  That's what the
BLIST_NOSTARTONADD flag uses.  I'm curious to know why it even
recognised the need not to start an array not in the black list.

> I would like to know what was the intention of this patch (from steeleye I
> guess) ? What problems does it solve ?
> Wouldn't it be better to consider ghosts as removable media, as one would get
> automatic activation on IO submition ?

The intention of the patch is not to send spurious start commands to
arrays as we boot up.  The HP MSA/EVA storage gets very annoyed by this
because a start triggers a path switch..you can imagine what this does
to a SAN when lots of machines boot, since we try to start every visible
path.

The MSA/EVA seem to handle this fine and the switch over start command
can be sent to the passive path on the event of active failure.

James


