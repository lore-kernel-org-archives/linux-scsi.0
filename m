From: Luben Tuikov <tluben@rogers.com>
Subject: Re: Patch: change the serial_number for error-handler commands
Date: Wed, 21 May 2003 14:50:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3ECBCA91.9010106@rogers.com>
References: <3ECA9D46.7010301@rogers.com> <Pine.LNX.4.44L0.0305202110520.4914-100000@netrider.rowland.org> <20030521180308.GD1116@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep03-mail.bloor.is.net.cable.rogers.com ([66.185.86.73]:25568
	"EHLO fep03-mail.bloor.is.net.cable.rogers.com") by vger.kernel.org
	with ESMTP id S262256AbTEUSiJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 May 2003 14:38:09 -0400
In-Reply-To: <20030521180308.GD1116@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-scsi@vger.kernel.org

Mike Anderson wrote:
> Sorry for the slow response I was under the weather and not doing much
> yesterday.
> 
> Alan Stern [stern@rowland.harvard.edu] wrote:
> 
>>Well, the patch changes the serial number regardless of its initial value,
>>but otherwise yes.  It would be okay with me to change scsi_core->sn.  
>>But the global serial number is currently a static variable defined in
>>scsi.c and my change was to scsi_error.c -- I didn't want to export the
>>variable needlessly.
>>
>>
>>>Q: Which value does USB Storage reserve for cmdsn, 0 or MAX?
>>
>>It doesn't reserve any values.  (I avoided 0 only because I noticed that
>>the scsi core uses 0 as a reserved value.)  Usb-storage just requires that
>>serial numbers not be repeated.
>>
> 
> 
> I agree on the change in SCSI core instead of a change just for scsi
> error handling. If you are depending on command serial number to be
> unique as the comments in scsi_dispatch_cmd already indicate we have
> problems (in USB storage case since can_queue is 1 it would not run into a
> issue until scsi error handling).
> 
> The patch below is a quick patch that moves the serial_number from a
> scsi mid level static to a per scsi host value. In looking at the usage
> of command serial_number it appears that moving to a per scsi host name
> space should be ok.
> 
> I have compile and boot tested it on my system with the ips and aic7xxx
> drivers.
> 
> The patch needs some more testing and some variable name updates, but
> should be ok to test USB and allow for discussion of this type of
> change.

1. cmdsn is per initiator, so I have no objections _in_principle_ to this
patch. (haven't looked at the patch code, just read the idea)
	Actually cmdsn just insures delvery of the _command_ across
the interconnect, after that it doesn't matter.  Normally transports play with
cmdsn, but it is no error for the application client to provide it.  Transports
may ignore it completely, when they don't support it or when they generate
their own, and thus SCSI Core SHOULD NOT rely on this to identify the command.

2. SCSI Core->cmdsn should _always_ contain the _next_ cmdsn to be assigned.
	This provides that at boot time, it contains 0, and this is consistent
with the fact that no commands have been issued yet.  Assignment to a command
should be atomic a la, cmd->cmdsn = scsi_core->cmdsn++;
	This also provides that for a reasonable value v [RFC1982],
one can tell immediately the number of commands issued, a la,
(scsi_core->cmdsn - v + MAX) % MAX is commands issued since v.
	This is also consistent with the well known practice that indexes,
etc, always contain the _next_ index, so that that it serves as an index
(to the next) and as a _size_ variable just by reading it.

(#2 should probably be fixed first)

3. Zero is indeed a reserved value, as per SAM-3r07, 5.1.

4. The error handler is NO exception.  If the error handler sends a
SCSI Command (i.e. a _CDB_) then it is supposed to assign a cmdsn,
as per the rules.  This is for delivery.

-- 
Luben


