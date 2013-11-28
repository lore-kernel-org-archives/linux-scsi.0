From: "George Spelvin" <linux@horizon.com>
Subject: Re: [mptscsih] Watchdog detected hard LOCKUP on cpu 0
Date: 28 Nov 2013 05:06:16 -0500
Message-ID: <20131128100616.640.qmail@science.horizon.com>
References: <1385380914.2354.38.camel@dabdike>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from science.horizon.com ([71.41.210.146]:54377 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750741Ab3K1KGU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Nov 2013 05:06:20 -0500
In-Reply-To: <1385380914.2354.38.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux@horizon.com
Cc: DL-MPTFusionLinux@lsi.com, kashyap.desai@lsi.com, linux-scsi@vger.kernel.org, Nagalakshmi.Nandigama@lsi.com

> The reason for the lack of replies is that no-one has much of an idea.
> This really looks like a hardware problem.  The qi_submit_sync() is
> suggestive: it's the intel IOMMU mapping call ... have you tried
> reproducing this with the iommu disabled?

I turned off VT-d, and the problem went away.
I turned on VT-d, and turned off all of the sub-options:
	Interrupt remapping
	Coherency
	ATS support
	Pass-through DMA
and the problem remained.

So them I did a hail mary, and upgraded my GA-X79-UP4 from the F2 BIOS
to the beta F5c BIOS.

VT-d and all of the sub-features are turned on, and I'm on my 6th full
read pass over the entire RAID array (when it would crash before 15%
before), with no problem.

Hardware problem, indeed.

Thanks for the pointer; I wouldn't have thought of trying a BIOS
upgrade without it.
