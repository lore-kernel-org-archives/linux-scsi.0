From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/5] ibmvscsi: Add eh_host_reset_handler
Date: Thu, 14 Jun 2007 08:37:36 -0500
Message-ID: <467144A0.7030005@linux.vnet.ibm.com>
References: <11817727312836-patch-mail.ibm.com> <200706132212.l5DMCQD9002964@d01av02.pok.ibm.com> <46706FFD.5030704@garzik.org>
Reply-To: brking@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:39479 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbXFNNhl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jun 2007 09:37:41 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l5EDbcrl013904
	for <linux-scsi@vger.kernel.org>; Thu, 14 Jun 2007 09:37:38 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5EDbc2d194688
	for <linux-scsi@vger.kernel.org>; Thu, 14 Jun 2007 07:37:38 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5EDbbwg008466
	for <linux-scsi@vger.kernel.org>; Thu, 14 Jun 2007 07:37:37 -0600
In-Reply-To: <46706FFD.5030704@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: santil@linux.vnet.ibm.com, rcjenn@linux.vnet.ibm.com, linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> Brian King wrote:
>> +	spin_lock_irqsave(hostdata->host->host_lock, flags);
>> +	list_for_each_entry_safe(tmp_evt, pos, &hostdata->sent, list) {
>> +		list_del(&tmp_evt->list);
>> +		del_timer(&tmp_evt->timer);
>> +		if (tmp_evt->cmnd) {
>> +			tmp_evt->cmnd->result = (error_code << 16);
>> +			unmap_cmd_data(&tmp_evt->iu.srp.cmd,
>> +				       tmp_evt,
>> +				       tmp_evt->hostdata->dev);
>> +			if (tmp_evt->cmnd_done)
>> +				tmp_evt->cmnd_done(tmp_evt->cmnd);
>> +		} else if (tmp_evt->done)
>> +			tmp_evt->done(tmp_evt);
>> +		free_event_struct(&tmp_evt->hostdata->pool, tmp_evt);
>> +	}
>> +	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
> 
> 
> Since it's been so long since I bothered with the old-style error 
> handling, a dumb question:
> 
> Are you sure that you should be completing the commands in the host 
> reset handler?  I thought EH took care of that, and your sole task in 
> the host reset handler was to reset everything attached to a single 
> scsi_host.

As far as scsi core is concerned, it really doesn't care either way.
The first thing scsi_done does is call scsi_delete_timer, which will
find that the timer has already expired/been deleted, which will cause
scsi_done to essentially do nothing.

Brian

-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center
