From: Bryan Henderson <hbryan@us.ibm.com>
Subject: RE: [linux-iscsi-devel] [question] deferred sense
Date: Thu, 6 Jan 2005 15:09:22 -0800
Message-ID: <OF20CD96E8.F1590B0E-ON88256F81.007E9E66-88256F81.007F28D1@us.ibm.com>
References: <1104961917.3883.4.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:51379 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S263102AbVAFXLV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Jan 2005 18:11:21 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.12.10/8.12.10) with ESMTP id j06NBJGb012079
	for <linux-scsi@vger.kernel.org>; Thu, 6 Jan 2005 18:11:19 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j06NBJ15242890
	for <linux-scsi@vger.kernel.org>; Thu, 6 Jan 2005 18:11:19 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.12.11) with ESMTP id j06NBJJs031337
	for <linux-scsi@vger.kernel.org>; Thu, 6 Jan 2005 18:11:19 -0500
In-Reply-To: <1104961917.3883.4.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, "Salyzyn, Mark" <mark_salyzyn@adaptec.com>

>> Change the assumptions in Journalling filesystems and make it work in a
>> deferred sense environment.
>
>It's possible, but I think it will involve large changes to the kernel.
>
>> Don't delete the Journal until a safe point of time when the writeback
>> is confirmed either by underlying knowledge, time (flush interval
>> passed), amount of data (dirty cache is forced flushed), or a read-back
>> (resulting from the deferred error investigation). RAID cards and
>> external enclosures do this all the time, but to be fair with usually
>> more knowledge of all the cache handling.
>
>Well ... this proposal would change every filesystem in the kernel for
>something that occurs rather rarely (I've never actually seen it
>happen), so it is rather a lot of work for not very much benefit.

It's especially little benefit because there's no reason for the SCSI 
target to be in write back mode.  Caching and I/O scheduling within Linux 
and SCSI command queueing do pretty much everything write back caching in 
the target is intended for.  So I think the right solution for this 
problem (which I agree is a major problem) is for journalled filesystems 
to keep the disk in non-writeback mode.

Don't you usually have to go out of your way to get a disk drive to do 
writeback?

--
Bryan Henderson                          IBM Almaden Research Center
San Jose CA                              Filesystems
