From: Chris Metcalf <cmetcalf@mellanox.com>
Subject: Re: [PATCH] scsi: fc: force inlining of wwn conversion functions
Date: Thu, 28 Apr 2016 11:48:57 -0400
Message-ID: <744a7126-47f7-c325-b208-cab8c30bcc0d@mellanox.com>
References: <20160419085221.GA29087@gmail.com> <4940273.pi2bWg8tAl@wuerfel>
 <fb8e623c-9a4f-655e-0670-2f8fa82021a7@mellanox.com>
 <2544325.pieyAoijz1@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2544325.pieyAoijz1@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Martin Jambor <mjambor@suse.cz>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Josh Poimboeuf <jpoimboe@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Denys Vlasenko <dvlasenk@redhat.com>, Thomas Graf <tgraf@suug.ch>, Peter Zijlstra <peterz@infradead.org>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, Himanshu Madhani <himanshu.madhani@qlogic.com>, qla2xxx-upstream@qlogic.com, Jan Hubicka <hubicka@ucw.cz>
List-Id: linux-scsi@vger.kernel.org

On 4/28/2016 11:23 AM, Arnd Bergmann wrote:
> On Thursday 28 April 2016 10:58:43 Chris Metcalf wrote:
>> (Resending as text/plain)
>>
>> On 4/27/2016 5:34 PM, Arnd Bergmann wrote:
>>> This won't help on TILE, which is the one architecture that sets
>>> ARCH_SUPPORTS_OPTIMIZED_INLINING but does not set ARCH_USE_BUILTIN_BSWAP.
>>> Chris Metcalf should be able to figure out whether we can just
>>> set ARCH_USE_BUILTIN_BSWAP for tile as well.
>> We certainly could enable ARCH_USE_BUILTIN_BSWAP.  The only problem is
>> that we never added explicit support for bswap16() in gcc, which is
>> efficiently done on tilegx via the "revbytes" instruction and a 48-bit
>> right-shift.  So gcc instead does a generic thing with four
>> instructions in three bundles, so really not as good as our asm/swab.h.
>>
>> I'm not sure how to weigh the implications of converting to
>> builtin_bswap16 (and possibly upstreaming a better implementation to
>> gcc), vs. disabling ARCH_SUPPORTS_OPTIMIZED_INLINING (which no one
>> else but x86 uses anyway), vs. just ignoring the compiler bug and
>> hoping it's not an issue in practice
> How about figuring out whether you hit the gcc bug on tile as a
> first step?

I don't have an affected build of gcc handy (just 4.8 and 4.4).  I will pass
this to our compiler folks and see what they know.

> Another idea would be to adapt this section in include/linux/compiler-gcc.h:
>
> #if !defined(CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING) ||                \
>      !defined(CONFIG_OPTIMIZE_INLINING) || (__GNUC__ < 4)
> #define inline          inline          __attribute__((always_inline)) notrace
> #define __inline__      __inline__      __attribute__((always_inline)) notrace
> #define __inline        __inline        __attribute__((always_inline)) notrace
> #else
> /* A lot of inline functions can cause havoc with function tracing */
> #define inline          inline          notrace
> #define __inline__      __inline__      notrace
> #define __inline        __inline        notrace
> #endif
>
> to work around the issue. We already check for gcc before 4.0, and
> we could also check for the affected releases (4.9, 5.x, 6.1) in the
> same place, possibly conditional on ARCH_USE_BUILTIN_BSWAP with
> a comment pointing to the gcc bug tracker.

This does seem like a more robust solution anyway, since more instances of the
bad inline pattern might get introduced in the future in other places.
I wouldn't make it conditional on ARCH_USE_BUILTIN_BSWAP for the same reason.

-- 
Chris Metcalf, Mellanox Technologies
http://www.mellanox.com
