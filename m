From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH as468] Retry supposedly "unrecoverable" hardware errors
Date: Fri, 18 Feb 2005 10:49:53 +1000
Message-ID: <42153BB1.4050303@torque.net>
References: <Pine.LNX.4.44L0.0502161144170.6418-100000@ida.rowland.org>	 <42141D3D.9080800@torque.net> <1108653107.5507.3.camel@mulgrave>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Received: from borg.st.net.au ([65.23.158.22]:32976 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S261277AbVBRAtS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Feb 2005 19:49:18 -0500
In-Reply-To: <1108653107.5507.3.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Martin Peschke <mpeschke@de.ibm.com>, Radovan Garabik <garabik@kassiopeia.juls.savba.sk>, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> On Thu, 2005-02-17 at 14:27 +1000, Douglas Gilbert wrote:
> 
>>Recent SPC-3 and SBC-2 drafts treat the sense keys of
>>MEDIUM ERROR and HARDWARE ERROR in a similar way.
>>Both can return an "info" field which has the same
>>meaning (lba of first failure). The distinction is that
>>MEDIUM ERROR is a little more precise (at least for
>>magnetic rotating media) **. For flash ram the distinction
>>is moot.
> 
> 
> My copy of SPC-3 (r21d) still defined HARDWARE ERROR in Table 27 as
> 
> HARDWARE ERROR: Indicates that the device server detected a non-
> recoverable hardware failure
> (e.g., controller failure, device failure, or parity error) while
> performing the command or during a self
> test.
> 
> which looks pretty non-retryable to me ... where does it say that the
> error might be retryable?

James,
The definition of MEDIUM ERROR from the same table:
"Indicates that the command terminated with a non-recoverable
error condition that may have been caused by a flaw in the
medium or an error in the recorded data. This sense key may
also be returned if the device server is unable to
distinguish between a flaw in the medium and a specific
hardware failure (i.e. sense key 4h)". Sense key "4h" is
HARDWARE ERROR.

I interpret that as SPC-3 saying MEDIUM ERROR and
HARDWARE ERROR may both report non-recoverable errors.
Also note that MEDIUM ERROR, HARDWARE ERROR and RECOVERED
ERROR can return an "actual retry count" in their additional
sense data.

SBC-2 (rev 16) makes little distinction between
the two sense keys for "unrecovered read errors": table 4 shows
either can be used. It also says on page 19: "When
an unrecovered read error is reported the information field
of the sense data shall contain the LBA of the unrecovered
logical block."

Nothing that I can see links an "unrecovered (read) error" with
the application client retrying the same command in either draft.
If "actual retry count" is > 1 in the sense key specific field
then that implies the device has already tried several times.

SSC-3 (for tape drives) also allows MEDIUM ERROR or HARDWARE ERROR
to indicate an unrecovered read error (rev 1c, table 2). For tape
drives, retrying the same command is probably not appropriate. [I
note that st and sg set their 'max_retries' to 0 to inhibit this.]
MMC-5 only mentions the HARDWARE ERROR sense key for a self
diagnostic failure.

This analysis leads me to question why retries are instigated
from the mid level and not the sd driver (and perhaps sr driver
as well). If so, sd should not instigate retries if the device
indicates a reasonable number of retries have already taken
place, unless it can change some other factor or is instructed by
some parameter to sd.


As Alan Stern points out, my patch fails the reality
test. The device in question obviously required a retry when
it returned a HARDWARE ERROR sense key (but perhaps the
reason was not an unrecovered error or it was not reported
properly).

Doug Gilbert


