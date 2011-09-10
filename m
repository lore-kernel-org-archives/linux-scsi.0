From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: NAA breakage
Date: Sat, 10 Sep 2011 13:37:41 -0700
Message-ID: <1315687061.12709.52.camel@haakon2.linux-iscsi.org>
References: <4E494F9F.4000909@zoner.cz>
	 <1313522082.2853.10.camel@haakon2.linux-iscsi.org>
	 <4E4BAB1D.6070104@zoner.cz>
	 <1313618333.9928.61.camel@haakon2.linux-iscsi.org>
	 <4E528F05.9090208@zoner.cz>  <4E6A0618.3040102@zoner.cz>
	 <1315604283.7420.58.camel@haakon2.linux-iscsi.org>
	 <4E6B7B76.4090805@zoner.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:56842 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933943Ab1IJUhu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Sep 2011 16:37:50 -0400
In-Reply-To: <4E6B7B76.4090805@zoner.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Svec <martin.svec@zoner.cz>
Cc: target-devel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>

On Sat, 2011-09-10 at 17:00 +0200, Martin Svec wrote:
> Hi Nicholas,
> 
> thanks for your response, see my comments below.
> 
> Dne 9.9.2011 23:38, Nicholas A. Bellinger napsal(a):
> > On Fri, 2011-09-09 at 14:27 +0200, Martin Svec wrote:

<SNIP>

> >
> >> (2) target_emulate_evpd_83() wrongly assumes that the unit serial
> >> number is a hex-encoded string with at least 25 characters and
> >> generates NAA ID using hex2bin() from its first 25 chars.
> >>
> > Correct, the fix that I think makes the most sense here is to ensure
> > that the unit serial number always contains only hex digits (by
> > stripping out the non hex charactes) when set via configfs in
> > vpd_unit_serial.
> 
> Martin: But then you place additional undocumented restrictions on the 
> unit serial number format, don't you?
> 

No, it does not.  It's vendor specific and perfectly within what's
allowable as defined by SPC-3.

> >> (3) SCSI SPC-3 (7.6.3.6.4) states that NAA IEEE Registered Extended
> >> identifier is a 16-byte fixed-length binary sequence that is
> >> _uniquely_ assigned by the organization associated with the IEEE
> >> company_id (LIO uses OpenFabrics IEEE ID 00 14 05). That is, NAA ID
> >> must be a guaranteed _stable_ worldwide-unique identifier and e.g.
> >> VMware strongly relies on this.
> >>
> >>   From (1) and (2) it follows me that LIO does not guarantee the
> >> uniqueness and in fact it very easily produces duplicate NAA IDs. For
> >> example, unit serial numbers with a common 25-character prefix will
> >> necessarily lead to the same NAA ID.
>
> > It's the job of userspace to generate a UUID for the unit_serial number,
> > and to ensure (as much as possible) the UUID is unique.  Taking the
> > first 25 characters of this value has not created a problem so far.  Can
> > you give an example of how it's 'very easily' able to produce duplicate
> > NAA IDs..?
> 
> Martin: Again, SPC-3 says nothing about hex-character UUID as a unit 
> serial number. That's the key point I try to emphasize -- you assume 
> that it has a particular format but everbody who follows only the 
> SPC-3 specification and doesn't know these LIO-specific restrictions 
> risks duplicate NAA IDs.

Not exactly.  When it doubt, people need to follow the offical userspace
code.  I am happy to support people who insist on their own interface to
configfs, but for something like this your code needs to follow what our
existing userspace library does to ensure uniqueness.

