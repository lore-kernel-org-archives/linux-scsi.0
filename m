From: Andy Grover <agrover@redhat.com>
Subject: Re: [PATCH 10/42] target: Rewrite transport_init_task_sg()
Date: Tue, 31 May 2011 14:04:52 -0700
Message-ID: <4DE557F4.3080700@redhat.com>
References: <1306523240-15543-1-git-send-email-agrover@redhat.com>	 <1306523240-15543-11-git-send-email-agrover@redhat.com> <1306825729.8193.77.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38431 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932282Ab1EaVE4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 May 2011 17:04:56 -0400
In-Reply-To: <1306825729.8193.77.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-iscsi-target-dev@googlegroups.com, target-devel <target-devel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, linux-scsi <linux-scsi@vger.kernel.org>

On 05/31/2011 12:08 AM, Nicholas A. Bellinger wrote:
> On Fri, 2011-05-27 at 12:06 -0700, Andy Grover wrote:
>> Don't set task->task_sg_num until task_sg is successfully alloced, to
>> prevent it from possibly being out of sync.
>>
>> Simplify loop counting sgs needed. Handle possible (?) case of offset
>> greater than se_mem->se_len. Remove some cluttering debugprints. Reduce
>> local variable usage.
>>
>> Do not set termination bit in padded-1 entry in the padded_sg case. If
>> something barfs on an extra zeroed sg, (will happen if chain-capable sgs
>> don't actually get chained) then it's broken.
>>
>> Remove unneeded parens.
>>
>> Signed-off-by: Andy Grover <agrover@redhat.com>
>> ---
> 
> So I am not exactly sure there is an issue here with task->task_sg_num
> assignment in the failure case, as nothing depends AFAICT upon
> task->task_sg_num in the release path before an possible
> transport_init_task_sg() failure..

Yeah I was just being paranoid..

> However, my main concern is the removal of sg_mark_end() calls  to
> signify the end of task->task_sg[] memory for individual task I/O
> dispatch.  As you have noticed this looks OK with existing code wrt to
> backend *_map_task_sg() and *_do_task() using for_each_sg() w/
> task->task_sg_num, but am wondering if it really makes sense to remove
> this for the actual scatterlist dispatch for all backends..?  Is there
> any possible code below TCM backend drivers where HW drivers can pose an
> issue..?
> 
> I am happy to merge this for tcm v4.1 along with patch #11 if this is
> really safe to do, but will defer for the moment until we can get a few
> more ACKs on these two..

Every sg[] that is initialized by sg_init_table (or sg_init_one) should
have sg_mark_end called on its last element[1] so I think we're ok, or
am I misunderstanding the issue you're getting at?

Regards -- Andy

[1] http://lxr.linux.no/linux+v2.6.38/lib/scatterlist.c#L85
