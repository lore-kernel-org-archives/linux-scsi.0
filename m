From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] SCSI: userspace cannot use scsi_command_size_tbl,
 COMMAND_SIZE and scsi_device_type
Date: Sun, 28 Jun 2009 09:44:42 -0500
Message-ID: <1246200282.4190.13.camel@mulgrave.site>
References: <1246122359.32198.7.camel@hpdv5.satnam>
	 <4A47222B.5020702@panasas.com>  <4A477F00.70305@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:36377 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750875AbZF1Oom (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 28 Jun 2009 10:44:42 -0400
In-Reply-To: <4A477F00.70305@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Jaswinder Singh Rajput <jaswinder@kernel.org>, Olaf Hering <olh@suse.de>, Andrew Morton <akpm@linux-foundation.org>, Sam Ravnborg <sam@ravnborg.org>, Benny Halevy <bhalevy@panasas.com>, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Sun, 2009-06-28 at 10:32 -0400, James Smart wrote:
> Sorry folks --  the nuance of the clibrary having it's own version of a 
> kernel header for distros was completely unknown to me.
> 
> Christoph mentioned this to me last week, with the recommendation to 
> back out the patch and move the other headers that were exprted into 
> include/linux - thus nothing in include/scsi gets export.  No Problem. 
> and I'll do so shortly.

Actually, I'm not sure that's the best way forwards ... the idea of
include/scsi is to group all the SCSI headers together; having to put
them in include/linux if they need to be exported defeats that purpose
slightly.

I think the first point of business might be to find out why (or even
if) glibc still wants its own SCSI headers.  After all, we now have
quite an anomaly: if you use the old SG_IO ioctl, glibc supplies the
header in include/scsi/sg.h; if you use the new bsg SG_IO then we supply
it in include/linux/bsg.h

> How does a lowly contributor track these kind of nuances ?

If the creator of the kernel header exports missed this problem for a
year, I think it's safe to assume you don't lose brownie points for not
spotting it either.

James


