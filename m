From: Brian King <brking@us.ibm.com>
Subject: Re: list_for_each_entry_safe() regarded as unsafe
Date: Fri, 10 Jun 2005 08:39:58 -0500
Message-ID: <42A9982E.5020802@us.ibm.com>
References: <Pine.LNX.4.44L0.0506091907520.30626-100000@netrider.rowland.org>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:33238 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262522AbVFJNkB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Jun 2005 09:40:01 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j5ADe1F9010151
	for <linux-scsi@vger.kernel.org>; Fri, 10 Jun 2005 09:40:01 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j5ADe1AR202998
	for <linux-scsi@vger.kernel.org>; Fri, 10 Jun 2005 09:40:01 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11/8.13.3) with ESMTP id j5ADe0Ts022370
	for <linux-scsi@vger.kernel.org>; Fri, 10 Jun 2005 09:40:00 -0400
In-Reply-To: <Pine.LNX.4.44L0.0506091907520.30626-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Mike Anderson <andmike@us.ibm.com>, Dag Nygren <dag@newtech.fi>, SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern wrote:
> On Thu, 9 Jun 2005, Mike Anderson wrote:
> 
> 
>>Well we need a updated scsi_host state model that would prevent scanning
>>while we are removing the host. I would believe that if the oopses in
>>__scsi_remove_target where prevent there maybe some other oopses showing
>>up as the host started going away.
> 
> 
> More than that is needed -- you have to guarantee that two threads won't 
> try to add or remove a target or device to the same host at the same time.
> 
> 
>>>I don't know what the best way is fix this.  Even if scsi_forget_host() 
>>>acquired the host's scan_mutex, that wouldn't be enough to guarantee the 
>>>__targets and __devices lists won't change, would it?  And it might cause 
>>>interference with other pathways.
>>>
>>
>>Yes if scsi_forget_host acquired the scan_mutex it would deadlock when
>>scsi_remove_device acquired it later on in the call stack.
> 
> 
> How about not acquiring the scan_mutex in scsi_remove_device, and 
> insisting that the caller hold it instead?  There aren't that many places 
> where it gets called.  In fact, one of those places (an error pathway in 
> scsi_sysfs_add_sdev) looks like it already will cause a deadlock.

scsi_remove_device is an exported symbol, so requiring the caller to obtain
the scan_mutex prior to calling it would not work. A __scsi_remove_device
could be created, however, which would not grab the scan_mutex so that scsi
core could do the right thing.


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
