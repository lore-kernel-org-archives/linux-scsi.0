From: Chris Metcalf <cmetcalf@mellanox.com>
Subject: Re: [PATCH] scsi: fc: force inlining of wwn conversion functions
Date: Thu, 28 Apr 2016 10:58:43 -0400
Message-ID: <fb8e623c-9a4f-655e-0670-2f8fa82021a7@mellanox.com>
References: <20160419085221.GA29087@gmail.com> <5298237.1Guzp0G04x@wuerfel>
 <20160427110503.GB24887@virgil.suse.cz> <4940273.pi2bWg8tAl@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4940273.pi2bWg8tAl@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, Martin Jambor <mjambor@suse.cz>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Josh Poimboeuf <jpoimboe@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Denys Vlasenko <dvlasenk@redhat.com>, Thomas Graf <tgraf@suug.ch>, Peter Zijlstra <peterz@infradead.org>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, Himanshu Madhani <himanshu.madhani@qlogic.com>, qla2xxx-upstream@qlogic.com, Jan Hubicka <hubicka@ucw.cz>
List-Id: linux-scsi@vger.kernel.org

(Resending as text/plain)

On 4/27/2016 5:34 PM, Arnd Bergmann wrote:
> This won't help on TILE, which is the one architecture that sets
> ARCH_SUPPORTS_OPTIMIZED_INLINING but does not set ARCH_USE_BUILTIN_BSWAP.
> Chris Metcalf should be able to figure out whether we can just
> set ARCH_USE_BUILTIN_BSWAP for tile as well.

We certainly could enable ARCH_USE_BUILTIN_BSWAP.  The only problem is
that we never added explicit support for bswap16() in gcc, which is
efficiently done on tilegx via the "revbytes" instruction and a 48-bit
right-shift.  So gcc instead does a generic thing with four
instructions in three bundles, so really not as good as our asm/swab.h.

I'm not sure how to weigh the implications of converting to
builtin_bswap16 (and possibly upstreaming a better implementation to
gcc), vs. disabling ARCH_SUPPORTS_OPTIMIZED_INLINING (which no one
else but x86 uses anyway), vs. just ignoring the compiler bug and
hoping it's not an issue in practice :-)
-- 
Chris Metcalf, Mellanox Technologies
http://www.mellanox.com
