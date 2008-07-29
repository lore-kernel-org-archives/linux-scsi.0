From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: Sample implementation of a scheme to handle missing interrupts
Date: Tue, 29 Jul 2008 17:38:26 -0600
Message-ID: <660360F4F2570145BD872F298951B17A3AC7E4BF@cosmail03.lsi.com>
References: <1217277901.3503.143.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:63348 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752069AbYG2Xig convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Jul 2008 19:38:36 -0400
In-Reply-To: <1217277901.3503.143.camel@localhost.localdomain>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Wilcox <matthew@wil.cx>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>

On Monday, July 28, 2008 2:45 PM, James Bottomley wrote:
> >
> > In my case, the MSI problem will manifest itself well before we bind
> > with the scsi midlayer.    Meaning when there is a MSI problem, we
> > can't even bring up the card.  Hence adding code in a eh_timed_out
> > callback handler would be meaningless in solving our problem. What I
> > need to do is find a problematic card, so I can verify some things.
>
> Actually, you don't need this.  I verified the behaviour of the MSI
> problem simply by commenting out the request_irq.  It looks
> like there's
> no simple way to simulate MSI misrouting, but perhaps I should look at
> that, since it would be useful.
>

Well today I found at FC929X where it fails when MSI enabled.   The problem is occuring at the end of mpt_do_ioc_recovery, after we enable interrupts, we are asking for random manufacturing config pages. I see it randomly timing out on the config pages, meaning some time GetLanConfigPages works, then other times it fails. Sometimes it fails later on for either GetIoUnitPage2 or mpt_get_manufacturing_pg_0.  So its randomly timing out on config pages, but most the time is the first one.   So did the following patch (hopefully its not butcherd by ccmail). What I'm doing is failling back to IOAPIC routing after we have a config page timeout.   This works scsi_misc tip with drives attached to both channels of the multifunction FC card.      I'm thinking we may still need do what Matt W. suggest
 ed just as I pointed, I see random timeouts with the config pages.  A side note, I found that pci_disable_msi() is not working in SLES10 SP2..    Did you have any other suggestion where this could be handled in a generic common method?


diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index d6a0074..e2804b2 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -1754,7 +1754,7 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)

        if (mpt_msi_enable == -1) {
                /* Enable on SAS, disable on FC and SPI */
-               if (ioc->bus_type == SAS)
+               if (ioc->bus_type == SAS || ioc->bus_type == FC)
                        ioc->msi_enable = 1;
                else
                        ioc->msi_enable = 0;
@@ -5927,6 +5927,25 @@ mpt_config(MPT_ADAPTER *ioc, CONFIGPARMS *pCfg)
        /* mf has been freed - do not access */

        rc = pCfg->status;
+       if ((rc == MPT_CONFIG_ERROR) && ioc->msi_enable) {
+               ioc->msi_enable = 0;
+               printk(MYIOC_s_ERR_FMT "free_irq\n", ioc->name);
+               free_irq(ioc->pci_irq, ioc);
+               printk(MYIOC_s_ERR_FMT "pci_disable_msi\n", ioc->name);
+               pci_disable_msi(ioc->pcidev);
+               printk(MYIOC_s_ERR_FMT "request_irq\n", ioc->name);
+               if (request_irq(ioc->pcidev->irq, mpt_interrupt, IRQF_SHARED,
+                   ioc->name, ioc) < 0) {
+                       printk(MYIOC_s_ERR_FMT "Unable to allocate "
+                           "interrupt %d!\n", ioc->name, ioc->pcidev->irq);
+                       return -EBUSY;
+               }
+               pci_set_master(ioc->pcidev);
+               pci_set_drvdata(ioc->pcidev, ioc);
+               ioc->pci_irq = ioc->pcidev->irq;
+               printk(MYIOC_s_INFO_FMT "PCI-MSI is being disabled\n",
+                   ioc->name);
+       }

        return rc;
 }
