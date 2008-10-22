From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Possible bug in SCSI Kconfig
Date: Wed, 22 Oct 2008 13:05:40 -0600
Message-ID: <1224702340.6851.20.camel@localhost.localdomain>
References: <b637ec0b0810220929r2c889423ma92bef0ec7f9b3b0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:48927 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753141AbYJVTLj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Oct 2008 15:11:39 -0400
In-Reply-To: <b637ec0b0810220929r2c889423ma92bef0ec7f9b3b0@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fabio Comolli <fabio.comolli@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, sam@ravnborg.org, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2008-10-22 at 18:29 +0200, Fabio Comolli wrote:
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

The point of all of this is that if you enable async scanning, you need
a method of waiting for the scans to complete, which is all this module
does (you insert it and it doesn't come back from the insertion until
all the pending async scans are complete).  It's tristate because really
it only makes sense to be M or N.  The consensus is that, given async
scanning is always an option, this function should always be built as a
module *if* modules and SCSI are enabled ... because you might have a
HBA module you enabled async scanning for and you need to wait.

There's really not much point giving the user the choice, since this
module is part of the initrd sequence ... it's not really anything a
user would want to use stand alone, hence there's no point giving a
choice about it.

James


