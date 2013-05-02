From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH V4 2/12] pm80xx: Added SPCv/ve specific ids, variables
 and modify for SPC
Date: Thu, 02 May 2013 15:12:24 -0700
Message-ID: <1367532744.3133.13.camel@dabdike>
References: <51703A99.5030605@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:53062 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751019Ab3EBWM2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 May 2013 18:12:28 -0400
In-Reply-To: <51703A99.5030605@pmc-sierra.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anand <anandkumar_santhanam@pmc-sierra.com>
Cc: linux-scsi@vger.kernel.org, Harry.Yang@pmcs.com, Vishwanath.Maram@pmcs.com, sakthivel.sk@hcl.com, rich.Bono@pmcs.com, Sangeetha.Gnanasekaran@pmcs.com

On Thu, 2013-04-18 at 11:25 -0700, Anand wrote:
> >From 6e057b9cd46d2f0f1838cf727bf8c0abc6a7b399 Mon Sep 17 00:00:00 20=
01
> From: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
> Date: Wed, 17 Apr 2013 16:26:36 +0530
> Subject: [PATCH V4 2/12] pm80xx: Added SPCv/ve specific ids, variable=
s and modify for SPC
>=20
> Updated pci id table with device, vendor, subdevice and subvendor ids
> for 8081, 8088, 8089 SAS/SATA controllers. Added SPCv/ve related macr=
os.
> Updated macros, hba info structure and other structures for SPCv/ve.
> Update of structure and variable names for SPC hardware functionaliti=
es.
>=20
> Signed-off-by: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
> Signed-off-by: Anand Kumar S <AnandKumar.Santhanam@pmcs.com>
> Ack-by: Jack Wang <jack_wang@usish.com>
> Ack-by:  Hannes Reinecke <hare@suse.de>

I think this should be Acked-by: and Reviewed-by: respectively

