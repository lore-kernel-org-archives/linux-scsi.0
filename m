From: "Cameron, Steve" <Steve.Cameron@hp.com>
Subject: RE: SG_IO weirdness
Date: Mon, 5 Feb 2007 22:53:09 -0000
Message-ID: <558F4D473FD7FE419B019232BF2D37B40B22FF@G3W0634.americas.hpqcorp.net>
References: <558F4D473FD7FE419B019232BF2D37B40B22F2@G3W0634.americas.hpqcorp.net> <45C782CF.9030207@torque.net> <558F4D473FD7FE419B019232BF2D37B40B22F8@G3W0634.americas.hpqcorp.net> <45C79F59.3090305@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ccerelbas03.cce.hp.com ([161.114.21.106]:54511 "EHLO
	ccerelbas03.cce.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965005AbXBEWxe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Feb 2007 17:53:34 -0500
Received: from G3W0060.americas.hpqcorp.net (g3w0060.americas.hpqcorp.net [16.232.1.19])
	by ccerelbas03.cce.hp.com (Postfix) with ESMTP id AF96634500
	for <linux-scsi@vger.kernel.org>; Mon,  5 Feb 2007 16:53:33 -0600 (CST)
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org



> Steve,
> From memory, between SPC-2 and SPC-3 the INQUIRY allocation
> length field went from 8 bits to 16 bits. If you do the
> above calculation modulo 256 it comes out correct :-)
>
> The moral here is don't set INQUIRY lengths > 252
> unless the target can handle it. There is no point
> anyway for a "standard" INQUIRY (EVPD=0, CmdDt is
> obsolete). With VPD pages you can do a double fetch,
> the first one 4 bytes long to pick up "page length"
> field.
> But then again you said the cdb was nonsense.

yeah, the 2nd command was not inquiry, it is a vendor
specific command.  when I reduced the buffer size < 256,
it began to work (not get check condition/sense key == 5).
I think I just have some misunderstanding about the CDB
format for xfer sizes > 256, but that is my problem,
not yours.  Mainly, I just thought SG_IO was behaving weird,
so I thought I should mention it.

It occurs to me that if I do this, below, after the SG_IO ioctl, 
it suppresses the extra data transferred (obviously):

memset(buffer + buffer_size - sgio.resid, 0, sgio.resid);

Though you mentioned that not all devices/LLD set resid?

> Now it is still a bit fuzzy because there is the
> allocation length field in some cdbs and the dxfer_len
> given to sg_io_hdr. I would think that the LLD
> should concentrate on the latter and set resid
> accordingly. That makes me wonder about the LLD
> involved (the sg driver just passes resid through).

Hmm, I was able to get the same behavior from mptsas,
qla2xxx, and cciss with SAS drives, HP MSA1000, and tape
drives for target devices, respectively, so not sure the 
LLD matters.

[...]

Thanks for taking the time to explain some of this
to me.

I can try to distill out a small test program, if it
would be of interest.

-- steve


