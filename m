From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: SCSI reserve / release support for SG
Date: Fri, 14 Nov 2003 09:05:30 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031114170530.GC3322@beaverton.ibm.com>
References: <3FB4BC92.D43703BE@in.ibm.com> <3FB4C85C.9020907@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:19680 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S262776AbTKNRB6
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Nov 2003 12:01:58 -0500
Content-Disposition: inline
In-Reply-To: <3FB4C85C.9020907@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Sachin Sant <sachinp@in.ibm.com>, linux-scsi@vger.kernel.org

Douglas Gilbert [dougg@torque.net] wrote:
> >If not then are there any plans to support reserve/release SCSI command
> >so that sg driver can provide these options for its users in its
> >open/close function  It will make all I/O operation with sg driver more
> >reliable especially in data storage area.
> 
> I'm getting this request from several angles. As someone
> wryly pointed out ... as if we haven't got enough trouble
> at the moment with the scsi subsystem implicitly issuing
> scsi commands :-)

Yes, a sub question in the following bugme bug also asks this question.
http://bugme.osdl.org/show_bug.cgi?id=1488

> 
> Seriously, I don't think issuing reserve/release SCSI commands
> on the open and close of a pass-through interface is a good
> idea. At a stretch it could be a non-default parameter on the
> sg driver [lk 2.4 via /proc/scsi/sg; in lk 2.6 ...]
> 

Doing a reserve operation on open is more than sg doing some action as
device state could have been altered without sg or any upper level
driver knowing about. This could cause a case where the reservation
would be lost, but upper level drivers would not be notified. I guess
you could use persistent reserves, but then you would need another
parameter for the key. If we need to do these actions plus revoking /
breaking reservations what is the gain of sg doing this on open vs.
doing this in user space. In theory I guess a device mapper target could
be created if someone was opposed to a user space daemon (this is just a
quick thought with very little investigation).

IIRC when updates where happening for scsi_error in relation to door
lock someone suggested that we need a general machanism to indicate what
state the device is in and restore it post recovery.

-andmike
--
Michael Anderson
andmike@us.ibm.com

