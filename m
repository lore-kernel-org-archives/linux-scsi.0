From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH as494] Add a scsi_device flag for RETRY_HWERROR
Date: Fri, 25 Mar 2005 09:13:17 +1000
Message-ID: <4243498D.6070409@torque.net>
References: <Pine.LNX.4.44L0.0503241134300.1345-100000@ida.rowland.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Received: from zorg.st.net.au ([203.16.233.9]:57519 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S261227AbVCXXMA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Mar 2005 18:12:00 -0500
In-Reply-To: <Pine.LNX.4.44L0.0503241134300.1345-100000@ida.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern wrote:
> James:
> 
> It turns out that a bunch of USB-IDE converters make the mistake of
> returning SK = 04 (Hardware Error) whenever the IDE device signals any
> sort of error, without bothering to distinguish recoverable from
> non-recoverable errors. 

Alan,
The sense key of HARDWARE ERROR is a superset of MEDIUM ERROR.
SBC-2 treats them as synonymous. If it is a "real" medium
error then the LBA of the first (i.e. lowest address) bad
block should be placed in the "info" field and the "valid"
bit should be set. If this is done the block layer does
its job well.

Also for both hardware and medium errors the "sense key
specific" field (if SKSV=1) reports the actual retry
count. The read/write retry count is set in the "read
write error recovery" mode page. Anyways if the disk
has already retried reading the bad block 64 times (say)
what is the point of the mid level retrying??

<aside>
Another interesting quirk I noticed recently was a disk
yielding "recovered error, failure prediction threshold
exceeded" even though the PER bit was clear (which is the
normal case). I had expected recovered errors to be
bad block specific but this error was from SMART saying
"your disk hasn't got long to live". BTW That recovered
error was repeated every 10 minutes or so. Probably a
useful alerte to put in the log and on the console.

Doug Gilbert
