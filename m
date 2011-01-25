From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] scsi: Erroneous handling of sense status in SCSI EH commands
Date: Mon, 24 Jan 2011 23:18:29 -0600
Message-ID: <4D3E5D25.9000604@cs.wisc.edu>
References: <1295597274-5844-1-git-send-email-hare@suse.de> <4D39F16A.5020002@cs.wisc.edu> <4D3D317D.6060403@suse.de> <4D3DDE3F.2030902@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:43407 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281Ab1AYFSj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Jan 2011 00:18:39 -0500
In-Reply-To: <4D3DDE3F.2030902@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@suse.de>, linux-scsi@vger.kernel.org

On 01/24/2011 02:17 PM, Mike Christie wrote:
> For example, with your patch if for the
> scsi_send_eh_cmnd/scsi_eh_completed_normally/scsi_check_sense path we
> got 02/04/01 (not ready - becomming ready), scsi_send_eh_cmnd would see
> SOFT_ERROR and fail the scsi eh. And, I am saying don't we want retry
> this like we would if we were going through the normal IO path, so we do
> not offline devices on this type of failure?
>

Just some corrections/clarifications. The device, target and bus reset 
handling are ok, but just host reset handling seems like the problem (at 
least the problem I was hitting I think). We do not call 
__scsi_report_device_reset for host reset handling, but some LLD 
eh_host_reset_handler implementations execute operations that can cause 
us to get something like a UA for the scsi eh TUR. For your patch do you 
also want to call __scsi_report_device_reset for the host reset handling 
for these drivers then?
