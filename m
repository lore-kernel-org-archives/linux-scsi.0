From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Bad reactions to QUEUE FULL
Date: 30 Apr 2003 09:58:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1051714713.1818.32.camel@mulgrave>
References: <20030429220259.A13386@jose.vato.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:37639 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262188AbTD3Oqu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Apr 2003 10:46:50 -0400
In-Reply-To: <20030429220259.A13386@jose.vato.org>
List-Id: linux-scsi@vger.kernel.org
To: Tim Pepper <tpepper@vato.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Mike Anderson <andmike@us.ibm.com>, Jens Axboe <axboe@suse.de>, olh@suse.de

On Wed, 2003-04-30 at 00:02, Tim Pepper wrote:
> Anybody interested in having a look at this or is it a known issue?

Actually, I'd be most interested in knowing what the problem is that the
patch solves.

The "old" fields (and all inconsistently named) are designed to keep a
copy of the original command for when the actual command gets re-used. 
This re-use happens in the error handler (to get sense, send TURs etc)
and sometimes in the device drivers if they simulate ACA).  Everything
that replaces the command is supposed to copy the old one back after
it's finished using it.

However, QUEUE FULL is a status return, not a sense code, so any command
that gets QUEUE FULL should be an original command, and thus not need
the fields replacing.  Even more curious, if the command were replaced,
then more fields than just the data direction would need putting back.

A viable theory seems to be that the drivers (qlogic and emulex) change
the sc_data_direction field for their own purposes and forget to restore
it again.  I don't have the source, so I can't check this.

Does anyone have any other theories?

James


