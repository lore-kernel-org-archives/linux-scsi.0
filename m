From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [PATCH/RFT] mode sense madness always use page 8
Date: 31 Oct 2003 13:38:21 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1067632701.5742.45.camel@patrh9>
References: <20031030100501.A7250@beaverton.ibm.com>
	 <Pine.LNX.4.44L0.0310301351380.1440-100000@ida.rowland.org>
	 <20031030112621.A7844@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:1176 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S263553AbTJaUi6
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Oct 2003 15:38:58 -0500
In-Reply-To: <20031030112621.A7844@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: patmans@us.ibm.com
Cc: stern@rowland.harvard.edu, ronald@kuetemeier.com, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net, james.bottomley@steeleye.com

> > __scsi_mode_sense() ...
> ...
> per Pat L's comment, should we decrement the len by four if going from
> MODE SENSE 10 to MODE SENSE? Or request four more bytes than required?

I've seen no answer here yet, so I figured I'd volunteer a little more
study myself, so now I ask:

Tell me again what we think __scsi_mode_sense does?

Am I correct to guess by intent __scsi_mode_sense does a complete job of
hiding the op x1A MODE_SENSE vs. op x5A MODE_SENSE_10 choice only if the
caller ignores the content of the buffer after the call, choosing
instead to interpret only the struct scsi_mode_data?

Supposing that's correct, then I vote we zero the buffer after copying
its bits into the struct scsi_mode_data.

Meanwhile, from that perspective, we say we bother to pass the dbd,
modepage, len parms into __scsi_mode_sense only to guess at specifically
what combination of sreq->sr_cmnd sr_cmd_len sr_bufflen might work.

Since we offer only one set of guesses, no matter
sreq->sr_device->use_10_for_ms, then yes, we have to reduce our guess by
four if we substitute op x1A MODE_SENSE for op x5A MODE_SENSE_10, else
our guesses are not consistent - not orthogonal vs. use_10_for_ms.

Ouch that doesn't sound like a 2.6.0 change necessary enough to pass
review, does it?

> __scsi_mode_sense() ...

I see { unsigned char cmd[12]; } there.  We mean 16, right?

I argue by way of seeing { memcpy(sreq->sr_cmnd, cmnd,
sizeof(sreq->sr_cmnd)); } in scsi_do_req.  I conclude we need sizeof
*cmnd to meet or exceed sizeof(sreq->sr_cmnd), thus same for
scsi_wait_req.  include/scsi/scsi_request.h tells me that size is
MAX_COMMAND_SIZE, possibly the 16 seen in include/scsi/scsi_cmnd.h.

I guess we're getting away with what we've got because we're mostly
using gcc in places where copying more than exists out of a local
variable picks up some extra stack that has already been allocated,
rather than double-faulting by trying to grow stack while talking scsi
to the paging device.

Pat LaVarre


