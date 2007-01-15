From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] ieee1394: sbp2: lower block queue alignment requirement
Date: Mon, 15 Jan 2007 13:50:28 -0600
Message-ID: <45ABDB04.1050307@cs.wisc.edu>
References: <tkrat.37326df2d568d12d@s5r6.in-berlin.de>	 <1168802387.2780.1.camel@mulgrave.il.steeleye.com>	 <tkrat.cad61efa52eb6e56@s5r6.in-berlin.de> <59ad55d30701151139w6176e785g53404d7b3a42ce6e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:49712 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439AbXAOTu4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Jan 2007 14:50:56 -0500
In-Reply-To: <59ad55d30701151139w6176e785g53404d7b3a42ce6e@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?B?S3Jpc3RpYW4gSMO4Z3NiZXJn?= <krh@bitplanet.net>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, James Bottomley <James.Bottomley@steeleye.com>, linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

Kristian H=C3=B8gsberg wrote:
> On 1/14/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>> On 14 Jan, James Bottomley wrote:
>> > The block layer currently provides sector (512) byte alignment
>> > guarantees.  However, there has been talk in SCSI of reducing that=
 to
>> > word (4) since that's what most intelligent PCI controllers can co=
pe
>> > with.  If you have any alignment constraints, they should be expre=
ssed
>> > in the slave configure.
>>
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
> couldn't find it browsing through the standard.  Also, since the SBP-=
2
> driver has to  convert the scatterlist to an SBP-2 page table, it can
> just allocate the page table on a 8-byte boundary if that is required=
=2E
> The entries in the scatter table have no alignment restrictions from
> the SBP-2 side.
>=20
> By the way, is there a way to ask the SCSI stack to limit the size of
> the entries in the scatterlist to 64k?  This would greatly simplify
> the conversion to SBP-2 page tables, since this is the maximum size
> these can hold.
>=20

I think 64k is the limit already, but I think you can call
blk_queue_max_segment_size in your scsi_host_template->slave_configure
or slave_alloc to set the size to whatever you like.
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
