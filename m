From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/2] scsi_dh patchset fixes
Date: Fri, 04 Jul 2008 10:05:59 -0500
Message-ID: <1215183959.5413.10.camel@localhost.localdomain>
References: <486E2986.6090209@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:44464 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753445AbYGDPGC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jul 2008 11:06:02 -0400
In-Reply-To: <486E2986.6090209@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2008-07-04 at 15:45 +0200, Hannes Reinecke wrote:
> Hi James,
> 
> these patches just fix the suggestions made by you and Mike C.
> - Check the return code from try_module_get()
> - Use GFP_ATOMIC in the IO path

I thought the final agreement was that these should be GFP_NOIO?

> Patches apply on top of my previous patchset for the scsi_dh fixes.

Could you not do this?  The GFP_KERNEL will spit might sleep warnings on
certain configs and the try_module_get could cause an oops on removal.
Either of these might confuse a bisection search if it accidentally
landed in them.  In general, for unapplied patches with identified bugs,
the patches should be fixed before applying.

Thanks,

James


