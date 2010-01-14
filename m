From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15007] SCSI host adapter's scatter-gather list size Issue
Date: Thu, 14 Jan 2010 12:49:56 GMT
Message-ID: <201001141249.o0ECnuTH008110@demeter.kernel.org>
References: <bug-15007-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:50852 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756174Ab0ANMt5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jan 2010 07:49:57 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o0ECnul0008111
	for <linux-scsi@vger.kernel.org>; Thu, 14 Jan 2010 12:49:56 GMT
In-Reply-To: <bug-15007-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=15007





--- Comment #5 from Anonymous Emailer <anonymous@kernel-bugs.osdl.org>  2010-01-14 12:49:54 ---
Reply-To: fujita.tomonori@lab.ntt.co.jp

On Thu, 14 Jan 2010 12:27:12 GMT
bugzilla-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=15007
> 
> 
> 
> 
> 
> --- Comment #4 from nick cheng <nick.cheng@areca.com.tw>  2010-01-14 12:27:11 ---
> Sorry, is it a really bug?

Yes because if sg entries are larger than 127, they are not
continuous. So sg++ doesn't work. We chain sg entries. The last sg
entry is a pointer to the next sg list.

For example, a command has 128 entries, it has two sg lists. The first
sg list has 127 sg entries. The last entry in the first sg list is a
pointer to the second sg list. The second sg list has one sg
entry. The command has 128 entries in total.

My previous mail is partially wrong. As I explained above, if sg
entries is 128, this bug leads to bogus 128th sg entry. So I think
that you hit this bug.


> Does it bug anything? I can't figure it out.
> I ever used scsi_for_each_sg() and found the performance is inferior to the
> original version. I tracked the source code for scsi_for_each_sg()and there is
> no two much difference to each other. I doubt it is compiler issue to make it
> worst.
> But it is my guess. Do you know why? 
> Anyway, will you or anybody take care of this issue?

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
