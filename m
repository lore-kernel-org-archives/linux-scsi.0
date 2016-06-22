From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2] byteswap: try to avoid __builtin_constant_p gcc bug
Date: Wed, 22 Jun 2016 14:25:11 +0200
Message-ID: <7892604.CjmUVh55Wd@wuerfel>
References: <1780465.XdtPJpi8Tt@wuerfel> <E607265CB020454880711A6F96C05A0388016E76@hasmsx107.ger.corp.intel.com> <CA+i0qc4TO=ucHUJduwGTAhU9Uzy0aTk-75N3uQ9piWZWKKUBFA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:61505 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366AbcFVMbK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jun 2016 08:31:10 -0400
In-Reply-To: <CA+i0qc4TO=ucHUJduwGTAhU9Uzy0aTk-75N3uQ9piWZWKKUBFA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Winkler <tomasw@gmail.com>
Cc: "Levy, Amir (Jer)" <amir.jer.levy@intel.com>, Andrew Morton <akpm@linux-foundation.org>, "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jpoimboe@redhat.com" <jpoimboe@redhat.com>, Martin Jambor <mjambor@suse.cz>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Denys Vlasenko <dvlasenk@redhat.com>, Thomas Graf <tgraf@suug.ch>, Peter Zijlstra <peterz@infradead.org>, David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@kernel.org>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@qlogic.com>, Jan Hubicka <hubicka@ucw.cz>

On Wednesday, June 22, 2016 2:44:21 PM CEST Tomas Winkler wrote:
> >
> > There are more than 20 files that have the statement: case cpu_to_...
> > Sparse complains about: case __builtin_bswap, not about __builtin_constant_p.
> 
> There is even much more in the header files used in  initializers,
> which also require constants.  I wonder if __builtin_bswap produces
> constant expression correctly under gcc?

In gcc-4.8 or later yes. gcc-4.6/4.7 on powerpc was a special case that we
have worked around now, as the 16-bit byteswap there was not a constant
expression, unlike the 32-bit and 64-bit ones.

	Arnd
