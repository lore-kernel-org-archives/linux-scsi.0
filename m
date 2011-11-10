From: Rob Evers <revers@redhat.com>
Subject: Re: [PATCH] Remove 'unhandled error code' messages
Date: Thu, 10 Nov 2011 12:27:04 -0500
Message-ID: <4EBC0968.9090000@redhat.com>
References: <1320934327-8384-1-git-send-email-hare@suse.de>	 <1320936918.3040.1.camel@dabdike.int.hansenpartnership.com>	 <4EBBEB61.1090903@suse.de> <1320939847.11745.7.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36952 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437Ab1KJR1I (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Nov 2011 12:27:08 -0500
In-Reply-To: <1320939847.11745.7.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org

On 11/10/2011 10:44 AM, James Bottomley wrote:
> On Thu, 2011-11-10 at 16:18 +0100, Hannes Reinecke wrote:
>> On 11/10/2011 03:55 PM, James Bottomley wrote:
>>> On Thu, 2011-11-10 at 15:12 +0100, Hannes Reinecke wrote:
>>>> scsi_io_completion() tries to take some action based on
>>>> the command result and sense code. It also displays
>>>> 'unhandled error code' or 'unhandled sense code' in case
>>>> no special handling was found.
>>>> This serves as an additional source of confusion to
>>>> the unsuspecting user, as the message in fact means
>>>> 'everything okay, no special casing required',
>>>> and not 'oh gosh, something has happened and the system
>>>> couldn't deal with it'.
>>> It means we're just about to fail the command with an error.  That's not
>>> really an everything ok case.
>>>
>>> Sometimes, you're right, this is the correct thing to do silently, but
>>> often it's not.  So, same question to you as to Rob: What are the
>>> circumstances you want silent failure for and can you special case them?
>>>

This is what I have seen (recent rhel6):

Nov 10 03:42:06 <host-name> kernel: sd 2:0:0:1: [sdb] Unhandled error code
Nov 10 03:42:06 <host-name> kernel: sd 2:0:0:1: [sdb] Result: 
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Nov 10 03:42:06 <host-name> kernel: sd 2:0:0:1: [sdb] CDB: Read(10): 28 
00 00 4e 91 e0 00 00 20 00
Nov 10 03:42:06 <host-name> kernel: end_request: I/O error, dev sdb, 
sector 5149152

Would the correct solution for this case to be to make description:

     ""

or a special case, something like:

     "Couldn't connect before timeout period"

as I posted here:
http://marc.info/?l=linux-scsi&m=131854148309464&w=2

In the post I made above, I also liked

+			description = "Default sense code handling";

for the sense case.

and potentially something like

+	description = "Default host byte handling";

for the host_byte case when a host_byte isn't handled as
an alternative catch-all.

