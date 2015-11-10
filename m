From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH V2 1/3] scsi: mptxsas: try 64 bit DMA when 32 bit DMA fails
Date: Tue, 10 Nov 2015 20:56:47 +0100
Message-ID: <3742888.Lmg2Y11mdz@wuerfel>
References: <1447034266-28003-1-git-send-email-okaya@codeaurora.org> <4982446.ZlJVrezq1Y@wuerfel> <56422725.7040809@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56422725.7040809@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Sinan Kaya <okaya@codeaurora.org>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, linux-scsi@vger.kernel.org, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, jcm@redhat.com, timur@codeaurora.org, "James E.J. Bottomley" <JBottomley@odin.com>, linux-kernel@vger.kernel.org, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Hannes Reinecke <hare@suse.de>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, cov@codeaurora.org, linux-arm-msm@vger.kernel.org, MPT-FusionLinux.pdl@avagotech.com, agross@codeaurora.org
List-Id: linux-scsi@vger.kernel.org

On Tuesday 10 November 2015 12:19:33 Sinan Kaya wrote:
> On 11/10/2015 11:47 AM, Arnd Bergmann wrote:
> > On Tuesday 10 November 2015 11:06:40 Sinan Kaya wrote:
> >> On 11/10/2015 3:38 AM, Arnd Bergmann wrote:
> >>   > No, as Timur found, the driver is correct and it intentionally
> >>> sets the 32-bit mask, and that is guaranteed to work on all sane
> >>> hardware. Don't change the driver but find a better platform for
> >>> your workload, or talk to the people that are responsible for
> >>> the platform and get them to fix it.
> >>
> >> Platform does have an IOMMU. No issues there. I am trying to clean out
> >> the patch pipe I have in order to get this card working with and without
> >> IOMMU.
> >
> > On PowerPC, I think we automatically enable the IOMMU whenever a DMA
> > mask is set that doesn't cover all of the RAM. We could think about
> > doing the same thing on ARM64 to make all devices work out of the box.
> >
> 
> The ACPI IORT table declares whether you enable IOMMU for a particular 
> device or not. The placement of IOMMU HW is system specific. The IORT 
> table gives the IOMMU HW topology to the operating system.

This sounds odd. Clearly you need to specify the IOMMU settings for each
possible PCI device independent of whether the OS actually uses the IOMMU
or not. In a lot of cases, we want to turn it off to get better performance
when the driver has set a DMA mask that covers all of RAM, but you
also want to enable the IOMMU for debugging purposes or for device
assignment if you run virtual machines. The bootloader doesn't know how
the device is going to be used, so it cannot define the policy here.

	Arnd
