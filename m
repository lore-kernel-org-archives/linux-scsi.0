From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: Re: How to get the number of VFs assigned to the guests in XEN
Date: Wed, 20 Aug 2014 19:14:25 +0530
Message-ID: <CAK=zhgrFV10k0yzOrkSnmYJge3M+kQrcNz9e5qZZ5q180NY2xQ@mail.gmail.com>
References: <CAK=zhgrv=e20s11v7Ls5ioWZrbyvp9Rzyv+QRDLR3mffr9E61A@mail.gmail.com>
	<1408538771.11383.33.camel@ul30vt.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1408538771.11383.33.camel@ul30vt.home>
Sender: linux-kernel-owner@vger.kernel.org
To: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, konrad.wilk@oracle.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, boris.ostrovsky@oracle.com, Sathya Prakash <sathya.prakash@avagotech.com>, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>
List-Id: linux-scsi@vger.kernel.org

Thanks Alex,

Then, Is there any other ways to stop accidental unload of PF driver
while still some VFs are accessing by the running VMs.

Regards,
Sreekanth

On Wed, Aug 20, 2014 at 6:16 PM, Alex Williamson
<alex.williamson@redhat.com> wrote:
> On Wed, 2014-08-20 at 16:39 +0530, Sreekanth Reddy wrote:
>> HI,
>>
>> For SRIOV support, currently in the KVM environment, mpt3sas driver
>> can use the API pci_vfs_assigned() to know the number of VFs that are
>> currently assigned to the running VMs. So that during the PF driver
>> unload time, if the return value of this API is greater than zero the
>> our driver won't call the pci_disable_sriov() to disable the VFs.
>>
>> Now for the same purpose in XEN environment, is there any API similar
>> to pci_vfs_assigned() which the low lever device driver can use to
>> know 'the number of VFs that are currently assigned to the running
>> VMs'. In XEN environment this API pci_vfs_assigned() will return
>> always zero even though VFs are assigned to the running VMs.
>
> Note that pci_vfs_assigned() assigned is only used by legacy KVM device
> assignment and primarily as a workaround for not using an actual
> host-based device driver to manage device ownership.  When using
> VFIO-based device assignment with KVM, pci_vfs_assigned() is not
> updated.  Please don't rely on this interface.  Thanks,
>
> Alex
>
