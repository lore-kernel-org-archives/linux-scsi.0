From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] scsi: megaraid_sas: Prevent future %p disaster
Date: Tue, 12 May 2015 08:01:23 -0700
Message-ID: <1431442883.2884.59.camel@perches.com>
References: <1423233221-27069-1-git-send-email-linux@rasmusvillemoes.dk>
	 <bb45ec6cfa94612741a2eb355d0de566@mail.gmail.com>
	 <87iobx7uzv.fsf@rasmusvillemoes.dk> <1431442336.2884.57.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1431442336.2884.57.camel@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux390 <linux390@de.ibm.com>
Cc: Eugene Crosser <eugene.crosser@ru.ibm.com>, Frank Blaschka <frank.blaschka@de.ibm.com>, Ursula Braun <ursula.braun@de.ibm.com>, Kashyap Desai <kashyap.desai@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@avagotech.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2015-05-12 at 07:52 -0700, Joe Perches wrote:
> On Tue, 2015-05-12 at 16:04 +0200, Rasmus Villemoes wrote:
> > On Tue, Feb 10 2015, Kashyap Desai <kashyap.desai@avagotech.com> wrote:
> > 
> > > Acked-by: Kashyap Desai <kashyap.desai@avagotech.com>
> > >
> > >> -----Original Message-----
> > >> From: Rasmus Villemoes [mailto:linux@rasmusvillemoes.dk]
> > >> Sent: Friday, February 06, 2015 8:04 PM
> > >> To: Kashyap Desai; Sumit Saxena; Uday Lingala; James E.J. Bottomley
> > >> Cc: Rasmus Villemoes; megaraidlinux.pdl@avagotech.com; linux-
> > >> scsi@vger.kernel.org; linux-kernel@vger.kernel.org
> > >> Subject: [PATCH] scsi: megaraid_sas: Prevent future %p disaster
> > >>
> > >> There is currently no %po format extension, so currently the letters
> > > "on" are
> > >> simply skipped and the pointer is printed as expected (while missing the
> > > word
> > >> on). However, it is probably only a matter of time before someone comes
> > > up
> > >> with a %po extension, at which point this is likely to fail
> > > spectacularly.
> > >>
> > >> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> > 
> > Any chance either this minimal fix or Joe's more thorough cleanup could
> > get applied? There's still no %po extension, but there's certainly a lot
> > of proposals for more %p extensions flying around LKML, so I still think
> > the "only a matter of time" holds.
> 
> There's also this one with %pM6:

And another with %ptail
---
 arch/s390/kernel/perf_cpum_sf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kernel/perf_cpum_sf.c b/arch/s390/kernel/perf_cpum_sf.c
index e6a1578..c0a4b87 100644
--- a/arch/s390/kernel/perf_cpum_sf.c
+++ b/arch/s390/kernel/perf_cpum_sf.c
@@ -205,7 +205,7 @@ static int realloc_sampling_buffer(struct sf_buffer *sfb,
 	 */
 	if (sfb->sdbt != get_next_sdbt(tail)) {
 		debug_sprintf_event(sfdbg, 3, "realloc_sampling_buffer: "
-				    "sampling buffer is not linked: origin=%p"
+				    "sampling buffer is not linked: origin=%p "
 				    "tail=%p\n",
 				    (void *) sfb->sdbt, (void *) tail);
 		return -EINVAL;
