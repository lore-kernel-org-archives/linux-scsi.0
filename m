From: Matthew Jacob <mjacob@feral.com>
Subject: Re: [PATCH + RFC] Beginning of some updates to scsi mid layer
Date: Mon, 1 Jul 2002 12:08:03 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.BSF.4.21.0207011205340.62375-100000@beppo>
References: <20020701225037.E3271-100000@localhost.my.domain>
Reply-To: mjacob@feral.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020701225037.E3271-100000@localhost.my.domain>
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-1?Q?G=E9rard_Roudier?= <groudier@free.fr>
Cc: Jeremy Higdon <jeremy@classic.engr.sgi.com>, Doug Ledford <dledford@redhat.com>, Martin Peschke3 <MPESCHKE@de.ibm.com>, Pete Zaitcev <zaitcev@redhat.com>, linux-scsi@vger.kernel.org


> 
> 
> On Fri, 28 Jun 2002, Matthew Jacob wrote:
> 
> > FWIW, Bob Snively (on T10 commitee) has always claimed that the correct
> > response to QUEUE FULL is immediate command resubmission (i.e., *don't* wait
> > for a command to complete (the QFULL may have resulted from commands being
> > processed for *another* initiator), and *don't* a period of time for things to
> > 'get better').
> >
> > I'm not sure  agree with this 100%, but he might have a point.
> 
> My favorite retry handling algorithm looks like this:
> 
> 1) Retry immediately,
> 2) If still fails, retry after some minimal delay T,
> 3) If still fails, retry after delay 2T,
> 4) If still fails, retry after delay 4T,
> *) and so on ... until some maximum value for the delay.
> 
> Even with T being very short, you will never flood. OTOH, a transient
> condition that lasts X will be recovered in not more than 2X.
> 
> BTW, it isn't implemented in the sym drivers, but I use to use such
> algorithm when kind of blind retrying is to be implemented.

Yes, exponential backoff is good in a lot of cases. BTW- this is something I
want to put into cam_periph_error for FreeBSD- I want to make the retry after
selection timeout also have exponential delays up to retry count.

In private mail with Doug && Pete, I managed to put myself into an untenable
position. The problem here is that we don't have end-to-end flow control, so
we have to *guess* when it might be good to try again. 



