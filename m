From: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH] PCI: add quirk for 3ware 9650SE controller
Date: Fri, 27 Sep 2013 11:08:51 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1309271106090.18703@pobox.suse.cz>
References: <alpine.LNX.2.00.1308271141080.2077@pobox.suse.cz> <alpine.LNX.2.00.1308271144420.2077@pobox.suse.cz> <alpine.LNX.2.00.1308281745460.4557@pobox.suse.cz> <CAErSpo6saRNMw6Js0PLXZzYDdH0M3ypSFLDxVxp0G02aetp0Dw@mail.gmail.com>
 <alpine.LNX.2.00.1309061150140.26934@pobox.suse.cz> <CAErSpo5ExXsbSd+jYP5JYwq-RBf-dx1T_AZx6CV4=6-AfTTynQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAErSpo5ExXsbSd+jYP5JYwq-RBf-dx1T_AZx6CV4=6-AfTTynQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Jesse Barnes <jbarnes@virtuousgeek.org>, Adam Radford <aradford@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 6 Sep 2013, Bjorn Helgaas wrote:

> >> >> > Commit d5dea7d95 ("PCI: msi: Disable msi interrupts when we initialize a
> >> >> > pci device") makes MSIs be forcibly disabled at boot time.
> >> >> >
> >> >> > It turns out that this breaks 3ware controller -- if MSIs are disabled
> >> >> > during PCI discovery of this controller, the device doesn't work properly
> >> >> > (it doesn't respond to any commands that are being sent to it after
> >> >> > initialization).
> 
> Is there a bug report for this issue?  

Yes, but unfortunately only in our internal bugzilla.

> It's nice to have a pointer to, e.g., a bugzilla.kernel.org bug report 
> with info such as dmesg logs, lspci output, etc., for future reference.  

It's a customer-reported issue, so I am gathering permission to make this 
information public (I don't think that'll be an issue).

I'll send up a followup afterwards.

> Maybe somebody will figure out a more generic change that could make 
> this quirk unnecessary, and details will help in figuring that out.
> 
> I assume the actual PCI discovery done in the PCI core works fine;
> it's just that the driver doesn't work if MSIs are disabled on the
> device.  If that's the case, can this be fixed by some driver change?
> Maybe the driver needs to enable MSI before it sends commands to the
> device?

I have tried it, but it still doesn't work. It seems like the device 
initialization is not finalized properly with MISs disabled; meaning the 
device is there (discovery has completed), but it "just doesn't work".

> Any description of what this failure looks like to a user?  How can a 
> user or a distro connect a symptom (driver timeout, console message, or 
> whatever) to this patch?

Will be hopefully part of the dmesg I will be providing later ... 
basically any commands sent to it time out.

Thanks,

-- 
Jiri Kosina
SUSE Labs
