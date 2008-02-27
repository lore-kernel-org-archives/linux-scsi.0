From: Chris Snook <csnook@redhat.com>
Subject: Re: Performance problems with 3ware 9500S-4LP and 2.6.25-rc3
Date: Wed, 27 Feb 2008 14:55:52 -0500
Message-ID: <47C5C048.9080704@redhat.com>
References: <20080226174314.GA30767@skl-net.de> <47C45B80.6090907@redhat.com> <20080227101143.GC30767@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:56965 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814AbYB0T5Q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Feb 2008 14:57:16 -0500
In-Reply-To: <20080227101143.GC30767@skl-net.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: adam radford <aradford@gmail.com>, Tony Battersby <tonyb@cybernetics.com>, =?ISO-8859-1?Q?Johannes_W=F6rner?= <johannes.woerner@tuebingen.mpg.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

Andre Noll wrote:
> On 13:33, Chris Snook wrote:
> 
>>> During the daily cron job that uses rsync to sync a 500G file system
>> >from another machine to the raid on the 3ware controller the load
>>> jumps up, and the machine becomes sluggish as hell. For example, an
>>> ssh login to that machine takes minutes to complete and ldap becomes
>>> unreliable while the rsync job is running. Even Nagios complains
>>> about the machine being down while rsync is running.
>> You're putting your box under astronomical load.  This is generally 
>> regarded as a bad idea, regardless of how well your storage controller 
>> is performing.
> 
> The machine becomes sluggish also when I write directly to the raid
> array. A simple
> 
> 	dd if=/dev/zero of=tmpfile
> 
> shouldn't push the load up to 4, right?

Actually, it's normal for pdflush to spawn up to 8 threads when you're 
dirtying memory faster than it can be written to disk.  Load going to 4 
is not abnormal.  ssh logins taking minutes is very abnormal.

>> Can you measure the single-threaded throughput (say, 
>> coping one huge file, and then syncing) to give us a baseline 
>> performance figure?
> 
> Single threaded throughput seems to be ok (140M/s). The problem is
> that the machine becomes unresponsive.

Does the machine become unresponsive during the single-threaded test, or 
only when doing the rsync?

	-- Chris
