From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] scsi-misc-2.5 remove scsi_scan.c EVPD code
Date: Tue, 06 May 2003 15:58:02 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EB74EEA.7030300@torque.net>
References: <UTC200304250047.h3P0lhl03517.aeb@smtp.cwi.nl> <3EB619A4.5090407@torque.net> <20030505093834.B7831@beaverton.ibm.com> <20030505174602.GA3433@beaverton.ibm.com> <20030505155127.A11734@beaverton.ibm.com> <3EB7124C.9010701@torque.net> <20030505211158.A14613@beaverton.ibm.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:39947 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S262365AbTEFFm5
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 May 2003 01:42:57 -0400
In-Reply-To: <20030505211158.A14613@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

Patrick Mansfield wrote:
> On Tue, May 06, 2003 at 11:39:24AM +1000, Douglas Gilbert wrote:
> 
>>Patrick Mansfield wrote:

<snip/>

>>Another approach could be to have a device node for
>>the scsi mid level (e.g. /dev/scsi) with an ioctl
>>that takes a device's toplogical address and some
>>parameters (e.g. VPD_83) and yields the response
>>of that INQUIRY (or yields an scsi status and a
>>sense buffer).
> 
> 
> Can something like that be done for a /dev/sg today? It would be very
> useful, not only for VPD/id like commands, but also for user level
> scanning.

It can be. There are a few details to be worked out.
In lk 2.4 for example the sg driver is not initialized
if there are no SCSI devices. That would cause a chicken
and egg type situation if sg was used to do user level
scanning to find the first scsi device. What major/minor
should /dev/sg have? (It could be a misc device and get
a minor reserved).

> That is open some /dev/sg via an ioctl (or ?) attach it to a nexus. If
> there is an existing scsi_device with a matching nexus, it can attach to
> it, else create an sdev via scsi_alloc_sdev, attach to it and go.
> 
> Then we can send whatever commands we want via current sg interfaces.

Sounds good. Only allow /dev/sg to have one nexus at
a time "open" (per file descriptor)? Could it
delete an existing nexus?

Doug Gilbert



