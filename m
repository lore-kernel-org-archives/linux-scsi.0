From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH 0/4] SCSI: Printing cleanups
Date: Tue, 27 Feb 2007 23:04:00 -0500
Message-ID: <45E4FF30.40300@torque.net>
References: <yq17iu36jdy.fsf@sermon.lab.mkp.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:45221 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbXB1EES (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Feb 2007 23:04:18 -0500
In-Reply-To: <yq17iu36jdy.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

Martin K. Petersen wrote:
> This patch series is the first batch of cleanups in an attempt to make
> the SCSI printing more consistent and suitable for human consumption.
> 
> Previously a typical error looked like this:
> 
>     sd 0:0:0:0: SCSI error: return code = 0x08000002
>     sda: Current: sense key: Aborted Command
>         Additional sense: Logical block reference tag check failed
> 
> You had to have the magic return value decoder ring handy to figure
> out what had really happened.  And you had to do the mapping between
> sd 0:0:0:0 and sda yourself.
> 
> 
> The following patches clean up various bits so that the same
> information can be presented in a more readable form:
> 
>     sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
>     sd 0:0:0:0: [sda] Sense Key : Aborted Command [current] 
>     sd 0:0:0:0: [sda] Add. Sense: Logical block reference tag check failed
> 
> All printk's from sd.c now have the same prefix.  If logging is turned
> on, for instance, we also get:
> 
>     sd 0:0:0:0: [sda] Send: 0x0fb89180 
>     sd 0:0:0:0: [sda] CDB: Read(16): 88 20 00 00 00 00 00 00 00 20 00 00 00 08 00 00
>     sd 0:0:0:0: [sda] Done: 0x0fb89180 SUCCESS
> 
> The patches need to be applied in order.

Martin,
Looks good.

If you need to revise anything, perhaps you could add a
comment with this url near the list of additional sense
codes:
  http://www.t10.org/lists/asc-num.txt

That is the official list of SCSI additional sense codes.

Based on the date of my last additional sense code update
only this one is missing:
  2Fh/02h  DTLPWROMAEBKVF  COMMANDS CLEARED BY DEVICE SERVER


Doug Gilbert




