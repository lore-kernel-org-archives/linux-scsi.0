From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [Patch] dont block device on QUEUE_FULL for last command
Date: Tue, 05 Aug 2003 09:08:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F2FAC35.3060509@pobox.com>
References: <OF9404399C.2F79915F-ONC1256D79.00285DC0@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:10438 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S272739AbTHENIR
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Aug 2003 09:08:17 -0400
In-Reply-To: <OF9404399C.2F79915F-ONC1256D79.00285DC0@de.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Andreas Herrmann <AHERRMAN@de.ibm.com>
Cc: linux-scsi@vger.kernel.org

Andreas Herrmann wrote:
>         Jeff Garzik <jgarzik@pobox.com>
>>For most cases you _should_ block until another command is completed, at
>>the very least.  Retrying the command immediately is _exactly_ the
>>situation one wishes to avoid, when returning a QUEUE_FULL result!

>         ... until another command is completed ...
> 
> ... which will never happen, because there was a QUEUE_FULL for the
> last command for the device.  The device will be blocked. No further
> commands are sent. Bad luck?

No; if driver does not complete (i.e. error out) commands in a timely 
manner, that's a driver bug.

Thus, the queue should stay blocked until another command is completed, 
because, not completing a command would be wrong :)

	Jeff




