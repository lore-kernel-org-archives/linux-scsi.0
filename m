From: Arvind Kumar <arvindkumar@vmware.com>
Subject: Re: DMA-API mapping errors in vmw_pvscsi
Date: Mon, 17 Mar 2014 13:56:55 -0700 (PDT)
Message-ID: <325692752.47738484.1395089815603.JavaMail.root@vmware.com>
References: <CA+5PVA5CmTJSjaikwtTTLwp1dLwFkYpXVr56ASA4t5n8ESRmOA@mail.gmail.com> <1395076090.2227.29.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1395076090.2227.29.camel@dabdike.int.hansenpartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: VMware PV-Drivers <pv-drivers@vmware.com>, linux-scsi@vger.kernel.org, "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>, Josh Boyer <jwboyer@fedoraproject.org>
List-Id: linux-scsi@vger.kernel.org

>It's missing checking in two places: from pci_map_single() and on
>scsi_dma_map().  In the latter case, pvscsi_map_buffers needs to return
>an error code and then pvscsi_queue_ring can return -1.

Agreed! And in addition to that pvscsi_queue_ring() also calls pci_map_single()
to map the sense buffer, which should also have the check. And if 
pvscsi_map_buffers() fails then we need to unmap the sense buffer too.

We already have an internal bug filed and we are working on this.

Thanks!
Arvind

----- Original Message -----
From: "James Bottomley" Bottomley@HansenPartnership.com>
To: "Josh Boyer" <jwboyer@fedoraproject.org>
Cc: "Arvind Kumar" <arvindkumar@vmware.com>, "VMware PV-Drivers" , linux-scsi@vger.kernel.org, "Linux-Kernel@Vger. Kernel. Org" vger.kernel.org>
Sent: Monday, March 17, 2014 10:08:10 AM
Subject: Re: DMA-API mapping errors in vmw_pvscsi

On Mon, 2014-03-17 at 12:52 -0400, Josh Boyer wrote:
> Hi All,
> 
> We've had a few reports[1][2] now on the vmw_pvscsi driver throwing
> DMA-API mapping errors when the DMA_API_DEBUG option is enabled.  I've
> included one from a recent 3.14-rc6 kernel below.  Looking at
> vmw_pvscsi.c, I can see pvscsi_map_buffers is missing the calls to
> pci_dma_mapping_error, which is what causes the warnings to be thrown.
> 
> However, I'm not familiar with this driver and I can't see what the
> proper error path should be in this case.  pvscsi_map_buffers is a
> void function and doesn't currently have the ability to return an
> error to the caller.  Even if it did, I'm not sure what the proper
> response to an error should be.  Thoughts?

It's missing checking in two places: from pci_map_single() and on
scsi_dma_map().  In the latter case, pvscsi_map_buffers needs to return
an error code and then pvscsi_queue_ring can return -1.

James
