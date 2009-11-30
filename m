From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 2nd try] PCI legacy I/O port free driver - Making
 MegaRAID SAS driver
Date: Mon, 30 Nov 2009 15:49:42 -0500
Message-ID: <1259614182.11762.5.camel@mulgrave.site>
References: <4AD52367.7050500@np.css.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:60862 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751793AbZK3Utm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Nov 2009 15:49:42 -0500
In-Reply-To: <4AD52367.7050500@np.css.fujitsu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Noriyuki Fujii <n-fujii@np.css.fujitsu.com>
Cc: megaraidlinux@lsi.com, linux-scsi@vger.kernel.org

On Wed, 2009-10-14 at 10:03 +0900, Noriyuki Fujii wrote:
> Hi,
> 
> Here's my 2nd try of the following post.
> 
> http://marc.info/?l=linux-scsi&m=124962265606425&w=2
> 
> I made a patch for MegaRAID sas driver to make PCI legacy I/O port free.
> 
> The way to make PCI legacy I/O port free is the same as Fusion-MPT
> driver's and it has been merged into 2.6.30.4.
> 
> This has already been fixed in e1000 and lpfc.
> 
> As a result of the above, the driver can handle its device even when
> there are a huge number of PCI devices being used on the system and no
> I/O port region assigned to the device.
> 
> I'm not in the linux-scsi mailing list.
> Please reply to the following address.

I need a Signed-off-by for this (see Documentation/SubmittingPatches).

>  E-Mail: n-fujii@np.css.fujitsu.com
> 
> Thanks,
> Noriyuki Fujii
> 
> plain text document attachment
> (linux-2.6-scsi-megaraid-sas-make-legacy-i-o-port-free.patch)
> --- megaraid_sasOrg.c	2009-07-02 16:31:17.000000000 +0900
> +++ megaraid_sasMod.c	2009-08-06 11:24:42.000000000 +0900
> @@ -2573,7 +2573,9 @@ static int megasas_init_mfi(struct megas
>  		instance->base_addr = pci_resource_start(instance->pdev, 0);
>  	}
>  
> -	if (pci_request_regions(instance->pdev, "megasas: LSI")) {
> +        if (pci_request_selected_regions(instance->pdev,

This is taking away a tab and substituting spaces ... our style is to
use tabs.  You can run the patch through scripts/checkpatch.pl and it
will advise on problems like this.

James


