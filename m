From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [SAS ANNOUNCEMENT] MPT Fusion driver 3.02.07.02 update
Date: 15 Nov 2004 12:00:44 -0600
Message-ID: <1100541651.1765.194.camel@mulgrave>
References: <91888D455306F94EBD4D168954A9457C3FF742@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:30621 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261645AbUKOSA6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Nov 2004 13:00:58 -0500
In-Reply-To: <91888D455306F94EBD4D168954A9457C3FF742@nacos172.co.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>, Jens Axboe <axboe@suse.de>

On Fri, 2004-11-12 at 17:15, Moore, Eric Dean wrote:
> Highlights for this release:
> 
> In addition to SAS support =>
> 

Actually, before we begin on a SAS implementation, I'd rather like us to
get the architecture and design correct.  Reading all the SAS and SATA
documentation is still on my todo list.  However, this is my brief take
on the architecture:

SAS itself is a bit of a monster because the PHY layer characteristics
are identical to those of SATA.  Therefore, it seems like we need two
separate transport classes, one for the PHY layer which would control
the PHY transport characteristics and would be shareable with SATA and
one for SAS only which would cover a large swath of the SAS specific
ioctls and the useful bits of CMSI.

As far as the controller and expander protocols to which Doug Gilbert
has been referring, I really have no current idea how to do them, but if
anyone else does now would be a good time to say something.

So does the above look like an acceptable way to move forward? (having a
PHY transport class is going to mean changes in both SCSI and SATA and
probably block as well, since this may ultimately not be a SCSI specific
transport class).

James


