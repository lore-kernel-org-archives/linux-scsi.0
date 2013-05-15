From: Liu Jiang <liuj97@gmail.com>
Subject: Re: [PATCH v2, part 1 3/9] PCI: Convert alloc_pci_dev(void) to pci_alloc_dev(bus)
 instead
Date: Thu, 16 May 2013 07:46:57 +0800
Message-ID: <51941E71.8010309@gmail.com>
References: <1368461313-4371-1-git-send-email-jiang.liu@huawei.com> <1368461313-4371-4-git-send-email-jiang.liu@huawei.com> <CAE9FiQVKKKmZRQ8CcKCzU8Gqzwb5SjWYagVB2OZiRqbSWXVpiw@mail.gmail.com> <5191F53E.4000305@cn.fujitsu.com> <51925136.5050302@gmail.com> <CAE9FiQWO-jR5y35kKiW0m6gVR54ZyRsBsdhP4BmFLSsDzCS3rA@mail.gmail.com> <51926CF6.1050706@gmail.com> <CAE9FiQWXN_ETRFPb5oFx-6LXyuHviX3h3NXCQKjcxtv2Uma-JA@mail.gmail.com> <51939E16.9090105@gmail.com> <CAE9FiQUXrOmN0rkvOwE1G_acEGY3-gouzaXjBMT7EE6uAqvuZA@mail.gmail.com> <51939FB1.20203@gmail.com> <1368653371.9603.18.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <1368653371.9603.18.camel@pasglop>
Sender: sparclinux-owner@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Gu Zheng <guz.fnst@cn.fujitsu.com>, Bjorn Helgaas <bhelgaas@google.com>, "Rafael J . Wysocki" <rjw@sisk.pl>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>, Yijing Wang <wangyijing@huawei.com>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>, "David S. Miller" <davem@davemloft.net>, David Airlie <airlied@linux.ie>, Neela Syam Kolli <megaraidlinux@lsi.com>, "James E.J. Bottomley" <jbottomley@parallels.com>, Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@lists.ozlabs.org, "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>, Linux-Scsi <linux-scsi@vger.kernel.org>, Jiang Liu <jiang.liu@huawei.com>
List-Id: linux-scsi@vger.kernel.org

On Thu 16 May 2013 05:29:31 AM CST, Benjamin Herrenschmidt wrote:
> On Wed, 2013-05-15 at 22:46 +0800, Liu Jiang wrote:
>>         I don't know any OF exports, could you please help to CC
>> some OF experts?
>
> I wrote that code I think. Sorry, I've missed the beginning of the
> thread, what is the problem ?
>
> Cheers,
> Ben.
>
>
Hi,
     Just found a little memory leak issue that we should call 
pci_release_of_node()
on error recovery path in function pci_scan_device().
        pci_set_of_node(dev);

        if (pci_setup_device(dev)) {
                kfree(dev);
                return NULL;
        }

Regards!
Gerry

