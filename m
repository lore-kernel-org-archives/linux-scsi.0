From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: sg driver and the error handler
Date: Wed, 11 May 2005 12:35:39 -0400
Message-ID: <4282345B.4010102@adaptec.com>
References: <Pine.LNX.4.44L0.0505101433520.5058-100000@iolanthe.rowland.org> <20050510225831.GA4181@us.ibm.com> <4281F396.2030607@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:63634 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261986AbVEKQfr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 May 2005 12:35:47 -0400
In-Reply-To: <4281F396.2030607@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Patrick Mansfield <patmans@us.ibm.com>, Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

>>The error handler is mainly a timeout handler, so it has to run to cancel
>>the timed out command, we can't complete the timed out command back to the
>>upper level until we know the HBA is no longer using it.
>>
>>
>>
>>>Consider a case that just came up.  A USB CD drive causes a phase error
>>>when it receives a certain READ BUFFER command (buggy firmware on the
>>>drive, never mind that now).  You would expect the user program to receive
>>
>>>from sg a host_status value indicating DID_ERROR or something of the sort.
>>
>>>Instead the error handler takes charge and sends out one or two TEST UNIT 
>>>READY commands.  The status information finally received by the user 
>>>program is the status from the TEST UNIT READY, not from the failed READ 
>>>BUFFER!  How's a program supposed to cope with that sort of obfuscation?
>>
>>
>>:-(

I think Alan even wants to see the QUEUEFULL status not being
retried.

That is, other than reclaiming the command from the LLDD, the
eh code should not retry or do anything with the command, just
pass it back to the user process who sent it via sg.

Maybe the application client has other tricks up its sleeve
on QUEUEFULL coming from the device.

I think scsi generic as a passthrough, where minimal logic
from SCSI Core is applied and most is left to the application
client.

	Luben
