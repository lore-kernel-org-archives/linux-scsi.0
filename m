From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [Bug 15007] SCSI host adapter's scatter-gather list size Issue
Date: Thu, 14 Jan 2010 21:49:51 +0900
Message-ID: <20100114214157I.fujita.tomonori@lab.ntt.co.jp>
References: <bug-15007-11613@http.bugzilla.kernel.org/>
	<201001141227.o0ECRCAb002637@demeter.kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:39145 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755804Ab0ANMtz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Jan 2010 07:49:55 -0500
In-Reply-To: <201001141227.o0ECRCAb002637@demeter.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

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


