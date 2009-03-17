From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: SES firmward download to SAS expander
Date: Mon, 16 Mar 2009 23:49:07 -0400
Message-ID: <49BF1DB3.7090705@interlog.com>
References: <CCC151398C6F2B41AD8ACC06C28A779106775B32@penmsg10.corp.jabil.org>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:52256 "EHLO
	elrond2.infotech.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbZCQDtS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Mar 2009 23:49:18 -0400
In-Reply-To: <CCC151398C6F2B41AD8ACC06C28A779106775B32@penmsg10.corp.jabil.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian May <Adrian_May@Jabil.com>
Cc: linux-scsi@vger.kernel.org

Adrian May wrote:
> Hi all,
> 
> Some folks are asking me to advise about downloading firmware to some
> SAS expander. They had this conversation with the box:
> 
> #sg_ses -s /dev/sg5
> ...
> Download microcode (SES-2) [0xe]
> ...
> #sg_ses --control --page=0xe --data=- /dev/sg5 < image.bin
>   PMCSIERA  SXP 36x6Gsec      RevB

Looks like an interesting device: a 36 port 6Gbps SAS
expander that talks SES (as well as SMP I assume)?

>     enclosure services device
> Setting SES control page 0xe not supported yet
> 
> What I'm trying to figure out is WHO doesn't support it: the driver or
> the hardware?

ME, the guy who wrote sg_ses. That utility is 5 years old
and this is the first time anyone has asked me about
firmware download capability.

  Is everything done by the generic linux driver or is there
> some vendor-specific driver somewhere in the picture?

The SCSI generic driver is there for devices that don't
already have a "class" driver. To date there has been
no class driver for SES devices but I think one is
being added. As for a vendor specific driver you might
ask PMC Sierra.

  And why would this
> diag page be listed if it doesn't work?

Would it be better if sg_ses said something like
"not implemented, feel free to send code"?

> Huge thanks in advance for any assistance,

What is the size of the firmware file? If it is
approaching 1 MB or more then that may be too big
for a single SCSI command. That would require the
firmware to be broken up into more digestible blobs.

If you look at ses2r20.pdf section 6.1.18 (and 6.1.19)
then you might agree with me that firmware download
is relatively complex.

Doug Gilbert
