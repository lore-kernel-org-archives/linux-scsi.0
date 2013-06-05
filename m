From: Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v3, part1 03/10] PCI: Convert alloc_pci_dev(void) to
 pci_alloc_dev(bus) instead
Date: Wed, 5 Jun 2013 14:07:18 -0600
Message-ID: <CAErSpo6C-QMFCbMMivBE5TN4sEOFR_EyPmtN=OUNo8eN-+t=GQ@mail.gmail.com>
References: <1369489718-25869-1-git-send-email-jiang.liu@huawei.com> <1369489718-25869-4-git-send-email-jiang.liu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <1369489718-25869-4-git-send-email-jiang.liu@huawei.com>
Sender: sparclinux-owner@vger.kernel.org
To: Jiang Liu <liuj97@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Gu Zheng <guz.fnst@cn.fujitsu.com>, "Rafael J . Wysocki" <rjw@sisk.pl>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>, Yijing Wang <wangyijing@huawei.com>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jiang Liu <jiang.liu@huawei.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, "David S. Miller" <davem@davemloft.net>, David Airlie <airlied@linux.ie>, Neela Syam Kolli <megaraidlinux@lsi.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, sparclinux@vger.kernel.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, May 25, 2013 at 7:48 AM, Jiang Liu <liuj97@gmail.com> wrote:
> From: Gu Zheng <guz.fnst@cn.fujitsu.com>
>
> Use the new pci_alloc_dev(bus) to replace the existing using of
> alloc_pci_dev(void).
> ...

> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index 26df9c8..d5d18a0 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -1130,6 +1130,7 @@ static void pci_release_dev(struct device *dev)
>         struct pci_dev *pci_dev;
>
>         pci_dev = to_pci_dev(dev);
> +       pci_bus_put(pci_dev->bus);
>         pci_release_capabilities(pci_dev);
>         pci_release_of_node(pci_dev);
>         kfree(pci_dev);

I think we should drop the pci_bus reference *last* (before the
kfree).  Otherwise, we have to audit pci_release_capabilities() and
pci_release_of_node() to make sure they don't use pci_dev->bus.

I made this change on my branch already; just let me know if you object.

Bjorn
