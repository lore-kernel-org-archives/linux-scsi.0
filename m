From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH RFC] Reduce amount of TURs sent in error recovery
Date: Mon, 11 Apr 2011 00:59:36 -0500
Message-ID: <4DA298C8.9090409@cs.wisc.edu>
References: <4D80F6D0.1010404@gmail.com> <4DA250C7.60904@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:51466 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487Ab1DKF7s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Apr 2011 01:59:48 -0400
In-Reply-To: <4DA250C7.60904@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Goodwin <mgoodwin@redhat.com>
Cc: David Jeffery <dhjeffery@gmail.com>, linux-scsi@vger.kernel.org

On 04/10/2011 07:52 PM, Mark Goodwin wrote:
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -554,7 +554,10 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
> cmd->result = (DID_NO_CONNECT << 16);
> scsi_done(cmd);
> } else {
> - rtn = host->hostt->queuecommand(cmd, scsi_done);
> + if (cmd->device->sdev_state == SDEV_ZOMBIE)
> + rtn = 0; /* will timeout so err handler will run */
> + else
> + rtn = host->hostt->queuecommand(cmd, scsi_done);
> }
>
> Would we want to consider adding this to the patch set too? It will allow
> affected sites to more easily tune their timeouts and redundancy config
> (i.e. echo zombie > /sys/block/sdX/device/state to simulate a failure).

You have someting like that already in the block layer with the 
io-timeout-fail sysfs setting.
