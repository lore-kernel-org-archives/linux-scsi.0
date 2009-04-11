From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 12207] block reads/writes > 122880 bytes to USB tape drive
 gives EBUSY
Date: Sat, 11 Apr 2009 02:38:28 GMT
Message-ID: <200904110238.n3B2cS7T016936@demeter.kernel.org>
References: <bug-12207-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:60005 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115AbZDKCib (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Apr 2009 22:38:31 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n3B2cSJP016937
	for <linux-scsi@vger.kernel.org>; Sat, 11 Apr 2009 02:38:28 GMT
In-Reply-To: <bug-12207-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12207





--- Comment #30 from Alan Stern <stern@rowland.harvard.edu>  2009-04-11 02:38:27 ---
On Fri, 10 Apr 2009 bugzilla-daemon@bugzilla.kernel.org wrote:

> Maybe you should check your facts before telling others where to look. 
> max_sectors_kb etc. exist only for block devices (in the Unix sense). 
> Tapes are character devices.

There's no need to be rude.  Besides, how would you suggest I check my 
facts (bearing in mind that I don't have access to any SCSI or USB tape 
drives)?

As the author of st.c, you certainly are the authority on how this
works.  And it's definitely true that tapes are char devices.

But isn't it also true that SCSI tapes, like all SCSI devices, have
their device queue set up by scsi_alloc_queue(), which calls
blk_init_queue(), which registers the queue's kobject using
blk_queue_ktype, whose default attributes include both
queue_max_sectors_entry.attr and queue_max_hw_sectors_entry.attr?  And
doesn't this mean that SCSI tapes _do_ have max_sectors_kb etc.  
attributes?

Alan Stern

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
