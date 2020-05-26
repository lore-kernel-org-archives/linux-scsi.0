Return-Path: <SRS0=HoCN=7I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0355EC433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 26 May 2020 02:02:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5699207FB
	for <linux-scsi@archiver.kernel.org>; Tue, 26 May 2020 02:02:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388434AbgEZCCJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 May 2020 22:02:09 -0400
Received: from smtp.infotech.no ([82.134.31.41]:48363 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388351AbgEZCCI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 25 May 2020 22:02:08 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id B838E204238;
        Tue, 26 May 2020 04:02:05 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id CBuvzwfKMMlA; Tue, 26 May 2020 04:02:02 +0200 (CEST)
Received: from [192.168.48.23] (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id A33F5204148;
        Tue, 26 May 2020 04:02:01 +0200 (CEST)
Reply-To: dgilbert@interlog.com
Subject: Re: [RFC v2 1/6] scsi: xarray hctl
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
References: <20200524155814.5895-1-dgilbert@interlog.com>
 <20200524155814.5895-2-dgilbert@interlog.com>
 <6527a0ca-954c-70e8-f0f5-08206c1779f2@suse.de>
 <8dab99d1-a22d-0065-5a7a-fd9b80bc661a@interlog.com>
 <20200525174052.GD17206@bombadil.infradead.org>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <f11f3d83-19a5-7a2a-bf14-917536514f68@interlog.com>
Date:   Mon, 25 May 2020 22:01:59 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200525174052.GD17206@bombadil.infradead.org>
Content-Type: multipart/mixed;
 boundary="------------20EDF13B07E075568162391D"
Content-Language: en-CA
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------20EDF13B07E075568162391D
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2020-05-25 1:40 p.m., Matthew Wilcox wrote:
> On Mon, May 25, 2020 at 12:30:52PM -0400, Douglas Gilbert wrote:
>> On 2020-05-25 2:57 a.m., Hannes Reinecke wrote:
>>> On 5/24/20 5:58 PM, Douglas Gilbert wrote:
>>>> +++ b/drivers/scsi/scsi.c
>>>> @@ -554,19 +554,32 @@ EXPORT_SYMBOL(scsi_device_put);
>>>>    struct scsi_device *__scsi_iterate_devices(struct Scsi_Host *shost,
>>>>                           struct scsi_device *prev)
>>>>    {
>>>> -    struct list_head *list = (prev ? &prev->siblings : &shost->__devices);
>>>> -    struct scsi_device *next = NULL;
>>>> -    unsigned long flags;
>>>> +    struct scsi_device *next = prev;
>>>> +    unsigned long flags, l_idx;
>>>>        spin_lock_irqsave(shost->host_lock, flags);
>>>> -    while (list->next != &shost->__devices) {
>>>> -        next = list_entry(list->next, struct scsi_device, siblings);
>>>> -        /* skip devices that we can't get a reference to */
>>>> -        if (!scsi_device_get(next))
>>>> -            break;
>>>> +    if (xa_empty(&shost->__devices)) {
>>>>            next = NULL;
>>>> -        list = list->next;
>>>> +        goto unlock;
>>>>        }
> 
> You don't need this stanza.  xa_find() will do the right thing (ie return
> NULL) with an empty array.

Okay.

When using xarray to store a bitset (e.g. say the 9 states in:
    enum scsi_device_state   [include/scsi/scsi_device.h]
as 2**0, 2**1, 2**2 .... 2**8), is there a mask to indicate which bit
positions are used internally by xarray? Or are the full 32 bits available,
other than the special value 0 aka NULL?

>>>> +    do {
>>>> +        if (!next) {    /* get first element iff first iteration */
>>>> +            l_idx = 0;
>>>> +            next = xa_find(&shost->__devices, &l_idx,
>>>> +                       scsi_xa_limit_16b.max, XA_PRESENT);
> 
> You don't need to use a 16-bit limit here; the XArray code will stop after
> the end of the array, and the only thing you might save is scanning the top
> node unnecessarily far.  To get there, you'd have to have an index >= 2^12,
> and the additional limit would mean that you'd scan the first 16 entries of
> the top node instead of all 64.  Kind of pales into insignificance compared
> to actually walking all 2^12 elements up to that point ;-)
> 

If we go to using parts of the hctl tuple (host, channel, target_id, lun)
as xarray indexes, then large numbers can occur in unstable systems with
say the same group of targets going offline and then back online  when,
for example, a power supply trips out. The number of elements will still
be relatively small, say well less than 2**16.

>>>> @@ -391,8 +391,8 @@ static void scsi_single_lun_run(struct
>>>> scsi_device *current_sdev)
>>>>        spin_lock_irqsave(shost->host_lock, flags);
>>>>        if (starget->starget_sdev_user)
>>>>            goto out;
>>>> -    list_for_each_entry_safe(sdev, tmp, &starget->devices,
>>>> -            same_target_siblings) {
>>>> +    /* XARRAY: was list_for_each_entry_safe(); is this safe ? */
>>>> +    xa_for_each(&starget->devices, l_idx, sdev) {
>>>>            if (sdev == current_sdev)
>>>>                continue;
>>>>            if (scsi_device_get(sdev))
>>>
>>> Frankly, I don't know why we're using the _safe variant here.
>>> Typically the _safe variant is used to protect against removal
>>> (ie if a list element is removed while iterating over the list),
>>> but I can't really imagine why starting I/O on the device would
>>> cause one entry to be deleted...
>>> James?
> 
> ... to add, xa_for_each() is safe against deletion while walking.
> Or addition while walking.
> 
>>>> @@ -234,8 +234,9 @@ static struct scsi_device
>>>> *scsi_alloc_sdev(struct scsi_target *starget,
>>>>        sdev->channel = starget->channel;
>>>>        mutex_init(&sdev->state_mutex);
>>>>        sdev->sdev_state = SDEV_CREATED;
>>>> -    INIT_LIST_HEAD(&sdev->siblings);
>>>> -    INIT_LIST_HEAD(&sdev->same_target_siblings);
>>>> +    /* XARRAY: INIT_LIST_HEAD()s here on list leaves, why ? */
>>>> +    sdev->sh_idx = -1;
>>>> +    sdev->starg_idx = -1;        /* for debugging */
>>>>        INIT_LIST_HEAD(&sdev->starved_entry);
>>>>        INIT_LIST_HEAD(&sdev->event_list);
>>>>        spin_lock_init(&sdev->list_lock);
>>>
>>> It is good practice to call INIT_LIST_HEAD() on list leaves as then you
>>> can call 'list_empty()' to figure out if they are part of a list or not.
>>>
>>> But I'm wondering about the 'sh_idx' and the 'starg_idx' here.
>>> We already have perfectly good indices with the 'lun' and 'id' entries
>>> in struct scsi_device, which (incidentally) _need_ to be unique.
>>>
>>> So why not use them?
>>
>> Ah now we have something to discuss and perhaps Willy can help
>>
>> At the target level we have two indexes:
>>     - channel (is 16 bits enough)
>>     - target (16 or 32 bits?)
>> This could be address to ways:
>>     1) introduce struct scsi_channel {int num_chans; scsi_target *t1p;}
>>     2) combine channnel and target into one 32 bit integer.
>>
>> The xarray type of its index seems to be unsigned long (Willy,
>> is that correct?). That is the same size as a pointer, 32 bits
>> on a 32 bit machine, 64 bits on a 64 bit machine. That is
>> unfortunate, since we can represent the full 64 bit LUN as
>> a single index on a 32 bit machine. We could 'hide' that and
>> have two xarrays in scsi_device for 32 bit machines.
> 
> You aren't the first person to ask about having a 64-bit lookup on
> 32-bit machines.  Indeed, I remember Hannes asking for a 256 bit lookup
> at LinuxCon in Prague.  I have always been reluctant to add such a thing because the XArray uses quite a naive data type underneath.  It works well with
> dense arrays but becomes very wasteful of memory for sparse arrays.
> 
> My understanding of SCSI-world is that most devices have a single
> LUN 0.  Most devices that have multiple LUNs number them sequentially.
> Some devices have either an internal structure or essentially pick random
> LUNs for the devices they expose.

Yes an no. There are now all sorts of weird patterns hiding in the
64 bit LUNs. See chapter 4.7 in sam6r05.pdf over at www.t10.org .
And arguably there is a 65th bit with the LU_CONG bit in an INQUIRY
standard response changing the interpretation of the 64 bit LUN.

>> So to start with, I took the easy approach, the one that most
>> resembles the what include/linux/list.h has been using. There
>> is also a (overly ?) complex locking scheme that I really did
>> not want to upset.
> 
> I think this is currently the best way to use the XArray.  I do have
> a project in the works to replace the data structure implementing the
> XArray API with a better one, but that project has been underway for
> almost two years now, so I would have a hard time suggesting that you
> wait for it to be ready.
> 
>> Those num_chans, t1p members that I put in scsi_channel is just
>> to show the xarray lookup can be bypassed when num_chans=1
>> which is very likely. Same approach could be taken in scsi_target
>> to scsi_device.
> 
> If you do only have a single entry at 0, the XArray is very efficient.
> It simplifies to a single pointer.  You don't need to optimise for that
> case yourself ;-)

That is good to know.

>>>> @@ -326,6 +331,7 @@ static void scsi_target_dev_release(struct device *dev)
>>>>        struct device *parent = dev->parent;
>>>>        struct scsi_target *starget = to_scsi_target(dev);
>>>> +    xa_destroy(&starget->devices);
> 
> By the way, you don't have to call xa_destroy() if you know the array
> is empty.  The IDR used to have that unfortunate requirement, and about a
> third of users blissfully ignored it, leaking uncounted amounts of memory.
> 
>>>> @@ -445,7 +455,15 @@ static struct scsi_target
>>>> *scsi_alloc_target(struct device *parent,
>>>>        if (found_target)
>>>>            goto found;
>>>> -    list_add_tail(&starget->siblings, &shost->__targets);
>>>> +    /* XARRAY: was list_add_tail(); may get hole in xarray or tail */
>>>> +    res = xa_alloc(&shost->__targets, &u_idx, starget, scsi_xa_limit_16b,
>>>> +               GFP_ATOMIC);
>>>> +    if (res < 0) {
>>>> +        spin_unlock_irqrestore(shost->host_lock, flags);
>>>> +        pr_err("%s: xa_alloc failure errno=%d\n", __func__, -res);
>>>> +        return NULL;
>>>> +    }
>>>> +    starget->sh_idx = u_idx;
>>>>        spin_unlock_irqrestore(shost->host_lock, flags);
>>>>        /* allocate and add */
>>>>        transport_setup_device(dev);
>>>
>>> 'scsi_xa_limit_16b' ?
>>> What's that for?
>>
>> See include/linux/xarray.h xa_limit_32b
>>
>> This is a 16 bit equivalent. Not sure if that is too restrictive.
>> Anyway, the xa_alloc() call amongst others needs an upper and
>> lower bound.
> 
> I'm happy to have an xa_limit_16b in xarray.h.  I estimate it would have
> about 5-10 users across the entire kernel.

No, that was just experimental.

>>> And, again, if we were to use the target id as an index we could be
>>> using 'xa_store' and the problem would be solved...
> 
> It may make sense to use an allocating XArray for LUNs and targets, but
> use the channel ID directly.  It depends how structured these things
> are in SCSI, and I'll admit I haven't been keeping up with how SCSI
> numbers things on a modern system (I suspect 99.9% of SCSI devices
> are USB keys with one host, one channel, one target, one LUN, but
> that the 0.1% of SCSI devices on Linux systems are responsible for 80%
> of the performance end of the market)

Attached is a UML (like) class diagram for folks to kick around. It handles
u32 values for the host, channel and target_id level and u64 at the lun
(leaf) level, via a bit of hackery, even on 32 bit machines. So the object
tree is built on the diagonal, with the multiplicity coming from xarray
members (attributes). The arrowed lines show inheritance, with
struct device being the base class aka superclass (one could argue
otherwise). The "transport_class_<n>"s are added as needed by SCSI
transports such as SAS and iSCSI.

And it uses native xarray indexes up to 2**32 - 1. So it meets all the
constraints we have currently.

Plus, based on the answers I get from above questions, in the
scsi_lu_low32 class I would like to add another xarray, that holds
bitsets rather than pointers. Each bitset holds amongst other things
the 9 scsi_device states. That way you could iterate through all
LU devices looking for an uncommon state _without_ dereferencing
pointers to any sdev_s that are bypassed. And if xarray is cache
efficient in storing its data, then it would be much faster. The
same thing (i.e. bitset xarray) could be done in scsi_channel, for
starget states.

Finally, for efficient xarray use, every object needs to be able to
get to its parent (or at least, its "collection") quickly as that is
where all xarray operations take place. And by efficient I do _not_
mean calling dev_to_shost(starget->dev.parent) when we built the
object hierarchy and _know_ where its "shost" is.

Doug Gilbert

--------------20EDF13B07E075568162391D
Content-Type: application/pdf;
 name="scsi_ml_cd1.pdf"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="scsi_ml_cd1.pdf"

JVBERi0xLjIKJcfsj6IKJSVJbnZvY2F0aW9uOiBwYXRoL2dzIC1xIC1kQ29tcGF0aWJpbGl0
eUxldmVsPTEuMiAtZE5PUEFVU0UgLWRCQVRDSCAtZFNBRkVSIC1zREVWSUNFPXBkZndyaXRl
IC1zT3V0cHV0RmlsZT0/IC1kQXV0b1JvdGF0ZVBhZ2VzPS9QYWdlQnlQYWdlIC1kQXV0b0Zp
bHRlckNvbG9ySW1hZ2VzPWZhbHNlIC1kQ29sb3JJbWFnZUZpbHRlcj0vRmxhdGVFbmNvZGUg
LWRQREZTRVRUSU5HUz0vcHJlcHJlc3MgPyA/IC1mID8KNSAwIG9iago8PC9MZW5ndGggNiAw
IFIvRmlsdGVyIC9GbGF0ZURlY29kZT4+CnN0cmVhbQp4nNVaS28bNxC+76/gUUphlsM3fWxR
9IFeUhnowQ0MQXZsA7LjyFad/Pt+lHaX3BVXkrNpEMMwRM3OznJe38xw9ZEJLjUT8a9ZLO6q
j5USgsV/CkYw6bBaXbG/2X1F7Lp88T3IlmvSTBoXuA1MG8MNs5IH7xVYqvdvKs118C6w50qw
Xw/fMQPbNbajOVlr3WZ/+Xpxx346q378yzHPrXIQcfYeW4yXiJEwnAjiNBeWnd1V55PZ1HMh
KPjJYqp4sMZPHqeah2B9mNxOT0DDo93kYnqCTRgTaPJbvO4NiB+mJ7jbSEHNTUJPnqbvzv6o
fjmr3tamqTWCmtxRrZEXPDhraxsc5DlW68AsDyTI5lo7KG2FYpaIWxm2ev8wPbFcSNJx6yfY
u7LCwAYt9SZR54l6n5YXieExUc87wprlrjCpXSOsXkYGRzS5StRlor5L1NO0ZInhU6LOE3WV
qKtEzfbweeOtGCtWGnb2Z3X2pmOcbOcfiiZ76likWd4mhstEPU1UlpbrtFRpY3IojBAWbYiQ
34mg3cuzyjjPTfBMKrIgIy04UqGXiIeZxuWeJm4QzcYirAVtoxDGc3XarKaOC0UiTOb3m2Qy
AJPJw9RwQR7ULNcSa3Z/lqCL5TxKEFKrbWIiv6XMOahr3FZ1ifwzstW9Ne9+hszAEubfL6DE
MKucgt8NMSm85rB2vG6N7bnoCK5xPgLoKgUfASdlMN/ER9IWfKRlhJqOj5Lu1ua6tybez5Cb
WPsDAkoMsyooj1ol8V1brlCbguCkXM9HR3CN8pE0iltyTGOTwvqtj1L1WTzC8Cioxm6rFwwM
XNlgtVDBuLrMafjtZn5/jy9CB/KTq2XX3K0aTgYgS6sGARyC21F2mGtU6UJ0cG9gRGWiJTql
K4LkImH6TRH/6xIjlMmXV1sGHUIsMQ31IlFv0/IyLU8TL0vLdWJQiSr31JW4x8e0x6d9lSvK
ui7u8TFRzxP1KS3naVkWdtW5rWyGhnqZlu+6FiGEkHBN/Y0M5Qevigyp/joKBTs9FKv2aqdd
6Hk4M8NFoj4m6k1afijaNLPIaWLI/P5QtN5qII0sEFvrNkG0LmLGMNfXSSPhNjW4n0bXxe7r
KVEvOmrv93MWVffFuOw6pFl2HVLwWGbkfybZetq1OKCHOCCbtEdLFBiqDdeyX0mP4BqF0ooC
l84zhcfYoF6M0nXRdE5P5ivU1+AVbrveVNrgwuTqaUhrlG70F40+3TnjCK5xcQZBCl0N/MWl
lZ0462XlvAMMDbULTvuTeRCjC7m6TkuVGFqM1iLoHvb0gm/ZkVXYTcaQ4cnzwHNzCWU8z+Q2
DOsO0o3fwwCe71a4T4fctg/ad0MUkw43qg2+LhQewfV1QhQNi5d6J0Sv0/4PRuB3D4VGQEkM
GRSHDseM1Nz5/tx3BNc4KAySu+BgeQ9IpBdD4TJR1xfLiItCofndmiZgDwYhruKJjJooOWAB
EQLmr1a3Hiwe5hoVc8rG7SH2nOF+N+TKKX5RBJ8sHp4H+s4BKCw84sh29aVQuO5kyP49dvGv
WZ4XMW3dyaaCndbF1Hwh6DXUbj/7xaDXhpanPLTaoXM/wwxiPlYUlMJcztCLxYMZzFYWg5/d
fmSnsOCLKAk+iHRhwxk09fJ9KxHwhyGyligF5l3J3Pajltg9mD1C9iiU0MgNCb2lAgg1h7N7
UIK8bVBCy2DRArSt0b/Tk2ZdH+AaHY93sdNARgKVWxfl1vXG40O29vWRCo8UDBxZMTS3RtgA
hXQFA3sTLeBbEwe0gxZ37LXxHvGjcEgjZATBxuS5cF8ARC9JsEH0eeGwfFQTdHAyt4mqB9xP
MksuI4p+x6ybO2bTlGBeK/hd1MFU+70Og/1uH5b+VdxOIba6O17PMLoMdF84YY8/iYi9TUPO
e5u3h15HkZWSq9jsBc1t/HRcmf1vno64Z3QbJLRjFj2G1bIPcNnAl45O14t43fqwOSQCKDgN
AGQR67anqDXWSUU+f1mVzviueuWoVRITmlWtkr0e/DDXuH4obACNWciVRP9DRJZL+kMxOFdD
JlKUK58q9l6GWUWxZZQOOiKK7pqvBFiwbFkZFc2kSxREBQdGLDcyfGwZd8R4CXgCBzmdLi6r
m8INcafjpQyoo7XgUuEeF7sQoGeBolyIJyuvQR0JX7i41YDuSyHCCxTSDgPjq1BHeJSyGEgY
6RQ3JQoFtJ3qVQQbcsNyir6gGGShQDDAKf1alPFcm40IJ2PGFChSw0fmdakjRVDx6LpAEUJi
ZPje1IkdGgonkwHbRJsPIfElumkJkKPQGkYCIG2bPQ2BXPwdyTIT0lBuCoKx5W/4tFlblJ/7
D8meuvOQhjCqsmPo4k44TJKbrqT5iU37SuHn9Eoho/6eqCxR79LyNjFcJupJomY/FMleoX0u
niavOoNJQ10UDzjmxc72sdhdZG/IbosNzHVxDxnDXd7ivq3+A9YSpzRlbmRzdHJlYW0KZW5k
b2JqCjYgMCBvYmoKMTg0NQplbmRvYmoKNCAwIG9iago8PC9UeXBlL1BhZ2UvTWVkaWFCb3gg
WzAgMCA2MTIgNzkyXQovUm90YXRlIDAvUGFyZW50IDMgMCBSCi9SZXNvdXJjZXM8PC9Qcm9j
U2V0Wy9QREYgL1RleHRdCi9Gb250IDExIDAgUgo+PgovQ29udGVudHMgNSAwIFIKPj4KZW5k
b2JqCjMgMCBvYmoKPDwgL1R5cGUgL1BhZ2VzIC9LaWRzIFsKNCAwIFIKXSAvQ291bnQgMQo+
PgplbmRvYmoKMSAwIG9iago8PC9UeXBlIC9DYXRhbG9nIC9QYWdlcyAzIDAgUgo+PgplbmRv
YmoKMTEgMCBvYmoKPDwvUjcKNyAwIFIvUjkKOSAwIFI+PgplbmRvYmoKMTQgMCBvYmoKPDwv
RmlsdGVyL0xaV0RlY29kZS9MZW5ndGggMzcxPj5zdHJlYW0KgAvIZJIhJNxpOggF5QORvMZT
MsJMxpNxkORlOZvOpyMZlEBiMpnigKGIyEBkNJjhMgkRuBUsihjNphOAKgRNmhUPJwj0mMhl
M02Ic4OBOMJtMovKQxGknoEkj8hmJvn5zOBhjpyMJuM5lBQ8GAwHw8MxmHwKMsVMdUjFXrNb
roKGVNmBuMRmrVcrw8GVivl+sN9s48GYxseFsdhxFfGYyw+OsAwxuDGYzw+WyOVwY0HFjzmJ
GGfr41zGk0Gm0dmHg11Vh1mDG2GHmx0G0r42zG42uW240sY232R4GwGu/4vC4u3G+/5fC5e3
zuz6NhG2d2453/Y4XY25j3/e4Xe25l3/k4Xk2+qG2tGHrwY3v3w0Hyr43yH2+eO+uYG+YsL+
ve4IbuC/7fPq44buO/7kh4G4bLHBz5we+rmhu5r/uetIyLuvK4w0mSaAUoaaKMpAQDGjaLjc
OiUJUhURjgpyJjcMqLoyjaOhAOA3prDQQQ0BSAgKZW5kc3RyZWFtCmVuZG9iago3IDAgb2Jq
Cjw8L0Jhc2VGb250L0NXUEZaQytDYWlyb0ZvbnQtMC0wL0ZvbnREZXNjcmlwdG9yIDggMCBS
L1RvVW5pY29kZSAxNCAwIFIvVHlwZS9Gb250Ci9GaXJzdENoYXIgMzIvTGFzdENoYXIgMTE5
L1dpZHRoc1sKMzQ4IDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwCjAgNjk2IDY5NiA2
OTYgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAKMCAwIDAgMCAwIDAgMCAwIDgzNyAwIDAgMCAw
IDAgMCAwCjAgMCAwIDcyMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgNTAwCjAgNjc1IDAgNTkz
IDcxNiA2NzggMCA3MTYgNzEyIDM0MyAwIDAgMzQzIDAgNzEyIDY4Nwo3MTYgMCA0OTMgNTk1
IDQ3OCA3MTIgNjUyIDkyNF0KL1N1YnR5cGUvVHJ1ZVR5cGU+PgplbmRvYmoKMTUgMCBvYmoK
PDwvRmlsdGVyL0xaV0RlY29kZS9MZW5ndGggNDUwPj5zdHJlYW0KgAvIZJIhJNxpOggF5QOR
vMZTMsJMxpNxkORlOZvOpyMZlEBiMpnigKGIyEBkNJjhMgkRuBUsihjNphOAKgRNmhUPJwj0
mMhlM02Ic4OBOMJtMovKQxGsnoEkj8hmJvn5zOBhjpyMJuM5lBQ8GAwHw8MxmHwKMsVMdUjF
XrNbroKGdNmBuMRmrVcrw8GVivl+sN9s98HFjGWFsAww+DGQ5w2OxONxhiw2UyOUr4yMmGze
RzdfGYysehsdh0mgGej1OJGep0A00ew1mw0A20e21m20Bh0e81m8r401fC0ow4nByA0yFh5W
DGur5/F6NfGuW6vSzA8Gud7fSz/as3g6Vmr42GNj83F9Pl1Y21dh92DG2y+fq2g8Gw19H6xP
5+QbvRAD+wA8rEBsxD4MK8rIBs5YYQa+QxvRCT+wk8rOhszr4O+GwyvRDz+w88rwhs8L4PIH
gbr9FTixYr4btFFMYrDGDBhu1cbxa10UtkG7ZRo+4bv5IUWv1F8BBvAUaQJFLEBvBAYSfGzI
BvB0qrOtIyLuvK4yymSaAUoaaKMpAQDGjaLjcOiUJUhUxDgpyJjcMqLoyjaOhAOA3prLIQSy
BSAgCmVuZHN0cmVhbQplbmRvYmoKOSAwIG9iago8PC9CYXNlRm9udC9KVVFPWU8rQ2Fpcm9G
b250LTEtMC9Gb250RGVzY3JpcHRvciAxMCAwIFIvVG9Vbmljb2RlIDE1IDAgUi9UeXBlL0Zv
bnQKL0ZpcnN0Q2hhciAzMi9MYXN0Q2hhciAxMjEvV2lkdGhzWwo2MDIgMCAwIDAgMCAwIDAg
MCA2MDIgNjAyIDAgNjAyIDAgNjAyIDAgMAowIDAgNjAyIDYwMiA2MDIgMCA2MDIgMCAwIDAg
NjAyIDAgMCAwIDAgMAowIDAgMCA2MDIgMCAwIDAgMCAwIDYwMiAwIDAgMCAwIDAgMAowIDAg
MCA2MDIgMCAwIDAgMCAwIDAgMCA2MDIgMCA2MDIgMCA2MDIKMCA2MDIgMCA2MDIgNjAyIDYw
MiAwIDYwMiA2MDIgNjAyIDAgMCA2MDIgNjAyIDYwMiA2MDIKNjAyIDAgNjAyIDYwMiA2MDIg
NjAyIDAgNjAyIDYwMiA2MDJdCi9TdWJ0eXBlL1RydWVUeXBlPj4KZW5kb2JqCjggMCBvYmoK
PDwvVHlwZS9Gb250RGVzY3JpcHRvci9Gb250TmFtZS9DV1BGWkMrQ2Fpcm9Gb250LTAtMC9G
b250QkJveFswIC0yMzUgODg5IDc1OV0vRmxhZ3MgNAovQXNjZW50IDc1OQovQ2FwSGVpZ2h0
IDc0MgovRGVzY2VudCAtMjM1Ci9JdGFsaWNBbmdsZSAwCi9TdGVtViAxMzMKL01pc3NpbmdX
aWR0aCA2MDAKL1hIZWlnaHQgNTYwCi9Gb250RmlsZTIgMTIgMCBSPj4KZW5kb2JqCjEyIDAg
b2JqCjw8L0ZpbHRlci9MWldEZWNvZGUKL0xlbmd0aDEgODA3Ni9MZW5ndGggNzE1MT4+c3Ry
ZWFtCoAAACAIIDQAgAAAwAUCeUxeMoJEQAHjxESsYzaYThEoIHDZBAC6jGdjoIB8uRiCIi3I
IAioZjgZzaWwEa3hBAGMIirDObDyZo4AAWyIIEDgaDKYTIDhKR0xBA+VIiNjRSDCDleB0VOJ
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
BAMTkgoBgSksKGAUpZTSSAALsNQWgn49AAAEF0YhaIVluXQXMupdzBSrc4YgIAfJQSgAgAKW
YIABAwhAAIKwAkDCAAEJAAQoDRTDNGamYw0ABTINhMsAQ8JmgCAy3SHADQBkiAqAACYAQOAD
A0AQEwAASJ8AGCkAgNgAA0ACDkAYOQCAwAQEYAARo1ADCSQ0BAeADImEQAMQ4BUUCWAAJYAI
mQBiZAIJUAomgDCoAGkoXIAwSPBTcAlOYIQPgBDMAFroFgAhnH8Ecfwd1Dj6AGAZSBYixTfF
0AEAgARYABG0AEdwAgUACDcAIZCigBiOAGNIAjCQfAEDYAQ0hSw2AFFoAYSgBh8AHDUAcXB5
zzv/UrShXxQmmgaIKAGQNKKvVfrBWEsTVaxVfAcu2stZau1hIPWVugCpQAWgQBEB7biogAKe
TcBIAwEASAuBOtNgbBWDsJYWw1h7ENQgiWJtzbq2jwDuP8f5BR4AgslHmuzVLE2CAcqQACvr
N2IrXYettm26EFrgQWAAFlfliAiAAB4ALMkFAaWIBcmiHliAS4UAACAAASAABebFXiD3AgBA
CSNdwABDDCGkOQbwjBvDcHQFoMLq1bq2JAAFp7Q2Gt9YJTo8LJ2BtLYwZoAAzAFGGAASYBBf
AACwAS9YagBXvFZZkAwsgAC8AKH++AAxpgAA2AMeQABWAFDNfAAt+sDi6wNfXAwBRIgAHPgv
CIbcFYOC5hYUABwyEIwkpbEIogC4aAKDePQAhkliqxd2r9pQBBeFwLEWArxdBfAeDweservl
iGmNkJw6KUY/yCPcOQ/BXAPGaAkMqlce1eICCmVuZHN0cmVhbQplbmRvYmoKMTAgMCBvYmoK
PDwvVHlwZS9Gb250RGVzY3JpcHRvci9Gb250TmFtZS9KVVFPWU8rQ2Fpcm9Gb250LTEtMC9G
b250QkJveFswIC0yMzUgNjAyIDc2NV0vRmxhZ3MgNAovQXNjZW50IDc2NQovQ2FwSGVpZ2h0
IDc0MgovRGVzY2VudCAtMjM1Ci9JdGFsaWNBbmdsZSAwCi9TdGVtViA5MAovTWlzc2luZ1dp
ZHRoIDYwMgovWEhlaWdodCA1NjAKL0ZvbnRGaWxlMiAxMyAwIFI+PgplbmRvYmoKMTMgMCBv
YmoKPDwvRmlsdGVyL0xaV0RlY29kZQovTGVuZ3RoMSA4ODAwL0xlbmd0aCA3ODE4Pj5zdHJl
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
iABAJH6PfZgpC5sDCkAAZESAAhEACLoAI8gBTmBUAIPwAhVACGYAId2+ABhkAGKwAgIgCBeA
IJgAgzACgUAK50VgBonBoAMLIAw3gDzqLGAwBASgEDIASA4BIOgEjAASNY+kNE/n0Aps61oG
k/IP5Hy3l3L+XIA5aBoDZ9QAAjPoBcCzvQOlzVVy4EHIwQ8wXjy1KVs0FmGAGBQBKUwJlyAU
Q4CNTAHgCTAYBCfMOtdb6513r3X+wdh7EZsahczNmb5KPAPI/x/lyHgCDtlrdqFz5l13lXNZ
Fly5xy9VoFollz57y3n/X+g9a6H2LovXUpFytmXJBZcjDFyAGYcAHTS5AY7n08+kSr4oPAiA
CphcgHw0P8BUuZgQHF+5Gn8/xdS6lyQfzIIYYQ0hyDeEYN4bg6AtBiC0GHeQAiQAB5HsXxS5
eL6458eHbeuclUANEAAaAABYABDMYYAPriF+wn4Z4AC+igACFoAI6S5hMACGr6IABEgA2aLL
732/1iY/eL4+6RC5/ahc7J2Vrw27HDI/9AA//AFADAJAHANALARAPAUkQ5Q+M5g+cAEC8FwF
iFgFeF0C+AeB4HqQC+QLkGmGyCcHePpA/BCH2EUH6ACAKF8AQByLnA6PoICACmVuZHN0cmVh
bQplbmRvYmoKMiAwIG9iago8PC9Qcm9kdWNlcihHUEwgR2hvc3RzY3JpcHQgOS41MCkKL0Ny
ZWF0aW9uRGF0ZShEOjIwMjAwNTI1MjA1MzA4LTA0JzAwJykKL01vZERhdGUoRDoyMDIwMDUy
NTIwNTMwOC0wNCcwMCcpCi9DcmVhdG9yKGNhaXJvIDEuMTYuMCBcKGh0dHBzOi8vY2Fpcm9n
cmFwaGljcy5vcmdcKSkKL0F1dGhvcihcKGRvdWdnXCkpCi9UaXRsZShcKC9ob21lL2RvdWdn
L3Njc2lfbWxfY2QxLmRpYVwpKT4+ZW5kb2JqCnhyZWYKMCAxNgowMDAwMDAwMDAwIDY1NTM1
IGYgCjAwMDAwMDIzODUgMDAwMDAgbiAKMDAwMDAxOTc3MyAwMDAwMCBuIAowMDAwMDAyMzI2
IDAwMDAwIG4gCjAwMDAwMDIxODQgMDAwMDAgbiAKMDAwMDAwMDI0OSAwMDAwMCBuIAowMDAw
MDAyMTY0IDAwMDAwIG4gCjAwMDAwMDI5MDkgMDAwMDAgbiAKMDAwMDAwNDIwNCAwMDAwMCBu
IAowMDAwMDAzODAxIDAwMDAwIG4gCjAwMDAwMTE2NTUgMDAwMDAgbiAKMDAwMDAwMjQzMyAw
MDAwMCBuIAowMDAwMDA0NDIzIDAwMDAwIG4gCjAwMDAwMTE4NzQgMDAwMDAgbiAKMDAwMDAw
MjQ3MiAwMDAwMCBuIAowMDAwMDAzMjg1IDAwMDAwIG4gCnRyYWlsZXIKPDwgL1NpemUgMTYg
L1Jvb3QgMSAwIFIgL0luZm8gMiAwIFIKL0lEIFs8NTA0QkNCMjNGQzVFN0U3QzlBM0RCQzJF
MzI4MUFDRTM+PDUwNEJDQjIzRkM1RTdFN0M5QTNEQkMyRTMyODFBQ0UzPl0KPj4Kc3RhcnR4
cmVmCjIwMDA4CiUlRU9GCg==
--------------20EDF13B07E075568162391D--
