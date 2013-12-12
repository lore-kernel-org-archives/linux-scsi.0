From: Loc Ho <lho@apm.com>
Subject: Re: [PATCH v4 2/4] Documentation: Add APM X-Gene SoC 15Gbps
 Multi-purpose PHY driver binding documentation
Date: Thu, 12 Dec 2013 15:30:47 -0800
Message-ID: <CAPw-ZTnBEj0ap60iHB7peMkEvOAJxyNFmd40+cZmAcTXOpi3Ug@mail.gmail.com>
References: <1386833435-30498-1-git-send-email-lho@apm.com>
	<201312121427.20040.arnd@arndb.de>
	<52A9C8C5.8030809@interlog.com>
	<201312122129.26714.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og110.obsmtp.com ([64.18.0.20]:47896 "HELO
	exprod5og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751912Ab3LLXas (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Dec 2013 18:30:48 -0500
Received: by mail-qc0-f182.google.com with SMTP id e16so936649qcx.27
        for <linux-scsi@vger.kernel.org>; Thu, 12 Dec 2013 15:30:47 -0800 (PST)
In-Reply-To: <201312122129.26714.arnd@arndb.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: dgilbert@interlog.com, Olof Johansson <olof@lixom.net>, Tejun Heo <tj@kernel.org>, Linux SCSI List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Jon Masters <jcm@redhat.com>, "patches@apm.com" <patches@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>

Hi,


On Thu, Dec 12, 2013 at 12:29 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 12 December 2013, Douglas Gilbert wrote:
>> >
>> >> +- apm,tx-speed              : Tx operating speed. One set of 3-tuple for
>> >> +                      Gen1 (0x1), Gen2 (0x3), and Gen3 (0x7). Default is
>> >> +                      0x7.
>> >
>> > I'm completely confused by this description. Can you rephrase this?
>> > It sounds like the only possible values are <1 3 7> for this property.
>>
>> Most likely Gen1, Gen2 and Gen3 are SATA-speak corresponding to SAS's
>> G1, G2 and G3:
>>
>> G1   Gen1     1.5 Gbps
>> G2   Gen2     3 Gbps
>> G3   Gen3     6 Gbps
>> G4   -        12 Gbps
>> G5   -        24 Gbps
>>
>> And the "7" corresponding to Gen3 is indicating backward compatibility
>> with Gen2 and Gen1. The SAS-3 draft only requires backward compatibility
>> two generations. Thus you can buy a SAS 12 Gbps HBA today that will
>> not support the original SATA 1.5 Gbps class of disks. The corresponding
>> value would be 0xe (rather than 0xf) using the tx-speed convention above.
>>
>>
>> My explanation is a bit long winded to put in a device-tree bindings
>> file. "RTFM: SATA drafts." should suffice.
>>
>>
>> BTW Compared to some device-tree binding explanations I have had
>> to wade through, the above looks pretty good.
>>
>
> Well, the problem is that this is not a SATA device but a PHY device
> that happens to support SATA among its protocols (at least PCIe
> as well, possibly more but I don't have the specs). The binding
> document has to cover all the possibilities or allow extensions
> for the other protocols to be implemented later. Having the driver
> support SATA only initially is fine, but we shouldn't plan for
> breaking compatibility with an established binding just a short time
> later.
>
[Loc Ho]
I will document them as XXGbps and drop the term GenX. As of right
now, we only have SATA and I will document on 1.5Gbps, 3.0Gbps, and
6Gbps. Also, keep in mind that these override are used for SATA. PCIe
doesn't need these custom override setting per port at this time. A
single value so far work just fine for PCIe, SGMII, and XFI.

Any other comments...

-Loc
