From: "Chris Friesen" <cfriesen@nortel.com>
Subject: how to handle QUEUE_FULL/SAM_STAT_TASK_SET_FULL in userspace?
Date: Mon, 12 Nov 2007 13:54:38 -0600
Message-ID: <4738AF7E.1060307@nortel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zcars04f.nortel.com ([47.129.242.57]:48788 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbXKLURG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Nov 2007 15:17:06 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, dgilbert@interlog.com, James.Bottomley@SteelEye.com, Eric.Moore@lsi.com, DL-MPTFusionLinux@lsi.com

Hi,

I asked this question on the list last Friday and haven't seen any 
replies, so I thought I'd ask again and broaden the receiver list a bit.

We have x86-based hardware with dual LSI 53c1030 devices.  We have a few 
apps that issue SCSI requests on sg device nodes.  The requests are 
generally related to the health of the disks (ie, LOG_SENSE, 
REQUEST_SENSE, TEST_UNIT_READY, MODE_SENSE_10, that sort of thing).

We recently moved from 2.6.10 to 2.6.14 and now we're seeing occasional 
QUEUE_FULL/SAM_STAT_TASK_SET_FULL errors being returned to userspace. 
These didn't ever show up in 2.6.10.

So...are these errors expected?  If so, why are they only showing up now?

Is there any way to get rid of the errors?  Should the scsi midlayer be 
handling retries for these or is it up to userspace because we're using 
the ioctl() interface?

Is there a "correct" way to handle them in userspace?  Should we delay 
then retry the command?  How long should the app delay, how many retries 
should it attempt before giving up?

I'm at a loss here, and I'm having a hard time finding any concrete 
information on the expected behaviour.

Thanks,

Chris
