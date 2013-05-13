From: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH v2, part 1 3/9] PCI: Convert alloc_pci_dev(void) to
 pci_alloc_dev(bus) instead
Date: Mon, 13 May 2013 10:23:29 -0700
Message-ID: <CAE9FiQVKKKmZRQ8CcKCzU8Gqzwb5SjWYagVB2OZiRqbSWXVpiw@mail.gmail.com>
References: <1368461313-4371-1-git-send-email-jiang.liu@huawei.com>
	<1368461313-4371-4-git-send-email-jiang.liu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1368461313-4371-4-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jiang Liu <liuj97@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Gu Zheng <guz.fnst@cn.fujitsu.com>, "Rafael J . Wysocki" <rjw@sisk.pl>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>, Yijing Wang <wangyijing@huawei.com>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, "David S. Miller" <davem@davemloft.net>, David Airlie <airlied@linux.ie>, Neela Syam Kolli <megaraidlinux@lsi.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@lists.ozlabs.org, "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>, Linux-Scsi <linux-scsi@vger.kernel.org>, Jiang Liu <jiang.liu@huawei.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, May 13, 2013 at 9:08 AM, Jiang Liu <liuj97@gmail.com> wrote:
> From: Gu Zheng <guz.fnst@cn.fujitsu.com>
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index 4f0bc0a..bc075a3 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -1131,6 +1131,7 @@ static void pci_release_dev(struct device *dev)
>         struct pci_dev *pci_dev;
>
>         pci_dev = to_pci_dev(dev);
> +       pci_bus_put(pci_dev->bus);
>         pci_release_capabilities(pci_dev);
>         pci_release_of_node(pci_dev);
>         kfree(pci_dev);
> @@ -1269,11 +1270,10 @@ static struct pci_dev *pci_scan_device(struct pci_bus *bus, int devfn)
>         if (!pci_bus_read_dev_vendor_id(bus, devfn, &l, 60*1000))
>                 return NULL;
>
> -       dev = alloc_pci_dev();
> +       dev = pci_alloc_dev(bus);
>         if (!dev)
>                 return NULL;
>
> -       dev->bus = bus;
>         dev->devfn = devfn;
>         dev->vendor = l & 0xffff;
>         dev->device = (l >> 16) & 0xffff;

in pci_setup_device() fail path, it release the ref to that bus.

Yinghai
