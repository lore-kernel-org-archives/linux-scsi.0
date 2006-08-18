From: Kyle McMartin <kyle@parisc-linux.org>
Subject: Re: Bug#380272: kernel-image-2.6-686-smp: cpqarray module fails to detect arrays
Date: Fri, 18 Aug 2006 12:39:04 -0400
Message-ID: <20060818163904.GC16593@athena.road.mcmartin.ca>
References: <200608180959.16889.joshua@rubixlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stout.engsoc.carleton.ca ([134.117.69.22]:22204 "EHLO
	stout.engsoc.carleton.ca") by vger.kernel.org with ESMTP
	id S1751399AbWHRQj6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Aug 2006 12:39:58 -0400
Content-Disposition: inline
In-Reply-To: <200608180959.16889.joshua@rubixlinux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joshua Rubin <joshua@rubixlinux.org>, 380272@bugs.debian.org
Cc: maximilian attems <maks@sternwelten.at>, Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

Hello Joshua,

On Fri, Aug 18, 2006 at 09:59:16AM -0600, Joshua Rubin wrote:
> I have confirmed that loading cpqarray first fixes the problem on several 
> systems now. I have also realized that when this is the case, the sym53c8xx 
> driver is not needed or loaded. I thought this was noteworthy. It appears 
> that your presumption was correct that the sym53c8xx and cpqarray modules do 
> not play nicely.
> 

The problem is because they both claim support for the same PCI Ids:

cpqarray.c,
static const struct pci_device_id cpqarray_pci_device_id[] =
{
	....
        { PCI_VENDOR_ID_NCR, PCI_DEVICE_ID_NCR_53C1510,
                0x0E11, 0x4048, 0, 0, 0},       /* LC2 */
        { PCI_VENDOR_ID_NCR, PCI_DEVICE_ID_NCR_53C1510,
                0x0E11, 0x4040, 0, 0, 0},      /* Integrated Array */
	....
};

and sym53c8xx_2/sym_glue.c,
static struct pci_device_id sym2_id_table[] __devinitdata = {
	....
        { PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_53C1510,
          PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
	....
        { PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_NCR_53C1510,
          PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL }, /* new */
	....
};

More correctly, the problem is because sym2 is claiming support
for all devices with these PCI device/vendor id.

Can we get the output of lspci -v output from your machine?

If LSI was kind, the PCI class might be different between the two,
or some other clue might be there to differentiate them.

> Is this something that can be handled in the initramfs automatically instead 
> of forcing everyone running these systems to update 
> their /etc/initramfs-tools/modules file?

The easiest thing to do from the initramfs point of view is to simply
load cpqarray in preference to sym53c8xx.

Regards,
	Kyle M.
