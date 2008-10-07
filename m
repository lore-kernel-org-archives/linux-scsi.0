From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC] Normalizing byteorder/unaligned access API
Date: Tue, 07 Oct 2008 18:12:22 -0400
Message-ID: <1223417543.7484.7.camel@localhost.localdomain>
References: <1223416391.8195.22.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:50612 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757126AbYJGWMd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Oct 2008 18:12:33 -0400
In-Reply-To: <1223416391.8195.22.camel@brick>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@ZenIV.linux.org.uk>, linux-arch <linux-arch@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>, linux-scsi <linux-scsi@vger.kernel.org>, Boaz Harrosh <bharrosh@panasas.com>

On Tue, 2008-10-07 at 14:53 -0700, Harvey Harrison wrote:
> [related question regarding the SCSI-private endian helper needs at the end]
> 
> Currently on the read side, we have (le16 as an example endianness)
> 
> le16_to_cpup(__le16 *)
> get_unaligned_le16(void *)
> 
> And on the write side:
> 
> *(__le16)ptr = cpu_to_le16(u16)
> put_unaligned_le16(u16, void *);
> 
> On the read side, Al said he would have preferred the unaligned version
> take the same types as the aligned, rather than void *.  AKPM didn't think
> the use of get_ was that great as get/put generally implies some kind of reference
> taking in the kernel.
> 
> As the le16_to_cpup has been around for so long and is more recognizable, let's
> make it the same for the unaligned case and typesafe:
> 
> le16_to_cpup(__le16 *)
> unaligned_le16_to_cpup(__le16 *)
> 
> On the write side, the above get/put and type issues are still there, in addition AKPM felt
> that the ordering of the put_unaligned parameters was opposite what was intuitive and that
> the pointer should come first.
> 
> In this case, as there is currently no aligned helper (other than in some drivers defining macros)
> define the api thusly:
> 
> Aligned:
> write_le16(__le16 *ptr, u16 val)
> 
> Unaligned:
> unaligned_write_le16(__le16 *ptr, u16 val)

Well, for us it would be even worse since now we'll have to do casting
to __beX just to shut sparse up, which makes the code even more
unreadable.

> The existing get/put_unaligned macros do not necessarily need to be modified.  It would
> present one oddity that the parameter order was different, but that's not a huge issue.
> 
> These could be phased in as they do not collide with the current API and the old api converted
> over fairly quickly as not many places use the get/put_unaligned_{endian} helpers yet.
> 
> In addition, there are some subsystems (scsi) that are looking into some differently sized
> endian helpers (be24) and it may be worthwhile to have some agreement whether it is worth
> making them common infrastructure and whether they should present a similar API to the
> common byteorder/unaligned API.
> 
> Is this a worthwhile direction to take?

I really don't think so.  The current:

cmd[2] = X >> 24;
cmd[3] = X >> 16;
...

make sense to a storage person because they replicate exactly how the
standards are laid out.  They're also clearer than the plethora of
unaligned_write_be32 etc.

The only real one we need an accessor for is 64 bits ... purely because
most people are too lazy to write all eight statements.

The optimisation argument is a bit of a myth ... the number of cycles
taken by these stores is dwarfed by the rest of the code path, even if
the compiler totally screws up the optimisation, which, realistically,
it shouldn't since it should know the platform native endianness in most
cases.

There was a fairly luke warm response to the idea of SCSI accessors
basically showing the level of apathy; certainly generic ones would be a
shade worse than this because now readers have to work out what they're
doing.  In general, I'd prefer the SCSI stack just be left alone rather
than converted to accessors like this.

James


