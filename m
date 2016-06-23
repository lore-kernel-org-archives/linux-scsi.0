From: Tomas Winkler <tomasw@gmail.com>
Subject: Re: [PATCH v2] byteswap: try to avoid __builtin_constant_p gcc bug
Date: Thu, 23 Jun 2016 09:27:30 +0300
Message-ID: <CA+i0qc4z2aNHQ+WcCJ7uz9pt9WCseQ-B_x7D0baMYduDcsV8Rw@mail.gmail.com>
References: <1780465.XdtPJpi8Tt@wuerfel> <E607265CB020454880711A6F96C05A0388016E76@hasmsx107.ger.corp.intel.com>
 <CA+i0qc4TO=ucHUJduwGTAhU9Uzy0aTk-75N3uQ9piWZWKKUBFA@mail.gmail.com> <7892604.CjmUVh55Wd@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:32774 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbcFWG1d (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jun 2016 02:27:33 -0400
In-Reply-To: <7892604.CjmUVh55Wd@wuerfel>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "Levy, Amir (Jer)" <amir.jer.levy@intel.com>, Andrew Morton <akpm@linux-foundation.org>, "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jpoimboe@redhat.com" <jpoimboe@redhat.com>, Martin Jambor <mjambor@suse.cz>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Denys Vlasenko <dvlasenk@redhat.com>, Thomas Graf <tgraf@suug.ch>, Peter Zijlstra <peterz@infradead.org>, David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@kernel.org>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@qlogic.com>, Jan Hubicka <hubicka@ucw.cz>

On Wed, Jun 22, 2016 at 3:25 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday, June 22, 2016 2:44:21 PM CEST Tomas Winkler wrote:
>> >
>> > There are more than 20 files that have the statement: case cpu_to_...
>> > Sparse complains about: case __builtin_bswap, not about __builtin_constant_p.
>>
>> There is even much more in the header files used in  initializers,
>> which also require constants.  I wonder if __builtin_bswap produces
>> constant expression correctly under gcc?
>
> In gcc-4.8 or later yes. gcc-4.6/4.7 on powerpc was a special case that we
> have worked around now, as the 16-bit byteswap there was not a constant
> expression, unlike the 32-bit and 64-bit ones.

Can you please give any references to that?
Just to make sure we are on the same line , the  bottom line is that
sparse has to be adjusted.

Thanks
Tomas
