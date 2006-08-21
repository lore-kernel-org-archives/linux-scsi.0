From: "Philip R. Auld" <pauld@egenera.com>
Subject: Re: [PATCH] SCSI: sanitize INQUIRY strings
Date: Mon, 21 Aug 2006 14:51:52 -0400
Message-ID: <20060821185152.GF29299@vienna.egenera.com>
References: <20060821161417.GB4340@parisc-linux.org> <Pine.LNX.4.44L0.0608211248490.8319-100000@iolanthe.rowland.org> <20060821173546.GA24068@parisc-linux.org> <20060821181132.GE29299@vienna.egenera.com> <20060821182745.GB24068@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from roadrunner-base.egenera.com ([63.160.166.46]:10948 "EHLO
	roadrunner-base.egenera.com") by vger.kernel.org with ESMTP
	id S1750800AbWHUSwe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Aug 2006 14:52:34 -0400
Content-Disposition: inline
In-Reply-To: <20060821182745.GB24068@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

Rumor has it that on Mon, Aug 21, 2006 at 12:27:45PM -0600 Matthew Wilcox said:
> On Mon, Aug 21, 2006 at 02:11:32PM -0400, Philip R. Auld wrote:
> > As far as I can tell Alan is not trying to "ascertain the intention"
> > of the firmware engineer, drug-crazed or otherwise. He is making sure
> > that the array of bytes is printable. You, I think, are trying to
> > get him to interepret the out-of-spec values. I think that's a
> > mistake. It's not a string so NUL byte termination does not 
> > apply. It's an array of what should be printable characters 
> > of the specified length.
> 
> The device is out of spec.  The question is how to handle it. 

I think we agree here.

> Alan thinks that a NUL should be treated as a space.  

Alan seems to think, and I agree, that the NUL should be 
treated as all the other non-printing characters. No special case, 
no guessing.

>I think that a NUL
> indicates the engineer didn't read the spec and intended the string to
> stop there, probably padding with garbage.
> 

This is trying to guess what the engineer really meant, though. What
if the engineer meant it to be a token separator? 

> Let's take the case of a fictional device that has a vendor string
> 
> TJD\0Hje9
> 
> I say that should be printed as "TJD     ".  You say that should be
> printed as "TJD Hje9".

Sure, but what if the Hje9 is not garbage. It's still available in the
proposed patch. It's lost if you overwrite it with spaces. Maybe the
TJD Hje9 requires special handling :)

If it turns out to be garbage couldn't the blacklist entry be set to TJD
and only match the first 3 characters? (I haven't looked at how the
comparison is made).

Indeed it may look better treating the NUL as the end, but I'm arguing
that assuming anything about the intent of the engineer who wrote the
out of spec code is probably a mistake.


Cheers,

Phil



-- 
Philip R. Auld, Ph.D.  	        	       Egenera, Inc.    
Software Architect                            165 Forest St.
(508) 858-2628                            Marlboro, MA 01752
