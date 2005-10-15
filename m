From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] Improve code for detecting errors near the end of a CD
Date: Sat, 15 Oct 2005 13:35:07 +1000
Message-ID: <435078EB.2040203@torque.net>
References: <Pine.LNX.4.44L0.0510142203230.24065-100000@netrider.rowland.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:42476 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S1750944AbVJODeS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Oct 2005 23:34:18 -0400
In-Reply-To: <Pine.LNX.4.44L0.0510142203230.24065-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <axboe@suse.de>, SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern wrote:
> On Sat, 15 Oct 2005, Douglas Gilbert wrote:
> 
> 
>>Alan,
>>In include/scsi/scsi_eh.h there are several helper functions
>>to aid processing SCSI errors. This includes SCSI sense data
>>descriptor format (which won't be needed for DVD/HD/BD for
>>some time with a (2**32 * 2048) byte maximum using existing
>>fixed sense data format). However there is
>>scsi_get_sense_info_fld() to fetch the info field.
>>
>>sd, st and sg have been converted to use these helpers,
>>where appropriate.
>>
>>MMC-4 does not mention that the valid bit needs to
>>be set on a MEDIUM/HARDWARE error and I have seen
>>real life examples of this. [So it's poorly defined
>>if one gets a medium error on lba 0.] You may also like to
>>consider deferred errors which can occur according to
>>MMC-4.
> 
> 
> Thanks for the comments.  It will be easiest to start with this patch and 
> then add others on top.  I wouldn't mind writing another update to use 
> scsi_get_sense_info_fld and friends.
> 
> I'm not familiar with the MMC standards and it will take some time to get 
> up to speed on MMC-4.  I just downloaded the draft standard, and it's not 
> obvious where (if anywhere) it describes the sense data values.

Alan,
With mmc4r05a.pdf search for "medium error". It talks
about setting the info field but says nothing about
the valid bit. In similar situations sbc (disks) and
ssc (tapes) do mention the valid bit. They should
all conform to spc (primary commands) but at the
margin (especially mmc) they don't. I have brought
up the subject on the "t10@t10.org" reflector, the
response, if memory serves, was along the lines of
"yep, live with it".

> As for deferred errors, I don't know the proper way of handling them.  It 
> would be better for someone else to take care of it.

While searching in the pdf you could look for
"deferred" as well. Lots of hits. Hard to say what
exactly to do, but reporting something to the log
wouldn't be a bad start. This file:
include/scsi/scsi_dbg.h
also contains sense data helper declarations.


Aside ... not addressed to Alan
Why this function is in scsi_dbg.h and is declared
like this:
extern const char *scsi_extd_sense_format(
		unsigned char, unsigned char);
rather than something like this:
extern const char *scsi_asc_ascq_str(
		unsigned char asc, unsigned char ascq);
is beyond me. What has "_extd_" got to do with it?
Basically even when I know the function is there,
and publically available, it is still difficult
to find!

Doug Gilbert
