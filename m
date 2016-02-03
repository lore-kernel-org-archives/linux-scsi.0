From: Joao Pinto <Joao.Pinto@synopsys.com>
Subject: Re: [PATCH 3/3] add support for DWC UFS Host Controller
Date: Wed, 3 Feb 2016 17:21:59 +0000
Message-ID: <56B23737.9040004@synopsys.com>
References: <cover.1454498292.git.jpinto@synopsys.com>
 <2072510.CA47OHQsUN@wuerfel> <56B2164E.5060007@synopsys.com>
 <2087303.0ORDEBS3hn@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2087303.0ORDEBS3hn@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, Joao Pinto <Joao.Pinto@synopsys.com>, vinholikatti@gmail.com
Cc: julian.calaby@gmail.com, akinobu.mita@gmail.com, hch@infradead.org, gbroner@codeaurora.org, subhashj@codeaurora.org, CARLOS.PALMINHA@synopsys.com, ijc+devicetree@hellion.org.uk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, devicetree@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


++ Vinayak Holikatti

Hi Vinayak,

Could I please get your opinion about the patch set?

thanks.

On 2/3/2016 3:39 PM, Arnd Bergmann wrote:
> On Wednesday 03 February 2016 15:01:34 Joao Pinto wrote:
>>
>> Hi Arnd,
>>
>> On 2/3/2016 12:54 PM, Arnd Bergmann wrote:
>>> On Wednesday 03 February 2016 11:28:26 Joao Pinto wrote:
>>>>
>>>> Signed-off-by: Joao Pinto <jpinto@synopsys.com>
>>>
>>> This needs a changelog comment, like every patch.
>>>
>>>> @@ -0,0 +1,16 @@
>>>> +* Universal Flash Storage (UFS) DesignWare Host Controller
>>>> +
>>>> +DWC_UFSHC nodes are defined to describe on-chip UFS host controllers.
>>>> +Each UFS controller instance should have its own node.
>>>> +
>>>> +Required properties:
>>>> +- compatible        : compatible list, contains "snps,ufshcd"
>>>
>>> Are there multiple versions of this controller? Usually for designware
>>> parts the version is known, so we should document which versions exist
>>
>> This controller recent releases was 2.0, but we released last year 1.1. The
>> driver works with both. The driver must work with all DWC UFS versions.
> 
> Ok, then make the driver match on the "snps,ufshcd-1.1" compatible
> string, but document both strings in the binding document, and make
> it mandatory to specify the 1.1 version as a compatible fallback.
> 
> If we ever need to handle a quirk for the 2.0 version then, it can
> easily be done.
> 
>>>> +config SCSI_UFS_DWC_HOOKS
>>>> +	bool "DesignWare hooks to UFS controller"
>>>> +	depends on SCSI_UFSHCD
>>>> +	---help---
>>>> +	  This selects the DesignWare hooks for the UFS host controller.
>>>> +
>>>> +	  Select this if you have a DesignWare UFS controller.
>>>> +	  If unsure, say N.
>>>
>>> This could be a silent symbol that gets selected by SCSI_UFS_DWC_PLAT
>>
>> We could do that, but imagine that we select SCSI_UFS_QCOM, then the synopsys
>> hooks would be selected also which in my opinion is not very accurate.
>> In my opinion we should have a selectable DWC_HOOKS.
> 
> I don't understand. At the moment, you can enable SCSI_UFS_DWC_HOOKS
> even if nothing uses it and you only have SCSI_UFS_QCOM enabled.
> 
> With my suggestion, the hooks would disappear unless they are
> actually used.
> 
> Then again, with my later comments, we no longer need the hooks.
> 
> 
>>>> +/**
>>>> + * ufshcd_dwc_setup_mphy()
>>>> + * This function configures Local (host) Synopsys MPHY specific attributes
>>>> + *
>>>> + * @hba: Pointer to drivers structure
>>>> + *
>>>> + * Returns 0 on success non-zero value on failure
>>>> + */
>>>> +int ufshcd_dwc_setup_mphy(struct ufs_hba *hba)
>>>> +{
>>>> +	int ret = 0;
>>>> +
>>>> +#ifdef CONFIG_SCSI_UFS_DWC_40BIT_RMMI
>>>> +	dev_info(hba->dev, "Configuring MPHY 40-bit RMMI");
>>>> +	ret = ufshcd_dwc_setup_40bit_rmmi(hba);
>>>> +	if (ret) {
>>>> +		dev_err(hba->dev, "40-bit RMMI configuration failed");
>>>> +		goto out;
>>>> +	}
>>>> +#else
>>>> +#ifdef CONFIG_SCSI_UFS_DWC_20BIT_RMMI
>>>> +	dev_info(hba->dev, "Configuring MPHY 20-bit RMMI");
>>>> +	ret = ufshcd_dwc_setup_20bit_rmmi(hba);
>>>> +	if (ret) {
>>>> +		dev_err(hba->dev, "20-bit RMMI configuration failed");
>>>> +		goto out;
>>>> +	}
>>>> +#endif
>>>> +#endif
>>>> +	/* To write Shadow register bank to effective configuration block */
>>>> +	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(VS_MPHYCFGUPDT), 0x01);
>>>> +	if (ret)
>>>> +		goto out;
>>>> +
>>>> +	/* To configure Debug OMC */
>>>> +	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(VS_DEBUGOMC), 0x01);
>>>> +
>>>> +out:
>>>> +	return ret;
>>>> +}
>>>
>>> Try to use the generic PHY abstraction here and remove all the #ifdef etc.
>>
>> Could you please point an example for me to check?
> 
> drivers/phy/phy-qcom-ufs-qmp-14nm.c is a phy driver, and it gets used through
> the generic devm_phy_get()/phy_power_on()/phy_power_off()/... interfaces.
> 
> This should probably be moved into the generic UFS platform driver so the PHY
> handling can be shared between all backends.
> 
>>>>  };
>>>
>>> I think you're better off with a separate PCI driver for this. Remove
>>> all the #ifdef mess here, put whatever is dwc specific into a new file,
>>> and perhaps move the common parts into a shared file that can be used
>>> by both the samsung and designware drivers.
>>
>> I have a branch with that approach, but honestly it would be a big change in the
>> UFS arch for the pci and I decided to make it simple. I sent that suggestion for
>> the scsi mailing list and the comments showed me that. Does anyone have anything
>> against putting ufshcd-pci.c as a pci common code and then have a ufs-dwc-pci.c
>> and a ufs-samsung-pci.c that uses that common code?
> 
> Another approach would be to just rename the existing file to ufs-samsung-pci.c
> and start the  ufs-dwc-pci.c as a copy of that. The file is not really all that
> large anyway.
> 
> 	Arnd
> 
