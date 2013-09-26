From: "Sangeetha Gnanasekaran" <Sangeetha.Gnanasekaran@pmcs.com>
Subject: RE: [PATCH V2 05/10] pm80xx: Phy settings support for motherboard controller.
Date: Thu, 26 Sep 2013 02:16:44 -0700
Message-ID: <E5DEE6F468524847995699AD11E8088501EDC915@BBY1EXM11.pmc_nt.nt.pmc-sierra.bc.ca>
References: <5243C75D.3060606@pmc-sierra.com> <5243DAA9.8050304@gmail.com> <E5DEE6F468524847995699AD11E8088501EDC90F@BBY1EXM11.pmc_nt.nt.pmc-sierra.bc.ca> <5243FA98.5070206@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:42966 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750933Ab3IZJQr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Sep 2013 05:16:47 -0400
Content-class: urn:content-classes:message
In-Reply-To: <5243FA98.5070206@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jack Wang <xjtuwjp@gmail.com>
Cc: Anand Kumar Santhanam <AnandKumar.Santhanam@pmcs.com>, linux-scsi@vger.kernel.org, Nikith Ganigarakoppal <Nikith.Ganigarakoppal@pmcs.com>, Viswas G <Viswas.G@pmcs.com>

Ok. We will add the device list and send updated patch.

-----Original Message-----
From: Jack Wang [mailto:xjtuwjp@gmail.com] 
Sent: Thursday, September 26, 2013 2:43 PM
To: Sangeetha Gnanasekaran
Cc: Anand Kumar Santhanam; linux-scsi@vger.kernel.org; Nikith
Ganigarakoppal; Viswas G
Subject: Re: [PATCH V2 05/10] pm80xx: Phy settings support for
motherboard controller.

On 09/26/2013 11:04 AM, Sangeetha Gnanasekaran wrote:
> Phy settings support is only for Motherboard controller. Firmware will

> only initialize default values for all PHY in case of motherboard 
> controller. Hence, this is mandatory to add this support in all 
> motherboard controllers to configure their own settings.

I still think you'd better add a list for devices know to support phy
setting similar as IS_SPC12G, there are some devices in the driver
support list do not have default setting I suspect.

Jack
> 
> -----Original Message-----
> From: Jack Wang [mailto:xjtuwjp@gmail.com]
> Sent: Thursday, September 26, 2013 12:27 PM
> To: Anand Kumar Santhanam
> Cc: linux-scsi@vger.kernel.org; Sangeetha Gnanasekaran; Nikith 
> Ganigarakoppal; Viswas G
> Subject: Re: [PATCH V2 05/10] pm80xx: Phy settings support for 
> motherboard controller.
> 
> snip
>>  #ifdef PM8001_USE_MSIX
>>  /**
>>   * pm8001_setup_msix - enable MSI-X interrupt @@ -847,6 +872,9 @@ 
>> static int pm8001_pci_probe(struct pci_dev *pdev,
>>  	}
>>  
>>  	pm8001_init_sas_add(pm8001_ha);
>> +	/* phy setting support for motherboard controller */
>> +	if (pdev->subsystem_vendor != PCI_VENDOR_ID_ADAPTEC2)
>> +		pm8001_get_phy_settings_info(pm8001_ha);
> 
> Are you sure about this, have you checked all controller except device

