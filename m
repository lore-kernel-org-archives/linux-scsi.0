From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCH] qla2xxx: Fix dpc_thread race on the module unload
Date: Mon, 28 Jul 2008 22:14:16 +0400
Message-ID: <488E0C78.80205@vlnb.net>
References: <488E02DE.5080100@vlnb.net> <1217267776.3503.112.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-03.mailcluster.net ([77.221.130.215]:33640 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751146AbYG1SOO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Jul 2008 14:14:14 -0400
In-Reply-To: <1217267776.3503.112.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Gal Rosen <galr@storwize.com>
Cc: linux-driver@qlogic.com, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net

James Bottomley wrote:
> On Mon, 2008-07-28 at 21:33 +0400, Vladislav Bolkhovitin wrote:
>> This patch fixes race on dpc_thread field of struct scsi_qla_host,
>> which can lead to crash on the module unload.
>>
>> This patch is against 2.6.26
> 
> I'm afraid adding a lock is almost certainly the wrong way to handle
> this type of failure. 

Why? It's simple and fully solves the problem. All the events, which 
left unhandled, because there is nobody to wake up by 
qla2xxx_wake_dpc(), are not relevant after the driver's shutdown.

> What should be done is to make sure the qla is
> correctly shut down (i.e. no tasks requiring the dpc_thread can be
> performed) *before* killing the thread ...

Sure, in ideal it would be the best approach. But, certainly, it would 
be a lot more complicated and error-prone.

 From other side, actually, it doesn't matter much for me how it will be 
fixed, if it's fixed.

> it sounds like shutdown is
> slightly broken in the current driver ... could you post the oops
> details and we can try to work out what the problem is

Gal, can you send the details, please?

> James
> 
> 
> 

