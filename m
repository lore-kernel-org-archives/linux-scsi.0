From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 4/5] convert st to use scsi_execte_async
Date: Sun, 18 Sep 2005 12:01:07 -0500
Message-ID: <432D9D53.3070706@cs.wisc.edu>
References: <1126845599.9276.44.camel@max>  <Pine.LNX.4.61.0509171428410.9258@kai.makisara.local>  <432C39BC.1030105@cs.wisc.edu>  <432C3C75.5090405@cs.wisc.edu>  <1126974325.10413.5.camel@max>  <Pine.LNX.4.61.0509181456370.14776@kai.makisara.local>  <432D81BD.9080803@cs.wisc.edu> <432D8515.9010809@cs.wisc.edu>  <Pine.LNX.4.61.0509182031090.15507@kai.makisara.local> <1127061365.800.1.camel@max> <432D97F2.5040508@cs.wisc.edu> <Pine.LNX.4.61.0509182155350.15507@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:45266 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932170AbVIRTBN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Sep 2005 15:01:13 -0400
In-Reply-To: <Pine.LNX.4.61.0509182155350.15507@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org

Kai Makisara wrote:
> 
> This solves the problem. All works properly and if I try some mt command 
> after filemark detection, the residual is correctly zero.

ok thanks for having patience with me and testing so much.

> 
> This change solving problems also explains what I have seen today. Before 
> your message I had found out that all three commands (the one that should 
> have been executed and the two retries) were fetched from the queue in the 
> normal way. Eh did not have anything to do with them. The command was 
> using dio and 10240 bytes needs three pages => two retries.
> 

ahh :)

> Fixing passing the retries did not actually have anything to do with this 
> exact problem. However, I think that the retries parameter should be 
> obeyed if it is in the interface.
> 

Yes, I think we need both fixes for the users of scsi_execte and 
scsi_execute_req that was added to scsi-rc-fixes. I will make a patch 
and send if off.

Thanks again for testing.

