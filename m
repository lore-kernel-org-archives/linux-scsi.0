From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH v5 20/32] scsi: hisi_sas: add v1 hw interrupt init
Date: Wed, 18 Nov 2015 16:13:10 +0000
Message-ID: <564CA396.9010709@huawei.com>
References: <1447779059-136143-1-git-send-email-john.garry@huawei.com>
 <1447779059-136143-21-git-send-email-john.garry@huawei.com>
 <CAL_Jsq+NEm_+cGYC6XG6_fprg1Gd7VG0dj8MKPAPUPqpBzL0pg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAL_Jsq+NEm_+cGYC6XG6_fprg1Gd7VG0dj8MKPAPUPqpBzL0pg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Rob Herring <robh+dt@kernel.org>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, Linuxarm <linuxarm@huawei.com>, John Garry <john.garry2@mail.dcu.ie>, hare@suse.de, Wei Xu <xuwei5@hisilicon.com>, Zhangfei Gao <zhangfei.gao@linaro.org>
List-Id: linux-scsi@vger.kernel.org



On 18/11/2015 15:26, Rob Herring wrote:
> On Tue, Nov 17, 2015 at 10:50 AM, John Garry <john.garry@huawei.com> wrote:
>> Add code to interrupts, so now we can get a phy up
>> interrupt when a disk is connected.
> So I started looking at why you are using of_irq_count which drivers
> shouldn't need to. In patch 5 you use it to allocate memory to store
> the irq names, then use them here...
right
>
>> +static const char phy_int_names[HISI_SAS_PHY_INT_NR][32] = {
>> +       {"Phy Up"},
>> +};
>> +static irq_handler_t phy_interrupts[HISI_SAS_PHY_INT_NR] = {
>> +       int_phyup_v1_hw,
>> +};
>> +
>> +static int interrupt_init_v1_hw(struct hisi_hba *hisi_hba)
>> +{
>> +       struct device *dev = &hisi_hba->pdev->dev;
>> +       struct device_node *np = dev->of_node;
>> +       char *int_names = hisi_hba->int_names;
>> +       int i, j, irq, rc, idx;
>> +
>> +       if (!np)
>> +               return -ENOENT;
>> +
>> +       for (i = 0; i < hisi_hba->n_phy; i++) {
>> +               struct hisi_sas_phy *phy = &hisi_hba->phy[i];
>> +
>> +               idx = i * HISI_SAS_PHY_INT_NR;
>> +               for (j = 0; j < HISI_SAS_PHY_INT_NR; j++, idx++) {
>> +                       irq = irq_of_parse_and_map(np, idx);
> It is also preferred that drivers don't use this either. You should
> use platform_get_irq() instead.
>
>> +                       if (!irq) {
>> +                               dev_err(dev,
>> +                                       "irq init: fail map phy interrupt %d\n",
>> +                                       idx);
>> +                               return -ENOENT;
>> +                       }
>> +
>> +                       (void)snprintf(&int_names[idx * HISI_SAS_NAME_LEN],
>> +                                      HISI_SAS_NAME_LEN,
>> +                                      "%s %s:%d", dev_name(dev),
>> +                                      phy_int_names[j], i);
>> +                       rc = devm_request_irq(dev, irq, phy_interrupts[j], 0,
>> +                                       &int_names[idx * HISI_SAS_NAME_LEN],
>> +                                       phy);
> There's no requirement for the name to match the name in the DT or
> even that the name needs to be unique.
It is desirable to be unique as we have so many instances of the same 
types of interrupt sources:
for hip05 chipset with v1 controller we have the following interrupts: 8 
phyup, 8 abnormal, 8 broadcast, 32 completion, 2 fatal
> If you really want the DT names used, then just call
> of_property_read_string_index() on interrupt-names here. There is no
> point to copy the string.
We would not want to add so many strings, no?
> Rob
thanks,
John
