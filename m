From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: mpt2sas,mpt3sas watchdog device removal
Date: Tue, 16 Jul 2013 16:03:38 +0400
Message-ID: <1373976218.2148.49.camel@dabdike>
References: <20130515132401.6a8ff7fb@jlaw-desktop.mno.stratus.com>
	 <20130515132948.7dc4c551@jlaw-desktop.mno.stratus.com>
	 <DCD177647606E9419ED923E0C8C4AA723006C4AFF2@inbmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41205 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932146Ab3GPMDn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Jul 2013 08:03:43 -0400
In-Reply-To: <DCD177647606E9419ED923E0C8C4AA723006C4AFF2@inbmail02.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>
Cc: Joe Lawrence <joe.lawrence@stratus.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, 2013-07-16 at 17:30 +0530, Reddy, Sreekanth wrote:
> James,
> 
> This patch seem to be fine. Please consider this patch.

Where's the new version?  The one that has all of this fixed:

> Off list, Sreekanth from LSI tested and noticed a few issues with this
> patch:
> 
>  - mpt2sas_base_stop_watchdog is called twice: The call from
>    mpt2sas_base_detach is safe, but now unnecessary (as a call was
>    added earlier up in the PCI driver callbacks to ensure that the
>    watchdog was out of the way.) This second invocation can be
> removed.
> 
>  - If the watchdog detects a bad IOC, the watchdog remains running:
>    The watchdog workqueue isn't cleaned up until
>    mpt2sas_base_stop_watchdog is called, so in the case that the
>    watchdog removes the device from SCSI topo, the workqueue will
>    remain unused until PCI .remove/.shutdown cleans it up. Perhaps a
>    single watchdog that iterates over all adapters would be simpler?
> 
> Finally, if SCSI topo detachment is all that is interesting here,
> would
> it make more sense to move the watchdog into the MPT "scsi" code?  I
> haven't looked at the code yet, but this might make an MPT fusion
> patch
> easier (due to dependencies between its "scsi" and "base" modules).

?

James


