From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15565] SCSI Generic queueing completes commands in reverse
 order
Date: Thu, 18 Mar 2010 08:23:59 GMT
Message-ID: <201003180823.o2I8NxNo011903@demeter.kernel.org>
References: <bug-15565-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:57980 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab0CRIYA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Mar 2010 04:24:00 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o2I8O0fY011904
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 18 Mar 2010 08:24:00 GMT
In-Reply-To: <bug-15565-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=15565





--- Comment #2 from Mike Hayward <mh-linux-kernel@loup.net>  2010-03-18 08:23:55 ---
Hey Doug,

 > bugzilla-daemon@bugzilla.kernel.org wrote:
 > > http://bugzilla.kernel.org/show_bug.cgi?id=15565
 > > 
 > >            Summary: SCSI Generic queueing completes commands in reverse
 > >                     order
 >
 > I have been told that is a feature :-)
 > 
 > The SCSI mid level processes commands from
 > pass-throughs (e.g. sg and bsg) in LIFO order.
 > For certain types of error processing it makes
 > sense. For READs and WRITEs it makes no sense.

Thanks for the confirmation; it in fact it makes anti sense to a
spinning disk drive!  Without drive command queueing it's causing the
maximum rotational delay for reads or writes with caching disabled,
maximizing latency and minimizing throughput to a given track.  Ouch.

I assume libaio does not exhibit this behavior, or is everything
running through the scsi mid level and just depending on adjacent io
aggregation to help reduce rotational latency?  I'm guessing I'll have
to use libaio to get good disk performance in the near future and save
sg for controlling caching, etc.

Bummer since SCSI gives much better control, like priority ios to a
journal, which NCQ can actually grant and SCSI-ATA translation should
support or SCSI drive can honor closer to the media.  Or FUA & DPO, or
command ordering to pipeline a barrier.

- Mike

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
