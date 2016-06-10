From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: kernel BUG in drivers/scsi/53c700.c:1129
Date: Fri, 10 Jun 2016 14:01:13 -0700
Message-ID: <1465592473.2224.52.camel@HansenPartnership.com>
References: <5759C524.2030009@gmx.de>
	 <1465511002.2259.19.camel@HansenPartnership.com>  <575B2239.4020403@gmx.de>
	 <1465592285.20724.173.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:56492 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932296AbcFJVBQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Jun 2016 17:01:16 -0400
In-Reply-To: <1465592285.20724.173.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne@redhat.com, Helge Deller <deller@gmx.de>
Cc: "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, 2016-06-10 at 16:58 -0400, Ewan D. Milne wrote:
> I'm not sure if this is the problem, but the tagging changes to
> scsi_tcq.h may have altered the 53c700 driver's assumptions.
> In one case it sets sdev->current_cmnd and then some of the
> tagging calls would return it if the tag was SCSI_NO_TAG.
> 
> NCR_700_queuecommand_lck() does:
> 
>         if ((hostdata->tag_negotiated & (1<<scmd_id(SCp))) &&
>             SCp->device->simple_tags) {
>                 slot->tag = SCp->request->tag;
>                 CDEBUG(KERN_DEBUG, SCp, "sending out tag %d, slot
> %p\n",
>                        slot->tag, slot);
>         } else {
>                 slot->tag = SCSI_NO_TAG;
>                 /* must populate current_cmnd for scsi_host_find_tag
> to
> work */
>                 SCp->device->current_cmnd = SCp;
>         }

Thanks ... I was just about to look for something this.  I'd got to
interpreting the script as reselected with tag information present and
then trying to look the command up with no tag present, hence the
BUG().

James


