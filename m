From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] scsi: fc: force inlining of wwn conversion functions
Date: Tue, 26 Apr 2016 17:58:20 +0200
Message-ID: <5298237.1Guzp0G04x@wuerfel>
References: <20160419085221.GA29087@gmail.com> <5249561.9VpAPLD61M@wuerfel> <yq14maoh635.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq14maoh635.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Josh Poimboeuf <jpoimboe@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Denys Vlasenko <dvlasenk@redhat.com>, Thomas Graf <tgraf@suug.ch>, Peter Zijlstra <peterz@infradead.org>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, jamborm@gcc.gnu.org, Ingo Molnar <mingo@kernel.org>, Himanshu Madhani <himanshu.madhani@qlogic.com>, qla2xxx-upstream@qlogic.com
List-Id: linux-scsi@vger.kernel.org

On Tuesday 26 April 2016 09:06:54 Martin K. Petersen wrote:
> >>>>> "Arnd" == Arnd Bergmann <arnd@arndb.de> writes:
> 
> Arnd> I don't think we can realistically blacklist gcc-4.9.{0,1,2,3},
> Arnd> gcc-5.{0,1,2,3}.* and gcc-6.0 and require everyone to upgrade to
> Arnd> compilers that have not been released yet in order to build a
> Arnd> linux-4.6 kernel.
> 
> I agree that compiler blacklisting is problematic and I'd like to avoid
> it. The question is how far we go in the kernel to accommodate various
> levels of brokenness.
> 
> In any case. Sticking compiler workarounds in device driver code is akin
> to putting demolition orders on display on Alpha Centauri. At the very
> minimum the patch should put a fat comment in the code stating that
> these wrapper functions or #defines should not be changed in the future
> because that'll break builds using gcc XYZ. But that does not solve the
> problem for anybody else that might be doing something similar.
> Converting between u64 and $RANDOM_TYPE in an inline wrapper does not
> seem like a rare and unusual programming pattern.

It's not the driver really, it's the core scsi/fc layer, which makes
it a little dangerous that a random driver.

I agree that putting a comment in would also help. What I understand
from the bug report is that to trigger this bug you need these elements:

1. an inline function marked __always_inline
2. another inline function that is automatically inlined (not __always_inline)
3. CONFIG_OPTIMIZE_INLINING=y to guarantee 2
4. __builtin_compatible_p inside that inline function

The last point is what Denys introduced in the kernel with
bc27fb68aaad ("include/uapi/linux/byteorder, swab: force inlining of some
byteswap operations"). So maybe it's better after all to revert that
patch, to have a higher confidence in the same bug not appearing
elsewhere. It's also really a workaround for another quirk of the
compiler, but that one only results in duplicated functions in object
code rather than functions that end in the middle.

	Arnd
