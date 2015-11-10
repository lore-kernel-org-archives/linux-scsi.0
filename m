From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH V2 1/3] scsi: mptxsas: try 64 bit DMA when 32 bit DMA fails
Date: Tue, 10 Nov 2015 23:06:03 +0100
Message-ID: <3710077.X1fITqqHih@wuerfel>
References: <1447034266-28003-1-git-send-email-okaya@codeaurora.org> <3742888.Lmg2Y11mdz@wuerfel> <56425A6B.2070900@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56425A6B.2070900@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Sinan Kaya <okaya@codeaurora.org>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, linux-scsi@vger.kernel.org, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, jcm@redhat.com, timur@codeaurora.org, "James E.J. Bottomley" <JBottomley@odin.com>, linux-kernel@vger.kernel.org, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Hannes Reinecke <hare@suse.de>, linux-arm-msm@vger.kernel.org, agross@codeaurora.org, MPT-FusionLinux.pdl@avagotech.com, cov@codeaurora.org
List-Id: linux-scsi@vger.kernel.org

On Tuesday 10 November 2015 15:58:19 Sinan Kaya wrote:
> 
> On 11/10/2015 2:56 PM, Arnd Bergmann wrote:
> >> The ACPI IORT table declares whether you enable IOMMU for a particular
> >> >device or not. The placement of IOMMU HW is system specific. The IORT
> >> >table gives the IOMMU HW topology to the operating system.
> > This sounds odd. Clearly you need to specify the IOMMU settings for each
> > possible PCI device independent of whether the OS actually uses the IOMMU
> > or not.
> 
> There are provisions to have DMA mask in the PCIe host bridge not at the 
> PCIe device level inside IORT table. This setting is specific for each 
> PCIe bus. It is not per PCIe device.

Same thing, I meant the bootloader must provide all the information that
is needed to use the IOMMU on all PCI devices. I don't care where the IOMMU
driver gets that information. Some IOMMUs require programming a
bus/device/function specific number into the I/O page tables, and they
might not always have the same algorithm to map from the PCI numbers
into their own number space.

> It is assumed that the endpoint device driver knows the hardware for 
> PCIe devices. The driver can also query the supported DMA bits by this 
> platform via DMA APIs and will request the correct DMA mask from the DMA 
> subsystem (surprise!).

I know how the negotiation works. Note that dma_get_required_mask()
will only tell you what mask the device needs to access all of memory,
while both the device and bus may have additional limitations, and
there is not always a solution.

> >In a lot of cases, we want to turn it off to get better performance
> > when the driver has set a DMA mask that covers all of RAM, but you
> > also want to enable the IOMMU for debugging purposes or for device
> > assignment if you run virtual machines. The bootloader doesn't know how
> > the device is going to be used, so it cannot define the policy here.
> 
> I think we'll end up adding a virtualization option to the UEFI BIOS 
> similar to how Intel platforms work. Based on this switch, we'll end up 
> patching the ACPI table.
> 
> If I remove the IORT entry, then the device is in coherent mode with 
> device accessing the full RAM range.
> 
> If I have the IORT table, the device is in IOMMU translation mode.
> 
> Details are in the IORT spec.

I think that would suck a lot more than being slightly out of spec
regarding SBSA if you make the low PCI addresses map to the start
of RAM. Asking users to select a 'virtualization' option based on
what kind of PCI device and kernel version they have is a major
hassle.

	Arnd
