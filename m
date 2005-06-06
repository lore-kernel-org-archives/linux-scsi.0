From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: SCSI commands order when using scsi_do_req
Date: Mon, 06 Jun 2005 09:32:53 -0500
Message-ID: <1118068373.5045.25.camel@mulgrave>
References: <OFDF05D602.08E5F1FA-ONC2257018.002E3CA5-C2257018.002EF1DD@il.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:60381 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261473AbVFFOc5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Jun 2005 10:32:57 -0400
In-Reply-To: <OFDF05D602.08E5F1FA-ONC2257018.002E3CA5-C2257018.002EF1DD@il.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Liran Schour <LIRANS@il.ibm.com>
Cc: Douglas Gilbert <dougg@torque.net>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-scsi-owner@vger.kernel.org

On Mon, 2005-06-06 at 11:32 +0300, Liran Schour wrote:
> In order to run our OSD SCSI initiator on top of the Linux SCSI layer
> we have needed to do the following changes to the SCSI code:
> 1. Redefine MAX_COMMAND_SIZE to 256 byte.

There's more than just you interested in this one, so separating this
feature out from all the rest would be helpful.

> 2. Define a new scatter gather structures that includes two virtual buffers
>    on for data out and one for data in. (implementing bidirectional
> commands)
>    The SCSI middle layer doesn't now this new structure (only ULD and LLD).

Yes, this is the nasty one ... and why OSD hasn't been incredibly
popular; bidirectional commands necessitate fairly sweeping changes to
all LLDs to support.  However, I don't see how we can get away without
the mid-layer knowing, since it's the entity that constructs the sglists
and the sglists have to be separated between the in and out pieces.

> 3. The problem above - define a new scsi_do_req that inserts our commands
> to
>    the tail of the Q.

Well, the solution, I think, is going to be the block execute one, which
will allow head or tail insertion.

James