>  Below is an example of two unique SPC-3 
> compliant serial numbers that result in the same NAA ID (tested with 
> mainline kernel 3.1.0-rc1+):
> 
> $ sg_inq -p 0x83 /dev/sdc
> VPD INQUIRY: Device Identification page
>    Designation descriptor number 1, descriptor length: 20
>      designator_type: NAA,  code_set: Binary
>      associated with the addressed logical unit
>        NAA 6, IEEE Company_id: 0x140f
>        Vendor Specific Identifier: 0xfefbfef9f
>        Vendor Specific Identifier Extension: 0xefefcfbfefef9fef
>        [0x600140ffefbfef9fefefcfbfefef9fef]
>    Designation descriptor number 2, descriptor length: 78
>      designator_type: T10 vendor identification,  code_set: ASCII
>      associated with the addressed logical unit
>        vendor id: LIO-ORG
>        vendor specific: 
> IBLOCK:OurCompanyProductionSAN.StorageServer12.Customer524.Drive1
> 
> $ sg_inq -p 0x83 /dev/sdd
> VPD INQUIRY: Device Identification page
>    Designation descriptor number 1, descriptor length: 20
>      designator_type: NAA,  code_set: Binary
>      associated with the addressed logical unit
>        NAA 6, IEEE Company_id: 0x140f
>        Vendor Specific Identifier: 0xfefbfef9f
>        Vendor Specific Identifier Extension: 0xefefcfbfefef9fef
>        [0x600140ffefbfef9fefefcfbfefef9fef]
>    Designation descriptor number 2, descriptor length: 78
>      designator_type: T10 vendor identification,  code_set: ASCII
>      associated with the addressed logical unit
>        vendor id: LIO-ORG
>        vendor specific: 
> IBLOCK:OurCompanyProductionSAN.StorageServer12.Customer524.Drive2
> 
>

FYI, descriptor number 2 above this is the 0x83 T10 vendor ID, and not
the 0x80 unit serial number.

> Clearly, the serial numbers differ only in the last character (drive 
> number), far beyond the 25 characters used for NAA. For somebody that 
> starts with (i)SCSI and wants a unique and readable identification of 
> its LUNs, these serial numbers IMHO perfectly make sense, are SPC-3 
> compliant, but VMware vSphere will be totally confused of their NAAs 
> generated by LIO.

This is broken userspace code that is using the unit serial number for
informational purposes.  Please don't do this.

All of the lio-utils and rtslib userspace generate a uuid for the unit
serial number,  and do not have an issue with the scenario you are
describing.  This is what your userspace should be doing as well.  

> >> However, I think that the solution is easy:
> >>
> >> (a) Provide a ConfigFS entry for NAA ID to allow userspace to maintain
> >> the uniqueness on its own.
> >>
> > I am against exposing the NAA ID as a configfs attribute.  I still think
> > basing this upon the EVPD 0x80 unit serial still makes the most sense,
> > and to make userspace ensure (as much as possible) that the UUID ->  unit
> > serial is unique.
> >
> >> (b) If no ConfigFS NAA ID is specified, target_emulate_evpd_83()
> >> should make the best effort to generate unique NAA ID from the unit
> >> serial number. An obvious solution is to compute a hash (e.g. SHA1)
> >> from the unit serial number and use its 13 most significant bytes to
> >> fill vendor-specific NAA ID bytes.
> >>
> > Generating a hash based upon unit serial for the vendor-specific NAA ID
> > bytes might be useful, but I am still not convinced there is a real
> > problem of duplicate NAA IDs using UUID based unit seriales for the
> > vendor specific area..
> >
> >> Yes, the drawback is that such a change breaks NAA IDs of existing
> >> setups. It's a question if it is better to maintain backward
> >> compatibility, or fix it while LIO is in mainline for a short time yet.
> >>
> > I think the drawback is worth the extra pain here..  As mentioned, I am
> > still leaning toward a simple fix to force hex characters for all
> > vpd_unit_serial values set via configfs.
> >
> 
> Martin: Yes, that's a possible solution -- enforce vpd_unit_serial to 
> be a hex-character string at least 25 characters long, and document 
> that the first 25 characters must be unique within a given SAN. It's 
> more restrictive than SPC-3 says but at least it doesn't allow to set 
> vpd_unit_serial to something that leads to duplicate NAA IDs.
> 
> I still think that my proposal is better because it provides the same 
> guarantees without additional restrictions to SPC-3 standard but I can 
> live with it :-) All that I want is to save future LIO users from 
> surprises caused by the NAA ID generation based on undocumented 
> vpd_unit_serial assumptions.
> 

No, changing kernel code to address the breakage of your own userspace
is not an option here.

Please fix your userspace code to follow what rtslib has always done to
ensure the uniqueness of vpd_unit_serial via a well known method (eg:
uuid).

http://www.risingtidesystems.com/git/?p=rtslib.git;a=blob;f=rtslib/tcm.py;h=4da49b0f4a4aea9a1eebed23d457181085a2d03d;hb=HEAD#l307

Thanks,

--nab

