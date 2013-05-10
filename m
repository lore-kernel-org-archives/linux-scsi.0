From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] scsi: Allow error handling timeout to be specified
Date: Fri, 10 May 2013 08:23:46 +0200
Message-ID: <518C9272.3080403@acm.org>
References: <yq1fvxvedg6.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:60444 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab3EJGXu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 May 2013 02:23:50 -0400
In-Reply-To: <yq1fvxvedg6.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Hannes Reinecke <hare@suse.de>, michaelc@cs.wisc.edu

On 05/10/13 05:11, Martin K. Petersen wrote:
> Introduce eh_timeout which can be used for error handling purposes. This
> was previously hardcoded to 10 seconds in the SCSI error handling
> code. However, for some fast-fail scenarios it is necessary to be able
> to tune this as it can take several iterations (bus device, target, bus,
> controller) before we give up.

Hello Martin,

  	sdev->max_queue_depth = sdev->queue_depth;
+	sdev->eh_timeout = SCSI_DEFAULT_EH_TIMEOUT;

Have you considered to move the eh_timeout assignment statement to just 
before the transport_configure_device() and slave_configure() calls ? 
That would allow transport drivers and LLD drivers to override the 
default eh_timeout value.

Bart.
