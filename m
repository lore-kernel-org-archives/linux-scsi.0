From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH + RFC] Beginning of some updates to scsi mid layer
Date: Fri, 28 Jun 2002 03:39:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020628033945.C23044@redhat.com>
References: <OFED46B639.A6655537-ONC1256BE6.00209712@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <OFED46B639.A6655537-ONC1256BE6.00209712@de.ibm.com>; from MPESCHKE@de.ibm.com on Fri, Jun 28, 2002 at 08:08:01AM +0200
List-Id: linux-scsi@vger.kernel.org
To: Martin Peschke3 <MPESCHKE@de.ibm.com>
Cc: Jeremy Higdon <jeremy@classic.engr.sgi.com>, Pete Zaitcev <zaitcev@redhat.com>, linux-scsi@vger.kernel.org

On Fri, Jun 28, 2002 at 08:08:01AM +0200, Martin Peschke3 wrote:
> as you describe below. This condition results in a starvation
> of I/O for that particular device. The command which was rejected
> with QUEUE_FULL is moved into the ml queue and never retried
> since the mid layer only triggers a retry when another command for
> that device returns. But there is no other command which
> could return.
> We think this needs to be fixed in the ml code (e.g. retry periodically
> triggered by timer?). Our current workaround is to map QUEUE_FULL

Yes, the answer to this problem involves a timer.  Basically what I 
suggest (and do in my driver) is set it so that the driver waits until 
either A) a command is completed or B) 10ms has passed before sending the 
command back out, whichever comes first.  Since most drives have had 
plenty of time to complete one or more commands in 10ms, we assume that 
even if we haven't got a completion yet that the drive likely has some 
freed up resources and so we try again.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
