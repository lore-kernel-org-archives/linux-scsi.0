From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [Fwd: [RFT] major libata update]
Date: Thu, 18 May 2006 08:57:45 -0500
Message-ID: <1147960665.3475.4.camel@mulgrave.il.steeleye.com>
References: <20060518023931.23450.qmail@web31806.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:1507 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932075AbWERN6A (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 May 2006 09:58:00 -0400
In-Reply-To: <20060518023931.23450.qmail@web31806.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: Jeff Garzik <jeff@garzik.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2006-05-17 at 19:39 -0700, Luben Tuikov wrote:
> Apparently you have no detailed knowlege of the implementation of
> SCSI storage stacks, for example: driver->fw->interconnect->device.

Well, I'm sure I read about it in a comic book somewhere ...

> You also fail to understand who the "I" and "T" could be in an
> I_T_x_x nexus at each stage of an implementation.
> 
> You also fail to understand that a SAM nexus is not necessarily
> established
> when queuecommand() is called. 

I didn't say it was.  The point, which you're ignoring, is that when the
driver knows the SAM nexus is terminated, it should call ->done() ASAP
to inform the mid-layer of this condition, so the mid-layer model of the
device interactions follows the SAM interactions as closely as possible.
The API you want to introduce and the implementation of it in libata lie
to the mid-layer and pretend the nexus still exists when the driver
knows it doesn't ... what I'm saying is that I see no reason to do that.

James


