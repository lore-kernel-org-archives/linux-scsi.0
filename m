From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCHv7 13/23] scsi_dh_alua: Use workqueue for RTPG
Date: Thu, 18 Feb 2016 13:12:05 -0800
Message-ID: <56C633A5.6050707@sandisk.com>
References: <1455524690-121073-1-git-send-email-hare@suse.de>
 <1455524690-121073-14-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0063.outbound.protection.outlook.com ([65.55.169.63]:34270
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964793AbcBRVMR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Feb 2016 16:12:17 -0500
In-Reply-To: <1455524690-121073-14-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>

On 02/15/2016 12:24 AM, Hannes Reinecke wrote:
> The current ALUA device_handler has two drawbacks:
> - We're sending a 'SET TARGET PORT GROUP' command to every LUN,
>    disregarding the fact that several LUNs might be in a port group
>    and will be automatically switched whenever _any_ LUN within
>    that port group receives the command.
> - Whenever a LUN is in 'transitioning' mode we cannot block I/O
>    to that LUN, instead the controller has to abort the command.
>    This leads to increased traffic across the wire and heavy load
>    on the controller during switchover.
>
> With this patch the RTPG handling is moved to a per-portgroup
> workqueue. This reduces the number of 'REPORT TARGET PORT GROUP'
> and 'SET TARGET PORT GROUPS' sent to the controller as we're sending
> them now per port group, and not per device as previously.
> It also allows us to block I/O to any LUN / port group found to be
> in 'transitioning' ALUA mode, as the workqueue item will be requeued
> until the controller moves out of transitioning.

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
