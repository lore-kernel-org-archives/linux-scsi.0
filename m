From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Debugging scsi abort handling ?
Date: Mon, 25 Aug 2014 08:41:39 -0700
Message-ID: <1408981299.17968.27.camel@jarvis.lan>
References: <53F8AAA8.8040407@redhat.com> <53FAE3CA.6060603@redhat.com>
	 <53FAF80D.2070209@redhat.com> <53FB0FE3.80603@acm.org>
	 <53FB1ACD.1040208@redhat.com> <53FB1D4F.5070606@redhat.com>
	 <53FB2083.9000208@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:43748 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754580AbaHYPlp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2014 11:41:45 -0400
In-Reply-To: <53FB2083.9000208@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Hans de Goede <hdegoede@redhat.com>, Bart Van Assche <bvanassche@acm.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 2014-08-25 at 13:39 +0200, Paolo Bonzini wrote:
> Il 25/08/2014 13:26, Hans de Goede ha scritto:
> > Thanks Bart and Paolo, your insights into this are greatly appreciated.
> > 
> > So with uas there are separate usb transaction for cmd, data in, data out
> > and sense for each tag. At the time of abort, usually one of data in / data
> > out and a sense usb transaction will be outstanding.
> > 
> > There already is logic in the driver to kill the data in / out transactions
> > if a sense gets returned (usually with an error) before they are done.
> > 
> > So if I'm reading this correctly, then on a successful abort, the sense
> > transaction (if not already completed by the target) should be cancelled as
> > it will never complete, correct ?
> 
> Yes.  More precisely, once the response IU comes back for the abort,
> there should be no more IUs for that task.  Figure 13 ("Multiple Command
> Example") in the UAS spec actually shows that.
> 
> At least, that's what it should be like in theory.  I suspect firmware
> bugs will abound in this area, but at least you shouldn't be actively
> expecting an IU for an aborted task.

Just a note on this.  The abort area in all devices is where we have
scope for spec compliance issues.  Also in the old days abort itself
could trigger a firmware crash on some devices (including arrays).  The
problem is actually that the system is usually groaning because it's out
of memory within the controller.  That actually means that sending in
another task (the abort) causes greater pressure.  For this reason, some
device drivers choose to skip the abort step and head straight to reset.
For reset, you guarantee that all outstanding tasks for the unit are
killed.

James


