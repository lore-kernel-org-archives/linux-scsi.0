From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Mid-layer handling of NOT_READY conditions...
Date: Sun, 30 Jan 2005 12:33:40 +1000
Message-ID: <41FC4784.8060905@torque.net>
References: <1106954650.9862.61.camel@plap> <1106977566.9862.102.camel@plap> <1107017081.4535.29.camel@mulgrave> <20050129193421.GA7573@us.ibm.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:63663 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S261631AbVA3CdX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Jan 2005 21:33:23 -0500
In-Reply-To: <20050129193421.GA7573@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Patrick Mansfield wrote:
> On Sat, Jan 29, 2005 at 10:44:41AM -0600, James Bottomley wrote:
> 
>>On Fri, 2005-01-28 at 21:46 -0800, Andrew Vasquez wrote:
>>
>>>Returning back DID_IMM_RETRY for these 'transport' related conditions
>>>would of course help in this issue -- but at the same time bring with it
>>>several side-effects which may not be desirable.
>>>
>>>So, beyond this particular circumstance, what would be considered a
>>>'proper' return status for this type of event? 
>>
>>Well, the correct return, since this is a condition from the storage, is
>>simply the check condition and the sense code (rather than having the
>>driver interpret it).
> 
> 
> But the transport hit a failure, not the storage device.
> 
> I thought Andrew hit this sequence:
> 
> 	- pull / replace cable
> 
> 	- IO resumes but gets NOT_READY (the device could be logging back
> 	  into the fibre or such)
> 
> 	- a FC transport problem is hit, DID_BUSY_BUSY is returned, but
> 	  scmd->retries has already been exhausted by the NOT_READY
> 
> Did I misread something?

Patrick,
I was also thinking of commenting on this. It depends on
where the failure is:
   a) between the device server (target) and a logical unit (lu)
   b) in the service delivery subsystem between the
      initiator (port) and the target (port).

James's explanation covers case a) (i.e. the device server
should constuct appropriate sense data and a SCSI status
in response to the current and future SCSI commands.
In case b) the reponse is transport dependent.
For example, in the case of SAS there are two further
situations:
    1) the failure occurs on a direct connect between the
       initiator (port) and the target (port) [e.g. between
       a HBA port and a target port on a disk].
       Then a low level state machine (phy/link layer) on
       the HBA will notice the problem
    2) the failure occurs between an expander and an end
       device (e.g. a tape drive). Then the expander issues
       a BROADCAST(CHANGE) link layer primitive which the
       initiator(s) will receive. In reponse to this the
       initiator(s) should do another discovery process
       to find the new topology (via SMP).

Also both of these situations are detected in real time
(more or less), not when the next command is issued.
New SCSI commands will fail relatively quickly when
the SAS HBA fails to open a connection to the target.
SCSI commands "in flight" to an effected target should
trigger connection timeouts in the initiator.

Doug Gilbert
