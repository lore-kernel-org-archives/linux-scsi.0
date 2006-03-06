From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: SCSI target and IO-throttling
Date: Mon, 6 Mar 2006 11:15:59 -0800
Message-ID: <OF4F9C2429.293D1C5C-ON88257129.00683373-88257129.0069D5D8@us.ibm.com>
References: <8932FBA5-241C-470E-A928-F34868EC0A8D@egenera.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:2720 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S932332AbWCFTQG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2006 14:16:06 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id k26JG3nU009265
	for <linux-scsi@vger.kernel.org>; Mon, 6 Mar 2006 14:16:03 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k26JG3vE099932
	for <linux-scsi@vger.kernel.org>; Mon, 6 Mar 2006 14:16:03 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11/8.13.3) with ESMTP id k26JG25o027928
	for <linux-scsi@vger.kernel.org>; Mon, 6 Mar 2006 14:16:03 -0500
In-Reply-To: <8932FBA5-241C-470E-A928-F34868EC0A8D@egenera.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steve Byan <smb@egenera.com>
Cc: linux-scsi@vger.kernel.org, Vladislav Bolkhovitin <vst@vlnb.net>

>On Mar 2, 2006, at 11:21 AM, Vladislav Bolkhovitin wrote:
>
>> Could anyone advice how a SCSI target device can IO-throttle its 
>> initiators, i.e. prevent them from queuing too many commands, please?
>>
>> I suppose, the best way for doing this is to inform the initiators 
>> about the maximum queue depth X of the target device, so any of the 
>> initiators will not send more than X commands. But I have not found 
>> anything similar to that on INQUIRY or MODE SENSE pages. Have I 
>> missed something? Just returning QUEUE FULL status doesn't look to 
>> be correct, because it can lead to out of order commands execution.
>
>Returning QUEUE FULL status is correct, unless the initiator does not 
>have any pending commands on the LUN, in which case you should return 
>BUSY. Yes, this can lead to out-of-order execution. That's why tapes 
>have traditionally not used SCSI command queuing.

I'm confused,  Vladislav appears to be asking about flow control such as 
is built into ISCSI, wherein the ISCSI target tells the intitiator how 
many tasks it's willing to work on at once and the initiator stops sending 
new ones when it has hit that limit and waits for one of the previous ones 
to finish.  And the target can continuously change that number.

With the more primitive transports, I believe this is a manual 
configuration step -- the target has a fixed maximum queue depth and you 
tell the driver via some configuration parameter what it is.

As I understand it, any system in which QUEUE FULL (that's another name 
for SCSI's Task Set Full, isn't it?) errors happen is one that is not 
properly configured.  I saw a broken ISCSI system that had QUEUE FULLs 
happening, and it was a performance disaster.

>> Apparently, hardware SCSI targets don't suffer from queuing 
>> overflow and don't return all the time QUEUE FULL status, so the 
>> must be a way to do the throttling more elegantly.
>
>No, they just have big queues.

Big queues are another serious performance problem, when it means a target 
accepts work faster than it can do it.  I've seen that cause initiators to 
send suboptimal requests (if the target appears to be working at infinite 
speed, the initiator sends small chunks of work as soon as each is ready, 
whereas if the initiator can tell that the target is choked, the initiator 
combines and sorts work while it waits, into a stream the target can 
handle more efficiently).  When systems substitute an oversized queue in a 
target for initiator-target flow control, the initiator ends up having to 
compensate with artificial schemes to withhold work from a willing target 
(e.g. Linux "queue plugging").

--
Bryan Henderson                     IBM Almaden Research Center
San Jose CA                         Filesystems

