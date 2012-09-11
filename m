From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] sg_io: allow UNMAP and WRITE SAME without CAP_SYS_RAWIO
Date: Tue, 11 Sep 2012 20:54:03 +0200
Message-ID: <504F88CB.6030105@redhat.com>
References: <1342801801-15617-1-git-send-email-pbonzini@redhat.com> <20120911165953.GK7677@google.com> <504F7B65.9090603@redhat.com> <20120911182904.GS7677@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53819 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509Ab2IKSyI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Sep 2012 14:54:08 -0400
In-Reply-To: <20120911182904.GS7677@google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>

Il 11/09/2012 20:29, Tejun Heo ha scritto:> Hello, Paolo.
> 
> On Tue, Sep 11, 2012 at 07:56:53PM +0200, Paolo Bonzini wrote:
>> Understood; unfortunately, there is another major user of it
>> (virtualization).  If you are passing "raw" LUNs down to a virtual
>> machine, there's no possibility at all to use a properly encapsulated
> 
> Is there still command filtering issue when you're passing "raw" LUNs
> down?

Yes, the passing down is just a userland program that gets SCSI
commands from the guest, sends them via SG_IO, and passes back the
result.  If the userland program is unprivileged (it usually is), then
you go through the filter.

>> The set of use cases is so variable that no single filter can accomodate
>> all of them: high availability people want persistent reservations, NAS
>> people want trim/discard, but these are just two groups.  Someone is
>> using a Windows VM to run vendor tools and wants to have access to
>> vendor-specific commands.
>>
>> You can tell this last group to use root, but not everyone else who is
>> already relying on Unix permissions, SELinux and/or device cgroups to
>> confine their virtual machines.
> 
> You listed three - HA w/ persistent reservation, NAS w/ trim/discard
> and the third which you said that using root would be fine.  Dunno
> much about persistent reservation but I don't see why trim/discard
> can't use existing block layer facilities whether from userland or
> virtio-scsi?

This is the userland for virtio-scsi (the kernel part of virtio-scsi is just
a driver running in the guest).  It can run in two mode: it can do its own
SCSI emulation, or it can just relay CDBs and their results.

It can (and does) use higher-level services if SCSI emulation is done in
userland.  In that case, trim/discard can become a BLKDISCARD or a fallocate
for example.  However, in this case userland doesn't do any emulation and in
fact doesn't even need to know that this CDB is a discard.

Also, if it fails, there's no way to reconstruct the NAS's sense data to
pass it back to the guest.  We do a limited amount of "making up" sense
data (for example if a command is filtered, all we get is an errno value;
and we say it was not recognized), but it should really be as simple
and limited as possible.

>> A generic filter (see
>> http://article.gmane.org/gmane.linux.kernel/1312326 for a proposal)
>> would be satisfactory for everyone, but it's also a major undertaking
>> and so far I've not received a single comment about it.
> 
> Maybe I'm just not familiar with the problem space but I really hope
> things don't come to that.

Why not? :)  (BTW it was suggested by Alan Cox, that's just my proposal for
how to do it).  I think that it's a good idea, but it's a big bazooka for
the smaller issue of supporting trim/discard.

>>> So, it wouldn't be a good idea to abuse SG_IO filtering for exposing
>>> trim/discard.  It's something which should be retired or at least
>>> severely restricted in time.  I don't think we want to be developing
>>> new uses of it.
>>>
>>> I think trim/discards are fairly easy to abstract and common enough to
>>> justify having properly abstracted interface.  In fact, we already
>>> have block layer interface for it - BLKDISCARD.  If it's lacking,
>>> let's improve that.
>>
>> I do want to improve the block layer interfaces to avoid that people use
>> SG_IO.  But unfortunately this is for a completely different use case.
> 
> Hmmm?  This was about discard, no?

One example of block layer interfaces that I want to add is BLKPING, so
that you can see if the NAS is reachable.  Then SCSI emulation can map
the "test unit ready" command to BLKPING.  There's a handful of such
ioctls that would be useful, such as BLKDISCARD itself.

But this is for the other direction, where ioctls are not enough accurate.

Paolo
