From: Denys Vlasenko <dvlasenk@redhat.com>
Subject: Re: This patch triggers a bad gcc bug (was Re: [PATCH] force inlining
 of some byteswap operations)
Date: Thu, 14 Apr 2016 17:29:06 +0200
Message-ID: <570FB742.2010309@redhat.com>
References: <1454615136-32308-1-git-send-email-dvlasenk@redhat.com> <1454615136-32308-2-git-send-email-dvlasenk@redhat.com> <20160413033649.7r3msnmo3trtq47z@treble> <570E37A9.2050503@redhat.com> <20160413123607.3y3v5esq3myto4kc@treble> <20160413151500.tate3u6trg4agugo@treble> <1460566509.2322.14.camel@HansenPartnership.com> <20160413171058.24tnvvquvnipnwnd@treble>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50674 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932215AbcDNP3K (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Apr 2016 11:29:10 -0400
In-Reply-To: <20160413171058.24tnvvquvnipnwnd@treble>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Josh Poimboeuf <jpoimboe@redhat.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Graf <tgraf@suug.ch>, Peter Zijlstra <peterz@infradead.org>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, linux-scsi <linux-scsi@vger.kernel.org>

On 04/13/2016 07:10 PM, Josh Poimboeuf wrote:
>>>>>> From the disassembly of drivers/scsi/qla2xxx/qla_attr.o:
>>>>>>
>>>>>> 0000000000002f53 <qla2x00_get_host_fabric_name>:
>>>>>>     2f53:       55                      push   %rbp
>>>>>>     2f54:       48 89 e5                mov    %rsp,%rbp
>>>>>>
>>>>>> 0000000000002f57 <qla2x00_get_fc_host_stats>:
>>>>>>     2f57:       55                      push   %rbp
>>>>>>     2f58:       b9 e8 00 00 00          mov    $0xe8,%ecx
>>>>>>     2f5d:       48 89 e5                mov    %rsp,%rbp
>>>>>> ...
>>>>>>
>>>>>> Note that qla2x00_get_host_fabric_name() is inexplicably
>>>>>> truncated after
>>>>>> setting up the frame pointer.  It falls through to the next
>>>>>> function, which is
>>>>>> very wrong.
>>>>>
>>>>> Wow, that's ... interesting.
>>>>>
>>>>>
>>>>>> I can recreate it with either gcc 5.3.1 or gcc 6.0 on
>>>>>> linus/master with
>>>>>> the .config from the above link.
>>>>>>
>>>>>> The call chain which appears to trigger the problem is:
>>>>>>
>>>>>> qla2x00_get_host_fabric_name()
>>>>>>   wwn_to_u64()
>>>>>>     get_unaligned_be64()
>>>>>>       be64_to_cpup()
>>>>>>         __be64_to_cpup() <- changed to __always_inline by this
>>>>>> patch
>>>>>>
>>>>>> It occurs with the combination of the following two recent
>>>>>> commits:
>>>>>>
>>>>>> - bc27fb68aaad ("include/uapi/linux/byteorder, swab: force
>>>>>> inlining of some byteswap operations")
>>>>>> - ef3fb2422ffe ("scsi: fc: use get/put_unaligned64 for wwn
>>>>>> access")
>>>>>>
>>>>>> I can confirm that reverting either patch makes the problem go
>>>>>> away.
>>>>>> I'm planning on opening a gcc bug tomorrow.
>>>>>
>>>>>
>>>>> Note that if CONFIG_OPTIMIZE_INLINING is not set, _all_ "inline"
>>>>> keywords are in fact __always_inline, so the bug must be
>>>>> triggering
>>>>> even without the patch.
>>>>
>>>> Makes sense in theory, but the bug doesn't actually trigger when I
>>>> revert the patch and set CONFIG_OPTIMIZE_INLINING=n.
>>>>
>>>> Perhaps even more surprising, it doesn't trigger *with* the patch
>>>> and
>>>> CONFIG_OPTIMIZE_INLINING=n.
>>>
>>> [ Adding James to CC since this bug affects scsi. ]
>>>
>>> Here's the gcc bug:
>>>
>>>   https://gcc.gnu.org/bugzilla/show_bug.cgi?id=70646
>>>
>>
>>
>> Actually, adding me doesn't help, I've added linux-scsi.  The summary
>> is that there's a but in gcc-5.3.1 which is miscompiling qla_attr.c ...
>> this means we're going to have to ask the compiler version of reported
>> crashes.
> 
> The bug isn't specific to a compiler version.  I've seen it with gcc
> 5.3.1 and gcc 6.0.  I haven't tried any older versions.  And the gcc bug
> hasn't been resolved (or even investigated) yet.
> 
> The bug is triggered by a combination of the above two commits from the
> 4.6 merge window, so presumably we'd need to revert one of them to avoid
> crashes in 4.6.

The bug is indeed in the compiler. 4.9 and all later versions are affected.
gcc bugzilla now has a reproducer. In abridged form:


static inline __attribute__((always_inline)) u64 __swab64p(const u64 *p)
{
 return (__builtin_constant_p((u64)(*p)) ? ((u64)( (((u64)(*p) & (u64)0x00000000000000ffULL) << 56) | (((u64)(*p) & (u64)0x000000000000ff00ULL) << 40) | (((u64)(*p) & (u64)0x0000000000ff0000ULL) << 24) | (((u64)(*p) & (u64)0x00000000ff000000ULL) << 8) | (((u64)(*p) & (u64)0x000000ff00000000ULL) >> 8) | (((u64)(*p) & (u64)0x0000ff0000000000ULL) >> 24) | (((u64)(*p) & (u64)0x00ff000000000000ULL) >> 40) | (((u64)(*p) & (u64)0xff00000000000000ULL) >> 56))) : __builtin_bswap64(*p));
}
static inline u64 wwn_to_u64(void *wwn)
{
 return __swab64p(wwn);
}
static void qla2x00_get_host_fabric_name(struct Scsi_Host *shost)
{
 scsi_qla_host_t *vha = shost_priv(shost);
 u8 node_name[8] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};
 u64 fabric_name = wwn_to_u64(node_name);
 if (vha->device_flags & 0x1)
  fabric_name = wwn_to_u64(vha->fabric_node_name);
 (((struct fc_host_attrs *)(shost)->shost_data)->fabric_name) = fabric_name;
}


Two (or more, there were more before simplification) levels of inlining
are necessary for bug to trigger in this example (folding to one level
makes it go away). "__attribute__((always_inline))" is necessary too.


Since we have lots of __always_inline anyway, this bug has a potential
to miscompile kernels regardless of CONFIG_OPTIMIZE_INLINING setting,
and with or without the patches mentioned above (they just happen
to create a reliable reproducer).

Since it was not detected for two years since gcc 4.9 release,
it must be triggering quite rarely.
