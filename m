From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] clean up some more tmscsim scan logic
Date: Sun, 22 Aug 2004 00:00:02 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.60.0408212346290.15226@poirot.grange>
References: <20040817163323.GA16799@lst.de> <Pine.LNX.4.60.0408172136340.5224@poirot.grange>
 <20040819113327.GA21326@lst.de> <Pine.LNX.4.60.0408192300530.5248@poirot.grange>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.net ([213.165.64.20]:12965 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S267936AbUHUWAo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Aug 2004 18:00:44 -0400
In-Reply-To: <Pine.LNX.4.60.0408192300530.5248@poirot.grange>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Thu, 19 Aug 2004, Guennadi Liakhovetski wrote:

> On Thu, 19 Aug 2004, Christoph Hellwig wrote:
>
>> None should be in the LLDD.  I have an experimental patch that doesn't
>> remove the per-device queue yet but only does the easier part of
>> returning MLQUEUE_DEVICE_BUSY in ->queuecommand but doesn't do the
>> requeueing from the isr yet.  I'll send it out ASAP.
>
> Looks good, thanks! Compiles too. I'll test it on the hardware tomorrow,

Ok, tested, works. So, James, please, apply. As for the proc-removal 
patch, don't know. The whole /proc/scsi and its subdirs are not going to 
disappear tomorrow, and a few other LLDs have their subdirs there (e.g., 
aic7xxx, sym53c8xx - those I can see here at least) so, don't know if it 
is the right thing to remove the tmscsim subdir. What's the current trend?

On a side note - my suspicion that INQUIRY outside of initial bus-scan was 
not such an exceptional situation turned right:-) E.g., scsiinfo issues 
it. And then my fix for bug 2139 breaks - it only handles those broken 
drives on initial scan. I've tried to improve that fix to generally not 
use tags for INQUIRY - it worked. But, I guess, unless anybody else 
complains, I will not apply / submit this patch - it is better to switch 
to tcq altogether, and the midlayer doesn't tag INQUIRY, right?

Thanks
Guennadi
---
Guennadi Liakhovetski

