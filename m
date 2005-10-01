From: "Moore, Eric Moore" <Eric.Moore@lsil.com>
Subject: Re: mpt fusion driver performance issue in 2.6.14-rc2
Date: Sat, 1 Oct 2005 00:19:56 -0600
Message-ID: <001a01c5c650$25719050$1b1015ac@ericmoore>
References: <200510010027.j910Rhg30932@unix-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:27286 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1750735AbVJAGUC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Oct 2005 02:20:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Chen, Kenneth W" <kenneth.w.chen@intel.com>, linux-scsi@vger.kernel.org
Cc: 'James Bottomley' <James.Bottomley@SteelEye.com>

On Friday, September 30, 2005 6:27 PM, Chen, Kenneth W wrote:
> Chen, Kenneth W  wrote on Thursday, September 29, 2005 11:59 AM
>> Something happened in between kernel 2.6.12 and 2.6.14-rc2, where
>> disk performance went 20X slower on the latest release kernel. I
>> suspect it has something to do with the fusion driver. This showed
>> up in the boot log: "mptscsih: ioc0: DV: Release failed." is it
>> significant?
>
> I think the bug is for real, and it is in the mpt fusion driver.  I'm
> not an expert of LSI53C1030 host controller, and I won't pretend to be
> one. Though I have data to show what is going on:
>
> There are two threads during driver initialization.  One does domain
> validation (mptscsih_domainValidation) and one does host controller
> initialization (mptspi_probe).  During 2nd host controller bringup,
> i.e., bringing up ioc1, it temporary disables first channel (ioc0).
> However, DV is in progress on ioc0 in another thread (and possibly
> running on another CPU).  The effect of disabling ioc0 during in-
> progress-domain-validation is that it causes all subsequent DV
> commands to fail and resulting lowest possible performance setting
> for almost all disks pending DV.
>
> Here is a fix that I propose: for the period that ioc0 need to be
> disabled for bringing up ioc1, ioc->active is marked with a special
> flag and have DV thread busy wait on that flag.  This avoid mptspi_probe
> thread clash into the DV thread causing brain-damage to DV.
>
> With the patch, all disks are up to the performance expectation and it
> also fixed the "mptscsih: ioc0: DV: Release failed" error message.
>

Thanks for you findings into this.

I'm moving across town, and will not be in the office, nor have
internet access for the next couple days.  I will look into this when I 
return.

Best regards,
Eric Moore


