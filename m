From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: requeuing a Scsi_Cmnd?
Date: 12 May 2003 15:30:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1052771428.2093.94.camel@mulgrave>
References: <3EBEB1D5.3040300@pobox.com>
	<1052750688.1769.27.camel@mulgrave>  <3EBFE408.4010607@rogers.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:22278 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262563AbTELURu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 May 2003 16:17:50 -0400
In-Reply-To: <3EBFE408.4010607@rogers.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <tluben@rogers.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2003-05-12 at 13:12, Luben Tuikov wrote:
> Uuuuh... Shouldn't this be fixed?

Not really, its design behaviour.  BUSY or QUEUE_FULL return means the
actual device couldn't accept the command, so we push back on the block
queue and suspend until a returning I/O frees the queue.  DID_BUS_BUSY
indicates transient failures in the host side which are eligible for
immediate requeueing

> The problem with this is that on BUSY, the LLDD _may_ get the task
> which got this condition out of order...  Furthermore, there's no

This would be why we don't support barriers.

> such thing as BUS BUSY anymore, it's an SPI left over.  In case
> where the transport is unavailable, a service response of
> SERVICE DELIVERY OR TARGET FAILURE should be returned*.
> Currently SCSI Core has no facility to return a ``service response''.

The service response are what the DID_ attributes are about.  At the end
of the day, though, the mid layer will either 

1. Fail the command
2. retry immediately, or
3. retry after another command returns.

That's what the large set of case statements in
scsi_error.c:scsi_decide_disposition() is about.

James


