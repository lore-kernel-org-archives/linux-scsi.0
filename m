From: Chris Boot <bootc@bootc.net>
Subject: Re: [PATCH 1/3] firewire-sbp2: Take into account Unit_Unique_ID
Date: Sat, 11 Feb 2012 12:26:29 +0000
Message-ID: <4F365E75.2030302@bootc.net>
References: <EE1CAC85-DF0C-4C21-B2BD-446C481C938F@bootc.net> <1328881314-26544-1-git-send-email-bootc@bootc.net> <1328881314-26544-2-git-send-email-bootc@bootc.net> <20120211121250.5e2fe781@stein>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120211121250.5e2fe781@stein>
Sender: linux-kernel-owner@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11/02/2012 11:12, Stefan Richter wrote:
> On Feb 10 Chris Boot wrote:
>> If the target's unit directory contains a Unit_Unique_ID entry, we
>> should use that as the target's GUID for identification purposes. The
>> SBP-2 standards document says:
>>
>> "Although the node unique ID (EUI-64) present in the bus information
>> block is sufficient to uniquely identify nodes attached to Serial Bus,
>> it is insufficient to identify a target when a vendor implements a
>> device with multiple Serial Bus node connections. In this case initiator
>> software requires information by which a particular target may be
>> uniquely identified, regardless of the Serial Bus access path used."
>>
>> [ IEEE T10 P1155D Revision 4, Section 7.6 (page 51) ] and
>> [ IEEE T10 P1467D Revision 5, Section 7.9 (page 74) ]
>>
>> Signed-off-by: Chris Boot<bootc@bootc.net>
>> Cc: Stefan Richter<stefanr@s5r6.in-berlin.de>
>> ---
>>   drivers/firewire/sbp2.c |   17 +++++++++++++++++
>>   1 files changed, 17 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
>> index 80e95aa..ed5bbbf 100644
>> --- a/drivers/firewire/sbp2.c
>> +++ b/drivers/firewire/sbp2.c
>> @@ -211,6 +211,7 @@ static struct fw_device *target_device(struct sbp2_target *tgt)
>>   #define SBP2_CSR_UNIT_CHARACTERISTICS	0x3a
>>   #define SBP2_CSR_FIRMWARE_REVISION	0x3c
>>   #define SBP2_CSR_LOGICAL_UNIT_NUMBER	0x14
>> +#define SBP2_CSR_UNIT_UNIQUE_ID		0x8d
>>   #define SBP2_CSR_LOGICAL_UNIT_DIRECTORY	0xd4
>>
>>   /* Management orb opcodes */
>> @@ -997,6 +998,17 @@ static int sbp2_add_logical_unit(struct sbp2_target *tgt, int lun_entry)
>>   	return 0;
>>   }
>>
>> +static int sbp2_get_unit_unique_id(struct sbp2_target *tgt,
>> +				    const u32 *leaf)
>> +{
>> +	if ((leaf[0]&  0xffff0000) != 0x00020000)
>> +		return -EINVAL;
>
> This could be relaxed to "if (leaf[0]<  0x00020000)", but the stricter
> check is fine too.

Well the standard does say the length must be exactly 2 rather than just 
defining it a leaf node that contains an EUI-64. But I did not realise 
various firmware gets things quite so wrong sometimes...

>> +
>> +	tgt->guid = (u64)leaf[1]<<  32 | leaf[2];
>> +
>> +	return 0;
>> +}
>> +
>>   static int sbp2_scan_logical_unit_dir(struct sbp2_target *tgt,
>>   				      const u32 *directory)
>>   {
>> @@ -1048,6 +1060,11 @@ static int sbp2_scan_unit_dir(struct sbp2_target *tgt, const u32 *directory,
>>   				return -ENOMEM;
>>   			break;
>>
>> +		case SBP2_CSR_UNIT_UNIQUE_ID:
>> +			if (sbp2_get_unit_unique_id(tgt, ci.p - 1 + value)<  0)
>> +				return -EINVAL;
>> +			break;
>> +
>>   		case SBP2_CSR_LOGICAL_UNIT_DIRECTORY:
>>   			/* Adjust for the increment in the iterator */
>>   			if (sbp2_scan_logical_unit_dir(tgt, ci.p - 1 + value)<  0)
>
> The error return here is wrong.  Garbage in a non-essential part of the
> Config ROM is no reason to refuse to work with a device.  It is too common
> for firmware to have various bogus values in there.  For instance, we
> never check the CRC of a Config ROM block because wrongly calculated CRCs
> or even zero CRC is quite commonly seen with otherwise correct Config ROMs.

Wow. I didn't expect things to get so bad. :-( I guess in this case we 
simply ignore the return value, which would have the effect of not 
setting the GUID.

> And there is another problem with the patch:  In fringe cases, we might
> now create more than one scsi_device instances with the same ieee1394_id
> sysfs attribute value.   Those cases are:
>   1. There are two targets present which expose the same, hence non-unique
>      and thus standards-violating Unit_Unique_ID. Or
>   2. There is a single target connected through more than one link, it has
>      got a Unit_Unique_ID, and either
>       2.a  it accepts concurrent login despite firewire-sbp2 demanding an
>            exclusive login (which is its default mode), or
>       2.b  firewire-sbp2 is configured to work in concurrent login mode and
>            the target grants concurrent logins.
>
> We do not need to care for case 1.  It cannot be distinguished from case
> 2, and we already do not care for the case that there are two or more
> nodes with a non-unique Node_Unique_ID.  Devices with the latter bug exist
> but are rare, judging from historical discussion on linux1394-devel.
>
> Case 2.a is highly unlikely, and I think we should not worry about that
> either.
>
> Should we do something about case 2.b?  Where in the Linux SCSI
> initiator stack is multipathing handled --- in transport layer drivers or
> higher up?  (Cc'ing LSML for this question.)

I believe multipathing is handled by multipathd, which uses devmapper to 
handle the actual data flow. Multipathd itself works out which LUNs it 
can see over multiple paths (using multiple /dev/sdX devices) and just 
creates the devmapper mappings as necessary. I'm not even convinced 
multipathd would care about the SBP-2 target port identifier, preferring 
instead to use the WWN on the LUN.

HTH,
Chris

-- 
Chris Boot
bootc@bootc.net
