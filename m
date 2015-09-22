From: Hannes Reinecke <hare@suse.de>
Subject: Re: [RFT v3] eata: Convert eata driver as normal PCI and platform
 device drivers
Date: Tue, 22 Sep 2015 22:27:28 +0200
Message-ID: <5601B9B0.4090302@suse.de>
References: <20150916134211.GA21535@infradead.org>
 <1442907023-12709-1-git-send-email-jiang.liu@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <1442907023-12709-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-pci-owner@vger.kernel.org
To: Jiang Liu <jiang.liu@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Bjorn Helgaas <bhelgaas@google.com>, Arthur Marsh <arthur.marsh@internode.on.net>, Ballabio Dario <dario.ballabio@emc.com>, Christoph Hellwig <hch@infradead.org>, Dario Ballabio <ballabio_dario@emc.com>, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, x86@kernel.org
List-Id: linux-scsi@vger.kernel.org

On 09/22/2015 09:30 AM, Jiang Liu wrote:
> Previously the eata driver just grabs and accesses eata PCI devices
> without implementing a PCI device driver, that causes troubles with
> latest IRQ related
>=20
> Commit 991de2e59090 ("PCI, x86: Implement pcibios_alloc_irq() and
> pcibios_free_irq()") changes the way to allocate PCI legacy IRQ
> for PCI devices on x86 platforms. Instead of allocating PCI legacy
> IRQs when pcibios_enable_device() gets called, now pcibios_alloc_irq(=
)
> will be called by pci_device_probe() to allocate PCI legacy IRQs
> when binding PCI drivers to PCI devices.
>=20
> But the eata driver directly accesses PCI devices without implementin=
g
> corresponding PCI drivers, so pcibios_alloc_irq() won't be called for
> those PCI devices and wrong IRQ number may be used to manage the PCI
> device.
>=20
> This patch implements a PCI device driver to manage eata PCI devices,
> so eata driver could properly cooperate with the PCI core. It also
> provides headroom for PCI hotplug with eata driver.
>=20
> It also represents non-PCI eata devices as platform devices, so it co=
uld
> be managed as normal devices.
>=20
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Ballabio, Dario <dario.ballabio@emc.com>
> Cc: Christoph Hellwig <hch@infradead.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
