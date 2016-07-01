From: Markus Mayer <markus.mayer@broadcom.com>
Subject: Re: [PATCH 1/6] lib: string: add function strtolower()
Date: Fri, 1 Jul 2016 10:14:12 -0700
Message-ID: <CAGt4E5teRyMJMfxz3s6PHmTgCApBWWdAiNu1VwQtdJybST3RTw@mail.gmail.com>
References: <1467330612-26242-1-git-send-email-mmayer@broadcom.com>
 <1467330612-26242-2-git-send-email-mmayer@broadcom.com> <87poqxpr4d.fsf@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vk0-f51.google.com ([209.85.213.51]:34915 "EHLO
	mail-vk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbcGAROO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Jul 2016 13:14:14 -0400
Received: by mail-vk0-f51.google.com with SMTP id u68so118691149vkf.2
        for <linux-scsi@vger.kernel.org>; Fri, 01 Jul 2016 10:14:13 -0700 (PDT)
In-Reply-To: <87poqxpr4d.fsf@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Chris Metcalf <cmetcalf@ezchip.com>, Kees Cook <keescook@chromium.org>, devel@driverdev.osuosl.org, linux-scsi@vger.kernel.org, nouveau@lists.freedesktop.org, speakup@linux-speakup.org, Linux Kernel <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org, linux-acpi@vger.kernel.org, target-devel@vger.kernel.org, devel@acpica.org

On 1 July 2016 at 03:52, Jani Nikula <jani.nikula@linux.intel.com> wrote:
> On Fri, 01 Jul 2016, Markus Mayer <mmayer@broadcom.com> wrote:
>> Add a function called strtolower() to convert strings to lower case
>> in-place, overwriting the original string.
>>
>> This seems to be a recurring requirement in the kernel that is
>> currently being solved by several duplicated implementations doing the
>> same thing.
>>
>> Signed-off-by: Markus Mayer <mmayer@broadcom.com>
>> ---
>>  include/linux/string.h |  1 +
>>  lib/string.c           | 14 ++++++++++++++
>>  2 files changed, 15 insertions(+)
>>
>> diff --git a/include/linux/string.h b/include/linux/string.h
>> index 26b6f6a..aad605e 100644
>> --- a/include/linux/string.h
>> +++ b/include/linux/string.h
>> @@ -116,6 +116,7 @@ extern void * memchr(const void *,int,__kernel_size_t);
>>  #endif
>>  void *memchr_inv(const void *s, int c, size_t n);
>>  char *strreplace(char *s, char old, char new);
>> +char *strtolower(char *s);
>>
>>  extern void kfree_const(const void *x);
>>
>> diff --git a/lib/string.c b/lib/string.c
>> index ed83562..6e3b560 100644
>> --- a/lib/string.c
>> +++ b/lib/string.c
>> @@ -952,3 +952,17 @@ char *strreplace(char *s, char old, char new)
>>       return s;
>>  }
>>  EXPORT_SYMBOL(strreplace);
>> +
>
> This needs a kernel-doc comment right here.

Will add it.

>> +char *strtolower(char *s)
>> +{
>> +     char *p;
>> +
>> +        if (unlikely(!s))
>> +                return NULL;
>
> Using spaces for indentation? See scripts/checkpatch.pl.

Not on purpose. Thanks for spotting it.

>> +
>> +     for (p = s; *p; p++)
>> +             *p = tolower(*p);
>> +
>> +     return s;
>
> Why does it return a value? Could be void?

It could be void, but I thought that would make the function's use
less flexible. As is, the return value is there if anybody wants it,
but it can be ignored if it is not needed. Also, it seems customary
for string functions to be returning the string that was passed in.

I'll change it to void if there are strong opinions leaning that way.
Personally, I like that it returns a char * better.

> BR,
> Jani.
>
>> +}
>> +EXPORT_SYMBOL(strtolower);
>
> --
> Jani Nikula, Intel Open Source Technology Center
