From: Luben Tuikov <luben@splentec.com>
Subject: Re: [CARE]: number of LUNS from REPORT LUNS data report and macros
Date: Thu, 29 Aug 2002 14:54:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D6E6DF8.78AA3952@splentec.com>
References: <3D6ACCA2.68364DDA@splentec.com> <20020826181058.A19719@eng2.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from splentec.com (canoe.splentec.com [209.47.35.250])
	by pepsi.splentec.com (8.11.6/8.11.0) with ESMTP id g7TIskH27635
	for <linux-scsi@vger.kernel.org>; Thu, 29 Aug 2002 14:54:46 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Patrick Mansfield wrote:
> 
> >
> > Firstly, I don't think that one can quite do
> > ``num_luns = (length / sizeof(ScsiLun));'' in scsi_scan.c.
> 
> length is the length returned from the REPORT LUNS, and sizeof(ScsiLun)
> is the size of an element in the REPORT LUNS. I don't see any better
> way to get the number of luns.

This is fine. My objection is ScsiLun as a type. Certainly looks
more like a big struct, e.g. Scsi_Device <=> pid_t, do you see
what I'm hinting at?

Someone may decide to add something to ScsiLun and
then surprize, surprize.

I don't know what will be a good way of representing
64 bit LUN, u64 seems attractive, but so does u8[8].

(We also have to take into account the fact than one day
this will be exported to userspace. What does Sun do?)

> > A SCSI LUN should be represented by ``u64''. Futhermore, only
> > a LLDD should poplulate such a variable (as outlined in another email)
> > directly or indirectly (though REPORT LUNS data).
> 
> IMO all the SCSI data is best represented as u8 chunks, but having a
> ScsiLun type (even with the butchered case) makes this simple to change.
> I see there are a bunch of u_char's, I'm not even sure if u8 or u_char
> is right.

Use u8 (if _that_ is what you are going to use).

Yes, most data is ok being represented as u8 [], am I'm not quite so
sure about a 64 bit LUN. Probably a u64, and when in a register (YKWIM),
it is ordered as per the spec -- what'd be kinda easier for userspace
users.
 
> Yes, but it is a static function, so to get rid of the ifdefs here
> I'd have to move code to a .h or something; I did do an inline
> on the #else portion, so there is no #ifdef in the caller.

Just _declare_ it as static -- that should do for the linker...

-- 
Luben
