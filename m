From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: Incorrect response to SK/ASC/ASCQ = x 02/04/01 (becoming ready)
Date: Mon, 23 Aug 2004 14:29:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <412A3772.2000900@adaptec.com>
References: <Pine.LNX.4.44L0.0408221154220.15992-100000@netrider.rowland.org> <412A08D9.7020502@adaptec.com> <412A15B8.2050909@optonline.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:62913 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S266509AbUHWS3K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Aug 2004 14:29:10 -0400
In-Reply-To: <412A15B8.2050909@optonline.net>
List-Id: linux-scsi@vger.kernel.org
To: Nathan Bryant <nbryant@optonline.net>
Cc: Alan Stern <stern@rowland.harvard.edu>, SCSI development list <linux-scsi@vger.kernel.org>, "Mike R." <turbanator1@verizon.net>

> Maybe the solution, then, instead of blocking, is to do something
> similar to quiesce, wherein we block normal user-initiated medium access
> but allow special requests. (?)

Yes, something like that.

> Not sure what an HOQ task attribute command is. Where in the t10.org
> specs should I look for a definition of that?

"Head Of Queue", cf., E.g. SAM-3r13, section 8.
 
> How would this interact with tagged command queueing? We don't want to
> attempt to queue other commands while START STOP UNIT is pending at the
> device. We don't want to disable disconnects, either, otherwise the bus
> would be blocked while waiting for START STOP UNIT, correct?

What would happen when you have SSU with IMMED=0 pending at the device
server and you send another task with say SIMPLE task attribute? ;-)
 
> Maybe this is a SCSI-novice question, but, does disconnection require
> tagged commands? Is the Linux midlayer smart enough to know that some
> kinds of commands need to block others until they complete?

Not sure I completely understand the questions, but I don't think
SCSI Core keeps an image of the deivice server's queues.  It may
keep a state (send/don't send) given recently sent commands, but
not as delicatly as a device server.

		Luben






