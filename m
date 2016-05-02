From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2] byteswap: try to avoid __builtin_constant_p gcc bug
Date: Tue, 03 May 2016 01:10:16 +0200
Message-ID: <2346484.tQ1Ts8bYKc@wuerfel>
References: <1780465.XdtPJpi8Tt@wuerfel> <20160502160218.595498b23dafe055fd52b039@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.74]:56599 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221AbcEBXLK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 May 2016 19:11:10 -0400
In-Reply-To: <20160502160218.595498b23dafe055fd52b039@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, jpoimboe@redhat.com, Martin Jambor <mjambor@suse.cz>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Denys Vlasenko <dvlasenk@redhat.com>, Thomas Graf <tgraf@suug.ch>, Peter Zijlstra <peterz@infradead.org>, David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@kernel.org>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@qlogic.com>, Jan Hubicka <hubicka@ucw.cz>

On Monday 02 May 2016 16:02:18 Andrew Morton wrote:
> On Mon, 02 May 2016 23:48:19 +0200 Arnd Bergmann <arnd@arndb.de> wrote:
> 
> > This is another attempt to avoid a regression in wwn_to_u64() after
> > that started using get_unaligned_be64(), which in turn ran into a
> > bug on gcc-4.9 through 6.1.
> 
> I'm still getting a couple screenfuls of things like
> 
> net/tipc/name_distr.c: In function 'tipc_named_process_backlog':
> net/tipc/name_distr.c:330: warning: format '%u' expects type 'unsigned int', but argument 3 has type 'unsigned int'
> net/tipc/name_distr.c:330: warning: format '%u' expects type 'unsigned int', but argument 4 has type 'unsigned int'
> net/tipc/name_distr.c:330: warning: format '%u' expects type 'unsigned int', but argument 5 has type 'unsigned int'
> net/tipc/name_distr.c:330: warning: format '%u' expects type 'unsigned int', but argument 7 has type 'unsigned int'

I've built a few thousand kernels (arm32 with gcc-6.1) with the patch applied,
but didn't see this one. What target architecture and compiler version produced
this? Does it go away if you add a (__u32) cast? I don't even know what the
warning is trying to tell me.

	Arnd
