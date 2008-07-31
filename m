From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH] qla2xxx: Fix dpc_thread race on the module unload
Date: Thu, 31 Jul 2008 10:55:44 -0700
Message-ID: <20080731175544.GB80258@elab5.qlogic.org>
References: <488E02DE.5080100@vlnb.net> <1217267776.3503.112.camel@localhost.localdomain> <488E0C78.80205@vlnb.net> <1217484743.25491.7.camel@galr-linux> <489181C4.70003@vlnb.net> <20080731160251.GB76172@plap4-2.local> <4891F95A.9070409@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:52668 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbYGaRzq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jul 2008 13:55:46 -0400
Content-Disposition: inline
In-Reply-To: <4891F95A.9070409@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: linux-driver@qlogic.com, Gal Rosen <galr@storwize.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net

On Thu, 31 Jul 2008, Vladislav Bolkhovitin wrote:

>> The changes above are large (170k diffs so far), and at this point are
>> being run-through our testing.  The hope is to get the changes
>> upstream during one of the next two merge windows.
>>
>> Given the infrustructure mods and our focus on that front, if there's
>> something small and contained you can offer above what I've proposed
>> we'll be interested in reviewing any patches you'd push forward.
>
> Then, I believe, my patch should go in as a temporal measure. I don't think 
> we should crash users for 2 more major releases.

So the 'online' check concerns you?  So, add an 'unloading' flag, set
it on remove_one(), save a copy of dpc_thread at qla2xxx_wake_dpc(),
then wake_up() saved value if not 'unloading'.  Of course the direct
wake_up() in request_acqusition should be modded to call
qla2xxx_wake_dpc().  We're not talking about some huge window here.

> The same is true for my 
> other patch "Proposed protection of fcports field of struct scsi_qla_host" 
> as well, because without it there should be no big problems to crash the 
> driver via sysfs.

We're still looking through your patches...  So how exactly would it
be 'be no big problems to crash the driver via sysfs.'???
