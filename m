From: "Smart, James" <James.Smart@Emulex.Com>
Subject: RE: [PATCH]: Flexible timeout infrastructure
Date: Wed, 16 Jun 2004 14:05:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3356669BBE90C448AD4645C843E2BF28034F94F8@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:22262 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S264397AbUFPSG2
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jun 2004 14:06:28 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@SteelEye.com>
Cc: Luben Tuikov <luben_tuikov@adaptec.com>, Mike Anderson <andmike@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

So the jist isn't to get the command to survive the LLDD event, even if it
could. Rather, the user has set aside X amount of time (where X = #retries *
timeout length), and you want to return the command to the user as close to
X as possible. And there are 2 further expectations: you are willing to
suffer the failure of non-retryable commands that may be forced to fail; and
you expect the LLDDs to call the midlayer to block further commands if the
LLDD event persists. (Note: this is where I think more granularity could be
used - instead of host-global events, there may be target-specific events as
well).

Ok.  Just trying to get on the same page...

-- james

> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@SteelEye.com]
> Sent: Wednesday, June 16, 2004 1:38 PM
> To: Smart, James
> Cc: Luben Tuikov; Mike Anderson; SCSI Mailing List
> Subject: RE: [PATCH]: Flexible timeout infrastructure
> 
> 
> On Wed, 2004-06-16 at 12:33, Smart, James wrote:
> > I'll try to restate. The patch proposed to allow only 1 
> restart of the timer
> > for a command. My comment was - why not 2, or 3?  I would 
> think - the number
> > of restarts needed is a function of how long the timeout 
> value is vs when
> > the LLDD event occurs and what the duration of the LLDD 
> event is. I can see
> > capping the number of timer restarts, but am not sure 1 is 
> the best choice. 
> 
> It does.  But the number of allowed restarts is linked to the command
> retries (actually allowed retries + 1).
> 
> James
> 
> 
