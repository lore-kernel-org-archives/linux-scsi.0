From: Liran Schour <LIRANS@il.ibm.com>
Subject: Re: bidirectional, long commands + OSD
Date: Fri, 30 Jan 2004 00:37:44 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OFF08D0FA1.3B48B6E9-ONC2256E2A.005B7FD5-42256E2A.007C4E35@il.ibm.com>
References: <40190591.5060409@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:30935 "EHLO
	mtagate6.uk.ibm.com") by vger.kernel.org with ESMTP id S263806AbUA3IwU
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Jan 2004 03:52:20 -0500
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate6.uk.ibm.com (8.12.10/8.12.10) with ESMTP id i0U8qJZP031770
	for <linux-scsi@vger.kernel.org>; Fri, 30 Jan 2004 08:52:19 GMT
Received: from d10ml001.telaviv.ibm.com (d06av02.portsmouth.uk.ibm.com [9.149.37.228])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id i0U8qGtQ074858
	for <linux-scsi@vger.kernel.org>; Fri, 30 Jan 2004 08:52:16 GMT
In-Reply-To: <40190591.5060409@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>






Douglas Gilbert wrote in thread:
   bidirectional, long commands + OSD


>>>** The Object Storage Device (OSD) commands use bidirectional
>>>data transfers so perhaps we should think about catering for
>>>that.
>>
>>
>> Actually, a much more fundamental problem for OSD is going to be >16
>> byte CDBs.  The mid and block layers today are coded with an internal 16
>> byte array for the CDB.  That's not very scaleable to the hundreds of
>> bytes that OSD needs.

We can allow the upper layer driver to set the cmd_len and the cdb pointer
to the
desired length, the default will stay 16 byte.

>Just did a check on recent drafts and SPC-3 doesn't have any
>commands with lengths > 16 bytes but SBC-2 has:
>    XDREAD(32)
>    XDWRITE(32)
>    XDWRITEREAD(32)
>    XPWRITE(32)

>> As far as bidirectional goes, we should be able to support that today
>> providing there's just a *single* data buffer, which the OSD spec
>> implies is the easiest way to support this (although I suspect most SCSI
>> processor coding won't be expecting to see both a data in and a data out
>> from a single command).

>... and XDWRITEREAD (both 10 and 32 byte variants) is bidirectional.

A single buffer for both data in and data out will force the user to
re-copy the buffer.
We can solve it by using a scatter-gather list. Each buffer will have its
own data
direction flag.

>> As I see it, OSD seems to require a different interface from the current
>> bio layer, so there would be some type of object layer glue between the
>> fs and the mid-layer, with the block layer relegated simply to queueing
>> specials for the mid-layer, but since no-one's actually come forward
>> with an implementation, that's just a guess.

>Both Jens and Linus jumped on me when I suggested
>similar heresy :-)

Intel's iscsi reference implementation includes an upper layer driver for
OSD, it
also includes a mini filesystem that works on top of it.
This implementation only demonstrate the need to solve this 3 issues: (the
implementation just work around them)
      1. Coupling of the scsi layer with the bio layer.
      2. Bidirectional support.
      3. Extended CDB support.

We will be happy to open this issues for a discussion.

- Liran

