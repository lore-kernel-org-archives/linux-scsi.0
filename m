From: Martin Svec <martin.svec@zoner.cz>
Subject: Re: NAA breakage
Date: Sat, 10 Sep 2011 17:00:06 +0200
Message-ID: <4E6B7B76.4090805@zoner.cz>
References: <4E494F9F.4000909@zoner.cz>  <1313522082.2853.10.camel@haakon2.linux-iscsi.org>  <4E4BAB1D.6070104@zoner.cz>  <1313618333.9928.61.camel@haakon2.linux-iscsi.org>  <4E528F05.9090208@zoner.cz>  <4E6A0618.3040102@zoner.cz> <1315604283.7420.58.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ham1.zoner.com ([217.198.112.147]:57944 "EHLO ham1.zoner.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933216Ab1IJPGN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Sep 2011 11:06:13 -0400
In-Reply-To: <1315604283.7420.58.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>

Hi Nicholas,

thanks for your response, see my comments below.

Dne 9.9.2011 23:38, Nicholas A. Bellinger napsal(a):
> On Fri, 2011-09-09 at 14:27 +0200, Martin Svec wrote:
>> Hello folks,
>>
>> I'd like to reopen this discussion because there was no conclusion in
>> last three weeks and I still believe that the present implementation
>> of NAA IDs is wrong, regardless of the Andy's Shevchenko patch. Let me
>> explain why:
>>
> Hi Martin,
>
> Thanks for your follow-up here Martin.  Getting this resolved for v3.1
> is still on my todo list, and the patch I would like to push will be
> ready for review in the next days.  My thoughts on your comments are
> below.
>
>> (1) According to SCSI SPC-3 (7.6.10), 0x80 VPD unit serial number is a
>> vendor-assigned variable-length string of ASCII data with characters
>> 20h through 7Eh.
>>
> Correct
>
>> (2) target_emulate_evpd_83() wrongly assumes that the unit serial
>> number is a hex-encoded string with at least 25 characters and
>> generates NAA ID using hex2bin() from its first 25 chars.
>>
> Correct, the fix that I think makes the most sense here is to ensure
> that the unit serial number always contains only hex digits (by
> stripping out the non hex charactes) when set via configfs in
> vpd_unit_serial.

Martin: But then you place additional undocumented restrictions on the 
unit serial number format, don't you?

>> (3) SCSI SPC-3 (7.6.3.6.4) states that NAA IEEE Registered Extended
>> identifier is a 16-byte fixed-length binary sequence that is
>> _uniquely_ assigned by the organization associated with the IEEE
>> company_id (LIO uses OpenFabrics IEEE ID 00 14 05). That is, NAA ID
>> must be a guaranteed _stable_ worldwide-unique identifier and e.g.
>> VMware strongly relies on this.
>>
>>   From (1) and (2) it follows me that LIO does not guarantee the
>> uniqueness and in fact it very easily produces duplicate NAA IDs. For
>> example, unit serial numbers with a common 25-character prefix will
>> necessarily lead to the same NAA ID.
> It's the job of userspace to generate a UUID for the unit_serial number,
> and to ensure (as much as possible) the UUID is unique.  Taking the
> first 25 characters of this value has not created a problem so far.  Can
> you give an example of how it's 'very easily' able to produce duplicate
> NAA IDs..?

Martin: Again, SPC-3 says nothing about hex-character UUID as a unit 
serial number. That's the key point I try to emphasize -- you assume 
that it has a particular format but everbody who follows only the 
SPC-3 specification and doesn't know these LIO-specific restrictions 
risks duplicate NAA IDs. Below is an example of two unique SPC-3 
compliant serial numbers that result in the same NAA ID (tested with 
mainline kernel 3.1.0-rc1+):

$ sg_inq -p 0x83 /dev/sdc
VPD INQUIRY: Device Identification page
   Designation descriptor number 1, descriptor length: 20
     designator_type: NAA,  code_set: Binary
     associated with the addressed logical unit
       NAA 6, IEEE Company_id: 0x140f
       Vendor Specific Identifier: 0xfefbfef9f
       Vendor Specific Identifier Extension: 0xefefcfbfefef9fef
       [0x600140ffefbfef9fefefcfbfefef9fef]
   Designation descriptor number 2, descriptor length: 78
     designator_type: T10 vendor identification,  code_set: ASCII
     associated with the addressed logical unit
       vendor id: LIO-ORG
       vendor specific: 
IBLOCK:OurCompanyProductionSAN.StorageServer12.Customer524.Drive1

$ sg_inq -p 0x83 /dev/sdd
VPD INQUIRY: Device Identification page
   Designation descriptor number 1, descriptor length: 20
     designator_type: NAA,  code_set: Binary
     associated with the addressed logical unit
       NAA 6, IEEE Company_id: 0x140f
       Vendor Specific Identifier: 0xfefbfef9f
       Vendor Specific Identifier Extension: 0xefefcfbfefef9fef
       [0x600140ffefbfef9fefefcfbfefef9fef]
   Designation descriptor number 2, descriptor length: 78
     designator_type: T10 vendor identification,  code_set: ASCII
     associated with the addressed logical unit
       vendor id: LIO-ORG
       vendor specific: 
IBLOCK:OurCompanyProductionSAN.StorageServer12.Customer524.Drive2

Clearly, the serial numbers differ only in the last character (drive 
number), far beyond the 25 characters used for NAA. For somebody that 
starts with (i)SCSI and wants a unique and readable identification of 
its LUNs, these serial numbers IMHO perfectly make sense, are SPC-3 
compliant, but VMware vSphere will be totally confused of their NAAs 
generated by LIO. And for equally sized LUNs, I guess that there is 
even a chance for data corruption because VMware will probably assume 
that the two LUNs are two _paths_ to the _same_ LUN (I'll try to test it).

Note that the above example is a real-world example that I hit in 
January when I started to play with iSCSI and LIO. After first 
multipathing issues and without any knowledge of LIO/SPC3/NAA, it was 
easier for me to change my scripts to generate serial numbers based on 
hashes, rather than read standards and LIO sources to find out if it 
was my bug or not.

Another examples of colliding serial numbers are all strings that 
contain no hex characters or contain a mixture of hex and non-hex 
characters with identical hex characters ocurring on the same offsets.

>> With Andy's Shevchenko patch, the
>> same also holds for serial numbers that contain only non-hex
>> characters in first 25 bytes, resulting in NAA IDs full of 0xff. And
>> there are other cases where hex2bin() conversion applied to serial
>> numbers leads to duplicates.
>>
>> So the way NAA ID is generated from the serial number seems to be
>> broken and does not guarantee NAA ID uniqueness even if the serial
>> numbers are unique and SPC-3 compliant.
>>
>> However, I think that the solution is easy:
>>
>> (a) Provide a ConfigFS entry for NAA ID to allow userspace to maintain
>> the uniqueness on its own.
>>
> I am against exposing the NAA ID as a configfs attribute.  I still think
> basing this upon the EVPD 0x80 unit serial still makes the most sense,
> and to make userspace ensure (as much as possible) that the UUID ->  unit
> serial is unique.
>
>> (b) If no ConfigFS NAA ID is specified, target_emulate_evpd_83()
>> should make the best effort to generate unique NAA ID from the unit
>> serial number. An obvious solution is to compute a hash (e.g. SHA1)
>> from the unit serial number and use its 13 most significant bytes to
>> fill vendor-specific NAA ID bytes.
>>
> Generating a hash based upon unit serial for the vendor-specific NAA ID
> bytes might be useful, but I am still not convinced there is a real
> problem of duplicate NAA IDs using UUID based unit seriales for the
> vendor specific area..
>
>> Yes, the drawback is that such a change breaks NAA IDs of existing
>> setups. It's a question if it is better to maintain backward
>> compatibility, or fix it while LIO is in mainline for a short time yet.
>>
> I think the drawback is worth the extra pain here..  As mentioned, I am
> still leaning toward a simple fix to force hex characters for all
> vpd_unit_serial values set via configfs.
>
> --nab
>

Martin: Yes, that's a possible solution -- enforce vpd_unit_serial to 
be a hex-character string at least 25 characters long, and document 
that the first 25 characters must be unique within a given SAN. It's 
more restrictive than SPC-3 says but at least it doesn't allow to set 
vpd_unit_serial to something that leads to duplicate NAA IDs.

I still think that my proposal is better because it provides the same 
guarantees without additional restrictions to SPC-3 standard but I can 
live with it :-) All that I want is to save future LIO users from 
surprises caused by the NAA ID generation based on undocumented 
vpd_unit_serial assumptions.

Finally, please remember that VMware strongly relies on _unique_ and 
_stable_ NAA IDs. So your decision should be definitive, unless you 
provide a configfs interface for NAA IDs. It would be really bad to 
generate different NAA IDs in different versions of mainline kernel.

Martin

