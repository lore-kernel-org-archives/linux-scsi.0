From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] ieee1394: sbp2: lower block queue alignment requirement
Date: Mon, 15 Jan 2007 21:02:14 +0100 (CET)
Message-ID: <tkrat.8dad811bf4dbb360@s5r6.in-berlin.de>
References: <tkrat.37326df2d568d12d@s5r6.in-berlin.de>
 <1168802387.2780.1.camel@mulgrave.il.steeleye.com>
 <tkrat.cad61efa52eb6e56@s5r6.in-berlin.de>
 <59ad55d30701151139w6176e785g53404d7b3a42ce6e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:50434 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbXAOUCl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jan 2007 15:02:41 -0500
In-Reply-To: <59ad55d30701151139w6176e785g53404d7b3a42ce6e@mail.gmail.com>
Content-Disposition: INLINE
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?iso-8859-1?Q?Kristian_H=F8gsberg?= <krh@bitplanet.net>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

On 15 Jan, Kristian H=F8gsberg wrote:
> On 1/14/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>> OK, thanks. I will keep the explicit setting of the mask then.
>> I actually think that everything should work just fine with 4 bytes
>> alignment, but the SBP-2 spec mentiones 8 bytes alignment for the S/=
G
>> tables.  So maybe device firmwares will expect it that way even thou=
gh
>> IEEE 1394 doesn't impose such a restriction even on transfers with a
>> payload of a multiple of 8 bytes.
>=20
> Do you have a reference to this 8 byte alignment requirement?  I
> couldn't find it browsing through the standard.

SBP-2 clause 5.2. It's also in SBP-3 even though there is no obvious
benefit for this rule.

> Also, since the SBP-2
> driver has to  convert the scatterlist to an SBP-2 page table, it can
> just allocate the page table on a 8-byte boundary if that is required=
=2E

Yes, after the discussion this occurred to me too but my energy reserve=
s
were already too low to wrap this up.

>  The entries in the scatter table have no alignment restrictions from
> the SBP-2 side.
>=20
> By the way, is there a way to ask the SCSI stack to limit the size of
> the entries in the scatterlist to 64k?  This would greatly simplify
> the conversion to SBP-2 page tables, since this is the maximum size
> these can hold.

Douglas has a very informative text on this:
http://sg.torque.net/sg/sg_io.html#mozTocId154063

| [...] since lk 2.6.16 another limit comes into play: the
| MAX_SEGMENT_SIZE define which is set to 64 KB. MAX_SEGMENT_SIZE is a
| default and can be overridden by the LLD calling
| blk_queue_max_segment_size().

Looks like we can yank out some cruft off sbp2.
--=20
Stefan Richter
-=3D=3D=3D=3D=3D-=3D-=3D=3D=3D ---=3D -=3D=3D=3D=3D
http://arcgraph.de/sr/

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
