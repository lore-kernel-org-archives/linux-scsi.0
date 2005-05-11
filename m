From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: sg driver and the error handler
Date: Wed, 11 May 2005 10:45:49 -0700
Message-ID: <20050511174549.GB9286@us.ibm.com>
References: <Pine.LNX.4.44L0.0505101433520.5058-100000@iolanthe.rowland.org> <20050510225831.GA4181@us.ibm.com> <4281F396.2030607@torque.net> <4282345B.4010102@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:3060 "EHLO e32.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S262005AbVEKRqG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 May 2005 13:46:06 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e32.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j4BHk40c591042
	for <linux-scsi@vger.kernel.org>; Wed, 11 May 2005 13:46:04 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j4BHk4Ap304310
	for <linux-scsi@vger.kernel.org>; Wed, 11 May 2005 11:46:04 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id j4BHk3ou028569
	for <linux-scsi@vger.kernel.org>; Wed, 11 May 2005 11:46:03 -0600
Content-Disposition: inline
In-Reply-To: <4282345B.4010102@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: dougg@torque.net, Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, May 11, 2005 at 12:35:39PM -0400, Luben Tuikov wrote:

> I think Alan even wants to see the QUEUEFULL status not being
> retried.
> 
> That is, other than reclaiming the command from the LLDD, the
> eh code should not retry or do anything with the command, just
> pass it back to the user process who sent it via sg.
> 
> Maybe the application client has other tricks up its sleeve
> on QUEUEFULL coming from the device.
> 
> I think scsi generic as a passthrough, where minimal logic
> from SCSI Core is applied and most is left to the application
> client.

IMO, normal sg/SG_IO usage wants scsi core to requeue the request, they
want the command to be processed by the LUN.

And user space does not have the information available in scsi core
(status of other outstanding IO to the same LUN), and can't retry in a
timely manner, possibly avoid starvation issues.

Maybe fast fail should be used to modify QUEUE FULL re-queue behaviours.

It might be a bit odd in some cases and maybe hardware specific (for multi
path io, does QUEUE FULL mean a storage port/controller is full, or the
LUN is full? if port, then you want to send back to the upper level, but
if LUN, you might want to let scsi core requeue it). 

-- Patrick Mansfield
