From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: Return of PENDING status to SCSI driver
Date: Sun, 14 Jun 2009 12:16:12 +0300
Message-ID: <4A34BFDC.2000408@panasas.com>
References: <3e7aae30906120229p3bbeb7f0jd07c5f1e823a456a@mail.gmail.com>	 <4A323CE8.7010207@garzik.org> <3e7aae30906120554u189d4abdye0f40cd2ddc12f58@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:2437
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754060AbZFNJQP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Jun 2009 05:16:15 -0400
In-Reply-To: <3e7aae30906120554u189d4abdye0f40cd2ddc12f58@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ramya Desai <ramya.desai@gmail.com>
Cc: linux-scsi@vger.kernel.org

On 06/12/2009 03:54 PM, Ramya Desai wrote:
> On 6/12/09, Jeff Garzik <jeff@garzik.org> wrote:
>> Ramya Desai wrote:
>>
>>> Dear Experts,
>>>
>>> I am writing my mass storage class driver for my custom USB device.
>>> My device is capable of queuing the commands that are issued to it.
>>> So, I wanted to send the second command from my driver even before the
>>> completion of first command.
>>> To do this I wanted to return the PENDING status to the SCSI layer
>>> immediately after receiving the command.
>>>
>>  Simply queue as many commands as possible to your hardware, and complete
>> them when they are done.  Use can_queue or scsi_adjust_queue_depth() to set
>> queueing limits.
>>
>>         Jeff
> 
> I used can_queue  to change the queue depth to 5, but I am not getting
> the next command until I finish (Done) the first command. I wanted the
> second command to come to my driver, even before first command
> finishes.
> 
> -RD

If you are using the existing USB mass storage infrastructure then
it will not work. This is because all commands are issued from a
thread per host, which does a synchronous execution of one command
at a time. In fact it does not even have a Q, but a global one cmnd
pointer per host. And therefor sets can_queue to 1.

Are you using the existing USB infrastructure?

Boaz
