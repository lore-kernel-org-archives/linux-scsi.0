From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] iscsi-target merge for v3.1-rc1
Date: Mon, 25 Jul 2011 16:46:03 -0700
Message-ID: <CA+55aFyJrw5jOjMz5q1upL9TiSRN5CLcHZgo6DTRNyiUytta4w@mail.gmail.com>
References: <1311462975.31450.356.camel@haakon2.linux-iscsi.org> <20110725163739.5c19b04d.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110725163739.5c19b04d.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Andy Grover <agrover@redhat.com>, Hannes Reinecke <hare@suse.de>, Roland Dreier <roland@purestorage.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Boaz Harrosh <openosd@gmail.com>, Mike Christie <michaelc@cs.wisc.edu>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jul 25, 2011 at 4:37 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Sat, 23 Jul 2011 16:16:15 -0700
> "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
>
>> Please go ahead and pull from:
>>
>> =A0 master.kernel.org:/pub/scm/linux/kernel/git/nab/target-pending.g=
it for-linus-merge
>
> i386 allyesconfig:
>
> ERROR: "__udivdi3" [drivers/target/target_core_mod.ko] undefined!
>
> somewhere in drivers/target/target_core_transport.c:transport_allocat=
e_data_tasks().

=2E. looks like somebody isn't doing a "sector_div()" for a sector_t.

Nicholas: full 64-bit divides are dog slow on most 32-bit targets, and
gcc is very iffy at doing a 64/32->32 divide (or even a 64/32->64 one,
which is still much faster than the full 64/64->64 one). So we very
much on purpose don't allow for __udivdi3 (which is gcc-speak for that
out-of-line "64/64->64" operation), so it generates link-time errors.

Note the odd semantics for sector_div():

  sector_div(a,b)

basically does a "a =3D a/b" (and then returns the remainder, but nobod=
y
uses it and maybe we should skip that part).

                   Linus
