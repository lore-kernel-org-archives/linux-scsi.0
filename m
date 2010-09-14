From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [Bug 18252] spinlock lockup in __make_request <- submit_bio <-
 ondemand_readahead
Date: Tue, 14 Sep 2010 08:56:43 +0200
Message-ID: <4C8F1CAB.7020004@s5r6.in-berlin.de>
References: <bug-18252-4803@https.bugzilla.kernel.org/>	<4C8B50F1.4020502@s5r6.in-berlin.de> <20100913144139.b9e18133.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:58953 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389Ab0ING5V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Sep 2010 02:57:21 -0400
In-Reply-To: <20100913144139.b9e18133.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Florian Mickler <florian@mickler.org>
Cc: linux-kernel@vger.kernel.org, bugzilla-daemon@bugzilla.kernel.org, axboe@kernel.dk, linux-scsi@vger.kernel.org

Andrew Morton wrote:
>>> https://bugzilla.kernel.org/show_bug.cgi?id=18252
...
> What you've quoted above appears to be just the aftermath. 
> https://bugzilla.kernel.org/attachment.cgi?id=29562 indicates that the
> kernel earlier crashed in scsi code, perhaps under
> scsi_setup_fs_cmnd().
> 
> The question is: was that actually the first crash, or did an even
> earlier one scroll off?

It happened overnight.  The screenshot
https://bugzilla.kernel.org/attachment.cgi?id=29562 shows that there was a lot
more logged before it.  When I saw it in the morning I assumed that the tail
was a repetition of the leading bug trace, but it seems I am mistaken.

Florian Mickler wrote:
> There was an scsi-related use-after-free OOPS fixed recently and pulled 3 days
> ago.  
> 
> On Sat, 11 Sep 2010 19:07:44 +0000
> James Bottomley <James.Bottomley@suse.de> wrote:
> 
>> This includes the oops from use after free, a set of qla2xxx fixes, some
>> misc warning cleanups from the recently introduced printk issue, an hpsa
>> lockup fix and a medium removal bug in sd introduced by the BKL
>> pushdown.
>> 
>> The patch is available here:
>> 
>> master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git
> 
> Maybe you are seeing that?
> 
> (reacting to the general-protection-fault preceded by scsi_init in the
> attachment jpg)

Now that you point it out --- perhaps.  Though I haven't looked into the
mechanics of the now fixed scsi_ini_io use after free.

I am going to update to 2.6.36-rc4 today (I had reverted to 2.6.35 since the
report), and if the issue does not return after two weeks or so I will close
it as fixed, I suggest.
-- 
Stefan Richter
-=====-==-=- =--= -===-
http://arcgraph.de/sr/
