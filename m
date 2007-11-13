From: "Chris Friesen" <cfriesen@nortel.com>
Subject: Re: how to handle QUEUE_FULL/SAM_STAT_TASK_SET_FULL in userspace?
Date: Tue, 13 Nov 2007 16:04:03 -0600
Message-ID: <473A1F53.2050209@nortel.com>
References: <4738AF7E.1060307@nortel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zcars04f.nortel.com ([47.129.242.57]:36885 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737AbXKMWEw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Nov 2007 17:04:52 -0500
In-Reply-To: <4738AF7E.1060307@nortel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Larry.Stephens@lsi.com
Cc: linux-scsi@vger.kernel.org, dgilbert@interlog.com, James.Bottomley@SteelEye.com, Eric.Moore@lsi.com, DL-MPTFusionLinux@lsi.com

Chris Friesen wrote:

> We recently moved from 2.6.10 to 2.6.14 and now we're seeing occasional 
> QUEUE_FULL/SAM_STAT_TASK_SET_FULL errors being returned to userspace. 
> These didn't ever show up in 2.6.10.

I found something that might be interesting.

With the the 3.01.18 fusion driver the queue length (as shown by 
"/sys/class/scsi_generic/sgX/device/queue_depth") was set to 7, while 
with the 3.02.57 fusion driver it was set to either 64 or 32.

It may be coincidence, but it's interesting that 
MPT_SCSI_CMD_PER_DEV_LOW is set to 7 in the earlier driver, and 32 in 
the later one, while MPT_SCSI_CMD_PER_DEV_HIGH went from 31 to 64.

Chris
