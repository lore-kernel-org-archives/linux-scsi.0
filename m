From: Joao Pinto <Joao.Pinto@synopsys.com>
Subject: Re: [PATCH v10 5/6] add TC G210 platform driver
Date: Mon, 7 Mar 2016 10:02:40 +0000
Message-ID: <56DD51C0.30900@synopsys.com>
References: <cover.1457111366.git.jpinto@synopsys.com>
 <cc5666f44c532b31dee1a1c8d12157173e69f9e2.1457111366.git.jpinto@synopsys.com>
 <2253265.cRVI7LPIKe@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from us01smtprelay-2.synopsys.com ([198.182.47.9]:45920 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611AbcCGKGX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2016 05:06:23 -0500
In-Reply-To: <2253265.cRVI7LPIKe@wuerfel>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, Joao Pinto <Joao.Pinto@synopsys.com>
Cc: vinholikatti@gmail.com, julian.calaby@gmail.com, akinobu.mita@gmail.com, hch@infradead.org, mark.rutland@arm.com, gbroner@codeaurora.org, subhashj@codeaurora.org, CARLOS.PALMINHA@synopsys.com, ijc+devicetree@hellion.org.uk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, devicetree@vger.kernel.org

Hi,

On 3/4/2016 9:12 PM, Arnd Bergmann wrote:
> On Friday 04 March 2016 17:22:18 Joao Pinto wrote:
>> This patch adds a glue platform driver for the Synopsys G210 Test Chip.
>>
>> Signed-off-by: Joao Pinto <jpinto@synopsys.com>
> 
> Looks basically ok, but I think it can be simplified a little:
> 
>> +/**
>> + * struct ufs_hba_dwc_vops - UFS DWC specific variant operations
>> + */
>> +static struct ufs_hba_variant_ops tc_dwc_g210_pltfm_hba_vops = {
>> +	.name                   = "tc-dwc-g210-pltfm",
>> +	.link_startup_notify	= ufshcd_dwc_link_startup_notify,
>> +};
>> +
>> +/**
>> + * tc_dwc_g210_pltfm_probe()
>> + * @pdev: pointer to platform device structure
>> + *
>> + */
>> +static int tc_dwc_g210_pltfm_probe(struct platform_device *pdev)
>> +{
>> +	int err;
>> +	struct device *dev = &pdev->dev;
>> +	struct device_node *np = dev->of_node;
>> +
>> +	/* Check Test Chip type and set the specific setup routine */
>> +	if (of_device_is_compatible(np, "snps, g210-tc-6.00-20bit")) {
>> +		tc_dwc_g210_pltfm_hba_vops.custom_phy_initialization =
>> +						tc_dwc_g210_config_20_bit;
>> +	} else if (of_device_is_compatible(np, "snps, g210-tc-6.00-40bit")) {
>> +		tc_dwc_g210_pltfm_hba_vops.custom_phy_initialization =
>> +						tc_dwc_g210_config_40_bit;
>> +	}
> 
> Instead of manually checking the compatible string, define two copies
> of the ufs_hba_variant_ops, and put a pointer to them into the
> .data field of tc_dwc_g210_pltfm_match.

Sounds nice. I'll do that!

> 
> 	Arnd
> 

Joao
