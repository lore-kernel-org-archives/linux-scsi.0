From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Control Mode page (0xA) QERR bit setting
Date: 30 Aug 2004 23:33:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1093923230.3731.22.camel@mulgrave>
References: <20040831024520.GA2118@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:11405 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266451AbUHaDeI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Aug 2004 23:34:08 -0400
In-Reply-To: <20040831024520.GA2118@sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2004-08-30 at 22:45, Jeremy Higdon wrote:
> It looks as though the midlayer assumes that QERR is 0.  Is that correct?

Actually, no, the mid-layer is agnostic to the setting of QERR.  On
error, it simply quiesces the host and waits for all the commands to
timeout or complete.

> If QERR is 0, then a check condition for one command will not affect other
> commands, whereas if QERR is 1, then when one command gets a check condition,
> all others for that ITL are silently aborted.

Yes, so we see them time out in the error handler.

> Since I wasn't able to find any code (other than in the ipr driver) that
> completed all outstanding commands to a Lun when a check condition is
> received, I figure that we depend on QERR=0.

No, we work for either.  QERR != 0 is very rare in mode pages, primarily
because it's almost impossible to predict what tags actually got dropped
on the floor because you don't know the status of the head scheduler
(only tasks accepted and scheduled behind the failing tag actually get
dropped; executing tasks ahead of it are allowed to complete as long as
the failing condition doesn't impact them).

James


