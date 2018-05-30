From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCH V3 2/2] scsi: hpsa: drop shutdown callback
Date: Wed, 30 May 2018 19:25:07 +0000
Message-ID: <af772e6434e645f4a42d22821442a3bd@microsemi.com>
References: <1527542471-10316-1-git-send-email-okaya@codeaurora.org>
 <1527542471-10316-2-git-send-email-okaya@codeaurora.org>
 <51bb7b82-c4a1-435c-7668-639db96d76e1@finnie.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <51bb7b82-c4a1-435c-7668-639db96d76e1@finnie.org>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Ryan Finnie <ryan@finnie.org>, Sinan Kaya <okaya@codeaurora.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "timur@codeaurora.org" <timur@codeaurora.org>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "open list:HEWLETT-PACKARD SMART ARRAY RAID
 DRIVER (hpsa)" <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>, "esc.storagedev" <esc.storagedev@microsemi.com>, open list <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Ryan Finnie [mailto:ryan@finnie.org]
> Sent: Tuesday, May 29, 2018 8:50 PM
> To: Sinan Kaya <okaya@codeaurora.org>; linux-pci@vger.kernel.org;
> timur@codeaurora.org
> Cc: linux-arm-msm@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
> stable@vger.kernel.org; Don Brace <don.brace@microsemi.com>; James E.J.
> Bottomley <jejb@linux.vnet.ibm.com>; Martin K. Petersen
> <martin.petersen@oracle.com>; esc.storagedev
> <esc.storagedev@microsemi.com>; open list:HEWLETT-PACKARD SMART ARRAY
> RAID DRIVER (hpsa) <linux-scsi@vger.kernel.org>; open list <linux-
> kernel@vger.kernel.org>
> Subject: Re: [PATCH V3 2/2] scsi: hpsa: drop shutdown callback
> 
> EXTERNAL EMAIL
> 
> 
> On 05/28/2018 02:21 PM, Sinan Kaya wrote:
> > 'Commit cc27b735ad3a ("PCI/portdrv: Turn off PCIe services during
> > shutdown")' has been added to kernel to shutdown pending PCIe port
> > service interrupts during reboot so that a newly started kexec kernel
> > wouldn't observe pending interrupts.
> >
> > pcie_port_device_remove() is disabling the root port and switches by
> > calling pci_disable_device() after all PCIe service drivers are shutdown.
> >
> > This has been found to cause crashes on HP DL360 Gen9 machines during
> > reboot due to hpsa driver not clearing the bus master bit during the
> > shutdown procedure by calling pci_disable_device().
> >
> > Drop the shutdown API and do an orderly clean up by using the remove.
> >
> > Signed-off-by: Sinan Kaya <okaya@codeaurora.org>
> > Link: https://bugzilla.kernel.org/show_bug.cgi?id=199779
> > Fixes: cc27b735ad3a ("PCI/portdrv: Turn off PCIe services during shutdown")
> > Cc: stable@vger.kernel.org
> > Reported-by: Ryan Finnie <ryan@finnie.org>
> 
> Tested successfully on DL360 Gen9 and DL380 Gen9.
> 
> Tested-by: Ryan Finnie <ryan@finnie.org>

The shutdown path issues a cache flush to the controller.
Without this flush, you will see "Dirty Cache" messages at POST.
It is best to keep the shutdown path.

Thanks,
Don Brace
ESC - Smart Storage
Microsemi Corporation
