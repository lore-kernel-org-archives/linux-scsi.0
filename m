From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] byteswap: try to avoid __builtin_constant_p gcc bug
Date: Mon, 2 May 2016 16:02:18 -0700
Message-ID: <20160502160218.595498b23dafe055fd52b039@linux-foundation.org>
References: <1780465.XdtPJpi8Tt@wuerfel>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
In-Reply-To: <1780465.XdtPJpi8Tt@wuerfel>
Sender: mm-commits-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, jpoimboe@redhat.com, Martin Jambor <mjambor@suse.cz>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Denys Vlasenko <dvlasenk@redhat.com>, Thomas Graf <tgraf@suug.ch>, Peter Zijlstra <peterz@infradead.org>, David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@kernel.org>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@qlogic.com>, Jan Hubicka <hubicka@ucw.cz>
List-Id: linux-scsi@vger.kernel.org

On Mon, 02 May 2016 23:48:19 +0200 Arnd Bergmann <arnd@arndb.de> wrote:

> This is another attempt to avoid a regression in wwn_to_u64() after
> that started using get_unaligned_be64(), which in turn ran into a
> bug on gcc-4.9 through 6.1.

I'm still getting a couple screenfuls of things like

net/tipc/name_distr.c: In function 'tipc_named_process_backlog':
net/tipc/name_distr.c:330: warning: format '%u' expects type 'unsigned int', but argument 3 has type 'unsigned int'
net/tipc/name_distr.c:330: warning: format '%u' expects type 'unsigned int', but argument 4 has type 'unsigned int'
net/tipc/name_distr.c:330: warning: format '%u' expects type 'unsigned int', but argument 5 has type 'unsigned int'
net/tipc/name_distr.c:330: warning: format '%u' expects type 'unsigned int', but argument 7 has type 'unsigned int'

