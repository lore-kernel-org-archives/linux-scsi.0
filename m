From: Liu Jiang <liuj97@gmail.com>
Subject: Re: [PATCH v2, part 1 3/9] PCI: Convert alloc_pci_dev(void) to pci_alloc_dev(bus)
 instead
Date: Wed, 15 May 2013 22:39:18 +0800
Message-ID: <51939E16.9090105@gmail.com>
References: <1368461313-4371-1-git-send-email-jiang.liu@huawei.com> <1368461313-4371-4-git-send-email-jiang.liu@huawei.com> <CAE9FiQVKKKmZRQ8CcKCzU8Gqzwb5SjWYagVB2OZiRqbSWXVpiw@mail.gmail.com> <5191F53E.4000305@cn.fujitsu.com> <51925136.5050302@gmail.com> <CAE9FiQWO-jR5y35kKiW0m6gVR54ZyRsBsdhP4BmFLSsDzCS3rA@mail.gmail.com> <51926CF6.1050706@gmail.com> <CAE9FiQWXN_ETRFPb5oFx-6LXyuHviX3h3NXCQKjcxtv2Uma-JA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <CAE9FiQWXN_ETRFPb5oFx-6LXyuHviX3h3NXCQKjcxtv2Uma-JA@mail.gmail.com>
Sender: sparclinux-owner@vger.kernel.org
To: Yinghai Lu <yinghai@kernel.org>
Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>, Bjorn Helgaas <bhelgaas@google.com>, "Rafael J . Wysocki" <rjw@sisk.pl>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>, Yijing Wang <wangyijing@huawei.com>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, "David S. Miller" <davem@davemloft.net>, David Airlie <airlied@linux.ie>, Neela Syam Kolli <megaraidlinux@lsi.com>, "James E.J. Bottomley" <jbottomley@parallels.com>, Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@lists.ozlabs.org, "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>, Linux-Scsi <linux-scsi@vger.kernel.org>, Jiang Liu <jiang.liu@huawei.com>
List-Id: linux-scsi@vger.kernel.org

On Wed 15 May 2013 02:52:51 AM CST, Yinghai Lu wrote:
> On Tue, May 14, 2013 at 9:57 AM, Liu Jiang <liuj97@gmail.com> wrote:
>> On Tue 14 May 2013 11:10:33 PM CST, Yinghai Lu wrote:
>>>
>>> On Tue, May 14, 2013 at 7:59 AM, Liu Jiang <liuj97@gmail.com> wrote:
>>>>
>>>> On 05/14/2013 04:26 PM, Gu Zheng wrote:
>>>>       I suggest to use pci_release_dev() instead because it also needs to
>>>> release OF related resources.
>>>> I will update it in next version.
>>>>
>>>> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
>>>> index bc075a3..2ac6338 100644
>>>> --- a/drivers/pci/probe.c
>>>> +++ b/drivers/pci/probe.c
>>>> @@ -1281,7 +1281,7 @@ static struct pci_dev *pci_scan_device(struct
>>>> pci_bus
>>>> *bus
>>>>           pci_set_of_node(dev);
>>>>
>>>>           if (pci_setup_device(dev)) {
>>>> -               kfree(dev);
>>>> +               pci_release_dev(&dev->dev);
>>>>                   return NULL;
>>>
>>>
>>> no, should move pci_set_of_node calling into pci_setup_device.
>>>
>>> Yinghai
>>
>>
>> I'm not sure whether we should call pci_set_of_node() for SR-IOV devices
>> too,
>> any suggestions here?
>
> or just move down pci_set_of_node after pci_setup_device?
>
> anyway that is another bug.
>
> Yinghai
I'm not familiar with the OF logic and can't make sure whether 
pci_setup_device()
has dependency on dev->of_node. Feel it's more safe to call 
pci_release_of_node()
on failing path instead of tuning call-site of pci_set_of_node().
