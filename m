From: Liran Schour <LIRANS@il.ibm.com>
Subject: Re: SCSI commands order when using scsi_do_req
Date: Tue, 7 Jun 2005 12:27:43 +0300
Message-ID: <OF63652C86.E1AD8161-ONC2257019.00335C96-C2257019.0033F9E7@il.ibm.com>
References: <1118068373.5045.25.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:26037 "EHLO
	mtagate4.de.ibm.com") by vger.kernel.org with ESMTP id S261817AbVFGJb6
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Jun 2005 05:31:58 -0400
In-Reply-To: <1118068373.5045.25.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Douglas Gilbert <dougg@torque.net>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-scsi-owner@vger.kernel.org






James Bottomley <James.Bottomley@SteelEye.com> wrote on 06/06/2005
17:32:53:

> On Mon, 2005-06-06 at 11:32 +0300, Liran Schour wrote:
> > In order to run our OSD SCSI initiator on top of the Linux SCSI layer
> > we have needed to do the following changes to the SCSI code:
> > 1. Redefine MAX_COMMAND_SIZE to 256 byte.
>
> There's more than just you interested in this one, so separating this
> feature out from all the rest would be helpful.
>
> > 2. Define a new scatter gather structures that includes two virtual
buffers
> >    on for data out and one for data in. (implementing bidirectional
> > commands)
> >    The SCSI middle layer doesn't now this new structure (only ULD and
LLD).
>
> Yes, this is the nasty one ... and why OSD hasn't been incredibly
> popular; bidirectional commands necessitate fairly sweeping changes to
> all LLDs to support.  However, I don't see how we can get away without
> the mid-layer knowing, since it's the entity that constructs the sglists
> and the sglists have to be separated between the in and out pieces.
>
In our driver we build both sg lists ( IN and OUT) in the OSD driver (ULD)
and send it
to the middlayer via scsi_do_req.

- Liran

