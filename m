From: =?ISO-8859-1?Q?G=E9rard_Roudier?= <groudier@free.fr>
Subject: Re: [PATCH + RFC] Beginning of some updates to scsi mid layer
Date: Mon, 1 Jul 2002 23:02:24 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020701225037.E3271-100000@localhost.my.domain>
References: <Pine.BSF.4.21.0206281902170.16861-100000@beppo>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <Pine.BSF.4.21.0206281902170.16861-100000@beppo>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Jacob <mjacob@feral.com>
Cc: Jeremy Higdon <jeremy@classic.engr.sgi.com>, Doug Ledford <dledford@redhat.com>, Martin Peschke3 <MPESCHKE@de.ibm.com>, Pete Zaitcev <zaitcev@redhat.com>, linux-scsi@vger.kernel.org



On Fri, 28 Jun 2002, Matthew Jacob wrote:

> FWIW, Bob Snively (on T10 commitee) has always claimed that the corre=
ct
> response to QUEUE FULL is immediate command resubmission (i.e., *don'=
t* wait
> for a command to complete (the QFULL may have resulted from commands =
being
> processed for *another* initiator), and *don't* a period of time for =
things to
> 'get better').
>
> I'm not sure  agree with this 100%, but he might have a point.

My favorite retry handling algorithm looks like this:

1) Retry immediately,
2) If still fails, retry after some minimal delay T,
3) If still fails, retry after delay 2T,
4) If still fails, retry after delay 4T,
*) and so on ... until some maximum value for the delay.

Even with T being very short, you will never flood. OTOH, a transient
condition that lasts X will be recovered in not more than 2X.

BTW, it isn't implemented in the sym drivers, but I use to use such
algorithm when kind of blind retrying is to be implemented.

  G=E9rard.

> On Fri, 28 Jun 2002, Jeremy Higdon wrote:
>
> > On Jun 28,  3:39am, Doug Ledford wrote:
> > >
> > > On Fri, Jun 28, 2002 at 08:08:01AM +0200, Martin Peschke3 wrote:
> > > > as you describe below. This condition results in a starvation
> > > > of I/O for that particular device. The command which was reject=
ed
> > > > with QUEUE_FULL is moved into the ml queue and never retried
> > > > since the mid layer only triggers a retry when another command =
for
> > > > that device returns. But there is no other command which
> > > > could return.
> > > > We think this needs to be fixed in the ml code (e.g. retry peri=
odically
> > > > triggered by timer?). Our current workaround is to map QUEUE_FU=
LL
> > >
> > > Yes, the answer to this problem involves a timer.  Basically what=
 I
> > > suggest (and do in my driver) is set it so that the driver waits =
until
> > > either A) a command is completed or B) 10ms has passed before sen=
ding the
> > > command back out, whichever comes first.  Since most drives have =
had
> > > plenty of time to complete one or more commands in 10ms, we assum=
e that
> > > even if we haven't got a completion yet that the drive likely has=
 some
> > > freed up resources and so we try again.
> >
> >
> > Do you change the queue depth that you use based on a QUEUE_FULL, t=
hen?
> > If so, then I presume you have some minimum, such as two or four
> > commands . . . ?
> >
> > jeremy
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-scs=
i" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
