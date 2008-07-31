From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCH] qla2xxx: Fix dpc_thread race on the module unload
Date: Thu, 31 Jul 2008 13:11:32 +0400
Message-ID: <489181C4.70003@vlnb.net>
References: <488E02DE.5080100@vlnb.net>	 <1217267776.3503.112.camel@localhost.localdomain> <488E0C78.80205@vlnb.net> <1217484743.25491.7.camel@galr-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-03.mailcluster.net ([77.221.130.215]:56437 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752499AbYGaJLe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jul 2008 05:11:34 -0400
In-Reply-To: <1217484743.25491.7.camel@galr-linux>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-driver@qlogic.com
Cc: Gal Rosen <galr@storwize.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net

Gal Rosen wrote:
> Andrew,
> 
> Add checking of the flag online still does not answer the race that Vlad
> stated before,

Yes, that's true.

And, since ha->flags.online set to 0 not only on shutdown, I'm afraid 
you could introduce a new set of subtle bugs, if not for the moment, but 
in the future, because with your patch it gets impossible to wake up the 
DPC thread if HA is offline.

Vlad

> unless you thought about another way without lock to
> protect this thread.
> 
>> Nope, taking only one that hunk from this patch isn't sufficient.
>> Around 
>> dpc_thread there is pretty simple and classical race. You can't do
>>
>> if (x != NULL)
>> y = *x;
>>
>> without any protection, if x can be set to NULL by another thread. It 
>> can happen exactly between "if" and "*x" and hence lead to a crash,
>> correct?
> 
> Gal.
> 

