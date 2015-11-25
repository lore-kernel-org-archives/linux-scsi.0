From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 2/3] block: Add badblock management for gendisks
Date: Wed, 25 Nov 2015 10:37:58 -0500
Message-ID: <x49h9kanl7t.fsf@segfault.boston.devel.redhat.com>
References: <1448066960-20119-1-git-send-email-vishal.l.verma@intel.com>
	<1448066960-20119-3-git-send-email-vishal.l.verma@intel.com>
	<x49a8q32yxy.fsf@segfault.boston.devel.redhat.com>
	<1448391837.27481.16.camel@intel.com>
	<x498u5n1a7h.fsf@segfault.boston.devel.redhat.com>
	<1448395840.14996.8.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45813 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198AbbKYPiA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Nov 2015 10:38:00 -0500
In-Reply-To: <1448395840.14996.8.camel@intel.com> (Vishal L. Verma's message
	of "Tue, 24 Nov 2015 20:10:39 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "neilb@suse.com" <neilb@suse.com>, "axboe@fb.com" <axboe@fb.com>, "linux-nvdimm@ml01.01.org" <linux-nvdimm@ml01.01.org>

"Verma, Vishal L" <vishal.l.verma@intel.com> writes:

> On Tue, 2015-11-24 at 14:14 -0500, Jeff Moyer wrote:
>>=20
>> I'm not sure whether it makes sense to continue without badblock
>> management for the RAID code.=C2=A0=C2=A0I was hoping Neil would com=
ment on
>> that.
>>=20
>> -Jeff
>
> Not sure I follow? I believe I've kept all the badblocks functionalit=
y
> RAID already had..

What I mean to say is that the RAID code had previously embedded the
badblocks structure in one of its other data structures.  As a result,
you would never get an allocation failure for it.

> On a related note, something I observed when testing with md:
>
> md's badblock list is per-device, and can be seen at:
> 	/sys/block/md0/md/dev-pmem0/bad_blocks
>
> Now if we have badblocks in the gendisks too, there is also:
> 	/sys/block/pmem0/bad_blocks
>
> The two are separate 'accounts' maintained by separate drivers (md fo=
r
> the former, and pmem for the latter). This can potentially be
> confusing..
>
> Should we consolidate the two, i.e. make md (re)use the gendisk
> badblocks for its purposes too?

I agree with what Dan said.

Cheers,
Jeff
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
