From: Tomas Winkler <tomasw@gmail.com>
Subject: Re: [PATCH v2] byteswap: try to avoid __builtin_constant_p gcc bug
Date: Wed, 22 Jun 2016 14:44:21 +0300
Message-ID: <CA+i0qc4TO=ucHUJduwGTAhU9Uzy0aTk-75N3uQ9piWZWKKUBFA@mail.gmail.com>
References: <1780465.XdtPJpi8Tt@wuerfel> <CA+i0qc6iCDx44hbX-VWvhinXtPBFS_wcQ3h7abNMjJpWfvbsug@mail.gmail.com>
 <CA+i0qc74R9Qfy8r+an4cwXQvtrk8W-=zXe3+2VgWft=J3EpV9Q@mail.gmail.com>
 <3864016.Cn7XXDBM38@wuerfel> <E607265CB020454880711A6F96C05A0388016E76@hasmsx107.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34330 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590AbcFVLoX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jun 2016 07:44:23 -0400
In-Reply-To: <E607265CB020454880711A6F96C05A0388016E76@hasmsx107.ger.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Levy, Amir (Jer)" <amir.jer.levy@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jpoimboe@redhat.com" <jpoimboe@redhat.com>, Martin Jambor <mjambor@suse.cz>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Denys Vlasenko <dvlasenk@redhat.com>, Thomas Graf <tgraf@suug.ch>, Peter Zijlstra <peterz@infradead.org>, David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@kernel.org>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@qlogic.com>, Jan Hubicka <hubicka@ucw.cz>

On Wed, Jun 22, 2016 at 1:25 PM, Levy, Amir (Jer)
<amir.jer.levy@intel.com> wrote:
> On 2016-06-22 Arnd Bergmann wrote:
>> On Wednesday, June 22, 2016 11:24:50 AM CEST Tomas Winkler wrote:
>> > On Tue, Jun 21, 2016 at 12:02 PM, Tomas Winkler <tomasw@gmail.com>
>> wrote:
>> > > On Tue, May 3, 2016 at 9:36 AM, Arnd Bergmann <arnd@arndb.de>
>> wrote:
>> > >> On Monday 02 May 2016 16:32:25 Andrew Morton wrote:
>>
>> > >>  #ifdef __HAVE_BUILTIN_BSWAP32__
>> > >> -#define __swab32(x) __builtin_bswap32((__u32)(x))
>> > >> +#define __swab32(x) (__u32)__builtin_bswap32((__u32)(x))
>> > >>  #else
>> > >>  #define __swab32(x)                            \
>> > >>         (__builtin_constant_p((__u32)(x)) ?     \
>> > >
>> > >>
>> > >
>> > > I wonder if this doesn't break switch statement that requires a
>> > > constant expression, there few cases like this over the kernel.
>> > >
>> > > switch(val) {
>> > > case cpu_to_le32(IXGBE_RXDADV_STAT_FCSTAT_FCPRSP):
>> > >
>> > > http://lxr.free-electrons.com/source/drivers/net/ethernet/intel/ixgb
>> > > e/ixgbe_fcoe.c#L458
>> > >
>> >
>> > I'm asking because sparse and checkpatch doesn't agree on that ping
>> > sparse issues
>> > 'error: bad constant expression'
>> > When changing to __constant_cpu_to_le32 sparse is happy but
>> > checkpatch.ps is complaining
>> > __constant_cpu_to_le32 should be cpu_to_le32
>> >
>>
>> That is an interesting problem, as both seem to be reasonable:
>> sparse probably doesn't understand __builtin_constant_p() enough, while
>> avoiding __constant_cpu_to_le32() is a good recommendation in general.
>>
>> How many instances of this do you see in the kernel? If ixgbe is the only one,
>> I'd just move the byteswap up into the switch statement:
>>
>>       switch (le32_to_cpu(val)) {
>>       case IXGBE_RXDADV_STAT_FCSTAT_FCPRSP:
>>
>> which may cost one or two cycles for the non-constant byteswap, but is also
>> easier to read than the current code.
>>
>>       Arnd
>
> There are more than 20 files that have the statement: case cpu_to_...
> Sparse complains about: case __builtin_bswap, not about __builtin_constant_p.

There is even much more in the header files used in  initializers,
which also require constants.  I wonder if __builtin_bswap produces
constant expression correctly under gcc?

Thanks
Tomas
