From: Nigel Cunningham <ncunningham@linuxmail.org>
Subject: Re: [PATCH] SCSI midlayer power management
Date: Thu, 12 Aug 2004 08:16:42 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1092262602.3553.14.camel@laptop.cunninghams>
References: <4119611D.60401@optonline.net>
	 <20040811080935.GA26098@elf.ucw.cz>  <411A1B72.1010302@optonline.net>
Reply-To: ncunningham@linuxmail.org
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tpgi.com.au ([203.12.160.113]:15302 "EHLO mail.tpgi.com.au")
	by vger.kernel.org with ESMTP id S268274AbUHKWUK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Aug 2004 18:20:10 -0400
In-Reply-To: <411A1B72.1010302@optonline.net>
List-Id: linux-scsi@vger.kernel.org
To: Nathan Bryant <nbryant@optonline.net>
Cc: Pavel Machek <pavel@ucw.cz>, 'James Bottomley' <James.Bottomley@steeleye.com>, Linux SCSI Reflector <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jgarzik@pobox.com

Hi.

On Wed, 2004-08-11 at 23:13, Nathan Bryant wrote:
> >>ACPI S1 and S4/swsusp are untested, but I think there should be no
> >>regressions with S1. To do S1 properly, we probably need to tell the
> >>drive to spin down, and I don't know what the SCSI command is for
> >>that... For S4, the call to scsi_device_quiesce might pose a problem for
> >>the subsequent state dump to disk. But I'm not sure swsusp ever worked
> >>for SCSI.

I tried it on an OSDL machine and could suspend (suspend 2), but only
resume as far as copying back the original kernel. The problem then
looked to me like it was request ids not matching what the drive was
expecting (but I'm ignorant of scsi, so might be completely wrong
there).

> answer is NO. For purposes of not suspending the drivers, I haven't 
> looked into how swsusp would see which host adapter owns which drive, 
> but some of the required information seems to be present in sysfs.

With my 'device tree' code, I'm getting the struct dev of the device
we're using via the struct block_device in the swap_info struct.

Nigel
-- 
Nigel Cunningham
Christian Reformed Church of Tuggeranong
PO Box 1004, Tuggeranong, ACT 2901

Many today claim to be tolerant. But true tolerance can cope with others
being intolerant.

