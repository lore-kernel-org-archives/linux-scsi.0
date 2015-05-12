From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] scsi: megaraid_sas: Prevent future %p disaster
Date: Tue, 12 May 2015 07:52:16 -0700
Message-ID: <1431442336.2884.57.camel@perches.com>
References: <1423233221-27069-1-git-send-email-linux@rasmusvillemoes.dk>
	 <bb45ec6cfa94612741a2eb355d0de566@mail.gmail.com>
	 <87iobx7uzv.fsf@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87iobx7uzv.fsf@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>, Eugene Crosser <eugene.crosser@ru.ibm.com>, Frank Blaschka <frank.blaschka@de.ibm.com>, Ursula Braun <ursula.braun@de.ibm.com>
Cc: Kashyap Desai <kashyap.desai@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@avagotech.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2015-05-12 at 16:04 +0200, Rasmus Villemoes wrote:
> On Tue, Feb 10 2015, Kashyap Desai <kashyap.desai@avagotech.com> wrote:
> 
> > Acked-by: Kashyap Desai <kashyap.desai@avagotech.com>
> >
> >> -----Original Message-----
> >> From: Rasmus Villemoes [mailto:linux@rasmusvillemoes.dk]
> >> Sent: Friday, February 06, 2015 8:04 PM
> >> To: Kashyap Desai; Sumit Saxena; Uday Lingala; James E.J. Bottomley
> >> Cc: Rasmus Villemoes; megaraidlinux.pdl@avagotech.com; linux-
> >> scsi@vger.kernel.org; linux-kernel@vger.kernel.org
> >> Subject: [PATCH] scsi: megaraid_sas: Prevent future %p disaster
> >>
> >> There is currently no %po format extension, so currently the letters
> > "on" are
> >> simply skipped and the pointer is printed as expected (while missing the
> > word
> >> on). However, it is probably only a matter of time before someone comes
> > up
> >> with a %po extension, at which point this is likely to fail
> > spectacularly.
> >>
> >> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> 
> Any chance either this minimal fix or Joe's more thorough cleanup could
> get applied? There's still no %po extension, but there's certainly a lot
> of proposals for more %p extensions flying around LKML, so I still think
> the "only a matter of time" holds.

There's also this one with %pM6:
---
 drivers/s390/net/qeth_l2_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 0ea0869..dc783047 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -1420,8 +1420,8 @@ static void qeth_bridge_emit_host_event(struct qeth_card *card,
 			env[i] = str[i]; i++;
 		}
 		if (code & IPA_ADDR_CHANGE_CODE_MACADDR) {
-			snprintf(str[i], sizeof(str[i]), "MAC=%pM6",
-				&addr_lnid->mac);
+			snprintf(str[i], sizeof(str[i]), "MAC=%pM",
+				addr_lnid->mac);
 			env[i] = str[i]; i++;
 		}
 		snprintf(str[i], sizeof(str[i]), "NTOK_BUSID=%x.%x.%04x",
