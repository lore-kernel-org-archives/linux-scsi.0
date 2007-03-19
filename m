From: "Patro, Sumant" <Sumant.Patro@lsi.com>
Subject: RE: [PATCH] scsi: megaraid_sas - throttle io if cmds are in riskof being timed-out
Date: Mon, 19 Mar 2007 17:08:54 -0600
Message-ID: <0631C836DBF79F42B5A60C8C8D4E82299C15B2@NAMAIL2.ad.lsil.com>
References: <1174083775.3519.54.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:47085 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965407AbXCSXJN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Mar 2007 19:09:13 -0400
Content-class: urn:content-classes:message
In-Reply-To: <1174083775.3519.54.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: akpm@osdl.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Kolli, Neela" <Neela.Kolli@lsi.com>, "Yang, Bo" <Bo.Yang@lsi.com>


Thank you James.
I will submit new patch that will throttle (if required) from
eh_timed_out call back.

Regards,

Sumant


-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@SteelEye.com] 
Sent: Friday, March 16, 2007 3:23 PM
To: Patro, Sumant
Cc: akpm@osdl.org; linux-scsi@vger.kernel.org;
linux-kernel@vger.kernel.org; Kolli, Neela; Yang, Bo
Subject: Re: [PATCH] scsi: megaraid_sas - throttle io if cmds are in
riskof being timed-out

On Thu, 2007-03-01 at 13:29 -0800, Sumant Patro wrote:
> Driver to throttle IO to reduce risk of OS timing out cmds.
> 
> Implemented a circular queue to keep track of pending OS cmds in FW. 
> This queue is periodically (every 10 sec) checked by a timer routine.
> If there is any cmd that is in risk of getting timed-out by the OS, 
> the host->can_queue is reduced to 16 and MEGASAS_FW_BUSY flag is set.
> The host->can_queue will be restored to default value when the 
> following two conditions are met : 5 secs has elapsed and the # of 
> outstanding cmds in FW is less than 17.
> Also increased the per cmd timeout to 120*HZ from 90*HZ.

OK, this is still not nice.  What you need to be doing is intercepting
the timeout before it fires (and quiesces the machine).  Currently the
eh_timed_out() callback is only exposed to transport classes, I'll put
it back into the host template and then you can use it.

James


