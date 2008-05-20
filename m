From: "Dave Young" <hidave.darkstar@gmail.com>
Subject: Re: [PATCH 1/3][-mm] add class_reclassify macro
Date: Tue, 20 May 2008 19:05:21 +0800
Message-ID: <a8e1da0805200405t10fae448w589449e75a5abec6@mail.gmail.com>
References: <20080520095553.GA3201@darkstar.te-china.tietoenator.com>
	 <20080520030232.fc91b64e.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.185]:36730 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765597AbYETLFX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 May 2008 07:05:23 -0400
Received: by ti-out-0910.google.com with SMTP id b6so1099984tic.23
        for <linux-scsi@vger.kernel.org>; Tue, 20 May 2008 04:05:21 -0700 (PDT)
In-Reply-To: <20080520030232.fc91b64e.akpm@linux-foundation.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: greg@kroah.com, matthew@wil.cx, kay.sievers@vrfy.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, May 20, 2008 at 6:02 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Tue, 20 May 2008 17:55:54 +0800 Dave Young <hidave.darkstar@gmail.com> wrote:
>
>> Converting class semaphore to mutex cause lockdep warnings due to
>> class_interface_register/unregister will possible call device_add/del
>
> Shouldn't we just fix that?

Andrew, could you tell more?

>
>> For the class_interface users here add a class_reclassify macro to
>> reclassify the lock class of their struct class.
>>
>> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
>>
>> ---
>> include/linux/device.h |    7 +++++++
>> 1 file changed, 7 insertions(+)
>>
>> --- linux/include/linux/device.h      2008-05-19 12:29:54.000000000 +0800
>> +++ linux.new/include/linux/device.h  2008-05-19 14:42:25.000000000 +0800
>> @@ -529,4 +529,11 @@ extern const char *dev_driver_string(str
>>       MODULE_ALIAS("char-major-" __stringify(major) "-" __stringify(minor))
>>  #define MODULE_ALIAS_CHARDEV_MAJOR(major) \
>>       MODULE_ALIAS("char-major-" __stringify(major) "-*")
>> +
>> +#define class_reclassify(class)                                              \
>> +do {                                                                 \
>> +     static struct lock_class_key    class_key;                      \
>> +     lockdep_set_class_and_name(&(class)->mutex, &class_key,         \
>> +                              (class)->name);                        \
>> +} while (0)
>>  #endif /* _DEVICE_H_ */
>
> I think it would need a lavish comment explaining what it is for, and
> the reasons for its existence.

Yes, will do.

>
> Perhaps this should be a kernel-wide thing in lockdep.h.  But then that
> would invite people to use it, and it looks like a bad thing.

I agree.
There's wellmeant lockdep warnings for some safe code logic every some time.
Yes, this macro violates the lockdep class-based rules, but it can act
as just supplementary. And it could help some users.

>
> device.h does not include lockdep.h, so putting this here assumes that
> callees have already included lockdep.h.  This is the sort of
> assumption which leads to compilation errors.
>
My wrong, thanks.

Regards
dave
