From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH 1/2] SCSI: implement scsi_eh_schedule_cmd()
Date: Wed, 19 Apr 2006 11:49:16 -0700 (PDT)
Message-ID: <20060419184916.22608.qmail@web31809.mail.mud.yahoo.com>
References: <443F8F41.1060002@gmail.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31809.mail.mud.yahoo.com ([68.142.207.72]:18082 "HELO
	web31809.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1751085AbWDSStT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Apr 2006 14:49:19 -0400
In-Reply-To: <443F8F41.1060002@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Jeff Garzik <jgarzik@pobox.com>, hch@lst.de, James.Bottomley@SteelEye.com, alan@lxorguk.ukuu.org.uk, albertcc@tw.ibm.com, arjan@infradead.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

Hi Tejun,

--- Tejun Heo <htejun@gmail.com> wrote:
> So, what's your suggestion here?  Do you think libata should do such 
> things with its own mechanism?

Your instinct is correct.  Anything between I and T, as in I_T, is SDS
domain.  That is, SAM doesn't have a _context_ for anything between the I and T.
(In SATA's case I_T_L, of course.)

So this is why you shouldn't call SCSI's ER without context, as in "Hey,
neither command, nor device is broken, but do some ER for me."  Such work belongs
in your SATA Layer, unless either a device or command is involved, as we discussed.

Handle protocol ER in your SATA layer.  Note however that most of your ER could
be done on behalf of a command or device, since of course, a device or command(s)
end up being affected.  Basically "do as little as possible but no less" technique.

Good luck!
     Luben


