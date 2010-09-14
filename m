From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [Bug 18252] spinlock lockup in __make_request <- submit_bio <-
  ondemand_readahead
Date: Tue, 14 Sep 2010 13:18:02 +0200
Message-ID: <4C8F59EA.6020606@s5r6.in-berlin.de>
References: <bug-18252-4803@https.bugzilla.kernel.org/>	<4C8B50F1.4020502@s5r6.in-berlin.de> <20100913144139.b9e18133.akpm@linux-foundation.org> <4C8F1CAB.7020004@s5r6.in-berlin.de> <4C8F1D16.3040109@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:33490 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab0INLTI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Sep 2010 07:19:08 -0400
In-Reply-To: <4C8F1D16.3040109@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>, Florian Mickler <florian@mickler.org>, linux-kernel@vger.kernel.org, bugzilla-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org

Jens Axboe wrote:
> On 2010-09-14 08:56, Stefan Richter wrote:
>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=18252
>> Florian Mickler wrote:
>>> There was an scsi-related use-after-free OOPS fixed recently and pulled 3 days
>>> ago.  
...
>>> Maybe you are seeing that?
>>>
>>> (reacting to the general-protection-fault preceded by scsi_init in the
>>> attachment jpg)
>> Now that you point it out --- perhaps.  Though I haven't looked into the
>> mechanics of the now fixed scsi_ini_io use after free.
> 
> It seems the very likely explanation, since I can't see any other way that
> you would deadlock on the queue lock from that call trace if you haven't
> had someone else crash with the lock held already.

Good, I close the bugzilla item right away with the reasonable assuption that
it is fixed by commit 3a5c19c23db65a554f2e4f5df5f307c668277056.
-- 
Stefan Richter
-=====-==-=- =--= -===-
http://arcgraph.de/sr/
