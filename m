From: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH] PCI: add quirk for 3ware 9650SE controller
Date: Tue, 5 Nov 2013 14:06:30 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1311051402500.2779@pobox.suse.cz>
References: <alpine.LNX.2.00.1308271141080.2077@pobox.suse.cz> <alpine.LNX.2.00.1308271144420.2077@pobox.suse.cz> <alpine.LNX.2.00.1308281745460.4557@pobox.suse.cz> <CAErSpo6saRNMw6Js0PLXZzYDdH0M3ypSFLDxVxp0G02aetp0Dw@mail.gmail.com>
 <alpine.LNX.2.00.1309061150140.26934@pobox.suse.cz> <CAErSpo5ExXsbSd+jYP5JYwq-RBf-dx1T_AZx6CV4=6-AfTTynQ@mail.gmail.com> <alpine.LNX.2.00.1309271106090.18703@pobox.suse.cz> <alpine.LNX.2.00.1310301125400.19090@pobox.suse.cz>
 <CAErSpo7qORQjs62zdi-5et2WnWwy3weMs56G84rWhNrW59F5WQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <CAErSpo7qORQjs62zdi-5et2WnWwy3weMs56G84rWhNrW59F5WQ@mail.gmail.com>
Sender: linux-pci-owner@vger.kernel.org
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Jesse Barnes <jbarnes@virtuousgeek.org>, Adam Radford <aradford@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 31 Oct 2013, Bjorn Helgaas wrote:

> > Attached is dmesg output leading to timeouts (that are cured by my
> > original patch in this thread) and lspci.
> 
> I opened https://bugzilla.kernel.org/show_bug.cgi?id=64141 for this
> issue and attached your dmesg log and lspci output.
> 
> > Please let me know if there is anything else I could do, or if you are
> > going to proceed with my patch adding the quirk.
> 
> Your quirk keeps us from disabling MSIs on the device during
> enumeration.  But even if the BIOS left MSIs enabled, there's nothing
> to field the MSI until after the driver claims the device.  So I don't
> believe this has to be done as a quirk.  It should work just as well
> to do something in the driver when it claims the device.
> 
> I guess another way to say this is that I don't think we understand
> what the real problem is, and if we just add a quirk to work around
> it, we might miss the chance to fix the real problem, and we may never
> be able to remove the special-case code we're adding in the generic
> path.
> 
> I know you said you tried doing something in the driver, and it didn't
> work.  I don't know exactly what you tried, but twa_probe() looks
> strange to me.  The other drivers I looked at do all their PCI
> initialization before the scsi_host_alloc() / scsi_add_host() /
> scsi_scan_host() stuff.  But twa_probe() has PCI stuff scattered
> around between those three SCSI calls.  In particular, it does the MSI
> setup way down near the end, after scsi_add_host(), which seems like
> just the sort of thing that could explain this problem.

What I tried was patch below, but it didn't have any observable effect -- 
the commands sent to the controller would still time out the same way.

Debugging this is not really straightforward for me unfortunately, as I 
don't own the system myself.

I agree that we don't fully understand what is happening, but the quirk 
was the only way I have been able to come up with to make the device 
functioning again (apart from reverting d5dea7d95).

Any other ideas are welcome.

---
 drivers/scsi/3w-9xxx.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index ba754c3..bad7faf 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -2055,6 +2055,11 @@ static int __devinit twa_probe(struct pci_dev *pdev, const struct pci_device_id
 			goto out_disable_device;
 		}
 
+	/* Try to enable MSI */
+	if (use_msi && (pdev->device != PCI_DEVICE_ID_3WARE_9000) &&
+	    !pci_enable_msi(pdev))
+		set_bit(TW_USING_MSI, &tw_dev->flags);
+
 	host = scsi_host_alloc(&driver_template, sizeof(TW_Device_Extension));
 	if (!host) {
 		TW_PRINTK(host, TW_DRIVER, 0x24, "Failed to allocate memory for device extension");
@@ -2134,11 +2139,6 @@ static int __devinit twa_probe(struct pci_dev *pdev, const struct pci_device_id
 	       le32_to_cpu(*(int *)twa_get_param(tw_dev, 2, TW_INFORMATION_TABLE,
 				     TW_PARAM_PORTCOUNT, TW_PARAM_PORTCOUNT_LENGTH)));
 
-	/* Try to enable MSI */
-	if (use_msi && (pdev->device != PCI_DEVICE_ID_3WARE_9000) &&
-	    !pci_enable_msi(pdev))
-		set_bit(TW_USING_MSI, &tw_dev->flags);
-
 	/* Now setup the interrupt handler */
 	retval = request_irq(pdev->irq, twa_interrupt, IRQF_SHARED, "3w-9xxx", tw_dev);
 	if (retval) {


-- 
Jiri Kosina
SUSE Labs
