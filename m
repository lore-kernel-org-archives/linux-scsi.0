From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH v2 00/23] scsi: Use pci_enable_msix_range() instead of
 pci_enable_msix()
Date: Thu, 13 Mar 2014 07:04:07 +0000
Message-ID: <1394694244.30610.17.camel@dabdike.int.hansenpartnership.com>
References: <cover.1393191330.git.agordeev@redhat.com>
	 <20140313040440.GB26657@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <20140313040440.GB26657@google.com>
Content-Language: en-US
Content-ID: <68C970746D5C9141ABC46694335BA49C@sw.swsoft.com>
Sender: linux-pci-owner@vger.kernel.org
To: "bhelgaas@google.com" <bhelgaas@google.com>
Cc: "DL-MPTFusionLinux@lsi.com" <DL-MPTFusionLinux@lsi.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "intel-linux-scu@intel.com" <intel-linux-scu@intel.com>, "iss_storagedev@hp.com" <iss_storagedev@hp.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "pv-drivers@vmware.com" <pv-drivers@vmware.com>, "qla2xxx-upstream@qlogic.com" <qla2xxx-upstream@qlogic.com>, "agordeev@redhat.com" <agordeev@redhat.com>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "support@lsi.com" <support@lsi.com>, "iscsi-driver@qlogic.com" <iscsi-driver@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2014-03-12 at 22:04 -0600, Bjorn Helgaas wrote:
> On Mon, Feb 24, 2014 at 09:02:00AM +0100, Alexander Gordeev wrote:
> > Hello!
> > 
> > This series is against James Bottomley's SCSI tree [1], but it needs
> > commit f7fc32c ("PCI/MSI: Add pci_enable_msi_exact() and
> > pci_enable_msix_exact()") from from Bjorn Helgaas's PCI tree [2]:
> > 
> > 1. git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
> > 2. git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git pci/msi
> > 
> > Recently pci_enable_msix_exact() function has been accepted to
> > the mainline. That is a variation of pci_enable_msix_range() which
> > allows a device driver to request a particular number of MSI-Xs.
> > 
> > As result, most of the changes posted in version 1 of this series
> > are invalidated and need to use pci_enable_msix_exact() instead of
> > originally posted pci_enable_msix_range() usages.
> > 
> > I removed almost all ACKs, since unlike pci_enable_msix_range()
> > function which returns the number of MSI-Xs allocated or negative
> > errno, pci_enable_msix_exact() returns either zero success code or
> > a negative errno. Although this change is simple, it still entails
> > an updated error code analysis and would be better reviewed by
> > driver maintainers.
> 
> Hi James,
> 
> I think Alexander sent these to linux-scsi hoping that you would handle
> them, but I know it's a hassle because they depend on f7fc32c, which went
> in after the merge window.
> 
> I'd be glad to review these and apply them through my tree, unless you want
> to do it.  I'd like to get these merged in the v3.15 merge window so
> Alexander can move on to something else.  I haven't checked for merge
> conflicts with scsi.git yet, but I assume they'd be pretty trivial if there
> are any.

Sure, any that haven't been applied ... I think we already have some
updates for drivers which do MSIX changes, but for those you'll see the
conflict with scsi.git and you can just drop the patch for that driver.

James
