From: "Anand Kumar Santhanam" <AnandKumar.Santhanam@pmcs.com>
Subject: RE: [PATCH V4 2/12] pm80xx: Added SPCv/ve specific ids, variables and modify for SPC
Date: Thu, 2 May 2013 19:26:56 -0700
Message-ID: <E5DEE6F468524847995699AD11E80885013304BA@BBY1EXM11.pmc_nt.nt.pmc-sierra.bc.ca>
References: <51703A99.5030605@pmc-sierra.com> <1367532744.3133.13.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:60365 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760994Ab3ECC1u convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 May 2013 22:27:50 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Harry Yang <Harry.Yang@pmcs.com>, Vishwanath Maram <Vishwanath.Maram@pmcs.com>, sakthivel.sk@hcl.com, Rich Bono <Rich.Bono@pmcs.com>, Sangeetha Gnanasekaran <Sangeetha.Gnanasekaran@pmcs.com>

James,
 
Can you pls let us know the warning flags you are including in your makefile such that we can check from our end.
Obviously it looks like we did not use -Warray-bounds in this case.
 
Thanks.
 
Regards
Anand

________________________________

From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
Sent: Thu 5/2/2013 3:12 PM
To: Anand Kumar Santhanam
Cc: linux-scsi@vger.kernel.org; Harry Yang; Vishwanath Maram; sakthivel.sk@hcl.com; Rich Bono; Sangeetha Gnanasekaran
Subject: Re: [PATCH V4 2/12] pm80xx: Added SPCv/ve specific ids, variables and modify for SPC



On Thu, 2013-04-18 at 11:25 -0700, Anand wrote:
> >From 6e057b9cd46d2f0f1838cf727bf8c0abc6a7b399 Mon Sep 17 00:00:00 2001
> From: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
> Date: Wed, 17 Apr 2013 16:26:36 +0530
> Subject: [PATCH V4 2/12] pm80xx: Added SPCv/ve specific ids, variables and modify for SPC
>
> Updated pci id table with device, vendor, subdevice and subvendor ids
> for 8081, 8088, 8089 SAS/SATA controllers. Added SPCv/ve related macros.
> Updated macros, hba info structure and other structures for SPCv/ve.
> Update of structure and variable names for SPC hardware functionalities.
>
> Signed-off-by: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
> Signed-off-by: Anand Kumar S <AnandKumar.Santhanam@pmcs.com>
> Ack-by: Jack Wang <jack_wang@usish.com>
> Ack-by:  Hannes Reinecke <hare@suse.de>

I think this should be Acked-by: and Reviewed-by: respectively

