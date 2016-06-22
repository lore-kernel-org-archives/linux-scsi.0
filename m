From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2] byteswap: try to avoid __builtin_constant_p gcc bug
Date: Wed, 22 Jun 2016 11:59:30 +0200
Message-ID: <3864016.Cn7XXDBM38@wuerfel>
References: <1780465.XdtPJpi8Tt@wuerfel> <CA+i0qc6iCDx44hbX-VWvhinXtPBFS_wcQ3h7abNMjJpWfvbsug@mail.gmail.com> <CA+i0qc74R9Qfy8r+an4cwXQvtrk8W-=zXe3+2VgWft=J3EpV9Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+i0qc74R9Qfy8r+an4cwXQvtrk8W-=zXe3+2VgWft=J3EpV9Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tomas Winkler <tomasw@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, jpoimboe@redhat.com, Martin Jambor <mjambor@suse.cz>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Denys Vlasenko <dvlasenk@redhat.com>, Thomas Graf <tgraf@suug.ch>, Peter Zijlstra <peterz@infradead.org>, David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@kernel.org>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@qlogic.com>, Jan Hubicka <hubicka@ucw.cz>, "Amir (Jer)" <amir.jer.levy@intel.com>
List-Id: linux-scsi@vger.kernel.org

On Wednesday, June 22, 2016 11:24:50 AM CEST Tomas Winkler wrote:
> On Tue, Jun 21, 2016 at 12:02 PM, Tomas Winkler <tomasw@gmail.com> wrote:
> > On Tue, May 3, 2016 at 9:36 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> >> On Monday 02 May 2016 16:32:25 Andrew Morton wrote:

> >>  #ifdef __HAVE_BUILTIN_BSWAP32__
> >> -#define __swab32(x) __builtin_bswap32((__u32)(x))
> >> +#define __swab32(x) (__u32)__builtin_bswap32((__u32)(x))
> >>  #else
> >>  #define __swab32(x)                            \
> >>         (__builtin_constant_p((__u32)(x)) ?     \
> >
> >>
> >
> > I wonder if this doesn't break switch statement that requires a
> > constant expression, there few cases like this over the kernel.
> >
> > switch(val) {
> > case cpu_to_le32(IXGBE_RXDADV_STAT_FCSTAT_FCPRSP):
> >
> > http://lxr.free-electrons.com/source/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c#L458
> >
> 
> I'm asking because sparse and checkpatch doesn't agree on that ping
> sparse issues
> 'error: bad constant expression'
> When changing to __constant_cpu_to_le32 sparse is happy but
> checkpatch.ps is complaining
> __constant_cpu_to_le32 should be cpu_to_le32
> 

That is an interesting problem, as both seem to be reasonable:
sparse probably doesn't understand __builtin_constant_p() enough,
while avoiding __constant_cpu_to_le32() is a good recommendation
in general.

How many instances of this do you see in the kernel? If ixgbe is the
only one, I'd just move the byteswap up into the switch statement:

	switch (le32_to_cpu(val)) {
	case IXGBE_RXDADV_STAT_FCSTAT_FCPRSP:

which may cost one or two cycles for the non-constant byteswap,
but is also easier to read than the current code.

	Arnd
