From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] SCSI midlayer power management
Date: Wed, 11 Aug 2004 10:09:36 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040811080935.GA26098@elf.ucw.cz>
References: <4119611D.60401@optonline.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gprs214-124.eurotel.cz ([160.218.214.124]:10368 "EHLO
	amd.ucw.cz") by vger.kernel.org with ESMTP id S267984AbUHKINF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Aug 2004 04:13:05 -0400
Content-Disposition: inline
In-Reply-To: <4119611D.60401@optonline.net>
List-Id: linux-scsi@vger.kernel.org
To: Nathan Bryant <nbryant@optonline.net>
Cc: 'James Bottomley' <James.Bottomley@steeleye.com>, Linux SCSI Reflector <linux-scsi@vger.kernel.org>, Linux Kernel list <linux-kernel@vger.kernel.org>, jgarzik@pobox.com

Hi!

> This proposed patch implements enough power-management support within
> the SCSI midlayer to get ACPI S3 working on my system. Changes as follows:
> 
> * Add generic_scsi_{suspend,resume} methods to scsi.c
> * Add suspend and resume callbacks to the scsi_driver structure, and
> implement those callbacks in sd.c
> * In sd.c, we call sd_shutdown on suspend, in order to synchronize the
> write-back cache.
> * In sd.c, we call sd_rescan from sd_resume in order to ensure that
> drives have spun up and avoid passing not ready errors back to the block
> layer.
> * In generic_scsi_suspend, we call scsi_device_quiesce before calling
> the scsi_driver suspend callback. We resume from quiesce state in
> reverse order in generic_scsi_resume.
> 
> ACPI S1 and S4/swsusp are untested, but I think there should be no
> regressions with S1. To do S1 properly, we probably need to tell the
> drive to spin down, and I don't know what the SCSI command is for
> that... For S4, the call to scsi_device_quiesce might pose a problem for
> the subsequent state dump to disk. But I'm not sure swsusp ever worked
> for SCSI.

swsusp will then resume disk and write the image, that should not be a
problem. Is it guaranteed that after generic_scsi_suspend() no DMA is
going on?

Anyway, you should try swsusp, preferably on some IDE notebook first
and prefereably -mm one, to get feel how it works. It should be
possible/easy to make it work with SCSI...

> This might help SATA drives, too, but I seem to remember that the SATA
> layer doesn't properly emulate the SYNCHRONIZE_CACHE command.
> 
> Comments, anybody? Can this be applied upstream? I think it's a step in
> the right direction.

Looks good to me.
								Pavel
-- 
People were complaining that M$ turns users into beta-testers...
...jr ghea gurz vagb qrirybcref, naq gurl frrz gb yvxr vg gung jnl!
