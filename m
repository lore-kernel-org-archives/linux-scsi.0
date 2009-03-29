From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: Subject: [PATCH] [Target_Core_Mod]: Add EVPD 0x83 NAA Registered
 Extended Assigned identifer support
Date: Sun, 29 Mar 2009 12:09:59 -0400
Message-ID: <49CF9D57.3030607@interlog.com>
References: <1238299172.4250.116.camel@haakon2.linux-iscsi.org>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:37549 "EHLO
	elrond2.infotech.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbZC2QKI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Mar 2009 12:10:08 -0400
In-Reply-To: <1238299172.4250.116.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Brad Fennell <wavebender@hotmail.com>, Jason Hodges <jasonahodges@gmail.com>, Rafiu Fakunle <rafiu@openfiler.com>

Nicholas A. Bellinger wrote:
> Greetings all,
> 
> This patch adds emulation for EVPD 0x83 NAA identifier type (0x3) Registered
> Extended Assigned format (0x6) from spc4r17 section 7.7.3.6.5.  The WWN value
> is based on the emulated Unit Serial Number supplied via ConfigFS into
> /sys/kernel/config/target/core/$HBA/$DEV/wwn/evpd_unit_serial for a
> given storage object.

Nicholas,
May I suggest:
s/evpd_unit_serial/vpd_unit_serial/

The "E" in EVPD stands for "enable" and should be used to
refer to bit 0, byte 1 in the SCSI INQUIRY command block
(cdb). So together with the page code field (byte 2 of the
cdb) that forms a so-called "non-standard" INQUIRY requesting
a VPD page. I think all other usages should prefer "VPD"
or "vpd" (for "vital product data").

My sg3_utils package is partially responsible for the misuse
of EVPD and I have been slowly converting such instances
to VPD (hopefully I just stamped out the final ones).

Doug Gilbert

