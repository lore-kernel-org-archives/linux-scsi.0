From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: BUG in sas event handling mechanism???
Date: Fri, 22 Sep 2006 11:47:47 -0700 (PDT)
Message-ID: <20060922184747.18919.qmail@web31805.mail.mud.yahoo.com>
References: <20060922174046.GA18715@us.ibm.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31805.mail.mud.yahoo.com ([68.142.207.68]:18094 "HELO
	web31805.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1750746AbWIVSrs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Sep 2006 14:47:48 -0400
In-Reply-To: <20060922174046.GA18715@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: malahal@us.ibm.com, linux-scsi@vger.kernel.org

--- malahal@us.ibm.com wrote:
> I see a PORTE_BYTES_DMAED event, followed by a PHYE_LOSS_OF_SIGNAL event
> and then followed by a PORTE_BYTES_DMAED event on the same phy. The code
> seems to just drop the last event because of the not yet processed first
> event. So, it just processes the first two events in that order. In
> other words, the link doesn't get used at all!

Hi Malahal,

This is of course wrong and the original SAS Stack as written by me
doesn't process this in the way you outlined above, and doesn't lose
*any* events.  In the above example, the device is _properly discovered_.

You should hold Bottomley and LTC directly responsible for this.
Not "someone" or "the community".

Here are their patches directy responsible for this:
Bottomley: http://marc.theaimsgroup.com/?l=linux-scsi&m=114218113500117&w=2
Bruemmer: http://marc.theaimsgroup.com/?l=linux-scsi&m=114235935625301&w=2
Bruemmer: http://marc.theaimsgroup.com/?l=linux-scsi&m=114721079722569&w=2

> Of course, I get timeouts because of Vitesse/AIC94xx combination while
> doing discovery. :-(

Don't blame the hardware.  Software should be robust enough to handle
the worst cases, in fact any case.

> Maybe, this is what Luben is talking about when he said,
> "Priority Queue Without Duplication Implementation"?

Yes.

Good luck Malahal!
      Luben

