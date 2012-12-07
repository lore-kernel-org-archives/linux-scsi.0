From: Jeremy Linton <jlinton@tributary.com>
Subject: Re: [PATCH][RFC] scsi_transport_fc: Implement I_T nexus reset
Date: Fri, 7 Dec 2012 16:33:47 -0600
Message-ID: <50C26ECB.3040103@tributary.com>
References: <1354891880-16159-1-git-send-email-hare@suse.de> <50C23C5A.9090907@cs.wisc.edu> <alpine.WNT.2.00.1212071451330.6432@N5102REMCQXM4BS.qlogic.org> <50C25A29.9030904@tributary.com> <50C25DA5.6040508@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.ihostexchange.net ([66.46.182.52]:19786 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab2LGWdu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Dec 2012 17:33:50 -0500
In-Reply-To: <50C25DA5.6040508@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 12/7/2012 3:20 PM, Mike Christie wrote:
> On 12/07/2012 03:05 PM, Jeremy Linton wrote:
>> That said, its far from perfect. The code (as I understand it) isn't 
>> differentiating between isolating the failure, or bringing out the big 
>> hammer in an attempt to correct problems on a specific I_T_L. If you 
>> drop/reset the I_T because one of the LUN's is misbehaving before
>> verifying the status of other LUN's on the target, you risk interrupting
>> operations to functional devices.
> 
> When this code is called the scsi eh has run the abort handler for each 
> outstanding command and that has failed, and it has run the lun/device 
> reset handler and that has failed (or the eh operations succeeded but the
> TUR checkup the scsi eh does failed).

	I think my issue with the error handler (rather than this patch in
particular) surrounds the fact that when scsi_eh_bus_device_reset (which maps
to lun reset) fails, it falls to scsi_eh_target_reset which issues a TARGET
RESET which then broadens the problem to devices which may be working fine,
and just happen to be on the same I_T.

	I think there should be some attempt to determine if there are other devices on
the I_T, and whether they have failed before going into target_reset. It looks
like there may have been a plan to do that in bus_device_reset, but it doesn't
appear to be complete.


	Now, all that said, I have a few things I wonder about in the
eh_bus_device_reset code. For one the use of TUR rather than a command with a
more straightforward return status like INQUIRY which also preserves the check
conditions.




