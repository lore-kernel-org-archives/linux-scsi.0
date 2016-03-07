From: Joao Pinto <Joao.Pinto-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v10 6/6] add TC G210 pci driver
Date: Mon, 7 Mar 2016 11:03:10 +0000
Message-ID: <56DD5FEE.8010508@synopsys.com>
References: <cover.1457111366.git.jpinto@synopsys.com>
 <3602f942ffc8673942f4944f77a8a9d2c805c847.1457111366.git.jpinto@synopsys.com>
 <1920822.ETZj8qFg72@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1920822.ETZj8qFg72@wuerfel>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Joao Pinto <Joao.Pinto-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>
Cc: vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, julian.calaby-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, gbroner-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, CARLOS.PALMINHA-HKixBCOQz3hWk0Htik3J/w@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hi,

On 3/4/2016 9:17 PM, Arnd Bergmann wrote:
> On Friday 04 March 2016 17:22:19 Joao Pinto wrote:
>> This patch adds a glue pci driver for the Synopsys G210 Test Chip.
>>
>> Signed-off-by: Joao Pinto <jpinto-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>
> 
> Mostly ok, just a few suggestions:
> 
>> +
>> +/* Test Chip type expected values */
>> +#define TC_G210_20BIT 20
>> +#define TC_G210_40BIT 40
>> +#define TC_G210_DEFAULTBIT 40
>> +
>> +static int tc_type = TC_G210_DEFAULTBIT;
>> +module_param(tc_type, int, 0);
>> +MODULE_PARM_DESC(tc_type, "Test Chip Type (20 = 20-bit, 40 = 40-bit)");
>>
> 
> What is the effect of setting the wrong one here? I was thinking
> it would be best to have the default be 'invalid' and then return
> an error from the probe() function when you neither value is
> set.

You're right. Maybe an TC_G210_20BIT_INV by default and also check if the
inserted value is TC_G210_20BIT or TC_G210_40BIT. if not, then abort the probe.

> 
>> +
>> +	/* Check Test Chip type and set the specific setup routine */
>> +	if (tc_type == TC_G210_20BIT) {
>> +		tc_dwc_g210_pci_hba_vops.custom_phy_initialization =
>> +						tc_dwc_g210_config_20_bit;
>> +	} else if (tc_type == TC_G210_40BIT) {
>> +		tc_dwc_g210_pci_hba_vops.custom_phy_initialization =
>> +						tc_dwc_g210_config_40_bit;
>> +	}
> 
> As for the platform driver, I would define two separate structures here,
> and then mark the operations as 'const'.
> 
>> +static const struct pci_device_id tc_dwc_g210_pci_tbl[] = {
>> +	{ PCI_VENDOR_ID_SYNOPSYS, 0xB101, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
>> +	{ PCI_VENDOR_ID_SYNOPSYS, 0xB102, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
>> +	{ }	/* terminate list */
>> +};
> 
> Is there any difference between these two IDs?

The Synopsys can be identified by one of these 2 IDs. There is no particular reason.

> 
> 	Arnd
> 

Joao
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
