From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Fri, 07 Nov 2003 18:55:01 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FAB5DE5.2080000@torque.net>
References: <20031027153932.A16679@infradead.org> <005801c3a44a$5847c6e0$8f074d0a@apac.cisco.com> <20031106100906.A15382@infradead.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:38923 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S263971AbTKGJWl
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Nov 2003 04:22:41 -0500
In-Reply-To: <20031106100906.A15382@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>
Cc: "Sachin Mhatre (smhatre)" <smhatre@cisco.com>, linux-scsi@vger.kernel.org, davmyers@cisco.com

'Christoph Hellwig' wrote:
> On Thu, Nov 06, 2003 at 03:12:51PM +0530, Sachin Mhatre (smhatre) wrote:
> 
>>Hi,
>>	The following is the reason for sending the TEST_UNIT_READY and
>>START_STOP initialization command in the iSCSI driver:- 
>>
>>The iSCSI driver receives a CHECK CONDITION with sense key, NOT READY
>>and ASC/ASCQ=04/02 (i.e. an initialization command required). The Linux
>>SCSI mid-layer does not handle this condition. Hence the TUR and START
>>STOP initialization commands are sent from the iSCSI driver.
>>
>>Should this condition be necessarily handled in the SCSI mid-layer or
>>the low-level driver?
> 
> 
> I think we should handle it in the midlayer.  Could you come up with a
> patch to implement it?

Interesting challenge. For a start START_STOP UNIT ** is a SBC-2
command so the mid-layer shouldn't be generating it, the
sd driver should. The sd_rw_intr() function in the sd driver
could be made to detect ASC/ASCQ=04/02 but it is pretty obviously
executing in interrupt context. The sd driver has a tailor made
routine to spin up a disk called sd_spinup_disk() but since it
calls schedule_timeout() it must be called from process context.

Also once a spinup has commenced, it will take about 30
seconds to complete. In that time an impatient user could
try and mount a different partition on the same disk.
That process should see a ASC/ASCQ=04/01 ("Logical unit is in
process of becoming ready") and it should wait till it
clears (and not issue another spinup).

Seems like some infrastructure changes would be needed.

Testing with lk 2.6.0-test9: spinning down a disk that
the scsi subsystem had already seen but with nothing mounted
on it, then trying to mount a partition on it, causes a lot
of ugly messages in my log (at least the machine didn't crash).


** There is also the Power Condition mode page that all SCSI
devices may optionally support. Trouble is with my SCSI-3 disks
they either don't support it or the one that does gives
ASC/ASCQ=04/02 when the disk is spun down (violating SPC-3).

Doug Gilbert



