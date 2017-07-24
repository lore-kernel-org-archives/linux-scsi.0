From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: Re: [PATCH 09/47] zfcp: open-code fc_block_scsi_eh() for host reset
Date: Mon, 24 Jul 2017 18:18:15 +0200
Message-ID: <a7950ea7-380c-bb01-7f31-5c555217ad2d@linux.vnet.ibm.com>
References: <1498638793-44672-1-git-send-email-hare@suse.de>
 <1498638793-44672-10-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39335 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752513AbdGXQSW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 Jul 2017 12:18:22 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v6OGE2A5095020
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2017 12:18:22 -0400
Received: from e06smtp15.uk.ibm.com (e06smtp15.uk.ibm.com [195.75.94.111])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2bwftgweyf-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2017 12:18:22 -0400
Received: from localhost
        by e06smtp15.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
        Mon, 24 Jul 2017 17:18:19 +0100
In-Reply-To: <1498638793-44672-10-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Benjamin Block <bblock@linux.vnet.ibm.com>

Hi Hannes,

unfortunately I only realized now by accident that there's stuff to 
review. Would be nice to send it also explicitly to driver maintainers 
in addition to the list.

Since you've asked for this multiple times, I happened to just now code 
a patch series of 6 patches in order to decouple zfcp from scsi_cmnd for 
device, target, and host reset.

While I provide some review comments below, I think it might be clearer 
and easier to review if you would rebase your series on top of my 
decoupling.

Let me know how urgent you'd like to see my code. I planned to send it 
as RFC soon anyway. However, it hasn't seen any function testing yet. If 
you don't care, let me know and I can send it.

On 06/28/2017 10:32 AM, Hannes Reinecke wrote:
> When issuing a host reset we should be waiting for all
> ports to become unblocked; just waiting for one might
> be resulting in host reset to return too early.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>   drivers/s390/scsi/zfcp_scsi.c | 27 +++++++++++++++++++++++----
>   1 file changed, 23 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
> index 0678cf7..3d18659 100644
> --- a/drivers/s390/scsi/zfcp_scsi.c
> +++ b/drivers/s390/scsi/zfcp_scsi.c
> @@ -311,13 +311,32 @@ static int zfcp_scsi_eh_target_reset_handler(struct scsi_cmnd *scpnt)
> 
>   static int zfcp_scsi_eh_host_reset_handler(struct scsi_cmnd *scpnt)
>   {
> -	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(scpnt->device);
> -	struct zfcp_adapter *adapter = zfcp_sdev->port->adapter;
> -	int ret;
> +	struct Scsi_Host *host = scpnt->device->host;
> +	struct zfcp_adapter *adapter = (struct zfcp_adapter *)host->hostdata[0];
> +	int ret = 0;
> +	unsigned long flags;
> +	struct zfcp_port *port;
> 
>   	zfcp_erp_adapter_reopen(adapter, 0, "schrh_1");
>   	zfcp_erp_wait(adapter);
> -	ret = fc_block_scsi_eh(scpnt);
> +retry_rport_blocked:
> +	spin_lock_irqsave(host->host_lock, flags);

missing read_lock(&adapter->port_list_lock);

Hm, well, I have to think about lock ordering, because my patch has the 
port_list as outer loop and inside it calls fc_block_scsi_eh (also 
modified with fc_rport as argument).
If there's any other location taking both locks we better get them in 
the same order.

> +	list_for_each_entry(port, &adapter->port_list, list) {
> +		struct fc_rport *rport = port->rport;

port->rport can be NULL, so need to check

> +
> +		if (rport->port_state == FC_PORTSTATE_BLOCKED) {
> +			if (rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT)
> +				ret = FAST_IO_FAIL;

Hm, doesn't this get lost if a next iteration hits ret=NEEDS_RETRY?

I was pondering in my own patch version what to return of just a subset 
of ports ran into fast_io_fail. And for now I thought just fast_io_fail 
would be good to let I/O bubble up for path failover, even if this would 
include of rport which meanwhile unblocked properly and would not need 
bubbling up pending requests because they could service them with a 
simple retry.

> +			else
> +				ret = NEEDS_RETRY;
> +			break;
> +		}

Why do you open code fc_block_scsi_eh() instead of calling it with 
port->rport (if it's !=NULL)?

Typically all rports would be blocked after adapter recovery, until they 
become unblocked (via zfcp's async rport_work). So we can wait for each 
in turn which should still only wait in summary for the last one to 
unblock. E.g. if the first rport takes longest we wait for it, and the 
rest of the loop will be fast since the others happen to be unblocked 
(or fast_io_fail) already?

> +	}

missing read_unlock(&adapter->port_list_lock);

> +	spin_unlock_irqrestore(host->host_lock, flags);
> +	if (ret == NEEDS_RETRY) {
> +		msleep(1000);
> +		goto retry_rport_blocked;
> +	}
>   	if (ret)
>   		return ret;
> 

-- 
Mit freundlichen Grüßen / Kind regards
Steffen Maier

Linux on z Systems Development

IBM Deutschland Research & Development GmbH
Vorsitzende des Aufsichtsrats: Martina Koederitz
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
