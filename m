From: liu ping fan <qemulist@gmail.com>
Subject: Re: [RFC 0/9] fix for the race issue between scsi timer and in-flight scmd
Date: Fri, 30 May 2014 16:31:32 +0800
Message-ID: <CAJnKYQmfiAn6ygM=SP9L56kbvxC7bZLtsCwDJgF64i7PYW4+9g@mail.gmail.com>
References: <1401437747-2097-1-git-send-email-pingfank@linux.vnet.ibm.com> <5388409F.8070004@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f181.google.com ([209.85.214.181]:43198 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbaE3Ibx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 May 2014 04:31:53 -0400
Received: by mail-ob0-f181.google.com with SMTP id wm4so1499477obc.40
        for <linux-scsi@vger.kernel.org>; Fri, 30 May 2014 01:31:52 -0700 (PDT)
In-Reply-To: <5388409F.8070004@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Liu Ping Fan <kernelfans@gmail.com>, linux-scsi@vger.kernel.org, Adaptec OEM Raid Solutions <aacraid@adaptec.com>, Jens Axboe <axboe@kernel.dk>, Stefan Hajnoczi <stefanha@redhat.com>, Jeff Moyer <jmoyer@redhat.com>

On Fri, May 30, 2014 at 4:26 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> Il 30/05/2014 10:15, Liu Ping Fan ha scritto:
>
>> When running io stress test on large latency scsi-disk, e.g guest with
>> virtscsi
>> on a nfs image. It can trigger the BUG_ON(test_bit(REQ_ATOM_COMPLETE,
>> &req->atomic_flags));
>> in blk_start_request().
>> Since there is a race between latency "finishing" scmd and the
>> re-allocated scmd.
>> I.e a request is still referred by a scmd, but we had turn it back to
>> slab.
>>
>> This series introduces the ref on scmd to exclude this issue, and the
>> following is ref rules.
>>
>>   inc ref rules is like the following:
>>     When setup a scmd, inited as 1. When add a timer inc 1.
>>
>>   dec ref rules is like the following:
>>     -for the normal ref
>>        scsi_done() will drop the ref when fail to acquire
>> REQ_ATOM_COMPLETE immediately
>>        or drop the ref by scsi_end_request()
>>        or drop by return SUCCESS_REMOVE
>>     -for a timer ref
>>        when deleting timer, if !list_empty(timeout_list), then there is a
>> timer ref, and
>>        drop it.
>>
>>
>> patch1-2: fix the current potential bug
>> patch3~6: prepare for the mechanism for the ref
>> patch7:   the ref rules core
>> patch8-9:  e.g and test-issue for the new mechanism. Since lack of many
>> virtscsi background,
>>            patch8 may be poor and need to be improved :)
>>
>>
>> Note: all the patches are based on rhel7, whose kernel version is
>> linux-3.10.
>>       I will rebase them onto the latest commit if my method is practical.
>
>
> This series is not necessary, this is a bug in the virtscsi driver.  I have
> a ten line patch to fix it, but I haven't yet tested it properly.
>
Could I pick up your patch, and test it?

Thx,
Fan

> Paolo
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
