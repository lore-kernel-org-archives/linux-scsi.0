From: Douglas Gilbert <dougg@torque.net>
Subject: CSMI [was: Re: [ANNOUNCE] MPT Fusion driver 3.02.06 update]
Date: Fri, 05 Nov 2004 10:55:27 +1000
Message-ID: <418ACF7F.3060809@torque.net>
References: <0E3FA95632D6D047BA649F95DAB60E57053AF031@exa-atlanta> <20041026103828.GC12026@infradead.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:48803 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S262527AbUKEAz5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Nov 2004 19:55:57 -0500
In-Reply-To: <20041026103828.GC12026@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Moore, Eric Dean" <Emoore@lsil.com>, linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> On Mon, Oct 25, 2004 at 07:32:35PM -0400, Moore, Eric Dean wrote:
>=20
>>All,
>>
>>We are pleased to announce the MPT Fusion release candidate for lk 2.=
6
>=20
>=20
> Some things that come to mind immediately:
>=20
>=20
>>
>>Highlights of this release:
>>=B7	SAS Support - 1064, 1066, 1068
>=20
>=20
> there's still tons of ioc->chip_type checks for SPI vs FC vs SAS -=20
> please always use the new bus_type member
>=20
>=20
>=20
>>=B7	csmi ioctl support
>=20
>=20
> rejected, this ioctl interface is completely horrible, even worse tha=
n
> the fc hbaapi.  Please help to provide a proper sas transport class s=
imilar
> to the fc one.

Christoph,
I'm not so sure why you want to reject this ioctl
at this stage when our existing infrastructure to handle
the 4 protocols that go through this SAS HBA is weak.
Those 4 protocols are:
   a) SSP (SCSI over a SAS transport) we should be able to
      handle this one ***  ****
   b) SMP is a packet like protocol meant mainly to probe
      and control expanders (think device discovery). The
      "target" is not necessarily a SCSI device and there
      is no concept of luns. Nice candidate for the sg driver.
   c) STP: ATA/ATAPI-7 tunnelled through a SAS transport with
      a SAS/sATA bridge probably hiding in an expander
   d) sATA: direct connect of a sATA disk to this SAS HBA

The t10 meeting next week will be considering the
"Common Storage Management Interface for SAS" (CSMI)
proposal. Here is a url for it:
ftp://ftp.t10.org/t10/document.04/04-284r0.pdf
This document names 3 target platforms: Windows, Linux
(2.4 and 2.6 series) and Netware.

This seems like a serious attempt to retrofit a control
(and passthrough) interface into existing OS SCSI stacks
at the LLD level. I have no information but I would expect
the Adaptec SAS HBA (when and if its Open source driver
becomes public) to follow the same (or a similar) route.


*** The primary SAS device identifier is a 64 bit SAS address
(naa 5, world wide unique). CSMI defines mapping functions
between the <h,c,t> like tuples that most OSes use in their
SCSI stacks (thanks to SPI) and SAS addresses. In short the CSMI
proposal looks like the distilled experience of writing real
SAS HBA drivers for several existing OSes.

**** Given the BCC (bridge controller commands) draft at t10
it would appear that SAS disk enclosure designers want to
command set convert ATA/ATAPI-7 into SPC in the enclosure.
That way sATA disks will appear as SAS disks (with a SCSI-ATA
pass-through command for awkward things like SMART). Such a
move would make the STP protocol superfluous.

Doug Gilbert
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
