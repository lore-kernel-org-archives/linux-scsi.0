From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: RFC: move hosts.h, scsi.h
Date: Thu, 22 May 2003 21:54:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3ECD7F6C.8010702@pobox.com>
References: <3ECD346D.2070302@pobox.com> <20030522230414.A1916@pclin040.win.tue.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:65173 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S263579AbTEWBl6
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 May 2003 21:41:58 -0400
In-Reply-To: <20030522230414.A1916@pclin040.win.tue.nl>
List-Id: linux-scsi@vger.kernel.org
To: Andries Brouwer <aebr@win.tue.nl>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Andries Brouwer wrote:
> On Thu, May 22, 2003 at 04:34:53PM -0400, Jeff Garzik wrote:
> 
> 
>>I request permission to do the following:
>>
>>1) bk mv drivers/scsi/scsi.h include/linux
>>2) bk mv drivers/scsi/hosts.h include/linux/scsi_hosts.h
>>3) bk mv drivers/scsi/scsi_obsolete.h include/linux
>>4) create shell drivers/scsi/{...}.h that includes just-moved files, so 
>>to preserve full driver source compatibility.
>>5) edit include/linux/scsi.h to include <linux/scsi_obsolete.h> not 
>>"scsi_obsolete.h"
>>
>>Objections/comments?
> 
> 
> No doubt with the goal of removing all those ugly
> 	#include "../../scsi/hosts.h"

Yes, and nasty -I hacks in Makefiles.


> A good plan.
> 
> I think point 5) is superfluous.
> (That is, I think by default "foo.h" is found in the directory
> of the including file.)

I thought so too, but gcc disagreed :)

I think '#include <linux/...>' is more clean, too.


> Probably this would mean that usb/storage/Makefile no longer
> needs -Idrivers/scsi, provided the "scsi.h" there is replaced
> by <linux/scsi.h>.

Yep


> Remains the vague objection: it is a bit confusing to have
> several files of the same name. And in case some compilation
> has both include/linux and include/scsi on the include path
> there are ordering restraints. Maybe life will be easier
> if you invent some other name like scsidefs.h.

Easily done and a good objection/suggestion.  I'm using 
scsi_{defs,hosts,obsolete}.h in my local tree right now.

	Jeff



