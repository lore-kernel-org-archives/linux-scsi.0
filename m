From: Tomas Winkler <tomasw@gmail.com>
Subject: Re: [PATCH v2] byteswap: try to avoid __builtin_constant_p gcc bug
Date: Wed, 22 Jun 2016 11:24:50 +0300
Message-ID: <CA+i0qc74R9Qfy8r+an4cwXQvtrk8W-=zXe3+2VgWft=J3EpV9Q@mail.gmail.com>
References: <1780465.XdtPJpi8Tt@wuerfel> <2346484.tQ1Ts8bYKc@wuerfel>
 <20160502163225.8b00a5ef7170a0f2533438e9@linux-foundation.org>
 <12243652.bxSxEgjgfk@wuerfel> <CA+i0qc6iCDx44hbX-VWvhinXtPBFS_wcQ3h7abNMjJpWfvbsug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:34695 "EHLO
	mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbcFVIjb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jun 2016 04:39:31 -0400
In-Reply-To: <CA+i0qc6iCDx44hbX-VWvhinXtPBFS_wcQ3h7abNMjJpWfvbsug@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, jpoimboe@redhat.com, Martin Jambor <mjambor@suse.cz>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Denys Vlasenko <dvlasenk@redhat.com>, Thomas Graf <tgraf@suug.ch>, Peter Zijlstra <peterz@infradead.org>, David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@kernel.org>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@qlogic.com>, Jan Hubicka <hubicka@ucw.cz>, "Amir (Jer)" <amir.jer.levy@intel.com>

On Tue, Jun 21, 2016 at 12:02 PM, Tomas Winkler <tomasw@gmail.com> wrot=
e:
> On Tue, May 3, 2016 at 9:36 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>> On Monday 02 May 2016 16:32:25 Andrew Morton wrote:
>>> On Tue, 03 May 2016 01:10:16 +0200 Arnd Bergmann <arnd@arndb.de> wr=
ote:
>>>
>>> > On Monday 02 May 2016 16:02:18 Andrew Morton wrote:
>>> > > On Mon, 02 May 2016 23:48:19 +0200 Arnd Bergmann <arnd@arndb.de=
> wrote:
>>> > >
>>> > > > This is another attempt to avoid a regression in wwn_to_u64()=
 after
>>> > > > that started using get_unaligned_be64(), which in turn ran in=
to a
>>> > > > bug on gcc-4.9 through 6.1.
>>> > >
>>> > > I'm still getting a couple screenfuls of things like
>>> > >
>>> > > net/tipc/name_distr.c: In function 'tipc_named_process_backlog'=
:
>>> > > net/tipc/name_distr.c:330: warning: format '%u' expects type 'u=
nsigned int', but argument 3 has type 'unsigned int'
>>> > > net/tipc/name_distr.c:330: warning: format '%u' expects type 'u=
nsigned int', but argument 4 has type 'unsigned int'
>>> > > net/tipc/name_distr.c:330: warning: format '%u' expects type 'u=
nsigned int', but argument 5 has type 'unsigned int'
>>> > > net/tipc/name_distr.c:330: warning: format '%u' expects type 'u=
nsigned int', but argument 7 has type 'unsigned int'
>>> >
>>> > I've built a few thousand kernels (arm32 with gcc-6.1) with the p=
atch applied,
>>> > but didn't see this one. What target architecture and compiler ve=
rsion produced
>>> > this? Does it go away if you add a (__u32) cast? I don't even kno=
w what the
>>> > warning is trying to tell me.
>>>
>>> heh, I didn't actually read it.
>>>
>>> Hopefully we can write this off as a gcc-4.4.4 glitch. 4.8.4 is OK.
>>
>> Ah, old compiler. I've tried gcc-4.3 now on ARM, and I don't get thi=
s warning
>> (just a lot "may be used uninitialized"), but unlike gcc-4.4, my ver=
sion doesn't
>> actually get into the code path I have changed because __builtin_bsw=
ap32 was only
>> introduced with 4.4.
>>
>> I don't have gcc-4.4 and 4.5 here, but the warning does show up with=
 4.6, 4.7
>> and 4.8:
>>
>> drivers/soc/sunxi/sunxi_sram.c: In function =E2=80=98sunxi_sram_show=
=E2=80=99:
>> drivers/soc/sunxi/sunxi_sram.c:103:7: warning: format =E2=80=98%x=E2=
=80=99 expects argument of type =E2=80=98unsigned int=E2=80=99, but arg=
ument 3 has type =E2=80=98unsigned int=E2=80=99 [-Wformat=3D]
>>
>> 4.8 is probably still common enough that we should try to address th=
is.
>> This change addresses the problem for me with ARM gcc-4.8, but addin=
g
>> two more type casts. This also makes the 16/32/64 bit swaps all
>> look the same. I would expect this to also have the same effect on 4=
=2E4.
>>
>> Please fold into the previous patch.
>>
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>>
>> diff --git a/include/uapi/linux/swab.h b/include/uapi/linux/swab.h
>> index d737804af181..8f3a8f606fd9 100644
>> --- a/include/uapi/linux/swab.h
>> +++ b/include/uapi/linux/swab.h
>> @@ -97,7 +97,7 @@ static inline __attribute_const__ __u32 __fswahb32=
(__u32 val)
>>   * @x: value to byteswap
>>   */
>>  #ifdef __HAVE_BUILTIN_BSWAP16__
>> -#define __swab16(x) __builtin_bswap16((__u16)(x))
>> +#define __swab16(x) (__u16)__builtin_bswap16((__u16)(x))
>>  #else
>>  #define __swab16(x)                            \
>>         (__builtin_constant_p((__u16)(x)) ?     \
>> @@ -110,7 +110,7 @@ static inline __attribute_const__ __u32 __fswahb=
32(__u32 val)
>>   * @x: value to byteswap
>>   */
>>  #ifdef __HAVE_BUILTIN_BSWAP32__
>> -#define __swab32(x) __builtin_bswap32((__u32)(x))
>> +#define __swab32(x) (__u32)__builtin_bswap32((__u32)(x))
>>  #else
>>  #define __swab32(x)                            \
>>         (__builtin_constant_p((__u32)(x)) ?     \
>
>>
>
> I wonder if this doesn't break switch statement that requires a
> constant expression, there few cases like this over the kernel.
>
> switch(val) {
> case cpu_to_le32(IXGBE_RXDADV_STAT_FCSTAT_FCPRSP):
>
> http://lxr.free-electrons.com/source/drivers/net/ethernet/intel/ixgbe=
/ixgbe_fcoe.c#L458
>

I'm asking because sparse and checkpatch doesn't agree on that ping
sparse issues
'error: bad constant expression'
When changing to __constant_cpu_to_le32 sparse is happy but
checkpatch.ps is complaining
__constant_cpu_to_le32 should be cpu_to_le32



 Thanks
 Tomas
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
