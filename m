From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] strstrip incorrectly marked __must_check
Date: Tue, 03 Nov 2009 13:10:48 -0600
Message-ID: <1257275448.2454.1.camel@mulgrave.site>
References: <1257273488.9427.27.camel@mulgrave.site>
	 <20091103105921.160d5599.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42273 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754508AbZKCTKv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Nov 2009 14:10:51 -0500
In-Reply-To: <20091103105921.160d5599.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-scsi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>

On Tue, 2009-11-03 at 10:59 -0800, Andrew Morton wrote:
> On Tue, 03 Nov 2009 12:38:08 -0600
> James Bottomley <James.Bottomley@suse.de> wrote:
> 
> > strstrip strips whitespace from the beginning and end of a string.  I
> > agree you have to take the returned pointer if you want to strip from
> > the beginning.  However, if you wish to keep the whitespace at the
> > beginning and only wish strstrip to remove it from the end, then it's
> > entirely legitimate to discard the returned pointer.
> > 
> > This is what we have in drivers/scsi/ipr.c and the patch to make
> > strstrip __must_check is now causing SCSI spurious warnings in that
> > code.
> > 
> 
> Would prefer to keep the warning and to patch ipr.c, please.  We found
> I think three call sites which were incorrectly ignoring the strstrip()
> return value and it's reasonable to fear that others will make the same
> mistake in the future.

What's the problem with the mistake ... additional leading whitespace?

> And maybe ipr.c _should_ be patched.  Right now it's assuming that the
> string coming back from the device has no leading whitespace.  Why trim
> any possible trailing whitespace but not trim any possible leading
> whitespace?

I think it doesn't care.  It wants to append an error code to the
string, and to make it more visible it wants to strip trailing
whitespace before doing so. 

> Or..
> 
> /*
>  * Comment goes here
>  */
> static inline void strsrip_tail(char *str)
> {
> 	char *x __used;
> 	x = strstrip(str);
> }

Yes, I could go for that ... I just don't see such a problem with the
currently overloaded uses of strstrip.

James


