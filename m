From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] definitive abstraction of the mode_sense commands
Date: Tue, 24 Jun 2003 18:10:29 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EF80775.9020105@torque.net>
References: <1056429111.2887.173.camel@mulgrave>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:56081 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S264075AbTFXH4b
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jun 2003 03:56:31 -0400
In-Reply-To: <1056429111.2887.173.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:

> +/**	scsi_do_mode_sense - issue a mode sense, falling back from 10 to 
> + *		six bytes if necessary.
> + *	@SRpnt:	SCSI request to fill in with the MODE_SENSE
> + *	@dbd:	set if mode sense will allow block descriptors to be returned

"A DBD bit of one specifies that the device server shall
not return any block descriptors in the returned MODE SENSE
data" [SPC-3 rev 13]. So that description of @dbd seems
inverted.

 > # Note: Requestors of the Block Descriptors now must pay attention
 > # to the longlba flag

The longlba flag can only be set in the "mode parameter
header(10)" if the LLBAA bit is set in the corresponding
MODE SENSE(10) command [ref: SPC-3 rev 13 MODE SENSE(10)
command (section 6.10)]. Your code doesn't set LLBAA so
there should be no reason to check the longlba flag.


For really depraved devices it can be useful to send a
MODE SENSE(6 or 10) that only asks for a 4 byte response. From
this response the length of the respone that can be supplied
is deduced. Then a second MODE SENSE can be
issued for the now known response length. Yes, it's
horrible, but that is precisely what Joerg Schilling
does in cdrecord.
Your code seems to have this technique in mind but requires
a MODE SENSE(10) response buffer to be at least 8 bytes long.

Doug Gilbert

