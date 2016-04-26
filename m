From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: fc: force inlining of wwn conversion functions
Date: Tue, 26 Apr 2016 09:06:54 -0400
Message-ID: <yq14maoh635.fsf@sermon.lab.mkp.net>
References: <20160419085221.GA29087@gmail.com>
	<yq1lh41gki4.fsf@sermon.lab.mkp.net>
	<1461641851.2392.32.camel@HansenPartnership.com>
	<5249561.9VpAPLD61M@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5249561.9VpAPLD61M@wuerfel> (Arnd Bergmann's message of "Tue, 26
	Apr 2016 09:22:46 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Josh Poimboeuf <jpoimboe@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Denys Vlasenko <dvlasenk@redhat.com>, Thomas Graf <tgraf@suug.ch>, Peter Zijlstra <peterz@infradead.org>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, jamborm@gcc.gnu.org, Ingo Molnar <mingo@kernel.org>, Himanshu Madhani <himanshu.madhani@qlogic.com>, qla2xxx-upstream@qlogic.com
List-Id: linux-scsi@vger.kernel.org

>>>>> "Arnd" == Arnd Bergmann <arnd@arndb.de> writes:

Arnd> I don't think we can realistically blacklist gcc-4.9.{0,1,2,3},
Arnd> gcc-5.{0,1,2,3}.* and gcc-6.0 and require everyone to upgrade to
Arnd> compilers that have not been released yet in order to build a
Arnd> linux-4.6 kernel.

I agree that compiler blacklisting is problematic and I'd like to avoid
it. The question is how far we go in the kernel to accommodate various
levels of brokenness.

In any case. Sticking compiler workarounds in device driver code is akin
to putting demolition orders on display on Alpha Centauri. At the very
minimum the patch should put a fat comment in the code stating that
these wrapper functions or #defines should not be changed in the future
because that'll break builds using gcc XYZ. But that does not solve the
problem for anybody else that might be doing something similar.
Converting between u64 and $RANDOM_TYPE in an inline wrapper does not
seem like a rare and unusual programming pattern.

-- 
Martin K. Petersen	Oracle Linux Engineering
