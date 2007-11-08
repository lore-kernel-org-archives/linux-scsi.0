From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH 1/1] aacraid: don't assign cpu_to_le32(int) to u8
Date: Thu, 8 Nov 2007 13:09:29 -0500
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01F9604C@otce2k301.adaptec.com>
References: <jefxzqqeha.fsf@sykes.suse.de> <AE4F746F2AECFC4DA4AADD66A1DFEF01F95EF7@otce2k301.adaptec.com> <20071107173307.GB25560@infradead.org> <AE4F746F2AECFC4DA4AADD66A1DFEF01F95F54@otce2k301.adaptec.com> <20071108172747.GA4054@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1762285AbXKHSJn@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <20071108172747.GA4054@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Andreas Schwab <schwab@suse.de>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Resounding ACK.

I just finished *exactly* the same set of changes, composed the patch
and was about to hit send when this one came over the wire from you!
There was absolutely no differences between our patches (save for the
fact I did not place the AIF ones in as they are already in the queue,
one is already on -mm).

I am going to return to this at some future date and figure out the
problems surrounding the context imbalances that are present, making
code that determines which context it is called from (sysfs, error
recovery or from the background thread) and plays with the various locks
confuses sparse. Rewriting so that the contexts are less programmatic is
in order...

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org] 
> Sent: Thursday, November 08, 2007 12:28 PM
> To: Salyzyn, Mark
> Cc: Christoph Hellwig; Andreas Schwab; Stephen Rothwell; 
> linux-scsi@vger.kernel.org; LKML
> Subject: Re: [PATCH 1/1] aacraid: don't assign cpu_to_le32(int) to u8
> 
> On Wed, Nov 07, 2007 at 01:51:44PM -0500, Salyzyn, Mark wrote:
> > Christoph Hellwig [mailto:hch@infradead.org] sez:
> > > Did anyone run the driver through sparse to see if we have 
> > > more issues like this?
> > 
> > There are some warnings from sparse, none like this one. I will deal
> > with the warnings ...
> 
> Actually there are a lot of endianess warnings, fortunately 
> most of them
> harmless.  The patch below fixes all of them up (including the ones in
> the patch I replied to), except for aac_init_adapter which is 
> really odd
> and I don't know what to do.
> 
