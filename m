From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14118] USB storage: "No sense [current]" when connecting
Date: Sat, 5 Sep 2009 21:18:19 GMT
Message-ID: <200909052118.n85LIJHn020984@demeter.kernel.org>
References: <bug-14118-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:55968 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbZIEVSR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Sep 2009 17:18:17 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n85LIJwj020985
	for <linux-scsi@vger.kernel.org>; Sat, 5 Sep 2009 21:18:19 GMT
In-Reply-To: <bug-14118-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14118





--- Comment #8 from Alan Stern <stern@rowland.harvard.edu>  2009-09-05 21:18:18 ---
On Sat, 5 Sep 2009, Andrew Morton wrote:

> OK, I reassigned it to scsi, but I expect it would help the scsi guys
> if someone could add a new summary of what they think the actual bug is.

Okay, here's a quick summary.  This USB mass storage device has a bug: 
It doesn't like to access the last 16 or so sectors of LUN 0.  When 
asked to read from those sectors it returns no data and Check Condition 
set.  Then in response to REQUEST SENSE it returns no information 
(SK=0, ASC=ASCQ=0).

This causes the SCSI midlayer to reissue the read request, with the 
same result.  We enter an unending loop because each READ is a new 
request with a new timeout.  That's the real problem -- the bug in the 
phone wouldn't matter much if SCSI would just give up and fail the READ 
after a couple of retries.

There are a few more details in comment #4.  Note that recently people
have been encountering more and more devices with this same kind of bug
(READ fails, REQUEST SENSE returns nothing).

My suggestion for a fix: Don't call scsi_requeue_command() if the 
current command made zero forward progress.  But this will have to be 
elaborated and made reliable.

Alan Stern

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
