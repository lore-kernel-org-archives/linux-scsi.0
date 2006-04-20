From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH 1/2] SCSI: implement scsi_eh_schedule_cmd()
Date: Thu, 20 Apr 2006 12:23:57 -0700 (PDT)
Message-ID: <20060420192357.26257.qmail@web31814.mail.mud.yahoo.com>
References: <4446ECCF.7080000@gmail.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31814.mail.mud.yahoo.com ([68.142.206.167]:56695 "HELO
	web31814.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1750861AbWDTTX6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Apr 2006 15:23:58 -0400
In-Reply-To: <4446ECCF.7080000@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Jeff Garzik <jgarzik@pobox.com>, hch@lst.de, James.Bottomley@SteelEye.com, alan@lxorguk.ukuu.org.uk, albertcc@tw.ibm.com, arjan@infradead.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

--- Tejun Heo <htejun@gmail.com> wrote:
> Hmmm.. libata isn't SCSI.  It's just hitch-hiking on the back of SCSI at 
> the moment.  And, being able to invoke EH on the host directly makes 
> things a lot simpler for libata.  So, what do you think about just 
> adding shost->host_eh_scheduled, adding a condition to 
> scsi_error_handler() and export scsi_eh_wakeup()?  The changes will be 
> like three lines.  And, also, ->host_eh_scheduled can be marked as hack 
> for libata.  libata can handle the rest.

Hi Tejun,

I don't mind such a patch.  It is well defined -- all you want is
process (ER) context to do some hw/proto ER work.  Clearly the architecture
of libata doesn't allow for protocol/hw work in a process as we'd discussed,
and so I think such a small patch would be completely ok to make the rest
of your work go through.

> This may not be the most graceful thing to do but...
> 
> 1. SCSI change is minimal

I think this is a good thing, and for clearly understood and well defined
solutions we want patches to be small.  Your architecural SATA layer work
can be as big as it needs to be and I think you're doing an excellent
job -- FWIW, if it hadn't been for your patches, a lot of things would
be pretty stagnant in libata, SCSI and the block layer.

> 2. it's a temporary measure (moving libata out of SCSI is one of the 
> items on my agenda and if no one else does it I'm gonna give a shot at 
> it in not-so-distant future.  Once libata is gone of SCSI, the three 
> lines can be removed.)

You are a very, very smart person to want to move libata out of SCSI.
It is very unfortunate, but I clearly understand why you'd want to do
it.

> 3. It will take a lot more work to achieve the same thing in libata 
> proper without the three line change.
> 
> Luben, what do you think?

I think it sounds good.

Good luck!
       Luben

P.S.  Remember what we'd discussed earlier, if you can offload something
to command ER or device ER, do it!  It will save you a lot of special
cases, IRQ/process context jungle, and differing paths and races.

Don't you mind that if a command fails, you know that all of them
queued commands would have to get zapped and that the device would probably
have to be reset.  Just call scsi_req_abort_cmd() and do that abstraction
later in process context when it calls your ER routine.

