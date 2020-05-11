Return-Path: <SRS0=B1Ch=6Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E17FDC47255
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 18:31:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C53BF20736
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 18:31:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731162AbgEKSbk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 May 2020 14:31:40 -0400
Received: from smtp.infotech.no ([82.134.31.41]:59502 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729825AbgEKSbk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 May 2020 14:31:40 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 3B4062041B2;
        Mon, 11 May 2020 20:31:38 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id apMMMrtNUupI; Mon, 11 May 2020 20:31:30 +0200 (CEST)
Received: from [192.168.48.23] (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 839D0204188;
        Mon, 11 May 2020 20:31:28 +0200 (CEST)
Reply-To: dgilbert@interlog.com
Subject: Re: scsi_alloc_target: parent of the target (need not be a scsi host)
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        SCSI development list <linux-scsi@vger.kernel.org>
References: <59d462c4-ceab-041a-bbb5-5b509f13a123@interlog.com>
 <1589136759.9701.25.camel@HansenPartnership.com>
 <5425d3ef-1cf8-fee0-58a5-fbf702d30562@interlog.com>
 <1589208092.3505.9.camel@HansenPartnership.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <9a72ead7-a8b3-abe6-cb97-c3dd030ac031@interlog.com>
Date:   Mon, 11 May 2020 14:31:26 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <1589208092.3505.9.camel@HansenPartnership.com>
Content-Type: multipart/mixed;
 boundary="------------69D3F28E49125A4068DE8E80"
Content-Language: en-CA
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------69D3F28E49125A4068DE8E80
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2020-05-11 10:41 a.m., James Bottomley wrote:
> On Sun, 2020-05-10 at 17:50 -0400, Douglas Gilbert wrote:
>> On 2020-05-10 2:52 p.m., James Bottomley wrote:
>>> On Sun, 2020-05-10 at 14:32 -0400, Douglas Gilbert wrote:
>>>> This gem is in scsi_scan.c in the documentation of that
>>>> function's first argument. "need not be a scsi host" should read
>>>> "it damn well better be a scsi host" otherwise that function will
>>>> crash and burn!
>>>
>>> It shouldn't: several transport classes, like SAS and FC have
>>> intermediate devices between the host and the target and they all
>>> work just fine using the non-host parent.  Since you don't give the
>>> error this is just guesswork, but the host has to be somewhere in
>>> the parent chain otherwise dev_to_shost(parent) will return NULL
>>> ... is that your problem?
>>
>> May be that "need not be a scsi host" should be expanded to something
>> that suggests dev_to_shost(first_arg) can resolve to a non-NULL
>> pointer.

In my working tree, I've changed that to:

* scsi_alloc_target - allocate a new or find an existing target
  * @parent:     may point to the parent shost, or an intermediate object
  *              that dev_to_shost() can resolve to the parent shost
  * @channel:    target channel number (zero if no channels)
  * @id:         target id number

Hinting at what is actually happening.

>> Are there restrictions on those intermediate object(s)? Can there be
>> more than one? If so, can those intermediate objects only form a
>> linear chain or could it be more complex, an object subtree for
>> example?
> 
> I think you can read the current code as well as I can:
> 
> static inline struct Scsi_Host *dev_to_shost(struct device *dev)
> {
> 	while
> (!scsi_is_host_device(dev)) {
> 		if (!dev->parent)
> 			return NULL;
> 		dev =
> dev->parent;
> 	}
> 	return container_of(dev, struct Scsi_Host,
> shost_gendev);
> }
> 
> The broad point is that this is open source, not some proprietary OS.
> I'm not giving you an API set in stone and you have to figure out the
> use cases, I'm telling you how the current API behaves and the reason
> why it behaves this way.  If there's an expansion or change you need,
> provided it supports the current uses and is maintainable, it can be
> done.  What you have to tell me is what you're trying to do.

https://marc.info/?l=linux-scsi&m=158880168715701&w=2

One aspect of xarray operations is that they are performed on the
collection holder (a scsi_host::__targets in this case), not so much on
the collected objects where it has a smaller footprint than list_head.
So I would be inclined to add a scsi_target::parent_shost pointer and
have a trivial:
   static inline struct Scsi_Host *starg_to_shost(struct scsi_target *starg) {}
accessor.

>>>> I'm trying to work out why the function:
>>>> starget_for_each_device() in scsi.c does _not_ use that
>>>> collection right in front of it (i.e. scsi_target::devices).
>>>> Instead, it step up to the host level, and iterates over all
>>>> devices (LUs) on that host and only calls the given function for
>>>> those devices that match the channel and target numbers.
>>>> That is bizarrely wasteful if scsi_target::devices could be
>>>> iterated over instead.
>>>>   
>>>> Anyone know why this is?
>>>
>>> Best guess would be it wasn't converted over when the target list
>>> was introduced.
>>
>> Okay, I'll change it and see what breaks.

A qualified success, so far. See below.

>> If you are not familiar with "mark"s in xarrays, they are binary
>> flags hidden inside the pointers that xarray holds to form a
>> container. With these flags (two available per xarray) one can make
>> iterations much more efficient with xa_for_each_marked() { }. The win
>> is that there is no need to dereference the pointers of collection
>> members that are _not_ marked. After playing with these in my rework
>> of the sg driver, I concluded that the best thing to mark was object
>> states. Unfortunately there are only 2 marks *** per xarray but
>> scsi_device, for example, has 9 states in scsi_device_state. Would
>> you like to hazard a guess of which two (or two groups), if any, are
>> iterated over often enough to make marking worthwhile?
>>
>> Those two marks could be stretched to four, sort of, as scsi_device
>> objects are members of two xarrays in my xarray rework: all sdev
>> objects in a starget, and all sdev objects in a shost.
> 
> I've got to say that sounds like a solution looking for a problem.
> 
> The fast path of SCSI is pretty rigorously checked with high iops
> devices these days.  The fact that this iterator is really lock heavy
> but has never been fingered in any of the traces indicates that it's
> probably not really a problem that needs solving.

https://www.kernel.org/doc/html/latest/core-api/xarray.html

Of xarray it says:
"It is more memory-efficient, parallelisable and cache friendly than
a doubly-linked list. It takes advantage of RCU to perform lookups
without locking."  M. Wilcox in the overview of that linked document.


The use of list_head objects to hold together the scsi mid-level
object tree is a mess, IMO. That makes it hard to maintain and possibly
inefficient. The fact that whoever added the scsi_target's collection
of scsi_device-s could not see the obvious way to iterate over that
collection is an example.

list_head based collections (as currently used) take spinlocks on
both modifying and non-modifying operations. An interesting aspect
of xarrays is that they have integrated locking and take cheaper
rcu locks for iterations which are mostly involved with non-modifying
operations. That integrated locking is both an advantage (it is
well instrumented in the case of xarray) and creates difficulties
when retrofitting xarrays in the place of list_head based collections
which have "roll your own" type locking.


Testing? Yes plenty of it. And things break, just not yet in the scsi
subsystem :-)  With the attached script, first my laptop goes into
thermal throttling, then a few minutes later systemd-udev seems
to lose it, spraying blocks of these messages in the log:
   xtwo70 systemd-udevd[9453]: 4:0:8:15: Failed to process device, ignoring: 
File exists

and leaking memory at the same time (based on that "age") in the kernel:
# cat /sys/kernel/debug/kmemleak
unreferenced object 0xffff88815929e000 (size 8192):
    comm "modprobe", pid 14214, jiffies 4297239717 (age 743.446s)
    hex dump (first 32 bytes):
      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    backtrace:
      [<000000003f0664f4>] 0xffffffffa0d7c202
      [<00000000f06ff621>] do_one_initcall+0x58/0x300
      [<00000000ee7e3b9e>] do_init_module+0x57/0x1f0
      [<000000000427a735>] load_module+0x2758/0x2930
      [<00000000b9da2d49>] __do_sys_finit_module+0xbf/0xe0
      [<000000003f60bec7>] do_syscall_64+0x4b/0x1c0
      [<000000007cbf2f8c>] entry_SYSCALL_64_after_hwframe+0x49/0xb3
.... < many more of the same >

The script does complete and my laptop seems normal.
It is hard to verify correctness and any performance gains when systemd
and udev are eating most of the processor resources.


Doug Gilbert



--------------69D3F28E49125A4068DE8E80
Content-Type: application/x-shellscript;
 name="tst_sdebug_modpr_rmmod.sh"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="tst_sdebug_modpr_rmmod.sh"

IyEvYmluL2Jhc2gKCiMgRXhhbXBsZSBpbnZvY2F0aW9uOgojICAgIC4vdHN0X3NkZWJ1Z19t
b2Rwcl9ybW1vZC5zaAojCiMgTi5CLiBXcml0ZXMgdG8gL2Rldi9zZzEKIwoKIyMgRG9lcyB0
aGUgc2FtZSB0aGluZyA2IHRpbWVzLCBieSByZXBsaWNhdGlvbi4gVG8gdGVzdCB0aHJvdWdo
IG5pZ2h0LgojIHRha2VzIDQgdG8gNSBob3VycwoKZm9yIGsgaW4gMSAyIDQgNyA4IDExIDE2
IDMxIDY0CmRvCglmb3IgaiBpbiAxIDIgNCA2IDgKCWRvCgkJZm9yIG0gaW4gMiA0IDggMTIK
CQlkbwoJCQltb2Rwcm9iZSBzY3NpX2RlYnVnIG5vX3VsZD0xIG1heF9sdW5zPSR7a30gbnVt
X3RndHM9JHtqfSBzZWN0b3Jfc2l6ZT01MTIgZGV2X3NpemVfbWI9MTAwIG5kZWxheT0xMDAw
MCBwZXJfaG9zdF9zdG9yZT0xIGFkZF9ob3N0PSR7bX0KCQkJc2xlZXAgMC4xCgkJCWlmIFsg
LWMgL2Rldi9zZzEgXSA7IHRoZW4KCQkJCXNnX3R1cnMgL2Rldi9zZzAKCQkJCXNnX3R1cnMg
L2Rldi9zZzEKCQkJCSMgc2doX2RkIGlmPS9kZXYvc2cwIGJzPTUxMiBvZj0vZGV2L3NnMQoJ
CQkJc2dfZGQgaWY9L2Rldi9zZzAgYnM9NTEyIG9mPS9kZXYvc2cxCgkJCWVsc2UKCQkJCWVj
aG8gIi9kZXYvc2cxIG5vdCByZWFkeSIKCQkJZmkKCQkJcm1tb2Qgc2NzaV9kZWJ1ZwoJCWRv
bmUKCWRvbmUKZG9uZQoK
--------------69D3F28E49125A4068DE8E80--
