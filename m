From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH RFC 0/3] add fc transport events
Date: Fri, 28 May 2004 01:18:16 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40B6F5C8.2090204@cs.wisc.edu>
References: <OFF941412B.2BD1747B-ONC1256EA2.0029BCD9@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:33801 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S265961AbUE1ISZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 May 2004 04:18:25 -0400
In-Reply-To: <OFF941412B.2BD1747B-ONC1256EA2.0029BCD9@de.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Martin Peschke3 <MPESCHKE@de.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Martin Peschke3 wrote:
> 
> 
> 
>>There are still some other large outstanding issues. For example the
>>kobject_hotplug function must be called from a process context. I was not
>>sure if the transport class should provide this, or is it the drivers
>>responsibilty (some drivers have threads for work already),
>>or should SCSI ML supply this as it may have to if it is going
>>to provide events too.
> 
> 
> The zfcp lldd also deploys threads to do link recovery. But I am not sure
> whether the event
> notifications we have been discussing would always fit into it. Other
> lldd's might have no
> threads at all. I tend to say that the midlayer should make sure that the
> actual hotplug
> calls are done in the right context in order to avoid duplicate pain in
> various lldds.

I will post my patch to handle this with a SCSI-ML workqueue. All transports
and SCSI-ML can then send an event without worrying about process context.


