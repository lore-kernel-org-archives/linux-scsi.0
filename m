From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Spinup of SCSI Disks: allow_restart won't work on 2.6.18
Date: Mon, 20 Nov 2006 22:20:50 -0600
Message-ID: <1164082850.2816.125.camel@mulgrave.il.steeleye.com>
References: <455DF39A.6090209@fbihome.de> <455E2D44.5030903@gmx.de>
	 <455E4703.3080005@s5r6.in-berlin.de> <456188FD.3020108@fbihome.de>
	 <45619611.5020502@s5r6.in-berlin.de> <45622CF5.507@fbihome.de>
	 <45624009.3040208@s5r6.in-berlin.de>  <45624E30.5080605@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:65197 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S934300AbWKUEW5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Nov 2006 23:22:57 -0500
In-Reply-To: <45624E30.5080605@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Joern Quillman <quillman@fbihome.de>, linux-scsi@vger.kernel.org

On Mon, 2006-11-20 at 19:54 -0500, Douglas Gilbert wrote:
> ... but why have the condition at all? What other peripheral
> device type should the _sd_ driver be handling??

The original patch was for some IBM ipr array that behaves stupidly and
requires a START_UNIT after a reset.  I suspect this was the reason the
type check was in there.  However, if there's a use for this outside the
particular array, then it should be taken out.

Note that there may be a bit of work necessary to make this function for
USB: it's keyed to the standard response CC/UA/LOGICAL UNIT NOT READY,
INITIALIZING COMMAND REQUIRED.  Since USB devices aren't necessarily
standards compliant in this regard, simply setting the bit may not work.

James


