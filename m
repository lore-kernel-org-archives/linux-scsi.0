From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [SCSI] qla2xxx: Question about out-of-order SCSI command processing
Date: Tue, 03 Dec 2013 13:26:13 +0100
Message-ID: <529DCDE5.6010304@acm.org>
References: <CAB-428kfuWWGDhciGTAy6OCZr8ACBh52_iebBd8U4gwN0S7GPA@mail.gmail.com> <1386027526.2014.2.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 87.238.162.66 ([87.238.162.66]:36993 "EHLO smtpgw.stone-is.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752865Ab3LCM0R (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Dec 2013 07:26:17 -0500
In-Reply-To: <1386027526.2014.2.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Alireza Haghdoost <alireza@cs.umn.edu>
Cc: linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-driver@qlogic.com, Jerry Fredin <jerry.fredin@netapp.com>

On 12/03/13 00:38, James Bottomley wrote:
> Well this would be because we don't guarantee order at any granularity
> below barriers.  We won't reorder across barriers but below them we can
> reorder the commands and, of course, we use simple tags for queuing
> which entitles the underlying storage hardware to reorder within its
> internal queue.  Previously, when everything was single threaded issue,
> you mostly got FIFO behaviour because reorder really only occurred on
> error or busy, but I would imagine that's changing now with multiqueue.

Reordering SCSI commands was fine as long as hard disks were the only
supported storage medium. This is because most hard disk controllers do
not perform writes in the order these writes are submitted to their
controller. However, with several SSD models it is possible to tell the
controller to preserve write order. Furthermore, the optimizations that
are possible by using atomic writes are only safe if it is guaranteed
that none of the layers between the application and the SCSI target
changes the order in which an application submitted these atomic writes.
In other words, although it was safe in the past to reorder the writes
submitted between two successive barriers such reordering would
eliminate several of the benefits of atomic writes. A quote from the
draft SCSI atomics specification
(http://www.t10.org/cgi-bin/ac.pl?t=d&f=13-064r7.pdf):
<quote>
Atomic writes may:
  a) increase write endurance
    A) reducing writes increases the life of a flash-based SSD
  b) increase performance
    A) reducing writes results in fewer system calls, fewer I/Os over
       the SCSI transport protocol, and fewer interrupts
  c) improve reliability for non-journaled data
  d) simplify applications
    A) reduce or eliminate journaling
    B) keep applications from managing atomicity
</quote>

Bart.

