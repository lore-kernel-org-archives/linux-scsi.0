From: Jeremy Higdon <jeremy@classic.engr.sgi.com>
Subject: Re: [PATCH + RFC] Beginning of some updates to scsi mid layer
Date: Fri, 28 Jun 2002 18:19:59 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <10206281819.ZM1024786@classic.engr.sgi.com>
References: <OFED46B639.A6655537-ONC1256BE6.00209712@de.ibm.com>
	<20020628033945.C23044@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: Doug Ledford <dledford@redhat.com>
        "Re: [PATCH + RFC] Beginning of some updates to scsi mid layer" (Jun 28,  3:39am)
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Martin Peschke3 <MPESCHKE@de.ibm.com>
Cc: Pete Zaitcev <zaitcev@redhat.com>, linux-scsi@vger.kernel.org

On Jun 28,  3:39am, Doug Ledford wrote:
> 
> On Fri, Jun 28, 2002 at 08:08:01AM +0200, Martin Peschke3 wrote:
> > as you describe below. This condition results in a starvation
> > of I/O for that particular device. The command which was rejected
> > with QUEUE_FULL is moved into the ml queue and never retried
> > since the mid layer only triggers a retry when another command for
> > that device returns. But there is no other command which
> > could return.
> > We think this needs to be fixed in the ml code (e.g. retry periodically
> > triggered by timer?). Our current workaround is to map QUEUE_FULL
> 
> Yes, the answer to this problem involves a timer.  Basically what I 
> suggest (and do in my driver) is set it so that the driver waits until 
> either A) a command is completed or B) 10ms has passed before sending the 
> command back out, whichever comes first.  Since most drives have had 
> plenty of time to complete one or more commands in 10ms, we assume that 
> even if we haven't got a completion yet that the drive likely has some 
> freed up resources and so we try again.


Do you change the queue depth that you use based on a QUEUE_FULL, then?
If so, then I presume you have some minimum, such as two or four
commands . . . ?

jeremy
