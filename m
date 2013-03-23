From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 08/15] be2iscsi: Fix displaying the FW Version from driver.
Date: Sat, 23 Mar 2013 01:00:47 -0500
Message-ID: <514D450F.9000801@cs.wisc.edu>
References: <1363063186-4902-1-git-send-email-jayamohan.kallickal@emulex.com> <1363063186-4902-8-git-send-email-jayamohan.kallickal@emulex.com> <51405526.1040203@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:60700 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755716Ab3CWGA7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 Mar 2013 02:00:59 -0400
In-Reply-To: <51405526.1040203@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steffen Maier <maier@linux.vnet.ibm.com>
Cc: jayamohank@gmail.com, james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, "Jayamohan.Kallickal" <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

I agree with Steffan's concerns below. Please fix or explain.

On 03/13/2013 05:29 AM, Steffen Maier wrote:
> On 03/12/2013 05:39 AM, jayamohank@gmail.com wrote:
>> From: "Jayamohan.Kallickal" <jayamohan.kallickal@emulex.com>
>>
>>     This patch fixes the display of proper FW Version from the drive=
r.
>>
>> Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
>> Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
>> ---
>>   drivers/scsi/be2iscsi/be_main.c |    2 ++
>>   drivers/scsi/be2iscsi/be_main.h |    2 ++
>>   drivers/scsi/be2iscsi/be_mgmt.c |   21 +++++++++++++++++++++
>>   drivers/scsi/be2iscsi/be_mgmt.h |   32 ++++++++++++++++++---------=
-----
>>   4 files changed, 43 insertions(+), 14 deletions(-)
>=20
>> diff --git a/drivers/scsi/be2iscsi/be_mgmt.h
>> b/drivers/scsi/be2iscsi/be_mgmt.h
>> index 2e4968a..0a406a4 100644
>> --- a/drivers/scsi/be2iscsi/be_mgmt.h
>> +++ b/drivers/scsi/be2iscsi/be_mgmt.h
>> @@ -156,25 +156,25 @@ union invalidate_commands_params {
>>   } __packed;
>>
>>   struct mgmt_hba_attributes {
>> -    u8 flashrom_version_string[32];
>> -    u8 manufacturer_name[32];
>> +    u8 flashrom_version_string[BEISCSI_VER_STRLEN];
>> +    u8 manufacturer_name[BEISCSI_VER_STRLEN];
>>       u32 supported_modes;
>>       u8 seeprom_version_lo;
>>       u8 seeprom_version_hi;
>>       u8 rsvd0[2];
>> -    u32 fw_cmd_data_struct_version;
>> +    u32 ioctl_data_struct_version;
>>       u32 ep_fw_data_struct_version;
>> -    u32 future_reserved[12];
>> +    u8 ncsi_version_string[12];
>=20
> Hm, this seems to replace 12*u32 by 12*u8, i.e. the subsequent fields
> would now have a reduced offset. Is this intentional? I would have
> expected to just use some part of future_reserved for newly defined
> fields and have the remainder of future_reserved still part of the
> structure to not shift the offset of subsequent fields; just like you
> did below in struct mgmt_hba_attributes.
>=20
>>       u32 default_extended_timeout;
>> -    u8 controller_model_number[32];
>> +    u8 controller_model_number[BEISCSI_VER_STRLEN];
>>       u8 controller_description[64];
>> -    u8 controller_serial_number[32];
>> -    u8 ip_version_string[32];
>> -    u8 firmware_version_string[32];
>> -    u8 bios_version_string[32];
>> -    u8 redboot_version_string[32];
>> -    u8 driver_version_string[32];
>> -    u8 fw_on_flash_version_string[32];
>> +    u8 controller_serial_number[BEISCSI_VER_STRLEN];
>> +    u8 ip_version_string[BEISCSI_VER_STRLEN];
>> +    u8 firmware_version_string[BEISCSI_VER_STRLEN];
>> +    u8 bios_version_string[BEISCSI_VER_STRLEN];
>> +    u8 redboot_version_string[BEISCSI_VER_STRLEN];
>> +    u8 driver_version_string[BEISCSI_VER_STRLEN];
>> +    u8 fw_on_flash_version_string[BEISCSI_VER_STRLEN];
>>       u32 functionalities_supported;
>>       u16 max_cdblength;
>>       u8 asic_revision;
>> @@ -190,7 +190,8 @@ struct mgmt_hba_attributes {
>>       u32 firmware_post_status;
>>       u32 hba_mtu[8];
>>       u8 iscsi_features;
>> -    u8 future_u8[3];
>> +    u8 asic_generation;
>> +    u8 future_u8[2];
>>       u32 future_u32[3];
>>   } __packed;
>=20
>> @@ -207,7 +208,7 @@ struct mgmt_controller_attributes {
>>       u64 unique_identifier;
>>       u8 netfilters;
>>       u8 rsvd0[3];
>> -    u8 future_u32[4];
>> +    u32 future_u32[4];
>>   } __packed;
>=20
> While I suppose this doesn't break existing functionality, is it
> intentional to actually increase the size of the trailing reserved
> fields and thus the size of the entire struct mgmt_controller_attribu=
tes?
>=20
> Steffen
>=20
> Linux on System z Development
>=20
> IBM Deutschland Research & Development GmbH
> Vorsitzende des Aufsichtsrats: Martina Koederitz
> Gesch=E4ftsf=FChrung: Dirk Wittkopp
> Sitz der Gesellschaft: B=F6blingen
> Registergericht: Amtsgericht Stuttgart, HRB 243294
>=20
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
