From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: ses: enclosure_unregister oops
Date: Thu, 17 Dec 2009 00:22:52 +0100
Message-ID: <1261005772.14435.164.camel@mulgrave.site>
References: <4565AEA676113A449269C2F3A549520F04362D9F@cosmail03.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:49507 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935277AbZLPXXB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Dec 2009 18:23:01 -0500
In-Reply-To: <4565AEA676113A449269C2F3A549520F04362D9F@cosmail03.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, 2009-12-16 at 15:44 -0700, Moore, Eric wrote:
> James -  Is there a way to turn of the enclosure services from the
> SCSI LLD, command line option, or some other method that doesn't
> require recompiling the kernel? 

Assuming you built it as a module, then just remove the module.  If
you're using a monolithic kernel, there's no real way to influence the
ULD binding apart from by disabling it.

>   The oops we are getting occurs on SLES11(2.6.27) when pulling the
> cable on certain enclosures.   I see this with a HP and Xyratex
> enclosure.  I don't see it on Engineo enclosures.   On the enclosures
> where it hangs, there are no slot subfolders
> under /sys/class/enclosure.
> 
> Apparently you have fixed this issue with the patch's that went into 2.6.32, e.g. 
> 
>       ses: update enclosure data on hot add
> 		http://marc.info/?l=linux-scsi&m=124908744713234&w=2
>       ses: add support for enclosure component hot removal 
> 		http://marc.info/?l=linux-scsi&m=124908728913082&w=2
>       ses: fix hotplug with multiple devices and expanders
> 		http://marc.info/?l=linux-scsi&m=124908718512951&w=2
> 
> Here is the sg_ses output
> 
> (1) Xyratex; FAILS
> 
>   XYRATEX   RS1603-SAS-01     0605
>     enclosure services device
> Supported diagnostic pages:
>   Supported diagnostic pages [0x0]
>   Configuration (SES) [0x1]
>   Enclosure status/control (SES) [0x2]
>   String In/Out (SES) [0x4]
>   Threshold In/Out (SES) [0x5]
>   Element descriptor (SES) [0x7]
>   Additional element status (SES-2) [0xa]
>   <unknown> [0x80]
>   <unknown> [0x81]
>   <unknown> [0x84]
>   <unknown> [0x85]
>   <unknown> [0x88]
>   <unknown> [0x89]
> 
> (2)  HP: FAILS
> 
>   HP        D2700 SAS AJ941A  0038
>     enclosure services device
> Supported diagnostic pages:
>   Supported diagnostic pages [0x0]
>   Configuration (SES) [0x1]
>   Enclosure status/control (SES) [0x2]
>   Threshold In/Out (SES) [0x5]
>   Element descriptor (SES) [0x7]
>   Additional element status (SES-2) [0xa]
>   Supported SES diagnostic pages (SES-2) [0xd]
>   <unknown> [0x11]
> 
> (3) Engineo: WORKS
> 
>   LSI  DE5300-SAS  0216
>     enclosure services device
> Supported diagnostic pages:
>   Supported diagnostic pages [0x0]
>   Configuration (SES) [0x1]
>   Enclosure status/control (SES) [0x2]
>   String In/Out (SES) [0x4]
>   Element descriptor (SES) [0x7]
>   Additional element status (SES-2) [0xa]
> 
> 
> The backtrace below is from enclosure_unregister, seems its deleting a NULL pointer from device_pm_remove.   
> 
> 
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000008

So if you're sure it's fixed, what happens when you try with a current
kernel?

James


