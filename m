From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [REPOST][PATCH] update max sdev block limit
Date: Tue, 16 May 2006 14:14:02 -0400
Message-ID: <446A166A.6080405@emulex.com>
References: <1147358563.3507.4.camel@localhost.localdomain> <4469EB45.7070104@sgi.com> <4469F83F.4030407@emulex.com> <20060516163450.GA25071@us.ibm.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:19077 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S932397AbWEPSLg
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 May 2006 14:11:36 -0400
In-Reply-To: <20060516163450.GA25071@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Michael Reed <mdr@sgi.com>, linux-scsi@vger.kernel.org



Patrick Mansfield wrote:
> On Tue, May 16, 2006 at 12:05:19PM -0400, James Smart wrote:
>> I don't mind making it bigger, especially as this is just a max, not the
>> default value. I tried to keep it low, as I believe even 2 mins is a long
>> time from the system's perspective. 10 minutes is forever (and remember
>> the scan deadlock that we just worked through).
> 
> Yes, so add default and max settings instead of using the max as the default.

Agreed - doing so.

> And I still don't see how the scsi timeout can (reliably) make it through
> these block/unblocks. EH_RESET_TIMER doesn't freeze the scsi timeout like
> you really need, just restarts it. 
> 
> For example, with default sd timeout of 30, you could be one second into a
> command, block for 28 seconds, unblock, and then still timeout.

True.  However, the point was not necessarily to allow the command to
succeed. Note: any target disappearance for any real amount of time (like 28s)
is likely going to be a condition that required a new login and killed the
i/o anyway.

The rescheduling of the timeout was to avoid the ramifications of the timeout
fails, which it would do, as there's no target to send the abort request to.
What was happening was the abort was failing, the device reset was failing,
and it escalated up to bus resets and adapter resets - followed by a Test Unit
Ready being sent, which of course was to a non-existent target, which failed
and took the device offline. Which then required manual interaction to restart
io.

-- james
