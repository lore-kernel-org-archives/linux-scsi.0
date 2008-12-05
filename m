From: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [RFC PATCH-mm] scsi: use unaligned endian helpers rather than
 byteshifting
Date: Fri, 05 Dec 2008 01:07:18 -0800
Message-ID: <1228468038.6166.14.camel@brick>
References: <1228333043.5412.35.camel@brick>
	 <1228336386.5551.66.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.175]:40285 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbYLEJHV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Dec 2008 04:07:21 -0500
Received: by wf-out-1314.google.com with SMTP id 27so4665303wfd.4
        for <linux-scsi@vger.kernel.org>; Fri, 05 Dec 2008 01:07:20 -0800 (PST)
In-Reply-To: <1228336386.5551.66.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2008-12-03 at 14:33 -0600, James Bottomley wrote:
> On Wed, 2008-12-03 at 11:37 -0800, Harvey Harrison wrote:
> > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> > ---
> > Depends on the unaligned access work in -mm.  Just so you can see what the
> > transition would look like.  See in particular the READ/WRITE6 bits
> > as just reading the full 32 bits and masking ends up being better on
> > lots of arches. (x86/powerpc/SH at least)
> 
> Well, as I've said before, I'm not particularly interested in moving
> SCSI over to the generic accessors.  It does look like the proponents of
> SCSI specific ones gave up as well (most driver writers even open coded
> their own over the u32 one we already have).

Well, I thought this over some more, since it seems that the offset
provides useful information to scsi-developers, how about an interface
like:

u16 load_be16_offset(u8 *buf, unsigned int offset)
u32 load_be24_offset(u8 *buf, unsigned int offset)
u32 load_be32_offset(u8 *buf, unsigned int offset)
u64 load_be64_offset(u8 *buf, unsigned int offset)

Which reads the given value in the given endianness from a (positive)
offset?  Since there don't exist any common structs in scsi-land that
would allow sparse checking and you'd have to have casts everywhere,
this might be a nice compromise.

Document that these guys make no alignment assumptions and use the
generic accessors inside...they are simple enough that they would
fit in the common code and be useful elsewhere as well.

What do you think of that James/Matthew?

Harvey


