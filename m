From: Luben Tuikov <tluben@rogers.com>
Subject: Re: Patch: change the serial_number for error-handler commands
Date: Wed, 21 May 2003 15:24:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3ECBD269.7050404@rogers.com>
References: <Pine.LNX.4.44L0.0305202110520.4914-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep03-mail.bloor.is.net.cable.rogers.com ([66.185.86.73]:13214
	"EHLO fep03-mail.bloor.is.net.cable.rogers.com") by vger.kernel.org
	with ESMTP id S262254AbTEUTL0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 May 2003 15:11:26 -0400
In-Reply-To: <Pine.LNX.4.44L0.0305202110520.4914-100000@netrider.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Mike Anderson <andmike@us.ibm.com>, linux-scsi@vger.kernel.org

Alan Stern wrote:
>>Alan, could you please explain this patch?
> 
> 
> It's just to insure that when the error handler sends a TEST-UNIT-READY,
> the serial number is different from that of the immediately-prior failed
> command (or from that of any command issued recently or likely to be
> issued in the near future).

This is a _trivial_ bug in SCSI Core (error handler, ...) which I hope
will be fixed in the near future (Mike or Patrick will send a patch).

That is, as per my other email, two successive commands (CDBs) should
never be sent with duplicate cmdsn's.

What we're talking about here is a _consistent_ path of a command
through SCSI Core, before it reaches a LLDD.  This is currently NOT
the case, thus the duplicate cmdsn...

-- 
Luben


