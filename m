From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH + RFC] Beginning of some updates to scsi mid layer
Date: Sat, 29 Jun 2002 06:05:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020629060509.A23827@redhat.com>
References: <10206281819.ZM1024786@classic.engr.sgi.com> <Pine.BSF.4.21.0206281902170.16861-100000@beppo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.BSF.4.21.0206281902170.16861-100000@beppo>; from mjacob@feral.com on Fri, Jun 28, 2002 at 07:04:28PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Matthew Jacob <mjacob@feral.com>
Cc: Jeremy Higdon <jeremy@classic.engr.sgi.com>, Martin Peschke3 <MPESCHKE@de.ibm.com>, Pete Zaitcev <zaitcev@redhat.com>, linux-scsi@vger.kernel.org

On Fri, Jun 28, 2002 at 07:04:28PM -0700, Matthew Jacob wrote:
> 
> FWIW, Bob Snively (on T10 commitee) has always claimed that the correct
> response to QUEUE FULL is immediate command resubmission (i.e., *don't* wait
> for a command to complete (the QFULL may have resulted from commands being
> processed for *another* initiator), and *don't* a period of time for things to
> 'get better').
> 
> I'm not sure  agree with this 100%, but he might have a point.

No, absolutely not!  Faster drivers are capable of restarting commands on 
the bus so fast that in this scenario they can flood the bus with 
selection, command, queue full sequences and not allow *any* commands to 
complete because the bus is always tied up (this was, in fact, one of the 
reasons that I had to put the queue handling code in the aic7xxx driver 
when I did).

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
