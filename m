From: Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH] PCI: add quirk for 3ware 9650SE controller
Date: Thu, 31 Oct 2013 15:27:58 -0600
Message-ID: <CAErSpo7qORQjs62zdi-5et2WnWwy3weMs56G84rWhNrW59F5WQ@mail.gmail.com>
References: <alpine.LNX.2.00.1308271141080.2077@pobox.suse.cz>
 <alpine.LNX.2.00.1308271144420.2077@pobox.suse.cz> <alpine.LNX.2.00.1308281745460.4557@pobox.suse.cz>
 <CAErSpo6saRNMw6Js0PLXZzYDdH0M3ypSFLDxVxp0G02aetp0Dw@mail.gmail.com>
 <alpine.LNX.2.00.1309061150140.26934@pobox.suse.cz> <CAErSpo5ExXsbSd+jYP5JYwq-RBf-dx1T_AZx6CV4=6-AfTTynQ@mail.gmail.com>
 <alpine.LNX.2.00.1309271106090.18703@pobox.suse.cz> <alpine.LNX.2.00.1310301125400.19090@pobox.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1310301125400.19090@pobox.suse.cz>
Sender: linux-pci-owner@vger.kernel.org
To: Jiri Kosina <jkosina@suse.cz>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Jesse Barnes <jbarnes@virtuousgeek.org>, Adam Radford <aradford@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Oct 30, 2013 at 4:27 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> Attached is dmesg output leading to timeouts (that are cured by my
> original patch in this thread) and lspci.

I opened https://bugzilla.kernel.org/show_bug.cgi?id=64141 for this
issue and attached your dmesg log and lspci output.

> Please let me know if there is anything else I could do, or if you are
> going to proceed with my patch adding the quirk.

Your quirk keeps us from disabling MSIs on the device during
enumeration.  But even if the BIOS left MSIs enabled, there's nothing
to field the MSI until after the driver claims the device.  So I don't
believe this has to be done as a quirk.  It should work just as well
to do something in the driver when it claims the device.

I guess another way to say this is that I don't think we understand
what the real problem is, and if we just add a quirk to work around
it, we might miss the chance to fix the real problem, and we may never
be able to remove the special-case code we're adding in the generic
path.

I know you said you tried doing something in the driver, and it didn't
work.  I don't know exactly what you tried, but twa_probe() looks
strange to me.  The other drivers I looked at do all their PCI
initialization before the scsi_host_alloc() / scsi_add_host() /
scsi_scan_host() stuff.  But twa_probe() has PCI stuff scattered
around between those three SCSI calls.  In particular, it does the MSI
setup way down near the end, after scsi_add_host(), which seems like
just the sort of thing that could explain this problem.

Bjorn
