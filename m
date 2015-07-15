From: Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v3] [SCSI] mpt2sas, mpt3sas: Abort initialization if no
 memory I/O resources detected
Date: Wed, 15 Jul 2015 09:59:01 -0500
Message-ID: <20150715145901.GU24416@google.com>
References: <1436935796-28995-1-git-send-email-Sreekanth.Reddy@avagotech.com>
 <CAE9FiQWzbwzQ7mrtyumhMFYg0-8N18+KZhjfvMfs5j5eV0C5wA@mail.gmail.com>
 <20150715062456.GB19028@dhcp-135-24-192-118.lsi.com>
 <55A6658D.6030802@raptorengineeringinc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55A6658D.6030802@raptorengineeringinc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Timothy Pearson <tpearson@raptorengineeringinc.com>
Cc: Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Yinghai Lu <yinghai@kernel.org>, James Bottomley <jejb@kernel.org>, martin.petersen@oracle.com, Linux-Scsi <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Sathya.Prakash@avagotech.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 15, 2015 at 08:52:13AM -0500, Timothy Pearson wrote:
> On 07/15/2015 01:24 AM, Sreekanth Reddy wrote:
> > On Tue, Jul 14, 2015 at 10:36:58PM -0700, Yinghai Lu wrote:
> >> On Tue, Jul 14, 2015 at 9:49 PM, Sreekanth Reddy
> >> <sreekanth.reddy@avagotech.com> wrote:
> >>> Driver crashes if the BIOS do not set up at least one
> >>> memory I/O resource. This failure can happen if the device is too
> >>> slow to respond during POST and is missed by the BIOS, but Linux
> >>> then detects the device later in the boot process.
> >>
> >> But pci subsystem should assign resources to those unassigned BAR.
> >>
> >> Do you mean even kernel can not assign resource to them? or it takes so long for
> >> mpt FW to get ready?
> > 
> > This is not an issue from mpt FW.
> > 
> > I have just kept the same description provide by Timothy in his
> > initial patch.
> > 
> > But I observe that their may be chance of getting "unable to handle
> > kernel NULL pointer dereference" kernel panic if no Memory Resource
> > available in the PCI subsystem. So agreed to the Timothy proposal of
> > aborting the driver initialization if it doesn't detect any Memory
> > resource instead of whole system get into panic state.
> 
> On some systems Linux is unable / unwilling to assign a BAR if the BIOS
> does not assign one at startup.  I didn't look into the Linux allocator
> side of things in much detail, but it is quite possible that Linux is
> unaware the device only has partial resources assigned.

There might be a Linux PCI core bug if we don't assign a BAR, although
resource assignment can always fail, even in the absence of bugs.

But there is definitely a driver bug if it uses ioc->chip when it hasn't
been initialized.  That's what this patch seems to fix.

Bjorn