[...]
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
> index b8dd050..dc45fdc 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -50,32 +50,39 @@
>  static void read_main_config_table(struct pm8001_hba_info *pm8001_ha)
>  {
>       void __iomem *address = pm8001_ha->main_cfg_tbl_addr;
> -     pm8001_ha->main_cfg_tbl.signature       = pm8001_mr32(address, 0x00);
> -     pm8001_ha->main_cfg_tbl.interface_rev   = pm8001_mr32(address, 0x04);
> -     pm8001_ha->main_cfg_tbl.firmware_rev    = pm8001_mr32(address, 0x08);
> -     pm8001_ha->main_cfg_tbl.max_out_io      = pm8001_mr32(address, 0x0C);
> -     pm8001_ha->main_cfg_tbl.max_sgl         = pm8001_mr32(address, 0x10);
> -     pm8001_ha->main_cfg_tbl.ctrl_cap_flag   = pm8001_mr32(address, 0x14);
> -     pm8001_ha->main_cfg_tbl.gst_offset      = pm8001_mr32(address, 0x18);
> -     pm8001_ha->main_cfg_tbl.inbound_queue_offset =
> +     pm8001_ha->main_cfg_tbl.pm8001_tbl.signature    =
> +                             pm8001_mr32(address, 0x00);
> +     pm8001_ha->main_cfg_tbl.pm8001_tbl.interface_rev =
> +                             pm8001_mr32(address, 0x04);
> +     pm8001_ha->main_cfg_tbl.pm8001_tbl.firmware_rev =
> +                             pm8001_mr32(address, 0x08);
> +     pm8001_ha->main_cfg_tbl.pm8001_tbl.max_out_io   =
> +                             pm8001_mr32(address, 0x0C);
> +     pm8001_ha->main_cfg_tbl.pm8001_tbl.max_sgl      =
> +                             pm8001_mr32(address, 0x10);
> +     pm8001_ha->main_cfg_tbl.pm8001_tbl.ctrl_cap_flag =
> +                             pm8001_mr32(address, 0x14);
> +     pm8001_ha->main_cfg_tbl.pm8001_tbl.gst_offset   =
> +                             pm8001_mr32(address, 0x18);
> +     pm8001_ha->main_cfg_tbl.pm8001_tbl.inbound_queue_offset =
>               pm8001_mr32(address, MAIN_IBQ_OFFSET);
> -     pm8001_ha->main_cfg_tbl.outbound_queue_offset =
> +     pm8001_ha->main_cfg_tbl.pm8001_tbl.outbound_queue_offset =
>               pm8001_mr32(address, MAIN_OBQ_OFFSET);
> -     pm8001_ha->main_cfg_tbl.hda_mode_flag   =
> +     pm8001_ha->main_cfg_tbl.pm8001_tbl.hda_mode_flag        =
>               pm8001_mr32(address, MAIN_HDA_FLAGS_OFFSET);
> 
>       /* read analog Setting offset from the configuration table */
> -     pm8001_ha->main_cfg_tbl.anolog_setup_table_offset =
> +     pm8001_ha->main_cfg_tbl.pm8001_tbl.anolog_setup_table_offset =
>               pm8001_mr32(address, MAIN_ANALOG_SETUP_OFFSET);
> 
>       /* read Error Dump Offset and Length */
> -     pm8001_ha->main_cfg_tbl.fatal_err_dump_offset0 =
> +     pm8001_ha->main_cfg_tbl.pm8001_tbl.fatal_err_dump_offset0 =
>               pm8001_mr32(address, MAIN_FATAL_ERROR_RDUMP0_OFFSET);
> -     pm8001_ha->main_cfg_tbl.fatal_err_dump_length0 =
> +     pm8001_ha->main_cfg_tbl.pm8001_tbl.fatal_err_dump_length0 =
>               pm8001_mr32(address, MAIN_FATAL_ERROR_RDUMP0_LENGTH);
> -     pm8001_ha->main_cfg_tbl.fatal_err_dump_offset1 =
> +     pm8001_ha->main_cfg_tbl.pm8001_tbl.fatal_err_dump_offset1 =
>               pm8001_mr32(address, MAIN_FATAL_ERROR_RDUMP1_OFFSET);
> -     pm8001_ha->main_cfg_tbl.fatal_err_dump_length1 =
> +     pm8001_ha->main_cfg_tbl.pm8001_tbl.fatal_err_dump_length1 =
>               pm8001_mr32(address, MAIN_FATAL_ERROR_RDUMP1_LENGTH);
>  }
> 
> @@ -86,31 +93,56 @@ static void read_main_config_table(struct pm8001_hba_info *pm8001_ha)
>  static void read_general_status_table(struct pm8001_hba_info *pm8001_ha)
>  {
>       void __iomem *address = pm8001_ha->general_stat_tbl_addr;
> -     pm8001_ha->gs_tbl.gst_len_mpistate      = pm8001_mr32(address, 0x00);
> -     pm8001_ha->gs_tbl.iq_freeze_state0      = pm8001_mr32(address, 0x04);
> -     pm8001_ha->gs_tbl.iq_freeze_state1      = pm8001_mr32(address, 0x08);
> -     pm8001_ha->gs_tbl.msgu_tcnt             = pm8001_mr32(address, 0x0C);
> -     pm8001_ha->gs_tbl.iop_tcnt              = pm8001_mr32(address, 0x10);
> -     pm8001_ha->gs_tbl.reserved              = pm8001_mr32(address, 0x14);
> -     pm8001_ha->gs_tbl.phy_state[0]  = pm8001_mr32(address, 0x18);
> -     pm8001_ha->gs_tbl.phy_state[1]  = pm8001_mr32(address, 0x1C);
> -     pm8001_ha->gs_tbl.phy_state[2]  = pm8001_mr32(address, 0x20);
> -     pm8001_ha->gs_tbl.phy_state[3]  = pm8001_mr32(address, 0x24);
> -     pm8001_ha->gs_tbl.phy_state[4]  = pm8001_mr32(address, 0x28);
> -     pm8001_ha->gs_tbl.phy_state[5]  = pm8001_mr32(address, 0x2C);
> -     pm8001_ha->gs_tbl.phy_state[6]  = pm8001_mr32(address, 0x30);
> -     pm8001_ha->gs_tbl.phy_state[7]  = pm8001_mr32(address, 0x34);
> -     pm8001_ha->gs_tbl.reserved1             = pm8001_mr32(address, 0x38);
> -     pm8001_ha->gs_tbl.reserved2             = pm8001_mr32(address, 0x3C);
> -     pm8001_ha->gs_tbl.reserved3             = pm8001_mr32(address, 0x40);
> -     pm8001_ha->gs_tbl.recover_err_info[0]   = pm8001_mr32(address, 0x44);
> -     pm8001_ha->gs_tbl.recover_err_info[1]   = pm8001_mr32(address, 0x48);
> -     pm8001_ha->gs_tbl.recover_err_info[2]   = pm8001_mr32(address, 0x4C);
> -     pm8001_ha->gs_tbl.recover_err_info[3]   = pm8001_mr32(address, 0x50);
> -     pm8001_ha->gs_tbl.recover_err_info[4]   = pm8001_mr32(address, 0x54);
> -     pm8001_ha->gs_tbl.recover_err_info[5]   = pm8001_mr32(address, 0x58);
> -     pm8001_ha->gs_tbl.recover_err_info[6]   = pm8001_mr32(address, 0x5C);
> -     pm8001_ha->gs_tbl.recover_err_info[7]   = pm8001_mr32(address, 0x60);
> +     pm8001_ha->gs_tbl.pm8001_tbl.gst_len_mpistate   =
> +                             pm8001_mr32(address, 0x00);
> +     pm8001_ha->gs_tbl.pm8001_tbl.iq_freeze_state0   =
> +                             pm8001_mr32(address, 0x04);
> +     pm8001_ha->gs_tbl.pm8001_tbl.iq_freeze_state1   =
> +                             pm8001_mr32(address, 0x08);
> +     pm8001_ha->gs_tbl.pm8001_tbl.msgu_tcnt          =
> +                             pm8001_mr32(address, 0x0C);
> +     pm8001_ha->gs_tbl.pm8001_tbl.iop_tcnt           =
> +                             pm8001_mr32(address, 0x10);
> +     pm8001_ha->gs_tbl.pm8001_tbl.rsvd               =
> +                             pm8001_mr32(address, 0x14);
> +     pm8001_ha->gs_tbl.pm8001_tbl.phy_state[0]       =
> +                             pm8001_mr32(address, 0x18);
> +     pm8001_ha->gs_tbl.pm8001_tbl.phy_state[1]       =
> +                             pm8001_mr32(address, 0x1C);
> +     pm8001_ha->gs_tbl.pm8001_tbl.phy_state[2]       =
> +                             pm8001_mr32(address, 0x20);
> +     pm8001_ha->gs_tbl.pm8001_tbl.phy_state[3]       =
> +                             pm8001_mr32(address, 0x24);
> +     pm8001_ha->gs_tbl.pm8001_tbl.phy_state[4]       =
> +                             pm8001_mr32(address, 0x28);
> +     pm8001_ha->gs_tbl.pm8001_tbl.phy_state[5]       =
> +                             pm8001_mr32(address, 0x2C);
> +     pm8001_ha->gs_tbl.pm8001_tbl.phy_state[6]       =
> +                             pm8001_mr32(address, 0x30);
> +     pm8001_ha->gs_tbl.pm8001_tbl.phy_state[7]       =
> +                             pm8001_mr32(address, 0x34);
> +     pm8001_ha->gs_tbl.pm8001_tbl.rsvd1[0]           =
> +                             pm8001_mr32(address, 0x38);
> +     pm8001_ha->gs_tbl.pm8001_tbl.rsvd1[1]           =
> +                             pm8001_mr32(address, 0x3C);
> +     pm8001_ha->gs_tbl.pm8001_tbl.rsvd1[2]           =
> +                             pm8001_mr32(address, 0x40);

The compiler doesn't like this bit:

drivers/scsi/pm8001/pm8001_hwi.c: In function 'pm8001_chip_init':
drivers/scsi/pm8001/pm8001_hwi.c:128:36: warning: array subscript is
above array bounds [-Warray-bounds]

And it's clearly right: the resvd1[] array only has two elements in
pm8001_sas.h, so  Either the array has to grow or something else needs
fixing in here.

James




