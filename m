From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Spinup of SCSI Disks: allow_restart won't work on 2.6.18
Date: Tue, 21 Nov 2006 09:12:57 +0100
Message-ID: <4562B509.1010303@s5r6.in-berlin.de>
References: <455DF39A.6090209@fbihome.de> <455E2D44.5030903@gmx.de>	 <455E4703.3080005@s5r6.in-berlin.de> <456188FD.3020108@fbihome.de>	 <45619611.5020502@s5r6.in-berlin.de> <45622CF5.507@fbihome.de>	 <45624009.3040208@s5r6.in-berlin.de>  <45624E30.5080605@torque.net> <1164082850.2816.125.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:57259 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S966917AbWKUINI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Nov 2006 03:13:08 -0500
In-Reply-To: <1164082850.2816.125.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: dougg@torque.net, Joern Quillman <quillman@fbihome.de>, linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Mon, 2006-11-20 at 19:54 -0500, Douglas Gilbert wrote:
>> ... but why have the condition at all? What other peripheral
>> device type should the _sd_ driver be handling??

Of course. Check the time stamp of my posting. #-)

> The original patch was for some IBM ipr array that behaves stupidly and
> requires a START_UNIT after a reset.  I suspect this was the reason the
> type check was in there.  However, if there's a use for this outside the
> particular array, then it should be taken out.

Enabling this feature for RBC devices too is not a big deal. As
mentioned earlier in the thread, sbp2 sets the respective flag to 1 for
all devices now, so this change would allow to switch this back off. I
don't anticipate actual need to ever switch it off though.

> Note that there may be a bit of work necessary to make this function for
> USB: it's keyed to the standard response CC/UA/LOGICAL UNIT NOT READY,
> INITIALIZING COMMAND REQUIRED.  Since USB devices aren't necessarily
> standards compliant in this regard, simply setting the bit may not work.
-- 
Stefan Richter
-=====-=-==- =-== =-=-=
http://arcgraph.de/sr/
