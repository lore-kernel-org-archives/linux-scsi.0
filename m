From: Karen Xie <kxie@chelsio.com>
Subject: RE: [PATCH scsi] cxgb4i : Avoid holding mutex in interrupt context
Date: Wed, 1 Oct 2014 17:22:38 +0000
Message-ID: <1442C3287A121140B690F7F20F94463D39FD8F@nice.asicdesigners.com>
References: <1410828258-14692-1-git-send-email-anish@chelsio.com>
	 <20140922144547.GA32651@infradead.org>
	 <525DB349B3FB5444AE057A887CB2A8D88F76D1@nice.asicdesigners.com>
	,<20141001074919.GA14826@infradead.org>
	 <525DB349B3FB5444AE057A887CB2A8D88F78E8@nice.asicdesigners.com>,<1412163405.5299.4.camel@jarvis>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 99-65-72-228.uvs.sntcca.sbcglobal.net ([99.65.72.228]:26676
	"EHLO stargate.chelsio.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751763AbaJARXE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Oct 2014 13:23:04 -0400
In-Reply-To: <1412163405.5299.4.camel@jarvis>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Anish Bhatt <anish@chelsio.com>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Manoj Malviya <manojmalviya@chelsio.com>

James, the bug is that with iscsi running, if ipv6 is provisioned on system, the kernel would oops on "scheduling while atomic". So it could be hit easily if ipv6 is used.

The changeset does look big, but it really just split a list original protected by mutex lock into two list, The 2nd list uses rcu lock.

Karen

________________________________________
From: James Bottomley [James.Bottomley@HansenPartnership.com]
Sent: Wednesday, October 01, 2014 4:36 AM
To: Anish Bhatt
Cc: Christoph Hellwig; linux-scsi@vger.kernel.org; Karen Xie; Manoj Malviya
Subject: Re: [PATCH scsi] cxgb4i : Avoid holding mutex in interrupt context

On Wed, 2014-10-01 at 08:08 +0000, Anish Bhatt wrote:
> James,
>     This is bugfix  and prevents a "scheduling while atomic" bug that can be
> hit when using an ipv6 address with cxgb4i, and can possibly be seen without
> Chelsio hardware. Could this be cherry picked for 3.17 please ?

Can you describe the bug it's fixing (what are the consequences) and how
often is it seen?

If it's not something everyone hits, it may be better to go via stable,
because the code change is quite large, so validating that nothing else
breaks with it at this stage (a week away from release) is quite
important.

> Christoph,
>    My bad, this is a bugfix for code that was added for 3.17, and I assumed the
> bugfixes would automatically be picked for the next rc. If James doesn't pick
> this up, I'll send it to stable when appropriate.

You said in your change log:

        Applies on top of core-for-3.18

So the natural assumption would be this is for the merge window queue.

James


