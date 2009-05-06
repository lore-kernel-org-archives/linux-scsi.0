From: "Love, Robert W" <robert.w.love@intel.com>
Subject: RE: [PATCH 5/8] fcoe: reduces lock cost when adding a new skb to
	fcoe_pending_queue
Date: Wed, 6 May 2009 13:28:41 -0700
Message-ID: <273D38FBE7C6FE46A1689FCD014A0B8B49655F54@azsmsx505.amr.corp.intel.com>
References: <20090506175206.26695.19457.stgit@fritz>
	 <20090506175234.26695.38431.stgit@fritz>
 <1241633364.3322.39.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:12486 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759761AbZEFU2m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 May 2009 16:28:42 -0400
In-Reply-To: <1241633364.3322.39.camel@mulgrave.int.hansenpartnership.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Dev, Vasu" <vasu.dev@intel.com>

James Bottomley wrote:
> On Wed, 2009-05-06 at 10:52 -0700, Robert Love wrote:
>> From: Vasu Dev <vasu.dev@intel.com>
>> 
>> Currently fcoe_pending_queue.lock held twice for every new skb
>> adding to this queue when already least one pkt is pending in this
>> queue and that is not uncommon once skb pkts starts getting queued
>> here upon fcoe_start_io => dev_queue_xmit failure.
>> 
>> This patch moves most fcoe_pending_queue logic to
>> fcoe_check_wait_queue function, this new logic grabs
>> fcoe_pending_queue.lock only once to add a new skb instead twice as
>> used to be. 
>> 
>> I think after this patch call flow around fcoe_check_wait_queue
>> calling in fcoe_xmit is bit simplified with modified
>> fcoe_check_wait_queue function taking care of adding and
>> removing pending skb in one function.
> 
> This isn't really a -rc4 bug fix, is it?  It reads a lot more like a
> feature enhancement that was given a bug like description.
> 
You're right- it is an enhancement and doesn't fix a bug (that I'm aware
of). I've pulled it out of the set (locally) and re-tested; there are
no dependency issues with removing it from this update.

What about the "6/8 removes fcoe_watchdog" patch? I think your reasoning
could apply to that one as well. It's replacing the global fcoe watchdog
with a per-interface one, which could be clasified as an enhancement
as well. (I've removed this patch also (locally) and tested, so if you
think it should be pushed later, removing it won't cause any issues.)