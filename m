From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] drivers/ata/ahci build break.
Date: Fri, 9 Oct 2009 00:46:39 -0600
Message-ID: <20091009064638.GA27673@parisc-linux.org>
References: <4ACED7E2.2010108@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:38873 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754663AbZJIGrQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Oct 2009 02:47:16 -0400
Content-Disposition: inline
In-Reply-To: <4ACED7E2.2010108@in.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sachin Sant <sachinp@in.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Tejun Heo <tj@kernel.org>

On Fri, Oct 09, 2009 at 11:57:46AM +0530, Sachin Sant wrote:
> @@ -2884,6 +2884,7 @@ static bool ahci_broken_online(struct pc
>  	return pdev->bus->number == (val >> 8) && pdev->devfn == (val & 0xff);
>  }
>  
> +#ifdef CONFIG_ATA_ACPI
>  static void ahci_gtf_filter_workaround(struct ata_host *host)
>  {
>  	static const struct dmi_system_id sysids[] = {
> @@ -2927,6 +2928,7 @@ static void ahci_gtf_filter_workaround(s
>  				dev->gtf_filter |= filter;
>  	}
>  }
> +#endif
>  
>  static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  {
> @@ -3093,8 +3095,10 @@ static int ahci_init_one(struct pci_dev
>  	/* apply workaround for ASUS P5W DH Deluxe mainboard */
>  	ahci_p5wdh_workaround(host);
>  
> +#ifdef CONFIG_ATA_ACPI
>  	/* apply gtf filter quirk */
>  	ahci_gtf_filter_workaround(host);
> +#endif

The usual way to do this is to make sure there's a dummy
ahci_gtf_filter_workaround so there doesn't have to be that ifdef in
the caller.  This is probably easier to do like this:

@@ -2884,6 +2884,7 @@ static bool ahci_broken_online(struct pc
 	return pdev->bus->number == (val >> 8) && pdev->devfn == (val & 0xff);
 }
 
 static void ahci_gtf_filter_workaround(struct ata_host *host)
 {
+#ifdef CONFIG_ATA_ACPI
 	static const struct dmi_system_id sysids[] = {
@@ -2927,6 +2928,7 @@ static void ahci_gtf_filter_workaround(s
 				dev->gtf_filter |= filter;
 	}
+#endif
 }
 
 static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
