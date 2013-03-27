From: "Kallickal, Jayamohan" <Jayamohan.Kallickal@Emulex.Com>
Subject: RE: [PATCH 08/15] be2iscsi: Fix displaying the FW Version from
 driver.
Date: Wed, 27 Mar 2013 20:19:52 +0000
Message-ID: <74ccdedd-f62c-40bf-8130-e973f689be1b@CMEXHTCAS2.ad.emulex.com>
References: <1363063186-4902-1-git-send-email-jayamohan.kallickal@emulex.com>
 <1363063186-4902-8-git-send-email-jayamohan.kallickal@emulex.com>
 <51405526.1040203@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:34864 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282Ab3C0UUA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Mar 2013 16:20:00 -0400
In-Reply-To: <51405526.1040203@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steffen Maier <maier@linux.vnet.ibm.com>, "jayamohank@gmail.com" <jayamohank@gmail.com>
Cc: "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "John, Sony" <Sony.John-N@Emulex.Com>

Thanks Steffen for the comments.=20

I agree with you that we could have subsequent fields with invalid data=
=2E However, we have not been really using any of the later fields,=20
Other than firmware_version_string and iSCSI_features which are used pr=
imarily for information (prints) while in debug state.

So, the structure we were using was very old and used by our very early=
 chips(BE1) which were never supported by this driver.

Thanks
Jay
-----Original Message-----
=46rom: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.=
kernel.org] On Behalf Of Steffen Maier
Sent: Wednesday, March 13, 2013 3:30 AM
To: jayamohank@gmail.com
Cc: james.bottomley@hansenpartnership.com; linux-scsi@vger.kernel.org; =
michaelc@cs.wisc.edu; Kallickal, Jayamohan; John, Sony
Subject: Re: [PATCH 08/15] be2iscsi: Fix displaying the FW Version from=
 driver.

On 03/12/2013 05:39 AM, jayamohank@gmail.com wrote:
> From: "Jayamohan.Kallickal" <jayamohan.kallickal@emulex.com>
>
> 	This patch fixes the display of proper FW Version from the driver.
>
> Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
> Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
> ---
>   drivers/scsi/be2iscsi/be_main.c |    2 ++
>   drivers/scsi/be2iscsi/be_main.h |    2 ++
>   drivers/scsi/be2iscsi/be_mgmt.c |   21 +++++++++++++++++++++
>   drivers/scsi/be2iscsi/be_mgmt.h |   32 ++++++++++++++++++----------=
----
>   4 files changed, 43 insertions(+), 14 deletions(-)

> diff --git a/drivers/scsi/be2iscsi/be_mgmt.h=20
> b/drivers/scsi/be2iscsi/be_mgmt.h index 2e4968a..0a406a4 100644
> --- a/drivers/scsi/be2iscsi/be_mgmt.h
> +++ b/drivers/scsi/be2iscsi/be_mgmt.h
> @@ -156,25 +156,25 @@ union invalidate_commands_params {
>   } __packed;
>
>   struct mgmt_hba_attributes {
> -	u8 flashrom_version_string[32];
> -	u8 manufacturer_name[32];
> +	u8 flashrom_version_string[BEISCSI_VER_STRLEN];
> +	u8 manufacturer_name[BEISCSI_VER_STRLEN];
>   	u32 supported_modes;
>   	u8 seeprom_version_lo;
>   	u8 seeprom_version_hi;
>   	u8 rsvd0[2];
> -	u32 fw_cmd_data_struct_version;
> +	u32 ioctl_data_struct_version;
>   	u32 ep_fw_data_struct_version;
> -	u32 future_reserved[12];
> +	u8 ncsi_version_string[12];

Hm, this seems to replace 12*u32 by 12*u8, i.e. the subsequent fields w=
ould now have a reduced offset. Is this intentional? I would have expec=
ted to just use some part of future_reserved for newly defined fields a=
nd have the remainder of future_reserved still part of the structure to=
 not shift the offset of subsequent fields; just like you did below in =
struct mgmt_hba_attributes.

>   	u32 default_extended_timeout;
> -	u8 controller_model_number[32];
> +	u8 controller_model_number[BEISCSI_VER_STRLEN];
>   	u8 controller_description[64];
> -	u8 controller_serial_number[32];
> -	u8 ip_version_string[32];
> -	u8 firmware_version_string[32];
> -	u8 bios_version_string[32];
> -	u8 redboot_version_string[32];
> -	u8 driver_version_string[32];
> -	u8 fw_on_flash_version_string[32];
> +	u8 controller_serial_number[BEISCSI_VER_STRLEN];
> +	u8 ip_version_string[BEISCSI_VER_STRLEN];
> +	u8 firmware_version_string[BEISCSI_VER_STRLEN];
> +	u8 bios_version_string[BEISCSI_VER_STRLEN];
> +	u8 redboot_version_string[BEISCSI_VER_STRLEN];
> +	u8 driver_version_string[BEISCSI_VER_STRLEN];
> +	u8 fw_on_flash_version_string[BEISCSI_VER_STRLEN];
>   	u32 functionalities_supported;
>   	u16 max_cdblength;
>   	u8 asic_revision;
> @@ -190,7 +190,8 @@ struct mgmt_hba_attributes {
>   	u32 firmware_post_status;
>   	u32 hba_mtu[8];
>   	u8 iscsi_features;
> -	u8 future_u8[3];
> +	u8 asic_generation;
> +	u8 future_u8[2];
>   	u32 future_u32[3];
>   } __packed;

> @@ -207,7 +208,7 @@ struct mgmt_controller_attributes {
>   	u64 unique_identifier;
>   	u8 netfilters;
>   	u8 rsvd0[3];
> -	u8 future_u32[4];
> +	u32 future_u32[4];
>   } __packed;

While I suppose this doesn't break existing functionality, is it intent=
ional to actually increase the size of the trailing reserved fields and=
 thus the size of the entire struct mgmt_controller_attributes?

Steffen

Linux on System z Development

IBM Deutschland Research & Development GmbH Vorsitzende des Aufsichtsra=
ts: Martina Koederitz
Gesch=E4ftsf=FChrung: Dirk Wittkopp
Sitz der Gesellschaft: B=F6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n the body of a message to majordomo@vger.kernel.org More majordomo inf=
o at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
