From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Incorrect response to SK/ASC/ASCQ = x 02/04/01 (becoming ready)
Date: Fri, 27 Aug 2004 10:03:22 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <412E7A4A.1090706@torque.net>
References: <Pine.LNX.4.44L0.0408221154220.15992-100000@netrider.rowland.org> <1093217548.1727.367.camel@mulgrave> <1093218968.3553.17.camel@swtf.comptex.com.au> <1093275122.1776.52.camel@mulgrave> <20040826025453.GA125799@sgi.com> <1093534695.1684.28.camel@mulgrave> <20040826223634.GB131056@sgi.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:17541 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S269818AbUH0AEU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Aug 2004 20:04:20 -0400
In-Reply-To: <20040826223634.GB131056@sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Burn Alting <burn@goldweb.com.au>, SCSI development list <linux-scsi@vger.kernel.org>

Jeremy Higdon wrote:
> On Thu, Aug 26, 2004 at 11:38:08AM -0400, James Bottomley wrote:
> 
>>On Wed, 2004-08-25 at 22:54, Jeremy Higdon wrote:
>>
>>>I believe that 02/04/01 should be treated like a Busy status.  The
>>>semantics are slightly different, but the action taken by the
>>>initiator is the same: wait a bit and then retry.
>>
>>Well, that's dangerous.  BUSY is assumed always to be a transient
>>condition, so it doesn't count against the retries, so if this thing
>>never comes back, we'd loop forever there.
> 
> 
> Hmm.  I think an exponential backoff would be better.
> 
> In any case, the 02/04/01 is also a transient condition.  It means
> that the device is in the process of becoming read, but is not ready yet.
> 
> 
>>The other thing about BUSY handling is that, for a device with no
>>outstanding commands like this, we retry based on I/O pressure, so even
>>if I increment the retry count time waited would depend on how much I/O
>>pressure the system had.
> 
> 
> The amount of time you wait to retry is based on I/O pressure?
> The amount of time that it will take before the device is ready is
> not based on I/O pressure.
> 
> 
>>>I have seen this key/asc/asq before and had to handle it that way.
>>>I believe the device in question was a disk drive that had been
>>>powered on recently.  Disks set to have a variable spinup delay
>>>(based on ID, so that not all disks in a 16-drive box power up at
>>>the same time and overstress a power supply) can return this code
>>>up to a couple of minutes after power on.
>>
>>But that's a start of day thing, which would be handled by sd's TUR
>>code.
> 
> 
> True.  However, in the future, I might expect to see more of this
> behavior, as drives are spun down for power conservation.  Probably
> more on small systems than on big ones.

Jeremy,
I have read that SAS disks will need spinning up. Also SATA
disks in a SAS domain will be held somewhere in their
initialization state machine so they don't spin up either.
It both cases active intervention from an application server
(e.g. linux scsi subsystem) will be required.

New infrastructure supporting a "power condition" state machine
has been added recently to SPC-3 and SBC-2. For disks I think
this is an attempt to merge the way SATA and SAS disks (and
perhaps recent u320 disks) will work in this area. There is
a new Power Condition mode page. See SPC-3 section 5.9 and
SBC-2 section 4.14 .

Doug Gilbert


