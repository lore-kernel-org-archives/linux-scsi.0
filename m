From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: Return of PENDING status to SCSI driver
Date: Mon, 15 Jun 2009 17:42:18 +0300
Message-ID: <4A365DCA.2030907@panasas.com>
References: <Pine.LNX.4.44L0.0906150958570.2928-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f206.google.com ([209.85.220.206]:60931 "EHLO
	mail-fx0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbZFOOmU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jun 2009 10:42:20 -0400
In-Reply-To: <Pine.LNX.4.44L0.0906150958570.2928-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ramya Desai <ramya.desai@gmail.com>, USB list <linux-usb@vger.kernel.org>, linux-scsi@vger.kernel.org

On 06/15/2009 05:01 PM, Alan Stern wrote:
> On Mon, 15 Jun 2009, Boaz Harrosh wrote:
> 
>>>> If you are using the existing USB mass storage infrastructure then
>>>>  it will not work. This is because all commands are issued from a
>>>>  thread per host, which does a synchronous execution of one command
>>>>  at a time. In fact it does not even have a Q, but a global one cmnd
>>>>  pointer per host. And therefor sets can_queue to 1.
>>>>
>>>>  Are you using the existing USB infrastructure?
>>>>
>>>>
>>>>  Boaz
>>>>
>>> I am replacing the default USB mass storage driver with the one I am
>>> developing. But I am using the default SCSI and USB stack provided by
>>> Linux.
>>>
>>> So is there any another way to make my driver asynchronous?
>>>
>>> -RD
>> I was afraid so.
>>
>> There is a lot of code you will need to change in current USB storage stack
>> SCSI is built with native support for queuing, but not so USB-storage-stack.
> 
> Boaz:
> 
> It looks like you didn't read Ramya's reply to your last message.  
> Ramya isn't keeping the USB storage "stack" -- it is being replaced by
> a new driver -- so there's no point talking about making changes to it.
> 

You are right, this is not what I understood. I understood that he is hacking
on current USB driver to try and enhance it in such a way that it will support
command queuing at the target.

He is not currently concerned about any devices but his own HW. But he is certainly
not writing a driver from scratch. He is basing on the current code base.

Did I understand right?

> Alan Stern
> 

Do you think you have any tips for him. For example at the USB transport side,
what is needed for asynchronous command execution as opposed to what is done now?

Boaz
