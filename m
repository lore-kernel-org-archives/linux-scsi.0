From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH + RFC] Beginning of some updates to scsi mid layer
Date: Sat, 29 Jun 2002 06:10:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020629061008.A23924@redhat.com>
References: <OFED46B639.A6655537-ONC1256BE6.00209712@de.ibm.com> <20020628033945.C23044@redhat.com> <dledford@redhat.com> <10206281819.ZM1024786@classic.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <10206281819.ZM1024786@classic.engr.sgi.com>; from jeremy@classic.engr.sgi.com on Fri, Jun 28, 2002 at 06:19:59PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@classic.engr.sgi.com>
Cc: Martin Peschke3 <MPESCHKE@de.ibm.com>, Pete Zaitcev <zaitcev@redhat.com>, linux-scsi@vger.kernel.org

On Fri, Jun 28, 2002 at 06:19:59PM -0700, Jeremy Higdon wrote:
> On Jun 28,  3:39am, Doug Ledford wrote:
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

There is a minimum (I think it's 8).  But, more importantly, I only adjust 
the queue depth if the QUEUE_FULL messages always come at some exact 
depth.  If the drive returns QUEUE_FULLs at differing depths, then we 
assume it's a resource shortage that causes it and that reducing the queue 
depth won't necessarily help.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
