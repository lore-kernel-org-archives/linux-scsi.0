From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH v2 1/5] virtio: add functions for piecewise addition of buffers
Date: Mon, 07 Jan 2013 10:02:57 +1030
Message-ID: <87sj6d51li.fsf@rustcorp.com.au>
References: <1355833972-20319-1-git-send-email-pbonzini@redhat.com> <1355833972-20319-2-git-send-email-pbonzini@redhat.com> <87r4m45g88.fsf@rustcorp.com.au> <50E5481E.20801@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:49158 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753277Ab3AFXmj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 Jan 2013 18:42:39 -0500
In-Reply-To: <50E5481E.20801@cn.fujitsu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, hutao@cn.fujitsu.com, linux-scsi@vger.kernel.org, virtualization@lists.linux-foundation.org, mst@redhat.com, asias@redhat.com, stefanha@redhat.com, nab@linux-iscsi.org, Wanlong Gao <gaowanlong@cn.fujitsu.com>

Wanlong Gao <gaowanlong@cn.fujitsu.com> writes:
> On 01/02/2013 01:03 PM, Rusty Russell wrote:
>> Paolo Bonzini <pbonzini@redhat.com> writes:
>>> The virtqueue_add_buf function has two limitations:
>>>
>>> 1) it requires the caller to provide all the buffers in a single call;
>>>
>>> 2) it does not support chained scatterlists: the buffers must be
>>> provided as an array of struct scatterlist;
>> 
>> Chained scatterlists are a horrible interface, but that doesn't mean we
>> shouldn't support them if there's a need.
>> 
>> I think I once even had a patch which passed two chained sgs, rather
>> than a combo sg and two length numbers.  It's very old, but I've pasted
>> it below.
>> 
>> Duplicating the implementation by having another interface is pretty
>> nasty; I think I'd prefer the chained scatterlists, if that's optimal
>> for you.
>
> I rebased against virtio-next and use it in virtio-scsi, and tested it with 4 targets
> virtio-scsi devices and host cpu idle=poll. Saw a little performance regression here.

Sure, but now you should be able to eliminate virtscsi_map_sgl(), right?
You should be able to use scsi_out(sc) and scsi_in(sc) directly, which
is what Paulo wanted to do...

Right Paulo?

Thanks,
Rusty.
