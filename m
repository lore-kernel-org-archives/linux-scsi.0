From: Matthew Jacob <mjacob@feral.com>
Subject: Re: [PATCH + RFC] Beginning of some updates to scsi mid layer
Date: Fri, 28 Jun 2002 19:04:28 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.BSF.4.21.0206281902170.16861-100000@beppo>
References: <10206281819.ZM1024786@classic.engr.sgi.com>
Reply-To: mjacob@feral.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <10206281819.ZM1024786@classic.engr.sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@classic.engr.sgi.com>
Cc: Doug Ledford <dledford@redhat.com>, Martin Peschke3 <MPESCHKE@de.ibm.com>, Pete Zaitcev <zaitcev@redhat.com>, linux-scsi@vger.kernel.org


FWIW, Bob Snively (on T10 commitee) has always claimed that the correct
response to QUEUE FULL is immediate command resubmission (i.e., *don't* wait
for a command to complete (the QFULL may have resulted from commands being
processed for *another* initiator), and *don't* a period of time for things to
'get better').

I'm not sure  agree with this 100%, but he might have a point.

On Fri, 28 Jun 2002, Jeremy Higdon wrote:

> On Jun 28,  3:39am, Doug Ledford wrote:
> > 
> > On Fri, Jun 28, 2002 at 08:08:01AM +0200, Martin Peschke3 wrote:
> > > as you describe below. This condition results in a starvation
> > > of I/O for that particular device. The command which was rejected
> > > with QUEUE_FULL is moved into the ml queue and never retried
> > > since the mid layer only triggers a retry when another command for
> > > that device returns. But there is no other command which
> > > could return.
> > > We think this needs to be fixed in the ml code (e.g. retry periodically
> > > triggered by timer?). Our current workaround is to map QUEUE_FULL
> > 
> > Yes, the answer to this problem involves a timer.  Basically what I 
> > suggest (and do in my driver) is set it so that the driver waits until 
> > either A) a command is completed or B) 10ms has passed before sending the 
> > command back out, whichever comes first.  Since most drives have had 
> > plenty of time to complete one or more commands in 10ms, we assume that 
> > even if we haven't got a completion yet that the drive likely has some 
> > freed up resources and so we try again.
> 
> 
> Do you change the queue depth that you use based on a QUEUE_FULL, then?
> If so, then I presume you have some minimum, such as two or four
> commands . . . ?
> 
> jeremy
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

