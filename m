From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: Debugging scsi abort handling ?
Date: Mon, 25 Aug 2014 13:39:47 +0200
Message-ID: <53FB2083.9000208@redhat.com>
References: <53F8AAA8.8040407@redhat.com> <53FAE3CA.6060603@redhat.com> <53FAF80D.2070209@redhat.com> <53FB0FE3.80603@acm.org> <53FB1ACD.1040208@redhat.com> <53FB1D4F.5070606@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37572 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753795AbaHYLjv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2014 07:39:51 -0400
In-Reply-To: <53FB1D4F.5070606@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>, Bart Van Assche <bvanassche@acm.org>, SCSI development list <linux-scsi@vger.kernel.org>

Il 25/08/2014 13:26, Hans de Goede ha scritto:
> Thanks Bart and Paolo, your insights into this are greatly appreciated.
> 
> So with uas there are separate usb transaction for cmd, data in, data out
> and sense for each tag. At the time of abort, usually one of data in / data
> out and a sense usb transaction will be outstanding.
> 
> There already is logic in the driver to kill the data in / out transactions
> if a sense gets returned (usually with an error) before they are done.
> 
> So if I'm reading this correctly, then on a successful abort, the sense
> transaction (if not already completed by the target) should be cancelled as
> it will never complete, correct ?

Yes.  More precisely, once the response IU comes back for the abort,
there should be no more IUs for that task.  Figure 13 ("Multiple Command
Example") in the UAS spec actually shows that.

At least, that's what it should be like in theory.  I suspect firmware
bugs will abound in this area, but at least you shouldn't be actively
expecting an IU for an aborted task.

> I wish the uas spec contained some more details on this, but it is very
> vague wrt task management (well it is vague in general, task management just
> is extra hard to test).

That may complicate usage of the spec, but it's not necessarily a bad
thing; a SCSI transport should heavily rely on the SCSI architecture and
thus the SAM spec, and vagueness can be a hint that the transport was
done right.

Paolo

