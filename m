From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: Re: [PATCH v3] [SCSI] mpt2sas, mpt3sas: Abort initialization if no
 memory I/O resources detected
Date: Tue, 14 Jul 2015 23:24:56 -0700
Message-ID: <20150715062456.GB19028@dhcp-135-24-192-118.lsi.com>
References: <1436935796-28995-1-git-send-email-Sreekanth.Reddy@avagotech.com>
 <CAE9FiQWzbwzQ7mrtyumhMFYg0-8N18+KZhjfvMfs5j5eV0C5wA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAE9FiQWzbwzQ7mrtyumhMFYg0-8N18+KZhjfvMfs5j5eV0C5wA@mail.gmail.com>
Sender: linux-pci-owner@vger.kernel.org
To: Yinghai Lu <yinghai@kernel.org>
Cc: tpearson@raptorengineeringinc.com, James Bottomley <jejb@kernel.org>, martin.petersen@oracle.com, Linux-Scsi <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Sathya.Prakash@avagotech.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Bjorn Helgaas <bhelgaas@google.com>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jul 14, 2015 at 10:36:58PM -0700, Yinghai Lu wrote:
> On Tue, Jul 14, 2015 at 9:49 PM, Sreekanth Reddy
> <sreekanth.reddy@avagotech.com> wrote:
> > Driver crashes if the BIOS do not set up at least one
> > memory I/O resource. This failure can happen if the device is too
> > slow to respond during POST and is missed by the BIOS, but Linux
> > then detects the device later in the boot process.
> 
> But pci subsystem should assign resources to those unassigned BAR.
> 
> Do you mean even kernel can not assign resource to them? or it takes so long for
> mpt FW to get ready?

This is not an issue from mpt FW.

I have just kept the same description provide by Timothy in his
initial patch.

But I observe that their may be chance of getting "unable to handle
kernel NULL pointer dereference" kernel panic if no Memory Resource
available in the PCI subsystem. So agreed to the Timothy proposal of
aborting the driver initialization if it doesn't detect any Memory
resource instead of whole system get into panic state.

> 
> Thanks
> 
> Yinghai
