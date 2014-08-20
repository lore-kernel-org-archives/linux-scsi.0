From: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: How to get the number of VFs assigned to the guests in XEN
Date: Wed, 20 Aug 2014 06:46:11 -0600
Message-ID: <1408538771.11383.33.camel@ul30vt.home>
References: <CAK=zhgrv=e20s11v7Ls5ioWZrbyvp9Rzyv+QRDLR3mffr9E61A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45745 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754386AbaHTMqT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Aug 2014 08:46:19 -0400
In-Reply-To: <CAK=zhgrv=e20s11v7Ls5ioWZrbyvp9Rzyv+QRDLR3mffr9E61A@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, konrad.wilk@oracle.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, boris.ostrovsky@oracle.com, Sathya Prakash <sathya.prakash@avagotech.com>, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>

On Wed, 2014-08-20 at 16:39 +0530, Sreekanth Reddy wrote:
> HI,
> 
> For SRIOV support, currently in the KVM environment, mpt3sas driver
> can use the API pci_vfs_assigned() to know the number of VFs that are
> currently assigned to the running VMs. So that during the PF driver
> unload time, if the return value of this API is greater than zero the
> our driver won't call the pci_disable_sriov() to disable the VFs.
> 
> Now for the same purpose in XEN environment, is there any API similar
> to pci_vfs_assigned() which the low lever device driver can use to
> know 'the number of VFs that are currently assigned to the running
> VMs'. In XEN environment this API pci_vfs_assigned() will return
> always zero even though VFs are assigned to the running VMs.

Note that pci_vfs_assigned() assigned is only used by legacy KVM device
assignment and primarily as a workaround for not using an actual
host-based device driver to manage device ownership.  When using
VFIO-based device assignment with KVM, pci_vfs_assigned() is not
updated.  Please don't rely on this interface.  Thanks,

Alex

