From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Possible bug in SCSI Kconfig
Date: Wed, 22 Oct 2008 20:35:25 +0200
Message-ID: <48FF726D.9060504@s5r6.in-berlin.de>
References: <b637ec0b0810220929r2c889423ma92bef0ec7f9b3b0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:53856 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbYJVSgf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Oct 2008 14:36:35 -0400
In-Reply-To: <b637ec0b0810220929r2c889423ma92bef0ec7f9b3b0@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fabio Comolli <fabio.comolli@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, sam@ravnborg.org, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>

(adding Cc: LSML and author)

On 10/22/2008, Fabio Comolli wrote at LKML:
> Hi.
> In kernel 2.6.27.2 - drivers/scsi/Kconfig we have:
> 
> config SCSI_WAIT_SCAN
>         tristate
>         default m
>         depends on SCSI
>         depends on MODULES
> 
> The tristate field is empty. This has the effect that this option is
> not visible in menuconfig and so it's always selected. The default is
> "m" for all architectures and so this module is always compiled if
> SCSI and MODULES are both enabled.
> 
> I'm using a patch like this one:
> 
>  config SCSI_WAIT_SCAN
> -	tristate
> +	tristate "Wait until all the async scans are complete"
>  	default m
>  	depends on SCSI
>  	depends on MODULES
> 
> to get rid of that module.
> 
> Of course, I have no idea if this is correct or the current behavior
> is the expected one.
> 
> Regards,
> Fabio

What's the correct behaviour is contentious.  There have been complaints
that it shouldn't be built if it is not needed.  However, how it
currently works is how those who added and merged that feature thought
that it should be.

Notes on your suggestion:

  - If you make it a visible prompt, you should also add a help text.
    No Kconfig prompts without good help text, please!

  - The suggested prompt text doesn't describe the matter too well.
    scsi_wait_scan rather is a module which userland can use to get
    a signal for when scans (by some but not all transports) are done.
    (The signal is the end of module initialization of the
    scsi_wait_scan module.)  I.e. the kernel as a whole doesn't
    necessarily wait, just this module does.

You could use the comment in drivers/scsi/scsi_wait_scan.c and the
changelog of
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=3e082a910d217b2e7b186077ebf5a1126a68c62f
as a basis for the Kconfig help text.  You could actually add a help
text even to invisible prompts, just for documentation purposes.
-- 
Stefan Richter
-=====-==--- =-=- =-==-
http://arcgraph.de/sr/