> This patch expects evpd_unit_serial to be in hex.  The first 24 bytes of
> evpd_unit_serial is then encoded in binary hex starting at the
> VENDOR_SPECIFIC_IDENTIFIER (36-bit) and VENDOR_SPECIFIC_IDENTIFIER_EXTENTION
> (64-bit) fields of the NAA identifier.
> 
> This patch also uses the OpenFabrics OUI (001405) for the IEEE Company ID
> field of the NAA identifier.  Note that the NAA (0x3) identifer is a requirement
> for logical unit WWN on certain iSCSI capable cluster clients.
> 
> These patches are made against lio-core-2.6.git/master and tested on
> v2.6.29 x86 32-bit HVM using sg_inq from sg3_utils. The lio-core-2.6.git tree
> can be found at: 
> 
> http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=summary
> 
> Here is what it looks like:
> 
> *) Set WWN value to target_core_mod/IBLOCK exported Linux LVM blockdevice
> 
> echo a97e4ce21c0711de829b000c2943d57b > $TARGET/iblock_0/lvm_test0/wwn/evpd_unit_serial
> 
> *) From target_core_mod side kernel buffer
> 
> IBLOCK: Created bio_set() for major/minor: 254:2
> iblock: Using SPC3_PERSISTENT_RESERVATIONS emulation
> iblock: Enabling ALUA Emulation for SPC-3 device
> iblock: Adding to default ALUA LU Group: core/alua/lu_gps/default_lu_gp
> CORE_iBLOCK[0] - Activating Device with TCQ: 0 at Major: 254 Minor 2
>   Vendor: LIO-ORG   Model: IBLOCK            Revision: 3.0
>   Type:   Direct-Access                      ANSI SCSI revision: 05
> T10 EVPD Unit Serial Number: a97e4ce21c0711de829b000c2943d57b
> T10 EVPD Page Length: 72
> T10 EVPD Identifer Length: 16
> T10 EVPD Identifier Association: addressed logical unit
> T10 EVPD Identifier Type: NAA
> T10 EVPD Binary Device Identifier: 36001405a97e4ce21c0711de829b000c2
> 
> *) From Open/iSCSI initiator side using sg_inq
> 
> initiator#~# sg_inq -p 0x83 -v /dev/sde
> VPD INQUIRY: Device Identification page
>     inquiry cdb: 12 01 83 00 fc 00
>   Designation descriptor number 1, descriptor length: 20
>     id_type: NAA,  code_set: Binary
>     associated with the addressed logical unit
>       NAA 6, IEEE Company_id: 0x1405
>       Vendor Specific Identifier: 0xa97e4ce21
>       Vendor Specific Identifier Extension: 0xc0711de829b000c2
>       [0x6001405a97e4ce21c0711de829b000c2]
>   Designation descriptor number 2, descriptor length: 52
>     id_type: T10 vendor identification,  code_set: ASCII
>     associated with the addressed logical unit
>       vendor id: LIO-ORG
>       vendor specific: IBLOCK:a97e4ce21c0711de829b000c2943d57b
>   Designation descriptor number 3, descriptor length: 8
>     transport: Internet SCSI (iSCSI)
>     id_type: Relative target port,  code_set: Binary
>     associated with the target port
>       Relative target port: 0x2
>   Designation descriptor number 4, descriptor length: 8
>     transport: Internet SCSI (iSCSI)
>     id_type: Target port group,  code_set: Binary
>     associated with the target port
>       Target port group: 0x0
>   Designation descriptor number 5, descriptor length: 8
>     id_type: Logical unit group,  code_set: Binary
>     associated with the addressed logical unit
>       Logical unit group: 0x0
>   Designation descriptor number 6, descriptor length: 72
>     transport: Internet SCSI (iSCSI)
>     id_type: SCSI name string,  code_set: UTF-8
>     associated with the target port
>       SCSI name string:
>       iqn.2003-01.org.linux-iscsi.target.i686:sn.cff3eedbd2fd,t,0x0001
> 
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> ---
>  drivers/lio-core/target_core_transport.c |  117 +++++++++++++++++++++++++-----
>  1 files changed, 100 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/lio-core/target_core_transport.c b/drivers/lio-core/target_core_transport.c
> index 4132da1..e8879a9 100644
> --- a/drivers/lio-core/target_core_transport.c
> +++ b/drivers/lio-core/target_core_transport.c
> @@ -4142,6 +4142,33 @@ static inline void transport_get_maps(se_cmd_t *cmd)
>  	cmd->transport_unmap_SG_segments = &transport_generic_unmap_SG_segments;
>  }
>  
> +static unsigned char asciihex_to_binaryhex(unsigned char val[2])
> +{
> +	unsigned char result = 0;
> +	/*
> +	 * MSB
> +	 */
> +	if ((val[0] >= 'a') && (val[0] <= 'f'))
> +		result = ((val[0] - 'a' + 10) & 0xf) << 4;
> +	else
> +		if ((val[0] >= 'A') && (val[0] <= 'F'))
> +			result = ((val[0] - 'A' + 10) & 0xf) << 4;
> +		else /* digit */
> +			result = ((val[0] - '0') & 0xf) << 4;
> +	/*
> +	 * LSB
> +	 */
> +	if ((val[1] >= 'a') && (val[1] <= 'f'))
> +		result |= ((val[1] - 'a' + 10) & 0xf);
> +	else
> +		if ((val[1] >= 'A') && (val[1] <= 'F'))
> +			result |= ((val[1] - 'A' + 10) & 0xf);
> +		else /* digit */
> +			result |= ((val[1] - '0') & 0xf);
> +
> +	return result;
> +}
> +
>  extern int transport_generic_emulate_inquiry(
>  	se_cmd_t *cmd,
>  	unsigned char type,
> @@ -4157,10 +4184,11 @@ extern int transport_generic_emulate_inquiry(
>  	t10_alua_tg_pt_gp_member_t *tg_pt_gp_mem;
>  	unsigned char *buf = (unsigned char *) T_TASK(cmd)->t_task_buf;
>  	unsigned char *cdb = T_TASK(cmd)->t_task_cdb;
> -	unsigned char *iqn_sn;
> +	unsigned char *iqn_sn, binary, binary_new;
>  	u32 prod_len, iqn_sn_len, se_location_len;
>  	u32 unit_serial_len, off = 0;
> -	u16 len = 0;
> +	int i;
> +	u16 len = 0, id_len;
>  
>  	/*
>  	 * Make sure we at least have 8 bytes of INQUIRY response payload
> @@ -4256,10 +4284,61 @@ extern int transport_generic_emulate_inquiry(
>  		 * DESIGNATOR TYPEs see spc4r17 Table 459.
>  		 */
>  		buf[1] = 0x83;
> +		off = 4;
> +		/*
> +		 * NAA IEEE Registered Extended Assigned designator format,
> +		 * see spc4r17 section 7.7.3.6.5
> +		 *
> +		 * We depend upon a target_core_mod/ConfigFS provided
> +		 * /sys/kernel/config/target/core/$HBA/$DEV/wwn/evpd_unit_serial
> +		 * value in order to return the NAA id.
> +		 */
> +		if (!(dev->se_sub_dev->su_dev_flags &
> +					SDF_EMULATED_EVPD_UNIT_SERIAL))
> +			goto check_t10_vend_desc;
> +		if ((off + 20) > cmd->data_length)
> +			goto check_t10_vend_desc;
> +		/* CODE SET == Binary */
> +		buf[off++] = 0x1;
> +		/* Set ASSOICATION == addressed logical unit: 0)b */
> +		buf[off] = 0x00;
> +		/* Identifier/Designator type == NAA identifier */
> +		buf[off++] = 0x3;
> +		off++;
> +		/* Identifier/Designator length */
> +		buf[off++] = 0x10;
> +		/*
> +		 * Start NAA IEEE Registered Extended Identifier/Designator
> +		 */
> +		buf[off++] = (0x6 << 4);
> +		/*
> +		 * Use OpenFabrics IEEE Company ID: 00 14 05
> +		 */
> +		buf[off++] = 0x01;
> +		buf[off++] = 0x40;
> +		buf[off] = (0x5 << 4);
> +		/*
> +		 * Return ConfigFS Unit Serial Number information for
> +		 * VENDOR_SPECIFIC_IDENTIFIER and
> +		 * VENDOR_SPECIFIC_IDENTIFIER_EXTENTION
> +		 */
> +		binary = asciihex_to_binaryhex(
> +					&DEV_T10_WWN(dev)->unit_serial[0]);
> +		buf[off++] |= (binary & 0xf0) >> 4;
> +		for (i = 0; i < 24; i += 2) {
> +			binary_new = asciihex_to_binaryhex(
> +				&DEV_T10_WWN(dev)->unit_serial[i+2]);
> +			buf[off] = (binary & 0x0f) << 4;
> +			buf[off++] |= (binary_new & 0xf0) >> 4;
> +			binary = binary_new;
> +		}
> +		len = 20;
> +		off = (len + 4);
> +check_t10_vend_desc:
>  		/*
>  		 * T10 Vendor Identifier Page, see spc4r17 section 7.7.3.4
>  		 */
> -		len += 8; /* For Vendor field */
> +		id_len = 8; /* For Vendor field */
>  		prod_len = 4; /* For EVPD Header */
>  		prod_len += 8; /* For Vendor field */
>  		prod_len += strlen(prod);
> @@ -4271,12 +4350,14 @@ extern int transport_generic_emulate_inquiry(
>  				strlen(&DEV_T10_WWN(dev)->unit_serial[0]);
>  			unit_serial_len++; /* For NULL Terminator */
>  
> -			if (((len + 4) + (prod_len + unit_serial_len)) >
> +			if ((len + (id_len + 4) +
> +			    (prod_len + unit_serial_len)) >
>  					cmd->data_length) {
>  				len += (prod_len + unit_serial_len);
>  				goto check_port;
>  			}
> -			len += sprintf((unsigned char *)&buf[16], "%s:%s", prod,
> +			id_len += sprintf((unsigned char *)&buf[off+12],
> +					"%s:%s", prod,
>  					&DEV_T10_WWN(dev)->unit_serial[0]);
>  		} else {
>  			iqn_sn = transport_get_iqn_sn();
> @@ -4285,24 +4366,26 @@ extern int transport_generic_emulate_inquiry(
>  			se_location_len = strlen(se_location);
>  			se_location_len++; /* For NULL Terminator */
>  
> -			if (((len + 4) + (prod_len + iqn_sn_len +
> +			if ((len + (id_len + 4) + (prod_len + iqn_sn_len +
>  					se_location_len)) > cmd->data_length) {
>  				len += (prod_len + iqn_sn_len +
>  						se_location_len);
>  				goto check_port;
>  			}
> -			len += sprintf((unsigned char *)&buf[16], "%s:%s:%s",
> -					prod, iqn_sn, se_location);
> +			id_len += sprintf((unsigned char *)&buf[off+12],
> +				"%s:%s:%s", prod, iqn_sn, se_location);
>  		}
> -		buf[4] = 0x2; /* ASCII */
> -		buf[5] = 0x1; /* T10 Vendor ID */
> -		buf[6] = 0x0;
> -		memcpy((unsigned char *)&buf[8], "LIO-ORG", 8);
> -
> -		len++; /* Extra Byte for NULL Terminator */
> -		buf[7] = len; /* Identifier Length */
> -		len += 4; /* Header size for Designation descriptor */
> -		off = (len + 4);
> +		buf[off] = 0x2; /* ASCII */
> +		buf[off+1] = 0x1; /* T10 Vendor ID */
> +		buf[off+2] = 0x0;
> +		memcpy((unsigned char *)&buf[off+4], "LIO-ORG", 8);
> +		/* Extra Byte for NULL Terminator */
> +		id_len++;
> +		/* Identifier Length */
> +		buf[off+3] = id_len;
> +		/* Header size for Designation descriptor */
> +		len += (id_len + 4);
> +		off += (id_len + 4);
>  		/*
>  		 * se_port_t is only set for INQUIRY EVPD=1 through $FABRIC_MOD
>  		 */

