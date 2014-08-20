From: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: How to get the number of VFs assigned to the guests in XEN
Date: Wed, 20 Aug 2014 08:09:58 -0600
Message-ID: <1408543798.11383.42.camel@ul30vt.home>
References: <CAK=zhgrv=e20s11v7Ls5ioWZrbyvp9Rzyv+QRDLR3mffr9E61A@mail.gmail.com>
	 <1408538771.11383.33.camel@ul30vt.home>
	 <CAK=zhgrFV10k0yzOrkSnmYJge3M+kQrcNz9e5qZZ5q180NY2xQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <CAK=zhgrFV10k0yzOrkSnmYJge3M+kQrcNz9e5qZZ5q180NY2xQ@mail.gmail.com>
Sender: linux-pci-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, konrad.wilk@oracle.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, boris.ostrovsky@oracle.com, Sathya Prakash <sathya.prakash@avagotech.com>, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2014-08-20 at 19:14 +0530, Sreekanth Reddy wrote:
> Thanks Alex,
> 
> Then, Is there any other ways to stop accidental unload of PF driver
> while still some VFs are accessing by the running VMs.

I believe the reason pci_vfs_assigned() and the pci_dev flag that backs
it exists is because legacy KVM device assignment does not require a
host driver for the device.  At best, the assigned device is bound to
pci-stub, which is more than happy to release a device at any point in
time.  This flag was therefore added to indicate that the device was in
use, please don't make it disappear.  With VFIO, the device is bound to
vfio-pci in the host which will only release the device when it is
unused, just like any other device driver.  If the device is in use,
either assigned to a VM or otherwise in use by a userspace driver,
vfio-pci will block until unused.

There are opportunities that we have yet to implement that we could
notify the user of the removal request, triggering a hot-unplug in a
guest.  Assuming some sort of revoke() functionality gets pushed
upstream we could also make an unplug request, wait from some time, then
revoke the device from the user.  The point however is that device
assignment shouldn't be handled as a special case.  When
pci_disable_sriov() is called, the release functions for any drivers
owning an affected VF should be called where we have the opportunity to
block until unused.  Thanks,

Alex

> On Wed, Aug 20, 2014 at 6:16 PM, Alex Williamson
> <alex.williamson@redhat.com> wrote:
> > On Wed, 2014-08-20 at 16:39 +0530, Sreekanth Reddy wrote:
> >> HI,
> >>
> >> For SRIOV support, currently in the KVM environment, mpt3sas driver
> >> can use the API pci_vfs_assigned() to know the number of VFs that are
> >> currently assigned to the running VMs. So that during the PF driver
> >> unload time, if the return value of this API is greater than zero the
> >> our driver won't call the pci_disable_sriov() to disable the VFs.
> >>
> >> Now for the same purpose in XEN environment, is there any API similar
> >> to pci_vfs_assigned() which the low lever device driver can use to
> >> know 'the number of VFs that are currently assigned to the running
> >> VMs'. In XEN environment this API pci_vfs_assigned() will return
> >> always zero even though VFs are assigned to the running VMs.
> >
> > Note that pci_vfs_assigned() assigned is only used by legacy KVM device
> > assignment and primarily as a workaround for not using an actual
> > host-based device driver to manage device ownership.  When using
> > VFIO-based device assignment with KVM, pci_vfs_assigned() is not
> > updated.  Please don't rely on this interface.  Thanks,
> >
> > Alex
> >
