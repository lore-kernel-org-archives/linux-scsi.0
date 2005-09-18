From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 4/5] convert st to use scsi_execte_async
Date: Sun, 18 Sep 2005 11:13:01 -0500
Message-ID: <432D920D.6070700@cs.wisc.edu>
References: <1126845599.9276.44.camel@max>  <Pine.LNX.4.61.0509171428410.9258@kai.makisara.local>  <432C39BC.1030105@cs.wisc.edu>  <432C3C75.5090405@cs.wisc.edu> <1126974325.10413.5.camel@max> <Pine.LNX.4.61.0509181456370.14776@kai.makisara.local> <432D81BD.9080803@cs.wisc.edu> <432D8515.9010809@cs.wisc.edu> <Pine.LNX.4.61.0509182031090.15507@kai.makisara.local> <432D8BD9.2070300@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:34514 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932153AbVIRSNG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Sep 2005 14:13:06 -0400
In-Reply-To: <432D8BD9.2070300@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Kai Makisara <Kai.Makisara@kolumbus.fi>, linux-scsi@vger.kernel.org

Mike Christie wrote:
> Kai Makisara wrote:
> 
>>
>> init_command() is _not_ called. I added a printk to it and it did not 
>> print anything. If you look at scsi_prep_fn(), init_command() is 
>> called only if req->rq_disk is set. scsi_execute_async() does not set it.
> 
> 
> oh yeah, sorry. I meant to add that back but would have had to add 
> another argument to the scsi_execute* functions since I could not figure 
> out how to go from scsi_device or request_queue to disk.
> 
>>
>> Setting command parameters through the separate init_command() 
>> function seems like a horrible idea. You have to do hacks to pass the 
>> information.
> 
> 
> This is how sd works :(
> 

But I guess if every ULD has to add a done() then scsi-ml could set it 
if we just add a complete_command on the scsi_driver.
