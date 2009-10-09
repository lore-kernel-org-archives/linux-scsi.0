From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] drivers/ata/ahci build break.
Date: Fri, 09 Oct 2009 16:00:57 +0900
Message-ID: <4ACEDFA9.9080102@kernel.org>
References: <4ACED7E2.2010108@in.ibm.com> <20091009064638.GA27673@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:36497 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932326AbZJIHB4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Oct 2009 03:01:56 -0400
In-Reply-To: <20091009064638.GA27673@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Sachin Sant <sachinp@in.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@HansenPartnership.com>

Matthew Wilcox wrote:
> The usual way to do this is to make sure there's a dummy
> ahci_gtf_filter_workaround so there doesn't have to be that ifdef in
> the caller.  This is probably easier to do like this:
> 
> @@ -2884,6 +2884,7 @@ static bool ahci_broken_online(struct pc
>  	return pdev->bus->number == (val >> 8) && pdev->devfn == (val & 0xff);
>  }
>  
>  static void ahci_gtf_filter_workaround(struct ata_host *host)
>  {
> +#ifdef CONFIG_ATA_ACPI
>  	static const struct dmi_system_id sysids[] = {
> @@ -2927,6 +2928,7 @@ static void ahci_gtf_filter_workaround(s
>  				dev->gtf_filter |= filter;
>  	}
> +#endif
>  }

Fix is already included in Jeff's tree.

Thanks.

-- 
tejun