[...]
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/p=
m8001_hwi.c
> index b8dd050..dc45fdc 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -50,32 +50,39 @@
>  static void read_main_config_table(struct pm8001_hba_info *pm8001_ha=
)
>  {
>  	void __iomem *address =3D pm8001_ha->main_cfg_tbl_addr;
> -	pm8001_ha->main_cfg_tbl.signature	=3D pm8001_mr32(address, 0x00);
> -	pm8001_ha->main_cfg_tbl.interface_rev	=3D pm8001_mr32(address, 0x04=
);
> -	pm8001_ha->main_cfg_tbl.firmware_rev	=3D pm8001_mr32(address, 0x08)=
;
> -	pm8001_ha->main_cfg_tbl.max_out_io	=3D pm8001_mr32(address, 0x0C);
> -	pm8001_ha->main_cfg_tbl.max_sgl		=3D pm8001_mr32(address, 0x10);
> -	pm8001_ha->main_cfg_tbl.ctrl_cap_flag	=3D pm8001_mr32(address, 0x14=
);
> -	pm8001_ha->main_cfg_tbl.gst_offset	=3D pm8001_mr32(address, 0x18);
> -	pm8001_ha->main_cfg_tbl.inbound_queue_offset =3D
> +	pm8001_ha->main_cfg_tbl.pm8001_tbl.signature	=3D
> +				pm8001_mr32(address, 0x00);
> +	pm8001_ha->main_cfg_tbl.pm8001_tbl.interface_rev =3D
> +				pm8001_mr32(address, 0x04);
> +	pm8001_ha->main_cfg_tbl.pm8001_tbl.firmware_rev	=3D
> +				pm8001_mr32(address, 0x08);
> +	pm8001_ha->main_cfg_tbl.pm8001_tbl.max_out_io	=3D
> +				pm8001_mr32(address, 0x0C);
> +	pm8001_ha->main_cfg_tbl.pm8001_tbl.max_sgl	=3D
> +				pm8001_mr32(address, 0x10);
> +	pm8001_ha->main_cfg_tbl.pm8001_tbl.ctrl_cap_flag =3D
> +				pm8001_mr32(address, 0x14);
> +	pm8001_ha->main_cfg_tbl.pm8001_tbl.gst_offset	=3D
> +				pm8001_mr32(address, 0x18);
> +	pm8001_ha->main_cfg_tbl.pm8001_tbl.inbound_queue_offset =3D
>  		pm8001_mr32(address, MAIN_IBQ_OFFSET);
> -	pm8001_ha->main_cfg_tbl.outbound_queue_offset =3D
> +	pm8001_ha->main_cfg_tbl.pm8001_tbl.outbound_queue_offset =3D
>  		pm8001_mr32(address, MAIN_OBQ_OFFSET);
> -	pm8001_ha->main_cfg_tbl.hda_mode_flag	=3D
> +	pm8001_ha->main_cfg_tbl.pm8001_tbl.hda_mode_flag	=3D
>  		pm8001_mr32(address, MAIN_HDA_FLAGS_OFFSET);
> =20
>  	/* read analog Setting offset from the configuration table */
> -	pm8001_ha->main_cfg_tbl.anolog_setup_table_offset =3D
> +	pm8001_ha->main_cfg_tbl.pm8001_tbl.anolog_setup_table_offset =3D
>  		pm8001_mr32(address, MAIN_ANALOG_SETUP_OFFSET);
> =20
>  	/* read Error Dump Offset and Length */
> -	pm8001_ha->main_cfg_tbl.fatal_err_dump_offset0 =3D
> +	pm8001_ha->main_cfg_tbl.pm8001_tbl.fatal_err_dump_offset0 =3D
>  		pm8001_mr32(address, MAIN_FATAL_ERROR_RDUMP0_OFFSET);
> -	pm8001_ha->main_cfg_tbl.fatal_err_dump_length0 =3D
> +	pm8001_ha->main_cfg_tbl.pm8001_tbl.fatal_err_dump_length0 =3D
>  		pm8001_mr32(address, MAIN_FATAL_ERROR_RDUMP0_LENGTH);
> -	pm8001_ha->main_cfg_tbl.fatal_err_dump_offset1 =3D
> +	pm8001_ha->main_cfg_tbl.pm8001_tbl.fatal_err_dump_offset1 =3D
>  		pm8001_mr32(address, MAIN_FATAL_ERROR_RDUMP1_OFFSET);
> -	pm8001_ha->main_cfg_tbl.fatal_err_dump_length1 =3D
> +	pm8001_ha->main_cfg_tbl.pm8001_tbl.fatal_err_dump_length1 =3D
>  		pm8001_mr32(address, MAIN_FATAL_ERROR_RDUMP1_LENGTH);
>  }
> =20
> @@ -86,31 +93,56 @@ static void read_main_config_table(struct pm8001_=
hba_info *pm8001_ha)
>  static void read_general_status_table(struct pm8001_hba_info *pm8001=
_ha)
>  {
>  	void __iomem *address =3D pm8001_ha->general_stat_tbl_addr;
> -	pm8001_ha->gs_tbl.gst_len_mpistate	=3D pm8001_mr32(address, 0x00);
> -	pm8001_ha->gs_tbl.iq_freeze_state0	=3D pm8001_mr32(address, 0x04);
> -	pm8001_ha->gs_tbl.iq_freeze_state1	=3D pm8001_mr32(address, 0x08);
> -	pm8001_ha->gs_tbl.msgu_tcnt		=3D pm8001_mr32(address, 0x0C);
> -	pm8001_ha->gs_tbl.iop_tcnt		=3D pm8001_mr32(address, 0x10);
> -	pm8001_ha->gs_tbl.reserved		=3D pm8001_mr32(address, 0x14);
> -	pm8001_ha->gs_tbl.phy_state[0]	=3D pm8001_mr32(address, 0x18);
> -	pm8001_ha->gs_tbl.phy_state[1]	=3D pm8001_mr32(address, 0x1C);
> -	pm8001_ha->gs_tbl.phy_state[2]	=3D pm8001_mr32(address, 0x20);
> -	pm8001_ha->gs_tbl.phy_state[3]	=3D pm8001_mr32(address, 0x24);
> -	pm8001_ha->gs_tbl.phy_state[4]	=3D pm8001_mr32(address, 0x28);
> -	pm8001_ha->gs_tbl.phy_state[5]	=3D pm8001_mr32(address, 0x2C);
> -	pm8001_ha->gs_tbl.phy_state[6]	=3D pm8001_mr32(address, 0x30);
> -	pm8001_ha->gs_tbl.phy_state[7]	=3D pm8001_mr32(address, 0x34);
> -	pm8001_ha->gs_tbl.reserved1		=3D pm8001_mr32(address, 0x38);
> -	pm8001_ha->gs_tbl.reserved2		=3D pm8001_mr32(address, 0x3C);
> -	pm8001_ha->gs_tbl.reserved3		=3D pm8001_mr32(address, 0x40);
> -	pm8001_ha->gs_tbl.recover_err_info[0]	=3D pm8001_mr32(address, 0x44=
);
> -	pm8001_ha->gs_tbl.recover_err_info[1]	=3D pm8001_mr32(address, 0x48=
);
> -	pm8001_ha->gs_tbl.recover_err_info[2]	=3D pm8001_mr32(address, 0x4C=
);
> -	pm8001_ha->gs_tbl.recover_err_info[3]	=3D pm8001_mr32(address, 0x50=
);
> -	pm8001_ha->gs_tbl.recover_err_info[4]	=3D pm8001_mr32(address, 0x54=
);
> -	pm8001_ha->gs_tbl.recover_err_info[5]	=3D pm8001_mr32(address, 0x58=
);
> -	pm8001_ha->gs_tbl.recover_err_info[6]	=3D pm8001_mr32(address, 0x5C=
);
> -	pm8001_ha->gs_tbl.recover_err_info[7]	=3D pm8001_mr32(address, 0x60=
);
> +	pm8001_ha->gs_tbl.pm8001_tbl.gst_len_mpistate	=3D
> +				pm8001_mr32(address, 0x00);
> +	pm8001_ha->gs_tbl.pm8001_tbl.iq_freeze_state0	=3D
> +				pm8001_mr32(address, 0x04);
> +	pm8001_ha->gs_tbl.pm8001_tbl.iq_freeze_state1	=3D
> +				pm8001_mr32(address, 0x08);
> +	pm8001_ha->gs_tbl.pm8001_tbl.msgu_tcnt		=3D
> +				pm8001_mr32(address, 0x0C);
> +	pm8001_ha->gs_tbl.pm8001_tbl.iop_tcnt		=3D
> +				pm8001_mr32(address, 0x10);
> +	pm8001_ha->gs_tbl.pm8001_tbl.rsvd		=3D
> +				pm8001_mr32(address, 0x14);
> +	pm8001_ha->gs_tbl.pm8001_tbl.phy_state[0]	=3D
> +				pm8001_mr32(address, 0x18);
> +	pm8001_ha->gs_tbl.pm8001_tbl.phy_state[1]	=3D
> +				pm8001_mr32(address, 0x1C);
> +	pm8001_ha->gs_tbl.pm8001_tbl.phy_state[2]	=3D
> +				pm8001_mr32(address, 0x20);
> +	pm8001_ha->gs_tbl.pm8001_tbl.phy_state[3]	=3D
> +				pm8001_mr32(address, 0x24);
> +	pm8001_ha->gs_tbl.pm8001_tbl.phy_state[4]	=3D
> +				pm8001_mr32(address, 0x28);
> +	pm8001_ha->gs_tbl.pm8001_tbl.phy_state[5]	=3D
> +				pm8001_mr32(address, 0x2C);
> +	pm8001_ha->gs_tbl.pm8001_tbl.phy_state[6]	=3D
> +				pm8001_mr32(address, 0x30);
> +	pm8001_ha->gs_tbl.pm8001_tbl.phy_state[7]	=3D
> +				pm8001_mr32(address, 0x34);
> +	pm8001_ha->gs_tbl.pm8001_tbl.rsvd1[0]		=3D
> +				pm8001_mr32(address, 0x38);
> +	pm8001_ha->gs_tbl.pm8001_tbl.rsvd1[1]		=3D
> +				pm8001_mr32(address, 0x3C);
> +	pm8001_ha->gs_tbl.pm8001_tbl.rsvd1[2]		=3D
> +				pm8001_mr32(address, 0x40);

The compiler doesn't like this bit:

drivers/scsi/pm8001/pm8001_hwi.c: In function =E2=80=98pm8001_chip_init=
=E2=80=99:
drivers/scsi/pm8001/pm8001_hwi.c:128:36: warning: array subscript is
above array bounds [-Warray-bounds]

And it's clearly right: the resvd1[] array only has two elements in
pm8001_sas.h, so  Either the array has to grow or something else needs
fixing in here.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
