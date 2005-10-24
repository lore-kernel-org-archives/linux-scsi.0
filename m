From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: infinite loop with 36 Byte inquiry (sbp2 regression	in	2.6.14-rcX)
Date: Mon, 24 Oct 2005 21:05:16 +0200
Message-ID: <435D306C.20202@s5r6.in-berlin.de>
References: <435ADA6D.4040705@s5r6.in-berlin.de>	 <1130107402.3437.54.camel@mulgrave>  <435C85FA.3000409@s5r6.in-berlin.de> <1130167914.3325.27.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:33719 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1751134AbVJXTHU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Oct 2005 15:07:20 -0400
In-Reply-To: <1130167914.3325.27.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
Cc: Ben Collins <bcollins@debian.org>

James Bottomley wrote:
> Like I said, I think that's because you send an orb to the device with a
> command indicated length of 36 but a buffer length of 37

It happens regardless of what I force sbp2_send_command() to do:
	request_bufflen = cmd[4] = 0x24;
or
	request_bufflen = cmd[4];
or none of that.

> I don't see any loops in the lun probing routines.  For UNIT_ATTENTION
> to inquiry, we should retry three times and then give up.  If you enable
> debugging at the SCSI layer, that might give a better indication of
> what's going on.

Yes, I will do so.

> There's an #if 0 around an incorrect piece of code that would return
> DID_BUS_BUSY in this condition, you don't have that enabled, do you?
> 
> DID_BUS_BUSY is a dangerous reply because it causes an immediate retry
> without decrementing the retry count.  If you return it for a condition
> that never clears, it used to cause a hang.  Now it should actually exit
> the loop after the command times out (6 seconds, I think).

The #if 0 block is still deactivated here.

Thanks a lot for the advice. I will post what I find out.
-- 
Stefan Richter
-=====-=-=-= =-=- ==---
http://arcgraph.de/sr/