> with subsystem_vendorid is PCI_VENDOR_ID_ADAPTEC2 all support this 
> get_phy_setting_info funcion?
> 
> Jack
>>  	pm8001_post_sas_ha_init(shost, chip);
>>  	rc = sas_register_ha(SHOST_TO_SAS_HA(shost));
>>  	if (rc)
>> diff --git a/drivers/scsi/pm8001/pm8001_sas.h
>> b/drivers/scsi/pm8001/pm8001_sas.h
>> index 68e1147..cbde11a 100644
>> --- a/drivers/scsi/pm8001/pm8001_sas.h
>> +++ b/drivers/scsi/pm8001/pm8001_sas.h
>> @@ -632,7 +632,8 @@ struct pm8001_device *pm8001_find_dev(struct 
>> pm8001_hba_info *pm8001_ha,  int pm80xx_set_thermal_config(struct 
>> pm8001_hba_info *pm8001_ha);
>>  
>>  int pm8001_bar4_shift(struct pm8001_hba_info *pm8001_ha, u32 
>> shiftValue);
>> -
>> +void pm8001_set_phy_profile(struct pm8001_hba_info *pm8001_ha,
>> +	u32 length, u8 *buf);
>>  /* ctl shared API */
>>  extern struct device_attribute *pm8001_host_attrs[];
>>  
>> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c
>> b/drivers/scsi/pm8001/pm80xx_hwi.c
>> index 99cec5f..e1ab320 100644
>> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
>> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
>> @@ -3131,9 +3131,27 @@ static int mpi_flash_op_ext_resp(struct 
>> pm8001_hba_info *pm8001_ha, void *piomb)  static int
> mpi_set_phy_profile_resp(struct pm8001_hba_info *pm8001_ha,
>>  			void *piomb)
>>  {
>> -	PM8001_MSG_DBG(pm8001_ha,
>> -			pm8001_printk("
> pm80xx_addition_functionality\n"));
>> +	u8 page_code;
>> +	struct set_phy_profile_resp *pPayload =
>> +		(struct set_phy_profile_resp *)(piomb + 4);
>> +	u32 ppc_phyid = le32_to_cpu(pPayload->ppc_phyid);
>> +	u32 status = le32_to_cpu(pPayload->status);
>>  
>> +	page_code = (u8)((ppc_phyid & 0xFF00) >> 8);
>> +	if (status) {
>> +		/* status is FAILED */
>> +		PM8001_FAIL_DBG(pm8001_ha,
>> +			pm8001_printk("PhyProfile command failed  with
> status "
>> +			"0x%08X \n", status));
>> +		return -1;
>> +	} else {
>> +		if (page_code != SAS_PHY_ANALOG_SETTINGS_PAGE) {
>> +			PM8001_FAIL_DBG(pm8001_ha,
>> +				pm8001_printk("Invalid page code
> 0x%X\n",
>> +					page_code));
>> +			return -1;
>> +		}
>> +	}
>>  	return 0;
>>  }
>>  
>> @@ -4128,6 +4146,45 @@ pm80xx_chip_isr(struct pm8001_hba_info
> *pm8001_ha, u8 vec)
>>  	return IRQ_HANDLED;
>>  }
>>  
>> +void mpi_set_phy_profile_req(struct pm8001_hba_info *pm8001_ha,
>> +	u32 operation, u32 phyid, u32 length, u32 *buf) {
>> +	u32 tag , i, j = 0;
>> +	int rc;
>> +	struct set_phy_profile_req payload;
>> +	struct inbound_queue_table *circularQ;
>> +	u32 opc = OPC_INB_SET_PHY_PROFILE;
>> +
>> +	memset(&payload, 0, sizeof(payload));
>> +	rc = pm8001_tag_alloc(pm8001_ha, &tag);
>> +	if (rc)
>> +		PM8001_FAIL_DBG(pm8001_ha, pm8001_printk("Invalid
> tag\n"));
>> +	circularQ = &pm8001_ha->inbnd_q_tbl[0];
>> +	payload.tag = cpu_to_le32(tag);
>> +	payload.ppc_phyid = (((operation & 0xF) << 8) | (phyid  &
> 0xFF));
>> +	PM8001_INIT_DBG(pm8001_ha,
>> +		pm8001_printk(" phy profile command for phy %x ,length
> is %d\n",
>> +			payload.ppc_phyid, length));
>> +	for (i = length ; i < (length + PHY_DWORD_LENGTH - 1) ; i++) {
>> +		payload.reserved[j] =  cpu_to_le32(*((u32 *)buf + i));
>> +		j++;
>> +	}
>> +	pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload, 0); }
>> +
>> +void pm8001_set_phy_profile(struct pm8001_hba_info *pm8001_ha,
>> +	u32 length, u8 *buf)
>> +{
>> +	u32 page_code, i;
>> +
>> +	page_code = SAS_PHY_ANALOG_SETTINGS_PAGE;
>> +	for (i = 0 ; i < pm8001_ha->chip->n_phy ; i++) {
>> +		mpi_set_phy_profile_req(pm8001_ha,
>> +			SAS_PHY_ANALOG_SETTINGS_PAGE, i, length, (u32
> *)buf);
>> +		length = length + PHY_DWORD_LENGTH;
>> +	}
>> +	PM8001_INIT_DBG(pm8001_ha, pm8001_printk("phy settings 
>> +completed\n")); }
>>  const struct pm8001_dispatch pm8001_80xx_dispatch = {
>>  	.name			= "pmc80xx",
>>  	.chip_init		= pm80xx_chip_init,
>> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.h
>> b/drivers/scsi/pm8001/pm80xx_hwi.h
>> index 9a9116d..872d5cf 100644
>> --- a/drivers/scsi/pm8001/pm80xx_hwi.h
>> +++ b/drivers/scsi/pm8001/pm80xx_hwi.h
>> @@ -170,6 +170,10 @@
>>  #define LINKRATE_60			(0x06 << 8)
>>  #define LINKRATE_120			(0x08 << 8)
>>  
>> +/* phy_profile */
>> +#define SAS_PHY_ANALOG_SETTINGS_PAGE	0x04
>> +#define PHY_DWORD_LENGTH		0xC
>> +
>>  /* Thermal related */
>>  #define	THERMAL_ENABLE			0x1
>>  #define	THERMAL_LOG_ENABLE		0x1
>>
> 

