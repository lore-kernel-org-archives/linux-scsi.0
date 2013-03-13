From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: Re: [PATCH 08/15] be2iscsi: Fix displaying the FW Version from driver.
Date: Wed, 13 Mar 2013 11:29:58 +0100
Message-ID: <51405526.1040203@linux.vnet.ibm.com>
References: <1363063186-4902-1-git-send-email-jayamohan.kallickal@emulex.com> <1363063186-4902-8-git-send-email-jayamohan.kallickal@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:33434 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932641Ab3CMO6v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Mar 2013 10:58:51 -0400
Received: from /spool/local
	by e06smtp13.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
	Wed, 13 Mar 2013 14:56:46 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
	by d06dlp02.portsmouth.uk.ibm.com (Postfix) with ESMTP id 3B46C4140162
	for <linux-scsi@vger.kernel.org>; Wed, 13 Mar 2013 10:31:35 +0000 (GMT)
Received: from d06av01.portsmouth.uk.ibm.com (d06av01.portsmouth.uk.ibm.com [9.149.37.212])
	by b06cxnps3074.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r2DATo5Z19726486
	for <linux-scsi@vger.kernel.org>; Wed, 13 Mar 2013 10:29:50 GMT
Received: from d06av01.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av01.portsmouth.uk.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r2DATwS1002903
	for <linux-scsi@vger.kernel.org>; Wed, 13 Mar 2013 04:29:59 -0600
In-Reply-To: <1363063186-4902-8-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jayamohank@gmail.com
Cc: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu, "Jayamohan.Kallickal" <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

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

> diff --git a/drivers/scsi/be2iscsi/be_mgmt.h b/drivers/scsi/be2iscsi/=
be_mgmt.h
> index 2e4968a..0a406a4 100644
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

Hm, this seems to replace 12*u32 by 12*u8, i.e. the subsequent fields=20
would now have a reduced offset. Is this intentional? I would have=20
expected to just use some part of future_reserved for newly defined=20
fields and have the remainder of future_reserved still part of the=20
structure to not shift the offset of subsequent fields; just like you=20
did below in struct mgmt_hba_attributes.

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

While I suppose this doesn't break existing functionality, is it=20
intentional to actually increase the size of the trailing reserved=20
fields and thus the size of the entire struct mgmt_controller_attribute=
s?

Steffen

Linux on System z Development

IBM Deutschland Research & Development GmbH
Vorsitzende des Aufsichtsrats: Martina Koederitz
Gesch=E4ftsf=FChrung: Dirk Wittkopp
Sitz der Gesellschaft: B=F6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
