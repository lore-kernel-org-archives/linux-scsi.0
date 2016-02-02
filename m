From: Julian Calaby <julian.calaby@gmail.com>
Subject: Re: [PATCH] add support for DWC UFS Host Controller
Date: Tue, 2 Feb 2016 22:44:54 +1100
Message-ID: <CAGRGNgVwqKWM5_QmSisEJPM098RjxmmAHMhrvXenBKSy+Jh9wQ@mail.gmail.com>
References: <33d190af027d92da449f379a5e60366729d37eab.1454330442.git.jpinto@synopsys.com>
 <CAGRGNgUZOZx80yQoqLq-YWxj7u7rWvGEy9UKSRU++t7VtXEOXQ@mail.gmail.com> <56B08359.1010405@synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56B08359.1010405@synopsys.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joao Pinto <Joao.Pinto@synopsys.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Christoph Hellwig <hch@infradead.org>, gbroner@codeaurora.org, subhashj@codeaurora.org, linux-scsi <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, CARLOS.PALMINHA@synopsys.com, Ian Campbell <ijc+devicetree@hellion.org.uk>
List-Id: linux-scsi@vger.kernel.org

Hi Joao,

On Tue, Feb 2, 2016 at 9:22 PM, Joao Pinto <Joao.Pinto@synopsys.com> wrote:
> Hi Julian,
>
> Thanks for the review. My comments are below.
>
> On 2/2/2016 1:00 AM, Julian Calaby wrote:
>> Hi Joao,
>>
>> On Mon, Feb 1, 2016 at 11:47 PM, Joao Pinto <Joao.Pinto@synopsys.com> wrote:
>>> diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
>>> index d15eaa4..0ee6c62 100644
>>> --- a/drivers/scsi/ufs/ufshcd-pci.c
>>> +++ b/drivers/scsi/ufs/ufshcd-pci.c
>>> @@ -167,6 +167,8 @@ static const struct dev_pm_ops ufshcd_pci_pm_ops = {
>>>
>>>  static const struct pci_device_id ufshcd_pci_tbl[] = {
>>>         { PCI_VENDOR_ID_SAMSUNG, 0xC00C, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
>>> +       { PCI_VENDOR_ID_SYNOPSYS, 0xB101, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
>>> +       { PCI_VENDOR_ID_SYNOPSYS, 0xB102, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
>>
>> Listing these here implies that the devices these lines match are
>> "normal" PCI UFSHCD devices that don't require any special handling
>> whatsoever. Is that correct?
>
> Yes they are normal PCI UFSHCD devices.
>
>>
>> If they do require special handling, then you need to put them in a
>> separate driver, e.g. ufs-dwc-pci.c
>
> Both ufs-dwc and pci driver must execute the same init sequence to correctly
> kick-off the hardware. That's why the common code is in the ufshcd.c.
> Maybe create a ufshcd-dwc-quirks.c with the dwc specififc code would be better.
> This way it could be used by ufs-dwc platform driver and pci.
> Since dwc hardware uses a specific init routine would it be better to have a
> ufs-dwc-pci and ufs-dwc calling the dwc specific init routine?

What you suggested below, i.e. having a ufshcd-dwc.c file containing
the common stuff then having separate platform and PCI drivers sounds
like the best option.

>>>         { }     /* terminate list */
>>>  };
>>>
>>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>>> index 85cd256..05d309d 100644
>>> --- a/drivers/scsi/ufs/ufshcd.c
>>> +++ b/drivers/scsi/ufs/ufshcd.c
>>> @@ -5521,6 +5541,790 @@ static struct devfreq_dev_profile ufs_devfreq_profile = {
>>>         .get_dev_status = ufshcd_devfreq_get_dev_status,
>>>  };
>>>
>>> +#ifdef CONFIG_SCSI_UFS_DWC_HOOKS
>>
>> This doesn't look right.
>>
>> The driver should be structured like this:
>>
>>  - ufs-dwc: contains everything that is specific to your hardware.
>>  - ufshcd: contains everything that is common to multiple types of
>> ufshcd from different vendors
>>
>> Your "hooks" here look like they're doing stuff that is specific to
>> the Designware hardware. They should not be in this file as it's for
>> hardware type independent code.
>>
>> If you need to do something special at some point in the common code,
>> then this should be exposed as an op in struct ufs_hba_variant_ops
>> which is then implemented in your device-specific code.
>
> Yes I agree that maybe the ufs core drive is not the perfect spot for specific
> vendor code. But DWC HW can be using pci or platform and so it has to share
> common code and that's why I put it in the ufshcd.
>
> I think creating a ufshcd-dwc.c would be better to share code between ufs-dwc
> and ufs-dwc-pci. Agree?

Agreed.

>>> +/**
>>> + * ufshcd_dwc_program_clk_div()
>>> + * This function programs the clk divider value. This value is needed to
>>> + * provide 1 microsecond tick to unipro layer.
>>> + * @hba: Private Structure pointer
>>> + * @divider_val: clock divider value to be programmed
>>> + *
>>> + */
>>> +void ufshcd_dwc_program_clk_div(struct ufs_hba *hba, u32 divider_val)
>>> +{
>>> +       ufshcd_writel(hba, divider_val, DWC_UFS_REG_HCLKDIV);
>>> +}
>>> +
>>> +/**
>>> + * ufshcd_dwc_link_is_up()
>>> + * Check if link is up
>>> + * @hba: private structure poitner
>>> + *
>>> + * Returns 0 on success, non-zero value on failure
>>> + */
>>> +int ufshcd_dwc_link_is_up(struct ufs_hba *hba)
>>> +{
>>> +       int dme_result = 0;
>>> +
>>> +       ufshcd_dme_get(hba, UIC_ARG_MIB(VS_POWERSTATE), &dme_result);
>>> +
>>> +       if (dme_result == UFSHCD_LINK_IS_UP) {
>>> +               ufshcd_set_link_active(hba);
>>> +               return 0;
>>> +       }
>>> +
>>> +       return 1;
>>> +}
>>> +
>>> +/**
>>> + * ufshcd_dwc_connection_setup()
>>> + * This function configures both the local side (host) and the peer side
>>> + * (device) unipro attributes to establish the connection to application/
>>> + * cport.
>>> + * This function is not required if the hardware is properly configured to
>>> + * have this connection setup on reset. But invoking this function does no
>>> + * harm and should be fine even working with any ufs device.
>>> + *
>>> + * @hba: pointer to drivers private data
>>> + *
>>> + * Returns 0 on success non-zero value on failure
>>> + */
>>> +int ufshcd_dwc_connection_setup(struct ufs_hba *hba)
>>> +{
>>> +       int ret = 0;
>>> +
>>> +       /* Local side Configuration */
>>> +       ret = ufshcd_dme_set(hba, UIC_ARG_MIB(T_CONNECTIONSTATE), 0);
>>> +       if (ret)
>>> +               goto out;
>>> +
>>> +       ret = ufshcd_dme_set(hba, UIC_ARG_MIB(N_DEVICEID), 0);
>>> +       if (ret)
>>> +               goto out;
>>> +
>>> +       ret = ufshcd_dme_set(hba, UIC_ARG_MIB(N_DEVICEID_VALID), 0);
>>> +       if (ret)
>>> +               goto out;
>>> +
>>> +       ret = ufshcd_dme_set(hba, UIC_ARG_MIB(T_PEERDEVICEID), 1);
>>> +       if (ret)
>>> +               goto out;
>>> +
>>> +       ret = ufshcd_dme_set(hba, UIC_ARG_MIB(T_PEERCPORTID), 0);
>>> +       if (ret)
>>> +               goto out;
>>> +
>>> +       ret = ufshcd_dme_set(hba, UIC_ARG_MIB(T_TRAFFICCLASS), 0);
>>> +       if (ret)
>>> +               goto out;
>>> +
>>> +       ret = ufshcd_dme_set(hba, UIC_ARG_MIB(T_CPORTFLAGS), 0x6);
>>> +       if (ret)
>>> +               goto out;
>>> +
>>> +       ret = ufshcd_dme_set(hba, UIC_ARG_MIB(T_CPORTMODE), 1);
>>> +       if (ret)
>>> +               goto out;
>>> +
>>> +       ret = ufshcd_dme_set(hba, UIC_ARG_MIB(T_CONNECTIONSTATE), 1);
>>> +       if (ret)
>>> +               goto out;
>>> +
>>> +
>>> +       /* Peer side Configuration */
>>> +       ret = ufshcd_dme_peer_set(hba, UIC_ARG_MIB(T_CONNECTIONSTATE), 0);
>>> +       if (ret)
>>> +               goto out;
>>> +
>>> +       ret = ufshcd_dme_peer_set(hba, UIC_ARG_MIB(N_DEVICEID), 1);
>>> +       if (ret)
>>> +               goto out;
>>> +
>>> +       ret = ufshcd_dme_peer_set(hba, UIC_ARG_MIB(N_DEVICEID_VALID), 1);
>>> +       if (ret)
>>> +               goto out;
>>> +
>>> +       ret = ufshcd_dme_peer_set(hba, UIC_ARG_MIB(T_PEERDEVICEID), 1);
>>> +       if (ret)
>>> +               goto out;
>>> +
>>> +       ret = ufshcd_dme_peer_set(hba, UIC_ARG_MIB(T_PEERCPORTID), 0);
>>> +       if (ret)
>>> +               goto out;
>>> +
>>> +       ret = ufshcd_dme_peer_set(hba, UIC_ARG_MIB(T_TRAFFICCLASS), 0);
>>> +       if (ret)
>>> +               goto out;
>>> +
>>> +       ret = ufshcd_dme_peer_set(hba, UIC_ARG_MIB(T_CPORTFLAGS), 0x6);
>>> +       if (ret)
>>> +               goto out;
>>> +
>>> +       ret = ufshcd_dme_peer_set(hba, UIC_ARG_MIB(T_CPORTMODE), 1);
>>> +       if (ret)
>>> +               goto out;
>>> +
>>> +       ret = ufshcd_dme_peer_set(hba, UIC_ARG_MIB(T_CONNECTIONSTATE), 1);
>>> +       if (ret)
>>> +               goto out;
>>> +
>>> +out:
>>> +       return ret;
>>> +}
>>> +
>>> +/**
>>> + * ufshcd_dwc_setup_20bit_rmmi_lane0()
>>> + * This function configures Synopsys MPHY 20-bit RMMI Lane 0
>>> + * @hba: Pointer to drivers structure
>>> + *
>>> + * Returns 0 on success or non-zero value on failure
>>> + */
>>> +int ufshcd_dwc_setup_20bit_rmmi_lane0(struct ufs_hba *hba)
>>> +{
>>> +       int ret = 0;
>>> +
>>> +       /* TX Reference Clock 26MHz */
>>> +       ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(TX_REFCLKFREQ,
>>> +                                                       SELIND_LN0_TX), 0x01);
>>> +       if (ret)
>>> +               goto out;
>>> +
>>> +#ifdef CONFIG_SCSI_UFS_DWC_MPHY_TC_GEN2
>>
>> Furthermore, the ARM developers are moving towards having single
>> kernels that support multiple different hardware platforms based on
>> the devicetree loaded at boot.
>>
>> It's expected that a single kernel might have drivers to support
>> multiple different types of UFS hardware from multiple vendors.
>>
>> Consequently, as the GEN2 hardware needs extra stuff, this stuff
>> should be enabled either by:
>> 1. detecting it at runtime
>
> Not yet possible unfornately.

I would have been surprised if it had been.

>> 2. adding a second compatible string and checking it where needed
>
> Maybe, but Kconfig is more intuitive for users in my perspective.

Users will be expecting to enable the Designware UFS driver in Kconfig
and get something that works with both versions. The way you have this
structured is not compatible with building a single kernel and having
it work over multiple devices.

>> 3. using a separate driver with a different compatible string
>
> Gen 2 Test Chip are init as the Gen 1 Test Chip with a few twists, so I fon't
> think it would be eficient to create a another driver with replicated init
> routines because Gen1 and Gen2 share most of the init instructions.

Fair enough.

>>> @@ -5645,8 +6449,16 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
>>>          */
>>>         ufshcd_set_ufs_dev_poweroff(hba);
>>>
>>> +#ifndef CONFIG_SCSI_UFS_DWC_HOOKS
>>>         async_schedule(ufshcd_async_scan, hba);
>>> -
>>> +#else
>>> +       /* Synopsys DWC Core + MPHY Test Chip needs a specific init routine */
>>> +       err = ufshcd_dwc_host_configuration(hba);
>>> +       if (err)
>>> +               dev_err(dev, "DWC host configuration failed\n");
>>> +       else
>>> +               dev_info(dev, "DWC host configuration successful\n");
>>> +#endif
>>
>> This initialisation should be in your hardware specific code.
>
> Already commented previously.

if your hardware needs some special initialisation at this point, then
you should add a function in struct vendor_ops to do this. That's what
it's there for.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
